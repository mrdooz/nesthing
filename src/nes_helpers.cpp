#include "nes_helpers.hpp"
#include <iostream>
#include <stdarg.h>

#include "cpu.hpp"
#include "ppu.hpp"

#ifdef _WIN32
#include <windows.h>
#endif

namespace nes
{

#ifdef _WIN32
  string ToString(char const * const format, ... ) 
  {
    va_list arg;
    va_start(arg, format);

    const int len = _vscprintf(format, arg) + 1;

    char* buf = (char*)_alloca(len);
    vsprintf_s(buf, len, format, arg);
    va_end(arg);

    return string(buf);
  }
#endif
  void LogConsole(char const * const format, ... )
  {
    va_list arg;
    va_start(arg, format);

    const int len = _vscprintf(format, arg) + 1;

    char* buf = (char*)_alloca(len);
    vsprintf_s(buf, len, format, arg);
    va_end(arg);

    OutputDebugStringA(buf);
  }

  Status LoadINes(const char* filename, Cpu6502* cpu, PPU* ppu)
  {
    FILE* f = fopen(filename, "rb");
    if (!f)
    {
      return Status::ROM_NOT_FOUND;
    }

    fseek(f, 0, SEEK_END);
    long fileSize = ftell(f);
    fseek(f, 0, SEEK_SET);

    vector<u8> data(fileSize);
    fread(&data[0], fileSize, 1, f);
    fclose(f);

    const INesHeaderCommon* header = (INesHeaderCommon*)&data[0];
    DumpHeader(header);
    DumpHeader1((INesHeader1*)header);
    DumpHeader2((INesHeader2*)header);

    if (header->flags6.mapperLowNibble != 1 && header->flags6.mapperLowNibble != 0)
    {
      LOG("Only mapper 0 and 1 is supported\n");
      return Status::INVALID_MAPPER_VERSION;
    }

    size_t numBanks = header->numRomBanks;
    u8* base = &data[16 + (header->flags6.trainer ? 512 : 0)];

    size_t romBankSize = 16 * 1024;
    size_t vromBankSize = 8 * 1024;
    // copy the PRG ROM
    for (size_t i = 0; i < numBanks; ++i)
    {
      PrgRom rom;
      memcpy(&rom.data[0], &base[i*romBankSize], romBankSize);
      // TODO: Disassemble the bank pointed to by the reset vector
      // Just disassemble the last bank on init
      if (i == 0 && numBanks > 1)
      {
        Disassemble(&rom.data[0], rom.data.size(), 0x8000, &rom.disasm);
      }
      else if (i == numBanks - 1)
      {
        Disassemble(&rom.data[0], rom.data.size(), 0xC000, &rom.disasm);
      }
      cpu->m_prgRom.emplace_back(rom);
    }

    // copy VROM banks
    u8* vram = &base[numBanks*romBankSize];
    size_t numVBanks = header->numVRomBanks;
    for (size_t i = 0; i < numVBanks; ++i)
    {
      memcpy(&ppu->m_memory[i*vromBankSize], &vram[0], vromBankSize);
    }

    ppu->DumpVRom();

#ifdef _WIN32
    const char* fontName = "/projects/nesthing/ProggyClean.ttf";
#else
    const char* fontName = "/users/dooz/projects/nesthing/ProggyClean.ttf";
#endif
    if (!cpu->font.loadFromFile(fontName))
    {
      return Status::FONT_NOT_FOUND;
    }

    return Status::OK;
  }

  void DumpHeader1(const INesHeader1* header)
  {
    LOG("Header1\n");
    LOG("mapper: %.2x\n", (header->flags7.mapperHiNibble << 4) + header->flags6.mapperLowNibble);
  }

  void DumpHeader2(const INesHeader2* header)
  {
    // If in ines 2.0 format, ignore hiNibble, because DiskDude! might have overwritten it!
    LOG("Header2\n");
    LOG("mapper: %.2x\n", header->flags6.mapperLowNibble);
  }

  void DumpHeader(const INesHeaderCommon* header)
  {
    LOG("%c%c%c\n", header->id[0], header->id[1], header->id[2]);
    LOG("ROM banks: %d, VROM banks: %d\n", header->numRomBanks, header->numVRomBanks);
    LOG("flags6: %s mirroring, battery: %d, trainer: %d, 4 screen: %d\n",
      header->flags6.verticalMirroring ? "v" : "h", header->flags6.batteryBacked,
      header->flags6.trainer, header->flags6.fourScreenVraw);
    LOG("flags7: vs system: %d\n",
      header->flags7.vsSystem);
  }

  void Disassemble(const u8* data, size_t len, u32 org, vector<pair<u32, string>>* output)
  {
    // Returns the disassembly of data. output is sorted, with pairs of (start_addr, disasm)
    output->clear();
    char buf[512];

    u32 ip = 0;
    u32 prevIp = 0;

    while (ip < len)
    {
      u8 op = data[ip];
      prevIp = ip;
      if (g_validOpCodes[op])
      {
        u32 nextIp = ip + g_instrLength[op];
        output->push_back(make_pair(ip+org, OpCodeToString(OpCode(op), nextIp + org, &data[ip+1])));
        //sprintf(buf, "%.4x    %s", ip + org, OpCodeToString(OpCode(op), nextIp + org, &data[ip+1]));
        ip = nextIp;
      }
      else
      {
        //      sprintf(buf, "%.4x    db %.2x", ip + org, op);
        sprintf(buf, "db %.2x", op);
        output->push_back(make_pair(ip+org, buf));
        ++ip;
      }
    }
  }

  void FindJumpDestinations(const u8* base, vector<u16>& branchDestinations)
  {
    u16 ip = 0;
    while (ip < 16*1024)
    {
      u8 op = base[ip];
      if (g_validOpCodes[op])
      {
        u16 nextIp = ip + g_instrLength[op];
        u8 branching = g_branchingOpCodes[op];
        if (branching)
        {
          u16 dest = nextIp;
          if (branching == 1)
          {
            // relative
            u8 ofs = base[ip+1];
            if (ofs & 0x80)
            {
              dest -= (ofs & 0x7f);
            }
            else
            {
              dest += (ofs & 0x7f);
            }
          }
          else if (branching == 2)
          {
            // abs
            dest = base[ip+1] + ((u16)base[ip+2] << 8);
          }

          if (!binary_search(branchDestinations.begin(), branchDestinations.end(), dest))
          {
            auto it = lower_bound(branchDestinations.begin(), branchDestinations.end(), dest);
            branchDestinations.insert(it, dest);
          }
        }
        ip = nextIp;
      }
      else
      {
        ++ip;
      }
    }
  }


  const char* OpToStringA(const char* op)
  {
    // operand is A
    static char buf[32];
    sprintf(buf, "%s A", op);
    return buf;
  }

  const char* OpToStringAbs(const char* op, u8 lo, u8 hi)
  {
    // operand is address $HHLL
    static char buf[32];
    sprintf(buf, "%s $%.4x", op, ((u16)hi << 8) + lo);
    return buf;
  }

  const char* OpToStringAbsX(const char* op, u8 lo, u8 hi)
  {
    // operand is address incremented by X with carry
    static char buf[32];
    sprintf(buf, "%s $%.4x,X", op, ((u16)hi << 8) + lo);
    return buf;
  }

  const char* OpToStringAbsY(const char* op, u8 lo, u8 hi)
  {
    // operand is address incremented by Y with carry
    static char buf[32];
    sprintf(buf, "%s $%.4x,Y", op, ((u16)hi << 8) + lo);
    return buf;
  }

  const char* OpToStringImm(const char* op, const u8 a)
  {
    // operand is byte (BB)
    static char buf[32];
    sprintf(buf, "%s #$%.2x", op, a);
    return buf;
  }

  const char* OpToStringInd(const char* op, u8 lo, u8 hi)
  {
    // operand is effective address
    static char buf[32];
    sprintf(buf, "%s ($%.4x)", op, ((u16)hi << 8) + lo);
    return buf;
  }

  const char* OpToStringXInd(const char* op, const u8 a)
  {
    // operand is effective zeropage address; effective address is byte (BB) incremented by X without carry
    static char buf[32];
    sprintf(buf, "%s ($%.2x,X)", op, a);
    return buf;
  }

  const char* OpToStringIndY(const char* op, u8 a)
  {
    // operand is effective address incremented by Y with carry; effective address is word at zeropage address
    static char buf[32];
    sprintf(buf, "%s ($%.2x),Y", op, a);
    return buf;
  }

  const char* OpToStringRel(const char* op, u16 ip, u8 a)
  {
    // branch target is PC + offset (BB). a is 2s complement
    static char buf[32];
    s16 res = (s16)ip + (s8)a;
    sprintf(buf, "%s %.4x", op, (u16)res);
    return buf;
  }


  const char* OpToStringZpg(const char* op, const u8 a)
  {
    // operand is of address; address hibyte = zero ($00xx)
    static char buf[32];
    sprintf(buf, "%s $%.2x", op, a);
    return buf;
  }

  const char* OpToStringZpgX(const char* op, u8 a)
  {
    // operand is address incremented by X; address hibyte = zero ($00xx); no page transition
    static char buf[32];
    sprintf(buf, "%s $%.2x,X", op, a);
    return buf;
  }

  const char* OpToStringZpgY(const char* op, u8 a)
  {
    // operand is address incremented by Y; address hibyte = zero ($00xx); no page transition
    static char buf[32];
    sprintf(buf, "%s $%.2x,Y", op, a);
    return buf;
  }

  const char* OpCodeToString(OpCode op, u16 ip, const u8* ptr)
  {
    switch (op)
    {
    case OpCode::BRK: return "BRK";
    case OpCode::ORA_X_IND: return OpToStringXInd("ORA", ptr[0]);
    case OpCode::ORA_ZPG: return OpToStringZpg("ORA", ptr[0]);
    case OpCode::ASL_ZPG: return OpToStringZpg("ASL", ptr[0]);
    case OpCode::PHP: return "PHP";
    case OpCode::ORA_IMM: return OpToStringImm("ORA", ptr[0]);
    case OpCode::ASL_A: return OpToStringA("ASL");
    case OpCode::ORA_ABS: return OpToStringAbs("ORA", ptr[0], ptr[1]);
    case OpCode::ASL_ABS: return OpToStringAbs("ASL", ptr[0], ptr[1]);
    case OpCode::BPL_REL: return OpToStringRel("BPL", ip, ptr[0]);
    case OpCode::ORA_IND_Y: return OpToStringIndY("ORA", ptr[0]);
    case OpCode::ORA_ZPG_X: return OpToStringZpgX("ORA", ptr[0]);
    case OpCode::ASL_ZPG_X: return OpToStringZpgX("ASL", ptr[0]);
    case OpCode::CLC: return "CLC";
    case OpCode::ORA_ABS_Y: return OpToStringAbsY("ORA", ptr[0], ptr[1]);
    case OpCode::ORA_ABS_X: return OpToStringAbsX("ORA", ptr[0], ptr[1]);
    case OpCode::ASL_ABS_X: return OpToStringAbsX("ASL", ptr[0], ptr[1]);
    case OpCode::JSR_ABS: return OpToStringAbs("JSR", ptr[0], ptr[1]);
    case OpCode::AND_X_IND: return OpToStringXInd("AND", ptr[0]);
    case OpCode::BIT_ZPG: return OpToStringZpg("BIT", ptr[0]);
    case OpCode::AND_ZPG: return OpToStringZpg("AND", ptr[0]);
    case OpCode::ROL_ZPG: return OpToStringZpg("ROL", ptr[0]);
    case OpCode::PLP: return "PLP";
    case OpCode::AND_IMM: return OpToStringImm("AND", ptr[0]);
    case OpCode::ROL_A: return OpToStringA("ROL");
    case OpCode::BIT_ABS: return OpToStringAbs("BIT", ptr[0], ptr[1]);
    case OpCode::AND_ABS: return OpToStringAbs("AND", ptr[0], ptr[1]);
    case OpCode::ROL_ABS: return OpToStringAbs("ROL", ptr[0], ptr[1]);
    case OpCode::BMI_REL: return OpToStringRel("BMI", ip, ptr[0]);
    case OpCode::AND_IND_Y: return OpToStringIndY("AND", ptr[0]);
    case OpCode::AND_ZPG_X: return OpToStringZpgX("AND", ptr[0]);
    case OpCode::ROL_ZPG_X: return OpToStringZpgX("ROL", ptr[0]);
    case OpCode::SEC: return "SEC";
    case OpCode::AND_ABS_Y: return OpToStringAbsY("AND", ptr[0], ptr[1]);
    case OpCode::AND_ABS_X: return OpToStringAbsX("AND", ptr[0], ptr[1]);
    case OpCode::ROL_ABS_X: return OpToStringAbsX("ROL", ptr[0], ptr[1]);
    case OpCode::RTI: return "RTI";
    case OpCode::EOR_X_IND: return OpToStringXInd("EOR", ptr[0]);
    case OpCode::EOR_ZPG: return OpToStringZpg("EOR", ptr[0]);
    case OpCode::LSR_ZPG: return OpToStringZpg("LSR", ptr[0]);
    case OpCode::PHA: return "PHA";
    case OpCode::EOR_IMM: return OpToStringImm("EOR", ptr[0]);
    case OpCode::LSR_A: return OpToStringA("LSR");
    case OpCode::JMP_ABS: return OpToStringAbs("JMP", ptr[0], ptr[1]);
    case OpCode::EOR_ABS: return OpToStringAbs("EOR", ptr[0], ptr[1]);
    case OpCode::LSR_ABS: return OpToStringAbs("LSR", ptr[0], ptr[1]);
    case OpCode::BVC_REL: return OpToStringRel("BVC", ip, ptr[0]);
    case OpCode::EOR_IND_Y: return OpToStringIndY("EOR", ptr[0]);
    case OpCode::EOR_ZPG_X: return OpToStringZpgX("EOR", ptr[0]);
    case OpCode::LSR_ZPG_X: return OpToStringZpgX("LSR", ptr[0]);
    case OpCode::CLI: return "CLI";
    case OpCode::EOR_ABS_Y: return OpToStringAbsY("EOR", ptr[0], ptr[1]);
    case OpCode::EOR_ABS_X: return OpToStringAbsX("EOR", ptr[0], ptr[1]);
    case OpCode::LSR_ABS_X: return OpToStringAbsX("LSR", ptr[0], ptr[1]);
    case OpCode::RTS: return "RTS";
    case OpCode::ADC_X_IND: return OpToStringXInd("ADC", ptr[0]);
    case OpCode::ADC_ZPG: return OpToStringZpg("ADC", ptr[0]);
    case OpCode::ROR_ZPG: return OpToStringZpg("ROR", ptr[0]);
    case OpCode::PLA: return "PLA";
    case OpCode::ADC_IMM: return OpToStringImm("ADC", ptr[0]);
    case OpCode::ROR_A: return OpToStringA("ROR");
    case OpCode::JMP_IND: return OpToStringInd("JMP", ptr[0], ptr[1]);
    case OpCode::ADC_ABS: return OpToStringAbs("ADC", ptr[0], ptr[1]);
    case OpCode::ROR_ABS: return OpToStringAbs("ROR", ptr[0], ptr[1]);
    case OpCode::BVS_REL: return OpToStringRel("BVS", ip, ptr[0]);
    case OpCode::ADC_IND_Y: return OpToStringIndY("ADC", ptr[0]);
    case OpCode::ADC_ZPG_X: return OpToStringZpgX("ADC", ptr[0]);
    case OpCode::ROR_ZPG_X: return OpToStringZpgX("ROR", ptr[0]);
    case OpCode::SEI: return "SEI";
    case OpCode::ADC_ABS_Y: return OpToStringAbsY("ADC", ptr[0], ptr[1]);
    case OpCode::ADC_ABS_X: return OpToStringAbsX("ADC", ptr[0], ptr[1]);
    case OpCode::ROR_ABS_X: return OpToStringAbsX("ROR", ptr[0], ptr[1]);
    case OpCode::STA_X_IND: return OpToStringXInd("STA", ptr[0]);
    case OpCode::STY_ZPG: return OpToStringZpg("STY", ptr[0]);
    case OpCode::STA_ZPG: return OpToStringZpg("STA", ptr[0]);
    case OpCode::STX_ZPG: return OpToStringZpg("STX", ptr[0]);
    case OpCode::DEY: return "DEY";
    case OpCode::TXA: return "TXA";
    case OpCode::STY_ABS: return OpToStringAbs("STY", ptr[0], ptr[1]);
    case OpCode::STA_ABS: return OpToStringAbs("STA", ptr[0], ptr[1]);
    case OpCode::STX_ABS: return OpToStringAbs("STX", ptr[0], ptr[1]);
    case OpCode::BCC_REL: return OpToStringRel("BCC", ip, ptr[0]);
    case OpCode::STA_IND_Y: return OpToStringIndY("STA", ptr[0]);
    case OpCode::STY_ZPG_X: return OpToStringZpgX("STY", ptr[0]);
    case OpCode::STA_ZPG_X: return OpToStringZpgX("STA", ptr[0]);
    case OpCode::STX_ZPG_Y: return OpToStringZpgY("STX", ptr[0]);
    case OpCode::TYA: return "TYA";
    case OpCode::STA_ABS_Y: return OpToStringAbsY("STA", ptr[0], ptr[1]);
    case OpCode::TXS: return "TXS";
    case OpCode::STA_ABS_X: return OpToStringAbsX("STA", ptr[0], ptr[1]);
    case OpCode::LDY_IMM: return OpToStringImm("LDY", ptr[0]);
    case OpCode::LDA_X_IND: return OpToStringXInd("LDA", ptr[0]);
    case OpCode::LDX_IMM: return OpToStringImm("LDX", ptr[0]);
    case OpCode::LDY_ZPG: return OpToStringZpg("LDY", ptr[0]);
    case OpCode::LDA_ZPG: return OpToStringZpg("LDA", ptr[0]);
    case OpCode::LDX_ZPG: return OpToStringZpg("LDX", ptr[0]);
    case OpCode::TAY: return "TAY";
    case OpCode::LDA_IMM: return OpToStringImm("LDA", ptr[0]);
    case OpCode::TAX: return "TAX";
    case OpCode::LDY_ABS: return OpToStringAbs("LDY", ptr[0], ptr[1]);
    case OpCode::LDA_ABS: return OpToStringAbs("LDA", ptr[0], ptr[1]);
    case OpCode::LDX_ABS: return OpToStringAbs("LDX", ptr[0], ptr[1]);
    case OpCode::BCS_REL: return OpToStringRel("BCS", ip, ptr[0]);
    case OpCode::LDA_IND_Y: return OpToStringIndY("LDA", ptr[0]);
    case OpCode::LDY_ZPG_X: return OpToStringZpgX("LDY", ptr[0]);
    case OpCode::LDA_ZPG_X: return OpToStringZpgX("LDA", ptr[0]);
    case OpCode::LDX_ZPG_Y: return OpToStringZpgY("LDX", ptr[0]);
    case OpCode::CLV: return "CLV";
    case OpCode::LDA_ABS_Y: return OpToStringAbsY("LDA", ptr[0], ptr[1]);
    case OpCode::TSX: return "TSX";
    case OpCode::LDY_ABS_X: return OpToStringAbsX("LDY", ptr[0], ptr[1]);
    case OpCode::LDA_ABS_X: return OpToStringAbsX("LDA", ptr[0], ptr[1]);
    case OpCode::LDX_ABS_Y: return OpToStringAbsY("LDX", ptr[0], ptr[1]);
    case OpCode::CPY_IMM: return OpToStringImm("CPY", ptr[0]);
    case OpCode::CMP_X_IND: return OpToStringXInd("CMP", ptr[0]);
    case OpCode::CPY_ZPG: return OpToStringZpg("CPY", ptr[0]);
    case OpCode::CMP_ZPG: return OpToStringZpg("CMP", ptr[0]);
    case OpCode::DEC_ZPG: return OpToStringZpg("DEC", ptr[0]);
    case OpCode::INY: return "INY";
    case OpCode::CMP_IMM: return OpToStringImm("CMP", ptr[0]);
    case OpCode::DEX: return "DEX";
    case OpCode::CPY_ABS: return OpToStringAbs("CPY", ptr[0], ptr[1]);
    case OpCode::CMP_ABS: return OpToStringAbs("CMP", ptr[0], ptr[1]);
    case OpCode::DEC_ABS: return OpToStringAbs("DEC", ptr[0], ptr[1]);
    case OpCode::BNE_REL: return OpToStringRel("BNE", ip, ptr[0]);
    case OpCode::CMP_IND_Y: return OpToStringIndY("CMP", ptr[0]);
    case OpCode::CMP_ZPG_X: return OpToStringZpgX("CMP", ptr[0]);
    case OpCode::DEC_ZPG_X: return OpToStringZpgX("DEC", ptr[0]);
    case OpCode::CLD: return "CLD";
    case OpCode::CMP_ABS_Y: return OpToStringAbsY("CMP", ptr[0], ptr[1]);
    case OpCode::CMP_ABS_X: return OpToStringAbsX("CMP", ptr[0], ptr[1]);
    case OpCode::DEC_ABS_X: return OpToStringAbsX("DEC", ptr[0], ptr[1]);
    case OpCode::CPX_IMM: return OpToStringImm("CPX", ptr[0]);
    case OpCode::SBC_X_IND: return OpToStringXInd("SBC", ptr[0]);
    case OpCode::CPX_ZPG: return OpToStringZpg("CPX", ptr[0]);
    case OpCode::SBC_ZPG: return OpToStringZpg("SBC", ptr[0]);
    case OpCode::INC_ZPG: return OpToStringZpg("INC", ptr[0]);
    case OpCode::INX: return "INX";
    case OpCode::SBC_IMM: return OpToStringImm("SBC", ptr[0]);
    case OpCode::NOP: return "NOP";
    case OpCode::CPX_ABS: return OpToStringAbs("CPX", ptr[0], ptr[1]);
    case OpCode::SBC_ABS: return OpToStringAbs("SBC", ptr[0], ptr[1]);
    case OpCode::INC_ABS: return OpToStringAbs("INC", ptr[0], ptr[1]);
    case OpCode::BEQ_REL: return OpToStringRel("BEQ", ip, ptr[0]);
    case OpCode::SBC_IND_Y: return OpToStringIndY("SBC", ptr[0]);
    case OpCode::SBC_ZPG_X: return OpToStringZpgX("SBC", ptr[0]);
    case OpCode::INC_ZPG_X: return OpToStringZpgX("INC", ptr[0]);
    case OpCode::SED: return "SED";
    case OpCode::SBC_ABS_Y: return OpToStringAbsY("SBC", ptr[0], ptr[1]);
    case OpCode::SBC_ABS_X: return OpToStringAbsX("SBC", ptr[0], ptr[1]);
    case OpCode::INC_ABS_X: return OpToStringAbsX("INC", ptr[0], ptr[1]);    }
    return "** UNKNOWN";
  }

  int g_instrLength[] =
  {
    1,2,0,0,0,2,2,0,1,2,1,0,0,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0,
    3,2,0,0,2,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0,
    1,2,0,0,0,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0,
    1,2,0,0,0,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0,
    0,2,0,0,2,2,2,0,1,0,1,0,3,3,3,0,
    2,2,0,0,2,2,2,0,1,3,1,0,0,3,0,0,
    2,2,2,0,2,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,2,2,2,0,1,3,1,0,3,3,3,0,
    2,2,0,0,2,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0,
    2,2,0,0,2,2,2,0,1,2,1,0,3,3,3,0,
    2,2,0,0,0,2,2,0,1,3,0,0,0,3,3,0
  };

  u8 g_validOpCodes[] =
  {
    1,1,0,0,0,1,1,0,1,1,1,0,0,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,
    1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,
    1,1,0,0,0,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,
    1,1,0,0,0,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,
    0,1,0,0,1,1,1,0,1,0,1,0,1,1,1,0,
    1,1,0,0,1,1,1,0,1,1,1,0,0,1,0,0,
    1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,
    1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,
    1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0
  };

  // 1 = relative branches
  // 2 = absolute
  u8 g_branchingOpCodes[] =
  {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  };

  u8 g_instructionTiming[] =
  {
    7,6,0,0,0,3,5,0,3,2,2,0,0,4,6,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0,
    6,6,0,0,3,3,5,0,4,2,2,0,4,4,6,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0,
    6,6,0,0,0,3,5,0,3,2,2,0,3,4,6,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0,
    6,6,0,0,0,3,5,0,4,2,2,0,5,4,6,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0,
    0,6,0,0,3,3,3,0,2,0,2,0,4,4,4,0,
    34,6,0,0,4,4,4,0,2,5,2,0,0,5,0,0,
    2,6,2,0,3,3,3,0,2,2,2,0,4,4,4,0,
    34,21,0,0,4,4,4,0,2,20,2,0,20,20,20,0,
    2,6,0,0,3,3,5,0,2,2,2,0,4,4,3,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0,
    2,6,0,0,3,3,5,0,2,2,2,0,4,4,6,0,
    34,21,0,0,0,4,6,0,2,20,0,0,0,20,7,0
  };

  u8 g_addressingModes[] =
  {
    0,7,0,0,0,10,10,0,0,5,1,0,0,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0,
    2,7,0,0,10,10,10,0,0,5,1,0,2,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0,
    0,7,0,0,0,10,10,0,0,5,1,0,2,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0,
    0,7,0,0,0,10,10,0,0,5,1,0,6,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0,
    0,7,0,0,10,10,10,0,0,0,0,0,2,2,2,0,
    9,8,0,0,11,11,12,0,0,4,0,0,0,3,0,0,
    5,7,5,0,10,10,10,0,0,5,0,0,2,2,2,0,
    9,8,0,0,11,11,12,0,0,4,0,0,3,3,4,0,
    5,7,0,0,10,10,10,0,0,5,0,0,2,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0,
    5,7,0,0,10,10,10,0,0,5,0,0,2,2,2,0,
    9,8,0,0,0,11,11,0,0,4,0,0,0,3,3,0
  };

  u8 g_NesPalette[] =
  {
    0x7c, 0x7c, 0x7c,
    0x00, 0x00, 0xfc,
    0x00, 0x00, 0xbc,
    0x44, 0x28, 0xbc,
    0x94, 0x00, 0x84,
    0xa8, 0x00, 0x20,
    0xa8, 0x10, 0x00,
    0x88, 0x14, 0x00,
    0x50, 0x30, 0x00,
    0x00, 0x78, 0x00,
    0x00, 0x68, 0x00,
    0x00, 0x58, 0x00,
    0x00, 0x40, 0x58,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0xbc, 0xbc, 0xbc,
    0x00, 0x78, 0xf8,
    0x00, 0x58, 0xf8,
    0x68, 0x44, 0xfc,
    0xd8, 0x00, 0xcc,
    0xe4, 0x00, 0x58,
    0xf8, 0x38, 0x00,
    0xe4, 0x5c, 0x10,
    0xac, 0x7c, 0x00,
    0x00, 0xb8, 0x00,
    0x00, 0xa8, 0x00,
    0x00, 0xa8, 0x44,
    0x00, 0x88, 0x88,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0xf8, 0xf8, 0xf8,
    0x3c, 0xbc, 0xfc,
    0x68, 0x88, 0xfc,
    0x98, 0x78, 0xf8,
    0xf8, 0x78, 0xf8,
    0xf8, 0x58, 0x98,
    0xf8, 0x78, 0x58,
    0xfc, 0xa0, 0x44,
    0xf8, 0xb8, 0x00,
    0xb8, 0xf8, 0x18,
    0x58, 0xd8, 0x54,
    0x58, 0xf8, 0x98,
    0x00, 0xe8, 0xd8,
    0x78, 0x78, 0x78,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0xfc, 0xfc, 0xfc,
    0xa4, 0xe4, 0xfc,
    0xb8, 0xb8, 0xf8,
    0xd8, 0xb8, 0xf8,
    0xf8, 0xb8, 0xf8,
    0xf8, 0xa4, 0xc0,
    0xf0, 0xd0, 0xb0,
    0xfc, 0xe0, 0xa8,
    0xf8, 0xd8, 0x78,
    0xd8, 0xf8, 0x78,
    0xb8, 0xf8, 0xb8,
    0xb8, 0xf8, 0xd8,
    0x00, 0xfc, 0xfc,
    0xf8, 0xd8, 0xf8,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
  };
}
