
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.h"
#include <vector>
#include <array>
#include <iostream>
#include <algorithm>

//#import "SFML/Headers/Window.hpp"
//#include <SFML/Headers/Window.hpp>
//#include <SFML/OpenGL.hpp>

#include <SFML/Graphics.hpp>

using namespace std;
/*
 struct INesHeader
 {
 u8 id[4];
 u8 numRomBanks;
 u8 numVRomBanks;
 struct
 {
 u8 batteryBacked    : 1;
 u8 trainer          : 1;
 u8 fourScreenVraw   : 1;
 u8 reserved         : 1;
 u8 mapperLowNibble  : 4;
 } flags6;
 struct
 {
 u8 vsSystem         : 1;
 u8 reserved         : 3;
 u8 mapperHiNibble   : 4;
 } flags7;
 u8 numRamBanks;
 u8 flags2;
 u8 reserved[6];
 };
 */
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

void DumpBlock(const char* desc, const u8* base, u32 len, u32 org)
{
  if (desc)
  {
    printf("*** %s ***\n", desc);
  }
  
  u32 ip = 0;
  u32 prevIp = 0;
  
  while (ip < len)
  {
    u8 op = base[ip];
    prevIp = ip;
    if (g_validOpCodes[op])
    {
      u32 nextIp = ip + g_instrLength[op];
      printf("%.4x    %s\n", ip + org, OpCodeToString(OpCode(op), nextIp + org, &base[ip+1]));
      ip = nextIp;
    }
    else
    {
      printf("%.4x    db %.2x\n", ip + org, op);
      ++ip;
    }
  }
}

// the 3 interrupt vectors are at the back of the last bank
struct InterruptVectors
{
  u16 nmi;
  u16 reset;
  u16 brk;
};

struct Cpu6502
{
  Cpu6502()
    : ip(0)
    , memory(64*1024)
    , a(0)
    , x(0)
    , y(0)
    , s(0)
  {
    flags = {0};
    flags.r = 1;
  }

  bool LoadINes(const char* filename);

  void SetIp(u32 v);
  void Execute();
  void Reset();
  
  void LoadRegister(s8* reg, s8 value);
  void StoreAbsolute(u16 addr, u8 value);
  void LoadAbsolute(u16 addr, u8* reg);
  
  void SetFlags(s8 value);
  
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
    u8 i : 1;   // interrupt enable
    u8 d : 1;   // decimal mode
    u8 b : 1;   // software interrupt
    u8 r : 1;   // reserved (1)
    u8 v : 1;   // overflow
    u8 s : 1;   // sign
  } flags;
  
  u32 ip;
  vector<u8> memory;
  
  typedef array<u8, 16*1024> PrgBank;
  vector<PrgBank> rom;
  
  s8 a, x, y;
  u16 s;
};

bool Cpu6502::LoadINes(const char* filename)
{
  FILE* f = fopen(filename, "rb");
  if (!f)
  {
    return false;
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
    return false;
  }
  
  size_t numBanks = header->numRomBanks;
  u8* base = &data[16 + (header->flags6.trainer ? 512 : 0)];
  
  // copy the PRG ROM
  for (size_t i = 0; i < numBanks; ++i)
  {
    rom.push_back(PrgBank());
    memcpy(rom.back().data(), &base[i*16*1024], 16*1024);
  }
  
  return true;
}

void Cpu6502::SetIp(u32 v)
{
  ip = v;
}

void Cpu6502::Reset()
{
  // For mapper 1, the first bank is loaded into $8000, and the
  // last bank info $c000
  memcpy(&memory[0x8000], rom[0].data(), 16 * 1024);
  memcpy(&memory[0xc000], rom.back().data(), 16 * 1024);

  // Get the current interrupt table, and start executing the
  // reset interrupt
  const InterruptVectors* v = (InterruptVectors*)&memory[0xfffa];
  ip = v->reset;
  
  
  DumpBlock("RESET INTERRUPT", &memory[v->reset], 0xffff - v->reset, ip);

}

void Cpu6502::StoreAbsolute(u16 addr, u8 value)
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

void Cpu6502::LoadAbsolute(u16 addr, u8* reg)
{
  switch (addr)
  {
    case 0x2002:
      // PPU Status Register
      break;
      
    default:
    {
      u8 value = memory[addr];
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

void Cpu6502::Execute()
{
  
  auto GetAddr = [this]() { return memory[ip+1] + (memory[ip+2] << 8); };
  
  OpCode op = (OpCode)memory[ip];
  switch (op)
  {
      
    case OpCode::BPL_REL:
    {
      if (!flags.s)
      {
        ip += (s8)memory[ip+1];
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
      
    case OpCode::JMP_ABS:
    {
      ip = GetAddr();
      DumpBlock("JMP", &memory[ip], (u32)memory.size() - ip, ip);
      break;
    }
      
    case OpCode::LDA_IMM:
    {
      LoadRegister(&a, (s8)memory[ip+1]);
      break;
    }
    
    case OpCode::LDX_IMM:
    {
      LoadRegister(&x, (s8)memory[ip+1]);
      break;
    }

    case OpCode::LDY_IMM:
    {
      LoadRegister(&y, (s8)memory[ip+1]);
      break;
    }
      
    case OpCode::LDA_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&a);
      break;
    }
      
    case OpCode::LDX_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&x);
      break;
    }

    case OpCode::LDY_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&y);
      break;
    }
      
    case OpCode::STA_ABS:
    {
      StoreAbsolute(GetAddr(), a);
      break;
    }
    
    case OpCode::STX_ABS:
    {
      StoreAbsolute(GetAddr(), x);
      break;
    }

    case OpCode::STY_ABS:
    {
      StoreAbsolute(GetAddr(), y);
      break;
    }

    default:
      return;
  }
  
  ip += g_instrLength[(u8)op];
}

Cpu6502 cpu;


int main(int argc, const char * argv[])
{
//  RotateCube();

  // Request a 32-bits depth buffer when creating the window
  sf::ContextSettings contextSettings;
  contextSettings.depthBits = 32;

  // Create the main window
  sf::RenderWindow window(sf::VideoMode(640, 480, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

  sf::Font font;
  if (!font.loadFromFile("/users/dooz/projects/nesthing/ComputerAmok.ttf"))
  {
    return 2;
  }

  if (argc < 2)
  {
    return 1;
  }
  
  if (!cpu.LoadINes(argv[1]))
  {
    printf("error loading rom: %s\n", argv[1]);
  }

  cpu.Reset();

  bool done = false;
  while (!done)
  {
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::Escape))
    {
      done = true;
    }
    else if (sf::Keyboard::isKeyPressed(sf::Keyboard::R))
    {
      cpu.Reset();
    }
    else if (sf::Keyboard::isKeyPressed(sf::Keyboard::S))
    {
      cpu.Execute();
    }

    sf::Text text;
    text.setString("test");
    text.setFont(font);
    text.setCharacterSize(75);
    window.draw(text);
    
    window.display();

  }

  return 0;
}

