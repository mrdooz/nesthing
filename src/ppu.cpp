#include "ppu.hpp"
#include "nes_helpers.hpp"

#ifdef _WIN32
#define NOMINMAX
#include <windows.h>
#endif

using namespace nes;

extern vector<u32> g_nesPixels;

u32 ColorToU32(const nes::Color& col)
{
  return ((u32)col.a << 24) + ((u32)col.r << 16) + ((u32)col.g << 8) + (u32)(col.b);
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
  : _hiLoLatch(true)
  , _writeAddr(0)
  , _readAddr(0)
  , _spriteRamOfs(0)
  , _evenFrame(true)
  , _hscroll(0)
  , _vscroll(0)
  , _memory(MEMORY_SIZE)
  , _backgroundTableAddr(0)
  , _spriteTableAddr(0)
  , _nameTableAddr(0x2000)
  , _curScanline(-1)
  , _scanlineTick(0)
  , _oamIdx(0)
{
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

  if (!_hiLoLatch)
  {
    int a = 10;
  }


  // process current scan line
  if (_curScanline < 240)
  {
    if (_scanlineTick > 0)
    {
      if (_curScanline == -1)
      {
        // pre render
        if (_scanlineTick == 1)
        {
          // turn vblank off
          _status.vblank = 0;
        }
      }

      // the 256 pixels consist of 32 8 pixel blocks
      // each memory fetch takes 2 cycles, and the following cycle is
      // performed for each block
      // 1) fetch name table byte
      // 2) fetch attribute table byte
      // 3) 2 x fetch pattern table byte

      if (_curScanline >= 0 && _scanlineTick < 256)
      {
        u16 x = _scanlineTick;
        u16 y = _curScanline;

        // brutal and hackish!
        u16 tileX = x / 8;
        u16 tileY = y / 8;

        u16 tileOfsX = x & 7;
        u16 tileOfsY = y & 7;

        // tile for current pixel
        u16 nameTable = _memory[_nameTableAddr + tileY * 32 + tileX];

        // fetch low bit for tile
        u8 loByte = _memory[_backgroundTableAddr + nameTable * 16 + 0 + tileOfsY];
        u8 hiByte = _memory[_backgroundTableAddr + nameTable * 16 + 8 + tileOfsY];

        // the attribute table contains the upper 2 bits of the pallete for
        // a 16x16 pixel block
        u16 attributeX = x / 32;
        u16 attributeY = y / 32;
        u8 attributeByte = _memory[_nameTableAddr + 0x3c0 + attributeY * 8 + attributeX];
        u16 attributeOfsX = x & 0xf;
        u16 attributeOfsY = y & 0xf;
        u8 attributeMask = ((attributeOfsX >> 3) << 1) + ((attributeOfsY >> 3) << 2);
        u8 attributeValue = (attributeByte >> attributeMask) & 0x3;

        u16 ofs = 7 - tileOfsX;
        u16 col = (attributeValue << 2) + (((hiByte >> ofs) & 1) << 1) + ((loByte >> ofs) & 1);
        col = _memory[0x3f00 + col];

        // draw sprite
        for (u32 s = 0; s < _numSprites; ++s)
        {
          const OamEntry& oam = _secondaryOam[s];
          // todo: why can this go negative?
          s32 yOfs = max(0, y - oam.vpos);
          s32 xOfs = max(0, (s32)x - (s32)oam.hpos);
          if (xOfs >= 0 && xOfs < 8)
          {
            u16 tileBank = oam.tile & 1;
            u16 tileAddr = (tileBank << 10) + 16 * (oam.tile >> 1);

            if (!oam.hflip)
              xOfs = 7 - xOfs;

            if (oam.vflip)
              yOfs = 7 - yOfs;

            u8 loByte = _memory[tileAddr + 0 + yOfs];
            u8 hiByte = _memory[tileAddr + 8 + yOfs];

            u16 pal = oam.palette;
            col = (pal << 2) + (((hiByte >> xOfs) & 1) << 1) + ((loByte >> xOfs) & 1);
            col = _memory[0x3f10 + col];
          }
        }

        if (_curScanline >= 0)
        {
          nes::Color cc(g_NesPalette[col*3+2], g_NesPalette[col*3+1], g_NesPalette[col*3+0]);
          g_nesPixels[_curScanline * 256 + _scanlineTick] = ColorToU32(cc);
        }
      }
    }
  }
  else if (_curScanline == 240)
  {
    // idle..
  }
  else
  {
    // in vblank
    if (_scanlineTick == 1 && _curScanline == 241)
    {
      // turn vblank on
      if (_control1.nmiOnVBlank)
        _triggerNmi = true;
      _status.vblank = 1;
    }
  }

  // each scan line is 341 ticks, except for line 0 every odd frame
  u16 ticksOnScanline = _curScanline == 0 && !_evenFrame ? 340 : 341;
  if (_scanlineTick == ticksOnScanline)
  {
    // check for visible sprites
    _numSprites = 0;
    // TODO: lowered max to 8
    for (u32 i = 0; i < 64 && _numSprites < 8; ++i)
    {
      s16 nextScanLine = _curScanline + 1;
      s16 cand = _oam[i].vpos;
      s16 delta = nextScanLine - cand;
      if (delta >= 0 && delta < 8)
      {
        _secondaryOam[_numSprites++] = _oam[i];
      }
    }

    if (_curScanline++ == 261)
    {
      _curScanline = -1;
    }

    _scanlineTick = 0;
  }
  else
  {
    _scanlineTick++;
  }
}

void PPU::SetControl1(u8 value)
{
  _control1.reg = value;

  _backgroundTableAddr = _control1.backgroundPatterTableAddr ? 0x1000 : 0;
  _spriteTableAddr     = _control1.spritePatternTableAddr ? 0x1000 : 0;

  switch (_control1.nameTableAddr)
  {
    case 0: _nameTableAddr = 0x2000; break;
    case 1: _nameTableAddr = 0x2400; break;
    case 2: _nameTableAddr = 0x2800; break;
    case 3: _nameTableAddr = 0x2c00; break;
  }
}

void PPU::SetControl2(u8 value)
{
  m_control2.reg = value;
}

void PPU::WriteMemory(u16 addr, u8 value)
{
  // only the lower 14 bits of addr are used
  addr = addr & (u16)0x3fff;

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
    _spriteRamOfs = value;
    break;

  case 0x2004:
    // Write to sprite RAM (OAMDATA)
    _spriteRam[_spriteRamOfs++] = value;
    break;

  case 0x2005:
    // Video RAM register 1 (PPUSCROLL)
    if (_hiLoLatch)
    {
      _hscroll = value;
    }
    else
    {
      _vscroll = value;
    }

    _hiLoLatch = !_hiLoLatch;
    break;

  case 0x2006:
    // Video RAM register 2 (PPUADDR)
    if (_hiLoLatch)
    {
      // set the upper 8 bits
      _writeAddr &= 0xffff;
      _writeAddr |= (u16)(value & 0x3f) << 8;
      _readAddr = _writeAddr;
    }
    else
    {
      _writeAddr &= 0xffff0000;
      _writeAddr |= value;
      _readAddr = _writeAddr;
    }

    printf("write addr: %.4x (%.2x)\n", _writeAddr, value);

    _hiLoLatch = !_hiLoLatch;
    break;

  case 0x2007:
    // Note, this should only be done during vblank or when rendering is disabled
    // Video RAM I/O register
    if (_writeAddr < _memory.size())
    {
      _memory[_writeAddr] = value;
      _writeAddr += _control1.ppuAddressIncr ? 32 : 1;
      printf("%.2x  ", value);

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
    _hiLoLatch = true;

    // Reading from 0x2002 resets the vblank flag
    u8 tmp = _status.reg;
    _status.vblank = 0;
    return tmp;
  }
  else if (addr == 0x2007)
  {
    _writeAddr += _control1.ppuAddressIncr ? 32 : 1;
  }

  return 0;
}

bool PPU::TriggerNmi()
{
  bool tmp = _triggerNmi;
  _triggerNmi = false;
  return tmp;
}
