
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.h"
#include <vector>
#include <array>
#include <iostream>
#include <algorithm>

#include <SFML/Graphics.hpp>

using namespace std;

void DumpHeader(const INesHeaderCommon* header)
{
  printf("%c%c%c\n", header->id[0], header->id[1], header->id[2]);
  printf("ROM banks: %d, VROM banks: %d\n", header->numRomBanks, header->numVRomBanks);
  printf("flags6: %s mirroring, battery: %d, trainer: %d, 4 screen: %d\n",
         header->flags6.verticalMirroring ? "v" : "h", header->flags6.batteryBacked,
         header->flags6.trainer, header->flags6.fourScreenVraw);
  printf("flags7: vs system: %d\n",
         header->flags7.vsSystem);
  
  if (header->flags7.ines2 == 0)
  {
    const INesHeader1* header1 = (INesHeader1*)header;
    printf("mapper: %.2x\n", (header->flags7.mapperHiNibble << 4) + header->flags6.mapperLowNibble);
  }
  else
  {
    // If in ines 2.0 format, ignore hiNibble, because DiskDude! might have overwritten it!
    const INesHeader1* header1 = (INesHeader1*)header;
    printf("mapper: %.2x\n", header->flags6.mapperLowNibble);
  }
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

struct PPU
{
  void Write(u16 addr, u8 value);

};

void PPU::Write(u16 addr, u8 value)
{
  
}

struct MMC1
{
  MMC1()
    : shiftRegister(0)
    , shiftRegisterOfs(0)
  {
    memset(&register0, 0, sizeof(register0));
  }

  void Write(u16 addr, u8 value);

  void WriteRegister(u8 reg, u8 value);
  void ResetRegister(u8 reg);
  u8 RegisterFromAddress(u16 addr);


  union
  {
    struct
    {
      u8 mirroring : 2;
      u8 prgRomSwapBank : 1;
      u8 prgRomBankSize : 1;
      u8 chrBankSize : 1;
    };
    u8 reg;
  } register0;

  union
  {
    struct
    {
      u8 chrBank : 5;
    };
    u8 reg;
  } register1;

  union
  {
    struct
    {
      u8 chrBank : 5;
    };
    u8 reg;
  } register2;

  union
  {
    struct
    {
      u8 prgBank : 4;
      u8 wramDisabled : 1;
    };
    u8 reg;

  } register3;

  u8 shiftRegister;
  u32 shiftRegisterOfs;
};

void MMC1::WriteRegister(u8 reg, u8 value)
{
  switch (reg)
  {
    case 0:
    {
      break;
    }

    case 1:
    {
      break;
    }

    case 2:
    {
      break;
    }

    case 3:
    {
      break;
    }
  }

}

void MMC1::ResetRegister(u8 reg)
{
  if (reg >= 4)
  {
    return;
  }

}

void MMC1::Write(u16 addr, u8 value)
{
  if (value & 0x80)
  {
    ResetRegister(RegisterFromAddress(addr));
    shiftRegisterOfs = 0;
  }
  else if (shiftRegisterOfs < 5)
  {
    if (shiftRegisterOfs < 4)
    {
      shiftRegister |= (value & 1) << shiftRegisterOfs;
      shiftRegisterOfs++;
    }
    else
    {
      WriteRegister(RegisterFromAddress(addr), shiftRegister);
    }
  }

}

u8 MMC1::RegisterFromAddress(u16 addr)
{
  if (addr < 0x8000)
  {
    return 0xff;
  }

  if (addr < 0xa000)
  {
    return 0;
  }

  if (addr < 0xc000)
  {
    return 1;
  }

  if (addr < 0xe000)
  {
    return 2;
  }

  return 3;
}


// the 3 interrupt vectors are at the back of the last bank
struct InterruptVectors
{
  u16 nmi;
  u16 reset;
  u16 brk;
};

struct PrgRom
{
  array<u8, 16*1024> data;
  vector<pair<u32, string> > disasm;
};

struct Cpu6502
{
  enum class Status
  {
    OK,
    ROM_NOT_FOUND,
    INVALID_MAPPER_VERSION,
    FONT_NOT_FOUND
  };

  enum class BinOp
  {
    OR,
    AND,
    XOR
  };

  Cpu6502()
    : memory(64*1024)
    , currentBank(0)
    , disasmOfs(0)
    , runUntilBranch(false)
  {
    memset(&flags, 0, sizeof(flags));
    memset(&regs, 0, sizeof(regs));
    flags.r = 1;
  }

  Status LoadINes(const char* filename);

  void SetIp(u32 v);
  u8 SingleStep();
  void Reset();
  
  void LoadRegister(s8* reg, s8 value);
  void StoreAbsolute(u16 addr, u8 value);
  void LoadAbsolute(u16 addr, u8* reg);
  
  void SetFlags(s8 value);

  void RenderState(sf::RenderWindow& window);
  void RenderStack(sf::RenderWindow& window);
  void RenderMemory(sf::RenderWindow& window, u16 ofs);

  void Push16(u16 value);
  void Push8(u8 value);
  u16 Pop16();
  u8 Pop8();

  void DoBinOp(BinOp op, s8* reg, u8 value);


  union
  {
    struct
    {
      u8 nameTableAddr : 2;
      u8 ppuAddrIncr : 1;
      u8 spritePatternTableAddr : 1;
      u8 backgroundPatternTableAddr : 1;
      u8 spriteSize : 1;
      u8 masterSlaveSelection : 1;
      u8 executeNMI : 1;
    };
    u8 reg;
  } ppuControl0;
  
  union
  {
    struct
    {
      u8 displayType : 1;
      u8 backgroundClipping : 1;
      u8 spriteClipping : 1;
      u8 backgroundVisibility : 1;
      u8 spriteVisibility : 1;
      union
      {
        u8 colorIntensity : 3;
        u8 fullBackgroundColor : 3;
      };
    };
    u8 reg;
  } ppuControl1;
  
  struct
  {
    u8 c : 1;   // carry
    u8 z : 1;   // zero
    u8 i : 1;   // interrupt disabled
    u8 d : 1;   // decimal mode
    u8 b : 1;   // software interrupt
    u8 r : 1;   // reserved (1)
    u8 v : 1;   // overflow
    u8 s : 1;   // sign
  } flags;
  
  vector<u8> memory;
  
  vector<PrgRom> prgRom;

  size_t currentBank;

  struct  
  {
    u32 ip;
    u8 s;
    s8 a, x, y;
  } regs;

  sf::Font font;

  int disasmOfs;
  bool runUntilBranch;

  PPU ppu;
  MMC1 mmc1;
};

Cpu6502 cpu;

Cpu6502::Status Cpu6502::LoadINes(const char* filename)
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
  
  if (header->flags6.mapperLowNibble != 1)
  {
    printf("Only mapper 1 is supported\n");
    return Status::INVALID_MAPPER_VERSION;
  }
  
  size_t numBanks = header->numRomBanks;
  u8* base = &data[16 + (header->flags6.trainer ? 512 : 0)];
  
  // copy the PRG ROM
  for (size_t i = 0; i < numBanks; ++i)
  {
    PrgRom rom;
    memcpy(&rom.data[0], &base[i*16*1024], 16*1024);
    // Just disassemble the last bank on init
    if (i == numBanks - 1)
    {
      Disassemble(&rom.data[0], rom.data.size(), 0xc000, &rom.disasm);
    }
    prgRom.emplace_back(rom);
  }

#ifdef _WIN32
  const char* fontName = "/projects/nesthing/ProggyClean.ttf";
#else
  const char* fontName = "/users/dooz/projects/nesthing/ProggyClean.ttf";
#endif
  if (!font.loadFromFile(fontName))
  {
    return Status::FONT_NOT_FOUND;
  }

  return Status::OK;
}

void Cpu6502::SetIp(u32 v)
{
  regs.ip = v;
}

void Cpu6502::Reset()
{
  // Turn off interrupts
  flags.i = 1;

  // Point the stack ptr to the top of the stack
  regs.s = 0xff;

  // For mapper 1, the first bank is loaded into $8000, and the
  // last bank info $c000
  memcpy(&memory[0x8000], &prgRom[0].data[0], 16 * 1024);
  memcpy(&memory[0xc000], &prgRom.back().data[0], 16 * 1024);

  currentBank = prgRom.size() - 1;

  // Get the current interrupt table, and start executing the
  // reset interrupt
  const InterruptVectors* v = (InterruptVectors*)&memory[0xfffa];
  regs.ip = v->reset;
}

void Cpu6502::DoBinOp(BinOp op, s8* reg, u8 value)
{
  switch (op)
  {
    case BinOp::OR:
    {
      *reg = *reg | value;
      break;
    }

    case BinOp::AND:
    {
      *reg = *reg & value;
      break;
    }

    case BinOp::XOR:
    {
      *reg = *reg ^ value;
      break;
    }

  }
  SetFlags(*reg);
}

void Cpu6502::StoreAbsolute(u16 addr, u8 value)
{
  if (addr >= 0x2000 && addr <= 0x2007)
  {
    // Check for PPU writes
    ppu.Write(addr, value);

  }
  else if (addr >= 0x8000)
  {
    // Check for writes to MMC1 registers
    mmc1.Write(addr, value);
  }
  else
  {
    switch (addr)
    {
      case 0x2000:
        ppuControl0.reg = value;
        break;

      case 0x2001:
        ppuControl1.reg = value;
        break;

      default:
        memory[addr] = value;
        break;
    }

  }
}

void Cpu6502::LoadAbsolute(u16 addr, u8* reg)
{
  u8 value;
  switch (addr)
  {
    case 0x2002:
    {
      // PPU Status Register
      value = 0x80;
      SetFlags(value);
      *reg = value;
      break;
    }
      
    default:
    {
      value = memory[addr];
      SetFlags(value);
      *reg = value;
      break;
    }
  }
}

void Cpu6502::SetFlags(s8 value)
{
  flags.z = value == 0;
  flags.s = value < 0;
}


void Cpu6502::LoadRegister(s8* reg, s8 value)
{
  *reg = value;
  SetFlags(value);
}

void Cpu6502::Push16(u16 value)
{
  memory[0x100 + regs.s-1] = value & 0xff;
  memory[0x100 + regs.s-0] = (value >> 8) & 0xff;
  regs.s -= 2;
}

void Cpu6502::Push8(u8 value)
{
  memory[0x100 + regs.s] = value;
  regs.s--;
}

u16 Cpu6502::Pop16()
{
  regs.s += 2;
  return (u16)memory[0x100 + regs.s-1] + ((u16)memory[0x100 + regs.s] << 8);
}

u8 Cpu6502::Pop8()
{
  regs.s++;
  return memory[0x100 + regs.s];
}

u8 Cpu6502::SingleStep()
{
  u8 lo = memory[regs.ip+1];
  u8 hi = memory[regs.ip+2];

  auto GetAddr = [this]() { return memory[regs.ip+1] + (memory[regs.ip+2] << 8); };
  OpCode op = (OpCode)memory[regs.ip];

  if (runUntilBranch && g_branchingOpCodes[(u8)op])
  {
    runUntilBranch = false;
    return 0;
  }

  int opLength = g_instrLength[(u8)op];
  bool ipUpdated = false;
  
  switch (op)
  {
    case OpCode::LSR_A:
    {
      u8 lsb = regs.a & 1;
      regs.a = (u8)regs.a >> 1;
      flags.c = lsb;
      break;
    }

    case OpCode::AND_IMM:
    {
      DoBinOp(BinOp::AND, &regs.a, (s8)lo);
      break;
    }

    case OpCode::ORA_IMM:
    {
      DoBinOp(BinOp::OR, &regs.a, (s8)lo);
      break;
    }

    case OpCode::EOR_IMM:
    {
      DoBinOp(BinOp::XOR, &regs.a, (s8)lo);
      break;
    }
      
    case OpCode::BPL_REL:
    {
      if (!flags.s)
      {
        regs.ip += (s8)lo;
      }
      break;
    }
      
    case OpCode::CLD:
    {
      flags.d = 0;
      break;
    }
      
    case OpCode::SEI:
    {
      flags.i  = 0;
      break;
    }
            
    case OpCode::LDA_IMM:
    {
      LoadRegister(&regs.a, (s8)lo);
      break;
    }

    case OpCode::LDA_ZPG:
    {
      LoadRegister(&regs.a, (s8)memory[lo]);
    }
    
    case OpCode::LDX_IMM:
    {
      LoadRegister(&regs.x, (s8)lo);
      break;
    }

    case OpCode::LDY_IMM:
    {
      LoadRegister(&regs.y, (s8)lo);
      break;
    }
      
    case OpCode::LDA_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.a);
      break;
    }
      
    case OpCode::LDX_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.x);
      break;
    }

    case OpCode::LDY_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.y);
      break;
    }
      
    case OpCode::STA_ABS:
    {
      StoreAbsolute(GetAddr(), regs.a);
      break;
    }
    
    case OpCode::STX_ABS:
    {
      StoreAbsolute(GetAddr(), regs.x);
      break;
    }

    case OpCode::STY_ABS:
    {
      StoreAbsolute(GetAddr(), regs.y);
      break;
    }

    case OpCode::JMP_ABS:
    {
      regs.ip = GetAddr();
      ipUpdated = true;
      break;
    }

    case OpCode::JSR_ABS:
    {
      // push the return address on the stack
      Push16(regs.ip + opLength);
      regs.ip = GetAddr();
      ipUpdated = true;
      break;
    }

    case OpCode::RTS:
    {
      regs.ip = Pop16();
      ipUpdated = true;
      break;
    }

    default:
      break;
  }

  // Update the IP if the instruction itself hasn't done it already (f ex JMP, JSR, RTS)
  if (!ipUpdated)
  {
    regs.ip += opLength;
  }
  return g_instructionTiming[(u8)op];
}

void Cpu6502::RenderMemory(sf::RenderWindow& window, u16 ofs)
{
  sf::Vector2f pos(400,20);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);
  text.setColor(sf::Color::White);

  u8* p = &memory[ofs];
  for (size_t i = 0; i < 30; ++i)
  {
    char buf[128];
    sprintf(buf, "%.4x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x",
      ofs,
      *p++, *p++, *p++, *p++, *p++, *p++, *p++, *p++,
      *p++, *p++, *p++, *p++, *p++, *p++, *p++, *p++);
    text.setString(buf);
    text.setPosition(pos);
    window.draw(text);
    pos.y += 15;
  }
}

void Cpu6502::RenderStack(sf::RenderWindow& window)
{
  sf::Vector2f pos(300,20);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);
  text.setColor(sf::Color(255,255,255,255));

  for (size_t i = 0; i < 30; ++i)
  {
    char buf[32];
    u32 cur = 0x1ff - i * 2;
    sprintf(buf, "%.4x %.2x%.2x", cur, memory[cur], memory[cur - 1]);
    text.setString(buf);
    text.setPosition(pos);
    text.setColor(cur == 0x100 + regs.s ? sf::Color::Yellow : sf::Color::White);
    window.draw(text);
    pos.y += 15;
  }
}

void Cpu6502::RenderState(sf::RenderWindow& window)
{
  sf::Vector2f pos(0,0);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);

  // write flags
  auto fnDrawFlag = [&](const char* flag, u8 value) {
    text.setPosition(pos);
    text.setColor(value ? sf::Color::Red : sf::Color::White);
    text.setString(flag);
    window.draw(text);
    pos.x += 10;
  };

  auto fnRegister8 = [&](const char* reg, u8 value) {
    text.setPosition(pos);
    char buf[32];
    int numChars = sprintf(buf, "%s: %.2x", reg, value);
    text.setString(buf);
    window.draw(text);
    pos.x += numChars * 10;
  };

  auto fnRegister16 = [&](const char* reg, u16 value) {
    text.setPosition(pos);
    char buf[32];
    int numChars = sprintf(buf, "%s: %.4x", reg, value);
    text.setString(buf);
    window.draw(text);
    pos.x += numChars * 10;
  };

  fnDrawFlag("C", flags.c);
  fnDrawFlag("Z", flags.z);
  fnDrawFlag("I", flags.i);
  fnDrawFlag("D", flags.d);
  fnDrawFlag("B", flags.b);
  fnDrawFlag("V", flags.v);
  fnDrawFlag("S", flags.s);

  text.setColor(sf::Color::White);
  pos.x += 20;
  fnRegister8("A", regs.a);
  fnRegister8("X", regs.x);
  fnRegister8("Y", regs.y);
  fnRegister16("IP", regs.ip);
  fnRegister16("S", regs.s);

  pos = sf::Vector2f(0, 20);

  auto& rom = prgRom[currentBank];
  u32 ofs = 0xc000;

  // Look for the current IP in the disassemble block (ideally it should always be there..)
  typedef pair<u32, string> Val;
  auto it = find_if(rom.disasm.begin(), rom.disasm.end(), [=](const Val& a)
  {
    return a.first == regs.ip;
  });

  if (it != rom.disasm.end())
  {
    // write disassemble
    // TODO: proper range checking on this
    auto startIt = max(rom.disasm.begin(), it - 10 + disasmOfs);
    int cnt = 0;
    for (auto it = startIt; it != rom.disasm.end() && cnt < 30; ++it, ++cnt)
    {
      text.setPosition(pos);
      u32 curIp = it->first;
      // Create the string "ADDR BYTES OPCODE"
      char buf[256];
      char* bufPtr = buf + sprintf(buf, "%.4x    ", curIp);
      // "max" to handle the case of illegal instructions
      size_t numBytes = max(1, g_instrLength[rom.data[curIp-ofs]]);
      for (size_t i = 0; i < numBytes; ++i)
      {
        bufPtr += sprintf(bufPtr, "%.2x", rom.data[curIp-ofs+i]);
      }
      for (size_t i = 0; i < 3 - numBytes + 2; ++i)
      {
        bufPtr += sprintf(bufPtr, "  ");
      }
      sprintf(bufPtr, "%s", it->second.c_str());
      text.setString(buf);
      text.setColor(curIp == regs.ip ? sf::Color::Yellow : sf::Color::White);
      window.draw(text);
      pos.y += 15;
    }
  }

  RenderStack(window);
  RenderMemory(window, 0);
}


int main(int argc, const char * argv[])
{
  // Request a 32-bits depth buffer when creating the window
  sf::ContextSettings contextSettings;
  contextSettings.depthBits = 32;

  // Create the main window
  sf::RenderWindow window(sf::VideoMode(800, 600, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

  if (argc < 2)
  {
    return 1;
  }
  
  if (cpu.LoadINes(argv[1]) != Cpu6502::Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
  }

  cpu.Reset();
  cpu.RenderState(window);
  window.display();

  bool done = false;
  while (!done)
  {
    window.clear();

    sf::Event event;
    if (window.waitEvent(event))
    {
      if (event.type == sf::Event::KeyReleased)
      {
        switch (event.key.code)
        {
          case sf::Keyboard::Escape:
          {
            done = true;
            break;
          }

          case sf::Keyboard::B:
          {
            cpu.runUntilBranch = true;
            while (cpu.runUntilBranch)
            {
              window.clear();
              cpu.SingleStep();
              cpu.RenderState(window);
              window.display();
            }
            break;
          }

          case sf::Keyboard::R:
          {
            cpu.Reset();
            break;
          }

          case sf::Keyboard::S:
          {
            cpu.SingleStep();
            break;
          }

          case sf::Keyboard::Up:
          {
            cpu.disasmOfs -= 1;
            break;
          }

          case sf::Keyboard::PageUp:
          {
            cpu.disasmOfs -= 20;
            break;
          }

          case sf::Keyboard::Down:
          {
            cpu.disasmOfs += 1;
            break;
          }

          case sf::Keyboard::PageDown:
          {
            cpu.disasmOfs += 20;
            break;
          }

          case sf::Keyboard::Home:
          {
            cpu.disasmOfs = 0;
            break;
          }
        }
      }
    }

    cpu.RenderState(window);
    window.display();
  }

  return 0;
}
