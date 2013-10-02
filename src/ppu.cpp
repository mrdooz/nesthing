#include "ppu.hpp"
#include "nes_helpers.hpp"

using namespace nes;

//  |  $2000  | PPU Control Register #1 (W)                              |
//  |         |                                                          |
//  |         |    D7: Execute NMI on VBlank                             |
//  |         |           0 = Disabled                                   |
//  |         |           1 = Enabled                                    |
//  |         |    D6: PPU Master/Slave Selection --+                    |
//  |         |           0 = Master                +-- UNUSED           |
//  |         |           1 = Slave               --+                    |
//  |         |    D5: Sprite Size                                       |
//  |         |           0 = 8x8                                        |
//  |         |           1 = 8x16                                       |
//  |         |    D4: Background Pattern Table Address                  |
//  |         |           0 = $0000 (VRAM)                               |
//  |         |           1 = $1000 (VRAM)                               |
//  |         |    D3: Sprite Pattern Table Address                      |
//  |         |           0 = $0000 (VRAM)                               |
//  |         |           1 = $1000 (VRAM)                               |
//  |         |    D2: PPU Address Increment                             |
//  |         |           0 = Increment by 1                             |
//  |         |           1 = Increment by 32                            |
//  |         | D1-D0: Name Table Address                                |
//  |         |         00 = $2000 (VRAM)                                |
//  |         |         01 = $2400 (VRAM)                                |
//  |         |         10 = $2800 (VRAM)                                |
//  |         |         11 = $2C00 (VRAM)                                |
//  +---------+----------------------------------------------------------+
//  |  $2001  | PPU Control Register #2 (W)                              |
//  |         |                                                          |
//  |         | D7-D5: Full Background Colour (when D0 == 1)             |
//  |         |         000 = None  +------------+                       |
//  |         |         001 = Green              | NOTE: Do not use more |
//  |         |         010 = Blue               |       than one type   |
//  |         |         100 = Red   +------------+                       |
//  |         | D7-D5: Colour Intensity (when D0 == 0)                   |
//  |         |         000 = None            +--+                       |
//  |         |         001 = Intensify green    | NOTE: Do not use more |
//  |         |         010 = Intensify blue     |       than one type   |
//  |         |         100 = Intensify red   +--+                       |
//  |         |    D4: Sprite Visibility                                 |
//  |         |           0 = Sprites not displayed                      |
//  |         |           1 = Sprites visible                            |
//  |         |    D3: Background Visibility                             |
//  |         |           0 = Background not displayed                   |
//  |         |           1 = Background visible                         |
//  |         |    D2: Sprite Clipping                                   |
//  |         |           0 = Sprites invisible in left 8-pixel column   |
//  |         |           1 = No clipping                                |
//  |         |    D1: Background Clipping                               |
//  |         |           0 = BG invisible in left 8-pixel column        |
//  |         |           1 = No clipping                                |
//  |         |    D0: Display Type                                      |
//  |         |           0 = Colour display                             |
//  |         |           1 = Monochrome display

PPU::PPU()
  : m_hiLoLatch(true)
  , m_writeAddr(0)
  , m_readAddr(0)
  , m_oamAddr(0)
  , m_spriteRamOfs(0)
  , m_evenFrame(true)
  , m_hscroll(0)
  , m_vscroll(0)
  , m_backgroundTableAddr(0)
  , m_spriteTableAddr(0)
  , m_nameTableAddr(0x2000)
  , m_backgroundTableIdx(0)
  , m_spriteTableIdx(0)
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

  u8* nameTable = &m_memory[m_nameTableAddr];
  //  u8* base = &m_memory[m_nameTableAddr];
  for (int i = 0; i < 32; ++i)
  {
    u8 sprite = nameTable[tileY*32+i];
    for (int j = 0; j < 8; ++j)
    {
      u8 pixel = m_patternTable[m_backgroundTableIdx].sprites[sprite].data[(m_curScanline&7)*8+j];
      image.setPixel(i*8+j, m_curScanline, sf::Color(g_NesPalette[pixel*3+0], g_NesPalette[pixel*3+1], g_NesPalette[pixel*3+2]));
    }
  }

  if (++m_curScanline == 30*8)
  {
    m_curScanline = 0;
  }

  // Sprite
}

void PPU::SetControl1(u8 value)
{
  m_control1.reg = value;
  if (m_control1.backgroundPatterTableAddr)
  {
    m_backgroundTableAddr = 0x1000;
    m_backgroundTableIdx = 1;
  }
  else
  {
    m_backgroundTableAddr = 0;
    m_backgroundTableIdx = 0;
  }

  if (m_control1.spritePatternTableAddr)
  {
    m_spriteTableAddr = 0x1000;
    m_spriteTableIdx = 1;
  }
  else
  {
    m_spriteTableAddr = 0;
    m_spriteTableIdx = 0;
  }

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
    m_memory[m_writeAddr] = value;
    m_writeAddr += m_control1.ppuAddressIncr ? 32 : 1;
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
