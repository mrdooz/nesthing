#include "ppu.hpp"
#include "nes_helpers.hpp"

using namespace nes;
#define DUMP_TO_STDOUT 0

extern u32 g_nesPixels[256*240];

u32 ColorToU32(const sf::Color& col)
{
  return (col.a << 24) + (col.r << 16) + (col.g << 8) + (col.b);
}

// PPU memory map
//Address   Size    Description
//$0000     $1000   Pattern Table 0
//$1000     $1000   Pattern Table 1
//$2000     $3C0    Name Table 0
//$23C0     $40     Attribute Table 0
//$2400     $3C0    Name Table 1
//$27C0     $40     Attribute Table 1
//$2800     $3C0    Name Table 2
//$2BC0     $40     Attribute Table 2
//$2C00       $3C0    Name Table 3
//$2FC0     $40     Attribute Table 3
//$3000     $F00    Mirror of 2000h-2EFFh
//$3F00     $10     BG Palette
//$3F10     $10     Sprite Palette
//$3F20     $E0     Mirror of 3F00h-3F1Fh

namespace
{
  size_t MEMORY_SIZE = 16 * 1024;
}

PPU::PPU()
  : m_hiLoLatch(true)
  , m_writeAddr(0)
  , m_readAddr(0)
  , m_oamAddr(0)
  , m_spriteRamOfs(0)
  , m_evenFrame(true)
  , m_hscroll(0)
  , m_vscroll(0)
  , m_memory(MEMORY_SIZE)
  , _backgroundTableAddr(0)
  , m_spriteTableAddr(0)
  , m_nameTableAddr(0x2000)
  , m_backgroundTableIdx(0)
  , m_spriteTableIdx(0)
  , m_curScanline(-1)
  , m_scanlineTick(0)
  , m_curCycle(0)
  , m_memoryAccessCycle(0)
  , m_OamIdx(0)
  , _curNameTable(0)
{
  m_nameTable[0] = 0x2000;
  m_nameTable[1] = 0x2400;
  m_nameTable[2] = 0x2800;
  m_nameTable[3] = 0x2c00;
}

void PPU::Tick()
{
  // The PPU is ticked every 4th master clock cycle
  // The screen is divided into 262 scanlines, each having 341 columns, as such:
  //
  //           x=0                 x=256      x=340
  //       ___|____________________|__________|
  //  y=-1    | pre-render scanline| prepare  |
  //       ___|____________________| sprites _|
  //  y=0     | visible area       | for the  |
  //          | - this is rendered | next     |
  //  y=239   |   on the screen.   | scanline |
  //       ___|____________________|______
  //  y=240   | idle
  //       ___|_______________________________
  //  y=241   | vertical blanking (idle)
  //          | 20 scanlines long
  //  y=260___|____________________|__________|
  //

  // process current scan line
  if (m_curScanline < 240)
  {
    // tick 0 is idle, so skip if
    if (m_scanlineTick > 0)
    {
      if (m_curScanline == -1)
      {
        // pre render
        if (m_scanlineTick == 1)
        {
          // turn vblank off
          m_status.vblank = 0;
        }
      }

      // the 256 pixels consist of 32 8 pixel blocks
      // each memory fetch takes 2 cycles, and the following cycle is
      // performed for each block
      // 1) fetch name table byte
      // 2) fetch attribute table byte
      // 3) 2 x fetch pattern table byte

      if (m_scanlineTick <= 256)
      {
        u16 x = m_scanlineTick / 8;
        u16 y = m_curScanline / 8;
        u8* nameTable = &m_memory[0x400];
        switch (m_scanlineTick & 7)
        {
          // name table byte
          case 0: break;
          case 1: _curNameTable = nameTable[y*32+x];
          // attribute table
          case 2: break;
          case 3:
          // pattern table
          case 4: break;
          case 5:
          // pattern table
          case 6: break;
          case 7: break;
        }

        if (m_curScanline >= 0)
        {
          // draw the current pixel using current name table
          u8 t = nameTable[_curNameTable*16];
          u8 v = 255 * ((t >> ((m_scanlineTick & 7) & 7)) & 1);
          g_nesPixels[m_curScanline*256+m_scanlineTick] = ColorToU32(sf::Color(v, v, v, 0xff));
        }
      }

    }

  }
  else if (m_curScanline == 240)
  {
    // idle..
  }
  else
  {
    // in vblank
    if (m_scanlineTick == 1 && m_curScanline == 241)
    {
      // turn vblank on
      m_triggerNmi = m_control1.nmiOnVBlank > 0;
      m_status.vblank = 1;
    }
  }

  // each scan line is 341 ticks, except for line 0 every odd frame
  u16 ticksOnScanline = m_curScanline == 0 && !m_evenFrame ? 340 : 341;
  if (m_scanlineTick == ticksOnScanline)
  {
    if (m_curScanline++ == 261)
    {
      m_curScanline = -1;
    }

    m_scanlineTick = 0;
  }
  else
  {
    m_scanlineTick++;
  }
}

void PPU::DrawScanline(int scanline, sf::Image& image)
{
  // Background
  // 32x30 tiles (8x8)
  int tileY = m_curScanline / 8;

  u8* nameTable = &m_memory[m_nameTableAddr];
  for (int i = 0; i < 32; ++i)
  {
    u8 sprite = nameTable[tileY*32+i];
    for (int j = 0; j < 8; ++j)
    {
      u8 pixel = _patternTable[m_backgroundTableIdx].sprites[sprite].data[(scanline&7)*8+j];
      image.setPixel(i*8+j, scanline, sf::Color(g_NesPalette[pixel*3+0], g_NesPalette[pixel*3+1], g_NesPalette[pixel*3+2]));
    }
  }

  // Sprite
}

void PPU::SetControl1(u8 value)
{
  m_control1.reg = value;
  _backgroundTableAddr = m_control1.backgroundPatterTableAddr ? 0x1000 : 0;
  m_backgroundTableIdx  = m_control1.backgroundPatterTableAddr ? 1 : 0;

  m_spriteTableAddr = m_control1.spritePatternTableAddr ? 0x1000 : 0;
  m_spriteTableIdx  = m_control1.spritePatternTableAddr ? 1 : 0;

  switch (m_control1.nameTableAddr)
  {
    case 0: m_nameTableAddr = 0x2000; break;
    case 1: m_nameTableAddr = 0x2400; break;
    case 2: m_nameTableAddr = 0x2800; break;
    case 3: m_nameTableAddr = 0x2c00; break;
  }
}

void PPU::SetControl2(u8 value)
{
  m_control2.reg = value;
}

void PPU::WriteMemory(u16 addr, u8 value)
{
  // only the lower 14 bits of addr are used
  addr = addr & 0x3fff;

  // 0x2000 - 0x2007 is mirrored between 0x2008 -> 0x3fff
  switch (0x2000 + (addr & 0x7))
  {
  case 0x2000:
    // Control register 1 (PPUCTRL)
    SetControl1(value);
    break;

  case 0x2001:
    // Control register 2 (PPUMASK)
    SetControl2(value);
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
    if (m_writeAddr < m_memory.size())
    {
      m_memory[m_writeAddr] = value;
      m_writeAddr += m_control1.ppuAddressIncr ? 32 : 1;
    }
    break;
  }
}

u8 PPU::ReadMemory(u16 addr)
{
  if (addr == 0x2002)
  {
    // PPUSTATUS

    // Reset hi/lo latch
    m_hiLoLatch = true;

    // Reset vblank bit
    u8 tmp = m_status.reg;
    m_status.vblank = 0;
    return tmp;
  }
  else if (addr == 0x2007)
  {

  }

  return 0;
}

void PPU::CreatePatternTable(const u8* data, size_t numTiles, PatternTable* patternTable, Image* image)
{
  // dump a tile bank
  for (size_t i = 0; i < numTiles; ++i)
  {
    // each tile is 8x8 pixels.
    // the tile is split into 2 layers. each layer hold 1 bit for each pixel
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

    int x = numTiles % 16;
    int y = numTiles / 16;

    for (size_t j = 0; j < 8; ++j)
    {
      for (size_t k = 0; k < 8; ++k)
      {
        u8 c = tile[j*8+k];
        if (image)
        {
          image->setPixel(x+k, y+j, Color(g_NesPalette[c*3+0], g_NesPalette[c*3+1], g_NesPalette[c*3+2]));
        }
#if DUMP_TO_STDOUT
        printf("%c", c == 0 ? '.' : '0' + c);
#endif
      }
#if DUMP_TO_STDOUT
      printf("\n");
#endif
    }
#if DUMP_TO_STDOUT
    printf("\n");
#endif
  }
}

void PPU::DumpVRom()
{
  Image image;
  image.create(16*8, 16*8);
  CreatePatternTable(&m_memory[0], 256, &_patternTable[0], &image);
  #if _WIN32
  image.saveToFile("c:/temp/pattern_table0.png");
  #else
  image.saveToFile("/Users/dooz/tmp/pattern_table0.png");
  #endif
  CreatePatternTable(&m_memory[256*16], 256, &_patternTable[1], &image);
#if _WIN32
  image.saveToFile("c:/temp/pattern_table1.png");
  #else
  image.saveToFile("/Users/dooz/tmp/pattern_table1.png");
#endif
}

bool PPU::TriggerNmi()
{
  bool tmp = m_triggerNmi;
  m_triggerNmi = false;
  return tmp;
}
