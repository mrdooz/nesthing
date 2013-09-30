
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.hpp"
#include <vector>
#include <array>
#include <iostream>
#include <algorithm>

#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>

#include <mach/mach.h>
#include <mach/mach_time.h>
#include <CoreServices/CoreServices.h>

using namespace std;

void DumpHeader1(const INesHeader1* header)
{
  printf("Header1\n");
  printf("mapper: %.2x\n", (header->flags7.mapperHiNibble << 4) + header->flags6.mapperLowNibble);
}

void DumpHeader2(const INesHeader2* header)
{
  // If in ines 2.0 format, ignore hiNibble, because DiskDude! might have overwritten it!
  printf("Header2\n");
  printf("mapper: %.2x\n", header->flags6.mapperLowNibble);
}

void DumpHeader(const INesHeaderCommon* header)
{
  printf("%c%c%c\n", header->id[0], header->id[1], header->id[2]);
  printf("ROM banks: %d, VROM banks: %d\n", header->numRomBanks, header->numVRomBanks);
  printf("flags6: %s mirroring, battery: %d, trainer: %d, 4 screen: %d\n",
         header->flags6.verticalMirroring ? "v" : "h", header->flags6.batteryBacked,
         header->flags6.trainer, header->flags6.fourScreenVraw);
  printf("flags7: vs system: %d\n",
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


// PPU memory map
//Address	Size	Description
//$0000	$1000	Pattern Table 0
//$1000	$1000	Pattern Table 1
//$2000	$3C0	Name Table 0
//$23C0	$40	Attribute Table 0
//$2400	$3C0	Name Table 1
//$27C0	$40	Attribute Table 1
//$2800	$3C0	Name Table 2
//$2BC0	$40	Attribute Table 2
//$2C00	$3C0	Name Table 3
//$2FC0	$40	Attribute Table 3
//$3000	$F00	Mirror of 2000h-2EFFh
//$3F00	$10	BG Palette
//$3F10	$10	Sprite Palette
//$3F20	$E0	Mirror of 3F00h-3F1Fh


struct PPU
{
  struct PatternTable;

  PPU();
  void Tick();
  void Write(u16 addr, u8 value);
  u8 Read(u16 addr);
  void DumpVRom();
  void DumpTileBank(const u8* data, size_t numTiles);
  void ProcessPatternTable(const u8* data, size_t numTiles, PatternTable* patternTable);

  void DrawScanline(sf::Image& image);

  union
  {
    struct  
    {
      u8 nameTableAddr : 2;
      u8 ppuAddressIncr : 1;
      u8 spritePatternTableAddr : 1;
      u8 backgroundPatterTableAddr : 1;
      u8 spriteSize : 1;
      u8 reserved : 1;
      u8 nmiOnVBlank : 1;
    };
    u8 reg;
  } m_control1;

  union
  {
    struct
    {
      u8 colorMode : 1;
      u8 backgroundClipping : 1;
      u8 spriteClipping : 1;
      u8 backgroundVisbility : 1;
      u8 spriteVisibility : 1;
      union
      {
        u8 colorIntensity : 3;
        u8 fullBackgroundColor : 3;
      };
    };
    u8 reg;
  } m_control2;

  union
  {
    struct
    {
      u8 reserved : 4;
      u8 vramWrite : 1;
      u8 scanlineSpriteCount : 1;
      u8 sprite0Occurence : 1;
      u8 vblank : 1;
    };
    u8 reg;
  } m_status;

  bool m_hiLoLatch; // false = low byte
  u16 m_writeAddr;
  u16 m_readAddr;
  bool m_firstRead;
  u8 m_oamAddr;

  u8 m_spriteRamOfs;

  struct OamEntry
  {
    u8 vpos;
    u8 tile;
    u8 palette: 2;
    u8 reserverd : 3;
    u8 prio : 1;
    u8 hflip : 1;
    u8 vflip : 1;
    u8 hpos;
  };

  union
  {
    OamEntry m_oam[64];
    u8 m_spriteRam[256];
  };

  union
  {
    OamEntry m_secondaryOam[8];
    u8 m_secondaryOamRaw[32];
  };

  bool m_evenFrame;
  u8 m_hscroll;
  u8 m_vscroll;
  vector<u8> m_memory;
  // at $2000, $2400, $2800, $2c00
  u16 m_nameTable[4];

  struct PatternTable
  {
    struct Sprite
    {
      u8 data[8*8];
    };
    Sprite sprites[256];
  };
  PatternTable m_patternTable[2];

  u16 m_curScanline;
  u16 m_curCycle;
  u8 m_memoryAccessCycle;
  u8 m_OamIdx;
};

PPU ppu;

PPU::PPU()
  : m_hiLoLatch(true)
  , m_writeAddr(0)
  , m_readAddr(0)
  , m_oamAddr(0)
  , m_spriteRamOfs(0)
  , m_evenFrame(true)
  , m_hscroll(0)
  , m_vscroll(0)
  , m_curScanline(1)
  , m_curCycle(1)
  , m_memoryAccessCycle(0)
  , m_OamIdx(0)
{
  m_memory.resize(16*1024);
  m_nameTable[0] = 0x2000;
  m_nameTable[1] = 0x2400;
  m_nameTable[2] = 0x2800;
  m_nameTable[3] = 0x2c00;
}

void PPU::Tick()
{
  return;
  u16 cycle = m_curCycle++;

  // The PPU is ticked for each master clock cycle, and not each PPU clock cycle. This is because
  // the timing is based on memory reads, where each read takes 2 master clock cycles
  bool renderingDisabled = m_control2.backgroundVisbility == 0 && m_control2.spriteVisibility == 0;
  if (!renderingDisabled)
  {
    // Check for end of scanline
    if (cycle >= 1360)
    {
      // The first scanline of even odd frame is 4 cycles shorter
      if ((!m_evenFrame && m_curScanline == 1) || cycle == 1364)
      {
        ++m_curScanline;
        m_curCycle = 1;
        return;
      }
    }

    if (cycle <= 128 * 8)
    {
      switch (cycle & 7)
      {
        case 1:
          // Fetch name table
          break;

        case 3:
          // Fetch attribute table
          break;

        case 5:
          // Fetch pattern table
          break;

        case 7:
          // Fetch pattern table
          break;
      }
    }

    if (cycle <= 64 * 4)
    {
      // Clear secondary OAM
      if (!(cycle & 7))
      {
        m_secondaryOamRaw[cycle/8] = 0xff;
      }
    }


    if (m_curCycle == 342)
    {
      m_curCycle = 0;
      ++m_curScanline;
    }

    if (m_curScanline == 262)
    {
      // Done with the current frame
      m_evenFrame = !m_evenFrame;
      m_status.vblank = 1;
    }
    else
    {
      if (m_curCycle == 0)
      {
        // idle cycle
      }
      else if (m_curCycle >=1 && m_curCycle <= 256)
      {

      }
      else if (m_curCycle >= 257 && m_curCycle <= 320)
      {

      }
      else if (m_curCycle >= 321 && m_curCycle <= 336)
      {

      }
      else if (m_curCycle >= 337 && m_curCycle <= 340)
      {

      }

    }
  }

  ++m_curCycle;

}

void PPU::DrawScanline(sf::Image& image)
{
  // Background
  // 32x30 tiles (8x8)
  int tileY = m_curScanline / 8;

  u8* nameTable = &m_memory[m_nameTable[0]];
  u8* base = &m_memory[m_nameTable[0]];
  for (int i = 0; i < 32; ++i)
  {
    u8 sprite = nameTable[tileY*32+i];
    for (int j = 0; j < 8; ++j)
    {
      u8 pixel = m_patternTable[0].sprites[sprite].data[(m_curScanline&7)*8+j];
      image.setPixel(i*32+j, m_curScanline, sf::Color(g_NesPalette[pixel*3+0], g_NesPalette[pixel*3+1], g_NesPalette[pixel*3+2]));
    }
  }

  if (++m_curScanline == 30*8)
  {
    m_curScanline = 0;
  }

  // Sprite
}

void PPU::Write(u16 addr, u8 value)
{
  // 0x2000 - 0x2007 is mirrored between 0x2008 -> 0x3fff
  switch (0x2000 + (addr & 0x7))
  {
    case 0x2000:
      // Control register 1 (PPUCTRL)
      m_control1.reg = value;
      break;

    case 0x2001:
      // Control register 2 (PPUMASK)
      m_control2.reg = value;
      break;

    case 0x2003:
      // Set sprite RAM offset (OAMADDR)
      m_spriteRamOfs = value;
      break;

    case 0x2004:
      // Write to sprite RAM (OAMDATA)
      m_spriteRam[m_spriteRamOfs++] = value;
      break;

    case 0x2005:
      // Video RAM register 1 (PPUSCROLL)
      if (m_hiLoLatch)
      {
        m_hscroll = value;
        m_hiLoLatch = false;
      }
      else
      {
        m_vscroll = value;
      }
      break;

    case 0x2006:
      // Video RAM register 2 (PPUADDR)
      if (m_hiLoLatch)
      {
        m_writeAddr = (u16)value << 8;
        m_readAddr = m_writeAddr;
        m_hiLoLatch = false;
      }
      else
      {
        m_writeAddr |= value;
        m_readAddr = m_writeAddr;
      }
      break;

    case 0x2007:
      // Note, this should only be done during vblank or when rendering is disabled
      // Video RAM I/O register
      m_memory[m_writeAddr] = value;
      m_writeAddr += m_control1.ppuAddressIncr ? 32 : 1;
      break;
  }
}

u8 PPU::Read(u16 addr)
{
  if (addr == 0x2002)
  {
    // PPUSTATUS

    // Reset hi/lo latch
    m_hiLoLatch = true;

    // Reset vblank bit
    u8 tmp = m_status.reg;
    // HACK
    m_status.vblank = !m_status.vblank;
    return tmp;
  }
  else if (addr == 0x2007)
  {

  }

  return 0;
}

void PPU::ProcessPatternTable(const u8* data, size_t numTiles, PatternTable* patternTable)
{
  // dump a tile bank
  for (size_t i = 0; i < numTiles; ++i)
  {
    // each tile is 16 bytes (8 per layer)
    u8 layer0[8];
    u8 layer1[8];
    memcpy(layer0, &data[i*16+0], 8);
    memcpy(layer1, &data[i*16+8], 8);

    u8* tile = &patternTable->sprites[i].data[0];

    // combine layers
    for (size_t j = 0; j < 8; ++j)
    {
      u8 v = layer0[j];
      for (size_t k = 0; k < 8; ++k)
      {
        tile[j*8+k] = (v >> (7 - k)) & 1;
      }

      v = layer1[j];
      for (size_t k = 0; k < 8; ++k)
      {
        tile[j*8+k] |= ((v >> (7 - k)) & 1) << 1;
      }
    }

    for (size_t j = 0; j < 8; ++j)
    {
      for (size_t k = 0; k < 8; ++k)
      {
        u8 c = tile[j*8+k];
        printf("%c", c == 0 ? '.' : '0' + c);
      }
      printf("\n");
    }
    printf("\n");
  }
}


void PPU::DumpTileBank(const u8* data, size_t numTiles)
{
  // dump a tile bank
  for (size_t i = 0; i < numTiles; ++i)
  {
    // each tile is 16 bytes (8 per layer)
    u8 layer0[8];
    u8 layer1[8];
    memcpy(layer0, &data[i*16+0], 8);
    memcpy(layer1, &data[i*16+8], 8);

    // combine layers
    vector<u8> tile(256);
    for (size_t j = 0; j < 8; ++j)
    {
      u8 v = layer0[j];
      for (size_t k = 0; k < 8; ++k)
      {
        tile[j*8+k] = (v >> (7 - k)) & 1;
      }

      v = layer1[j];
      for (size_t k = 0; k < 8; ++k)
      {
        tile[j*8+k] |= ((v >> (7 - k)) & 1) << 1;
      }
    }

    for (size_t j = 0; j < 8; ++j)
    {
      for (size_t k = 0; k < 8; ++k)
      {
        u8 c = tile[j*8+k];
        printf("%c", c == 0 ? '.' : '0' + c);
      }
      printf("\n");
    }
    printf("\n");
  }
}

void PPU::DumpVRom()
{
  ProcessPatternTable(&m_memory[0], 256, &m_patternTable[0]);
  ProcessPatternTable(&m_memory[256*16], 256, &m_patternTable[1]);
}


struct MMC1
{
  MMC1()
    : m_shiftRegister(0)
    , m_shiftRegisterOfs(0)
  {
    memset(&m_register0, 0, sizeof(m_register0));
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
  } m_register0;

  union
  {
    struct
    {
      u8 chrBank : 5;
    };
    u8 reg;
  } m_register1;

  union
  {
    struct
    {
      u8 chrBank : 5;
    };
    u8 reg;
  } m_register2;

  union
  {
    struct
    {
      u8 prgBank : 4;
      u8 wramDisabled : 1;
    };
    u8 reg;

  } m_register3;

  u8 m_shiftRegister;
  u32 m_shiftRegisterOfs;
};

void MMC1::WriteRegister(u8 reg, u8 value)
{
  switch (reg)
  {
    case 0:
    {
      // control register
      break;
    }

    case 1:
    {
      // chr bank 1
      break;
    }

    case 2:
    {
      // chr bank 2
      break;
    }

    case 3:
    {
      // prg bank
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
    m_shiftRegisterOfs = 0;
  }
  else if (m_shiftRegisterOfs < 5)
  {
    if (m_shiftRegisterOfs < 4)
    {
      m_shiftRegister |= (value & 1) << m_shiftRegisterOfs;
      m_shiftRegisterOfs++;
    }
    else
    {
      WriteRegister(RegisterFromAddress(addr), m_shiftRegister);
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

  Cpu6502();

  Status LoadINes(const char* filename);

  void Tick();

  void SetIp(u32 v);
  u8 SingleStep();
  void Reset();
  
  void Transfer(s8* dst, s8* src);
  void StoreRegister(s8* reg, s8 value);
  void StoreAbsolute(u16 addr, u8 value);
  void LoadAbsolute(u16 addr, u8* reg);
  u8 ReadMemory(u16 addr);
  
  void SetFlags(s8 value);

  void RenderState(sf::RenderWindow& window);
  void RenderStack(sf::RenderWindow& window);
  void RenderMemory(sf::RenderWindow& window, u16 ofs);


  void Push16(u16 value);
  void Push8(u8 value);
  u16 Pop16();
  u8 Pop8();

  void DoBinOp(BinOp op, s8* reg, u8 value);

  OpCode PeekOp();

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
  } m_flags;
  
  vector<u8> memory;
  
  vector<PrgRom> m_prgRom;

  size_t currentBank;

  struct  
  {
    u32 ip;
    u8 s;
    s8 a, x, y;
  } regs;

  sf::Font font;

  size_t memoryOfs;
  size_t disasmOfs;
  bool runUntilBranch;

};

Cpu6502::Cpu6502()
  : memory(64*1024)
  , currentBank(0)
  , disasmOfs(0)
  , runUntilBranch(false)
  , memoryOfs(0)
{
  memset(&m_flags, 0, sizeof(m_flags));
  memset(&regs, 0, sizeof(regs));
  m_flags.r = 1;
}

Cpu6502 cpu;
MMC1 mmc1;


OpCode Cpu6502::PeekOp()
{
  return (OpCode)memory[regs.ip];
}

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
  DumpHeader1((INesHeader1*)header);
  DumpHeader2((INesHeader2*)header);
  
  if (header->flags6.mapperLowNibble != 1 && header->flags6.mapperLowNibble != 0)
  {
    printf("Only mapper 0 and 1 is supported\n");
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
    if (i == 0)
    {
      Disassemble(&rom.data[0], rom.data.size(), 0x8000, &rom.disasm);
    }
    else if (i == numBanks - 1)
    {
      Disassemble(&rom.data[0], rom.data.size(), 0xC000, &rom.disasm);
    }
    m_prgRom.emplace_back(rom);
  }

  // copy VROM banks
  u8* vram = &base[numBanks*romBankSize];
  size_t numVBanks = header->numVRomBanks;
  ppu.m_memory.resize(numVBanks * vromBankSize);
  for (size_t i = 0; i < numVBanks; ++i)
  {
    memcpy(&ppu.m_memory[i*vromBankSize], &vram[0], vromBankSize);
  }

  ppu.DumpVRom();

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

void Cpu6502::Tick()
{
  SingleStep();
}

void Cpu6502::SetIp(u32 v)
{
  regs.ip = v;
}

void Cpu6502::Reset()
{
  // Turn off interrupts
  m_flags.i = 1;

  // Point the stack ptr to the top of the stack
  regs.s = 0xff;

  // For mapper 1, the first bank is loaded into $8000, and the
  // last bank info $c000
  memcpy(&memory[0x8000], &m_prgRom[0].data[0], 16 * 1024);
  memcpy(&memory[0xc000], &m_prgRom.back().data[0], 16 * 1024);

  currentBank = m_prgRom.size() - 1;
  currentBank = 0;

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
  if (addr >= 0x2000 && addr <= 0x3fff)
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
      case 0x4014:
        // Transfer 256 bytes to SPR-RAM
        for (size_t i = 0; i < 256; ++i)
        {
          ppu.Write(0x2004, memory[0x100 * (u16)value + i]);
        }
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
  if (addr >= 0x2000 && addr <= 0x2007)
  {
    value = ppu.Read(addr);
    SetFlags(value);
    *reg = value;
  }
  else
  {
    value = memory[addr];
    SetFlags(value);
    *reg = value;
  }
}

u8 Cpu6502::ReadMemory(u16 addr)
{
  if (addr >= 0x2000 && addr <= 0x2007)
  {
    return ppu.Read(addr);
  }

  return memory[addr];
}

void Cpu6502::SetFlags(s8 value)
{
  m_flags.z = value == 0 ? 1 : 0;
  m_flags.s = value < 0 ? 1 : 0;
}


void Cpu6502::Transfer(s8* dst, s8* src)
{
  *dst = *src;
  SetFlags(*dst);
}

void Cpu6502::StoreRegister(s8* reg, s8 value)
{
  *reg = value;
  SetFlags(value);
}

void Cpu6502::Push16(u16 value)
{
  memory[0x100 + regs.s-1] = (u8)(value & 0xff);
  memory[0x100 + regs.s-0] = (u8)((value >> 8) & 0xff);
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
  u8 op8 = memory[regs.ip];
  OpCode op = (OpCode)op8;
  if (!g_validOpCodes[op8])
  {
    return op8;
  }

  // Load values depending on addressing mode
  AddressingMode addrMode = (AddressingMode)g_addressingModes[op8];
  u8 lo, hi;
  u16 addr;
  switch (addrMode)
  {
    case AddressingMode::ABS:
      addr = memory[regs.ip+1] + (memory[regs.ip+2] << 8);
      break;

    case AddressingMode::ABS_X:
      addr = memory[regs.ip+1] + (memory[regs.ip+2] << 8) + regs.x;
      break;

    case AddressingMode::ABS_Y:
      addr = memory[regs.ip+1] + (memory[regs.ip+2] << 8) + regs.y;
      break;

    case AddressingMode::IMM:
      lo = memory[regs.ip+1];
      break;

    case AddressingMode::ZPG:
      addr = memory[regs.ip+1];
      break;

    case AddressingMode::ZPG_X:
      addr = (memory[regs.ip+1] + regs.x) & 0xff;
      break;

    case AddressingMode::ZPG_Y:
      addr = (memory[regs.ip+1] + regs.y) & 0xff;
      break;

    case AddressingMode::IND:
      addr = memory[regs.ip+1] + (memory[regs.ip+2] << 8);
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    case AddressingMode::X_IND:
      addr = (memory[regs.ip+1] + regs.x) & 0xff;
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    case AddressingMode::IND_Y:
      addr = memory[regs.ip+1];
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8) + regs.y;
      break;
  }

  /*
  u8 lo = memory[regs.ip+1];
  u8 hi = memory[regs.ip+2];

  auto GetAddr = [this]() { return memory[regs.ip+1] + (memory[regs.ip+2] << 8); };
*/
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
      m_flags.c = lsb;
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

    case OpCode::CLD:
    {
      m_flags.d = 0;
      break;
    }
      
    case OpCode::SEI:
    {
      m_flags.i  = 0;
      break;
    }

    case OpCode::BIT_ZPG:
    case OpCode::BIT_ABS:
    {
      // A and M. M7 -> flags.s, m6 -> flags.v
      u8 m = ReadMemory(op == OpCode::BIT_ZPG ? lo : GetAddr());
      u8 res = regs.a & m;
      m_flags.z = res == 0;
      m_flags.v = (m & 0x40) == 0x40;
      m_flags.s = (m & 0x80) == 0x80;
      break;
    }

    case OpCode::DEX:
    {
      StoreRegister(&regs.x, regs.x - 1);
      SetFlags(regs.x);
      break;
    }

    case OpCode::DEY:
    {
      StoreRegister(&regs.y, regs.y - 1);
      SetFlags(regs.y);
      break;
    }

    case OpCode::INC_ABS:
    {
      u8 tmp = memory[GetAddr()] + 1;
      StoreAbsolute(GetAddr(), tmp);
      SetFlags(tmp);
      break;
    }

    case OpCode::INC_ZPG:
    {
      u8 tmp = memory[lo] + 1;
      StoreAbsolute(lo, tmp);
      SetFlags(tmp);
      break;
    }

    case OpCode::INC_ABS_X:
    {
      u8 tmp = memory[(u16)(GetAddr()+regs.x)] + 1;
      StoreAbsolute(GetAddr(), tmp);
      SetFlags(tmp);
      break;
    }

    case OpCode::INC_ZPG_X:
    {
      u8 tmp = memory[(u8)(lo+regs.x)] + 1;
      StoreAbsolute(lo, tmp);
      SetFlags(tmp);
      break;
    }

    case OpCode::INX:
    {
      regs.x++;
      SetFlags(regs.x);
      break;
    }

    case OpCode::INY:
    {
      regs.y++;
      SetFlags(regs.y);
      break;
    }

    //////////////////////////////////////////////////////////////////////////
    // Transfer
    //////////////////////////////////////////////////////////////////////////
    case OpCode::TAX:
    {
      Transfer(&regs.x, &regs.a);
      break;
    }

    case OpCode::TAY:
    {
      Transfer(&regs.y, &regs.a);
      break;
    }

    case OpCode::TSX:
    {
      Transfer(&regs.x, (s8*)&regs.s);
      break;
    }

    case OpCode::TXS:
    {
      Transfer((s8*)&regs.s, &regs.x);
      break;
    }

    case OpCode::TXA:
    {
      Transfer(&regs.a, &regs.x);
      break;
    }

    case OpCode::TYA:
    {
      Transfer(&regs.a, &regs.y);
      break;
    }

    //////////////////////////////////////////////////////////////////////////
    // Store
    //////////////////////////////////////////////////////////////////////////
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

    //////////////////////////////////////////////////////////////////////////
    // Load
    //////////////////////////////////////////////////////////////////////////
    case OpCode::LDA_IMM:
    {
      StoreRegister(&regs.a, (s8)lo);
      break;
    }

    case OpCode::LDA_ZPG:
    {
      StoreRegister(&regs.a, (s8)memory[lo]);
      break;
    }

    case OpCode::LDA_ZPG_X:
    {
      StoreRegister(&regs.a, (s8)memory[(u8)(lo+regs.x)]);
      break;
    }

    case OpCode::LDA_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.a);
      break;
    }

    case OpCode::LDA_ABS_X:
    {
      LoadAbsolute((u16)(GetAddr()+regs.x), (u8*)&regs.a);
      break;
    }

    case OpCode::LDA_ABS_Y:
    {
      LoadAbsolute((u16)(GetAddr()+regs.y), (u8*)&regs.a);
      break;
    }

    // add indirect loads

    case OpCode::LDX_IMM:
    {
      StoreRegister(&regs.x, (s8)lo);
      break;
    }

    case OpCode::LDX_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.x);
      break;
    }

    case OpCode::LDX_ABS_Y:
    {
      LoadAbsolute((u16)(GetAddr()+regs.y), (u8*)&regs.x);
      break;
    }

    case OpCode::LDX_ZPG:
    {
      StoreRegister(&regs.x, (s8)memory[lo]);
      break;
    }

    case OpCode::LDX_ZPG_Y:
    {
      StoreRegister(&regs.x, (s8)memory[(u8)(lo+regs.y)]);
      break;
    }

    case OpCode::LDY_IMM:
    {
      StoreRegister(&regs.y, (s8)lo);
      break;
    }


    case OpCode::LDY_ABS:
    {
      LoadAbsolute(GetAddr(), (u8*)&regs.y);
      break;
    }

    //////////////////////////////////////////////////////////////////////////
    // Stack instructions
    //////////////////////////////////////////////////////////////////////////
    case OpCode::PHA:
    {
      Push8(regs.a);
      break;
    }

    case OpCode::PLA:
    {
      regs.a = Pop8();
      break;
    }

    //////////////////////////////////////////////////////////////////////////
    // Branching instructions
    //////////////////////////////////////////////////////////////////////////

#define BRANCH_ON_FLAG(f)   \
if (!m_flags.f) {             \
  regs.ip += (s8)lo;        \
}

    case OpCode::BPL_REL:
      BRANCH_ON_FLAG(s);
      break;

    case OpCode::BNE_REL:
      BRANCH_ON_FLAG(z);
      break;

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
      ofs + i * 16,
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

  fnDrawFlag("C", m_flags.c);
  fnDrawFlag("Z", m_flags.z);
  fnDrawFlag("I", m_flags.i);
  fnDrawFlag("D", m_flags.d);
  fnDrawFlag("B", m_flags.b);
  fnDrawFlag("V", m_flags.v);
  fnDrawFlag("S", m_flags.s);

  text.setColor(sf::Color::White);
  pos.x += 20;
  fnRegister8("A", regs.a);
  fnRegister8("X", regs.x);
  fnRegister8("Y", regs.y);
  fnRegister16("IP", regs.ip);
  fnRegister16("S", regs.s);

  pos = sf::Vector2f(0, 20);

  auto& rom = m_prgRom[currentBank];
  u32 ofs = 0x8000;

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
    size_t delta = distance(rom.disasm.begin(), it);
    auto startIt = max(rom.disasm.begin(), it - min(delta, 10u + disasmOfs));
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
  RenderMemory(window, memoryOfs);
}


int main(int argc, const char * argv[])
{
  // Create the main window
  sf::RenderWindow window(sf::VideoMode(800, 600, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

  sf::Image image;
  image.create(32*8, 30*8);

  if (argc < 2)
  {
    return 1;
  }
  
  Cpu6502::Status status = cpu.LoadINes(argv[1]);
  if (status != Cpu6502::Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  cpu.Reset();
  cpu.RenderState(window);
  window.display();

  u64 lastTick = mach_absolute_time();
  u64 tickCount = 0;
  bool executing = false;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

  auto IsRunning = [&]() { return executing || runUntilBranch || runUntilReturn; };

  bool done = false;
  while (!done)
  {
    tickCount++;

    if (IsRunning() && ((tickCount % 20) == 0) || !IsRunning())
    {
      window.clear();
    }

    sf::Event event;
    if ((IsRunning() && window.pollEvent(event)) || (!IsRunning() && window.waitEvent(event)))
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
            runUntilBranch = true;
            break;
          }

          case sf::Keyboard::D:
          {
            if (!cpu.m_prgRom.empty())
            {
              for (auto& d : cpu.m_prgRom[0].disasm)
              {
                printf("%.4x  %s\n", d.first, d.second.c_str());
              }
            }
            break;
          }

          case sf::Keyboard::Y:
          {
            for (size_t i = 0; i < 30*8; ++i)
            {
              ppu.DrawScanline(image);
            }

            image.saveToFile("/Users/dooz/tmp/tjong.png");
            break;
          }

          case sf::Keyboard::O:
          {
            runUntilReturn = true;
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

          case sf::Keyboard::J:
          {
            cpu.memoryOfs += 10 * 16;
            break;
          }

          case sf::Keyboard::K:
          {
            cpu.memoryOfs -= 10 * 16;
            break;
          }

          case sf::Keyboard::X:
          {
            executing = !executing;
            break;
          }
        }
      }
    }

    if (executing || runUntilReturn || runUntilBranch)
    {
      ppu.Tick();
      cpu.Tick();
/*
      u64 now = mach_absolute_time();
      u64 delta = now - lastTick;
      Nanoseconds deltaNs = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);

      // 236250000.0 / 11
      s64 masterClock = 236250000;
      // Time between master clock ticks (ns)
      double masterClockTickInterval = 1e9 / (masterClock / 11.0);

      u64 d = ((u64)deltaNs.hi << 32ul) + (u64)deltaNs.lo;
      if (d > masterClockTickInterval)
      {
        tickCount++;

        if ((tickCount % 4) == 0)
        {
          ppu.Tick();
        }

        if ((tickCount % 12) == 0)
        {
          cpu.Tick();

        }
        lastTick = now;
      }
 */
      if (runUntilReturn)
      {
        OpCode op = cpu.PeekOp();
        if (op == OpCode::RTS || op == OpCode::RTI)
        {
          runUntilReturn = false;
        }
      }

      if (runUntilBranch)
      {
        OpCode op = cpu.PeekOp();
        if (g_branchingOpCodes[(u8)op])
        {
          runUntilBranch = false;
        }
      }
    }

    if (IsRunning() && ((tickCount % 20) == 0) || !IsRunning())
    {
      cpu.RenderState(window);
      window.display();
    }

  }

  return 0;
}
