#include "nes_helpers.hpp"
#include <iostream>
#include <stdarg.h>
#include <unordered_map>

#include "cpu.hpp"
#include "ppu.hpp"
#include "nesthing.hpp"

#ifdef _WIN32
#define NOMINMAX
#include <windows.h>
#endif



namespace nes
{
  map<u16, string> addrLookup;

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
#else

  void LogConsole(char const * const format, ... )
  {
    va_list arg;
    va_start(arg, format);
    vprintf(format, arg);
    va_end(arg);
  }
#endif
  
  Status LoadINes(const char* filename, Cpu6502* cpu, PPU* ppu)
  {
    // TODO: this is a bit muddled up at the moment, as it treats the
    // data stored in the .nes file as some kind of truth..
    FILE* f = fopen(filename, "rb");
    if (!f)
      return Status::ROM_NOT_FOUND;

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

    // TODO: Do I want some kind of MMC abstraction (that also handles the 1/2 bank configs)?
    size_t numBanks = header->numRomBanks;
    u8* base = &data[16 + (header->flags6.trainer ? 512 : 0)];

    size_t romBankSize = 0x4000;
    size_t vromBankSize = 0x2000;

    // copy the PRG ROM
    cpu->_prgRom.resize(numBanks);
    for (size_t i = 0; i < numBanks; ++i)
    {
      PrgRom& rom = cpu->_prgRom[i];
      memcpy(&rom.data[0], &base[i*romBankSize], romBankSize);
      rom.bank = i;
//      switch (i)
//      {
//        case 0: rom.base = 0x8000; break;
//        case 1: rom.base = 0xc000; break;
//        default: rom.base = 0; break;
//      }
//      cpu->_prgRom.emplace_back(rom);
    }

    // copy VROM banks
    u8* vram = &base[numBanks*romBankSize];
    size_t numVBanks = header->numVRomBanks;
    for (size_t i = 0; i < numVBanks; ++i)
    {
      memcpy(&ppu->_memory[i*vromBankSize], vram, vromBankSize);
      vram += vromBankSize;
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

  // RGB
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

  const char* g_formatStrings[] = {
    "BRK","ORA (X, $%.2X)","","","","ORA $%.2X","ASL $%.2X","","PHP","ORA #$%.2X","ASL A","","","ORA $%.4X","ASL $%.4X","","BPL $%.2X","ORA ($%.2X),Y","","","","ORA $%.2X,X","ASL $%.2X,X","","CLC","ORA $%.4X, Y","","","","ORA $%.4X,X","ASL $%.4X,X","","JSR $%.4X","AND (X, $%.2X)","","","BIT $%.2X","AND $%.2X","ROL $%.2X","","PLP","AND #$%.2X","ROL A","","BIT $%.4X","AND $%.4X","ROL $%.4X","","BMI $%.2X","AND ($%.2X),Y","","","","AND $%.2X,X","ROL $%.2X,X","","SEC","AND $%.4X, Y","","","","AND $%.4X,X","ROL $%.4X,X","","RTI","EOR (X, $%.2X)","","","","EOR $%.2X","LSR $%.2X","","PHA","EOR #$%.2X","LSR A","","JMP $%.4X","EOR $%.4X","LSR $%.4X","","BVC $%.2X","EOR ($%.2X),Y","","","","EOR $%.2X,X","LSR $%.2X,X","","CLI","EOR $%.4X, Y","","","","EOR $%.4X,X","LSR $%.4X,X","","RTS","ADC (X, $%.2X)","","","","ADC $%.2X","ROR $%.2X","","PLA","ADC #$%.2X","ROR A","","JMP ($%.2X)","ADC $%.4X","ROR $%.4X","","BVS $%.2X","ADC ($%.2X),Y","","","","ADC $%.2X,X","ROR $%.2X,X","","SEI","ADC $%.4X, Y","","","","ADC $%.4X,X","ROR $%.4X,X","","","STA (X, $%.2X)","","","STY $%.2X","STA $%.2X","STX $%.2X","","DEY","","TXA","","STY $%.4X","STA $%.4X","STX $%.4X","","BCC $%.2X","STA ($%.2X),Y","","","STY $%.2X,X","STA $%.2X,X","STX $%.2X,Y","","TYA","STA $%.4X, Y","TXS","","","STA $%.4X,X","","","LDY #$%.2X","LDA (X, $%.2X)","LDX #$%.2X","","LDY $%.2X","LDA $%.2X","LDX $%.2X","","TAY","LDA #$%.2X","TAX","","LDY $%.4X","LDA $%.4X","LDX $%.4X","","BCS $%.2X","LDA ($%.2X),Y","","","LDY $%.2X,X","LDA $%.2X,X","LDX $%.2X,Y","","CLV","LDA $%.4X, Y","TSX","","LDY $%.4X,X","LDA $%.4X,X","LDX $%.4X, Y","","CPY #$%.2X","CMP (X, $%.2X)","","","CPY $%.2X","CMP $%.2X","DEC $%.2X","","INY","CMP #$%.2X","DEX","","CPY $%.4X","CMP $%.4X","DEC $%.4X","","BNE $%.2X","CMP ($%.2X),Y","","","","CMP $%.2X,X","DEC $%.2X,X","","CLD","CMP $%.4X, Y","","","","CMP $%.4X,X","DEC $%.4X,X","","CPX #$%.2X","SBC (X, $%.2X)","","","CPX $%.2X","SBC $%.2X","INC $%.2X","","INX","SBC #$%.2X","NOP","","CPX $%.4X","SBC $%.4X","INC $%.4X","","BEQ $%.2X","SBC ($%.2X),Y","","","","SBC $%.2X,X","INC $%.2X,X","","SED","SBC $%.4X, Y","","","","SBC $%.4X,X","INC $%.4X,X",""
  };
}
