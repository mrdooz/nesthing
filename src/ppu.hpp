#pragma once

#include "nesthing.hpp"

namespace nes
{
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
    void WriteMemory(u16 addr, u8 value);
    u8 ReadMemory(u16 addr);
    void DumpVRom();
    void ProcessPatternTable(const u8* data, size_t numTiles, PatternTable* patternTable, Image* image);

    void DrawScanline(sf::Image& image);

    void SetControl1(u8 value);
    void SetControl2(u8 value);

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

    u16 m_backgroundTableAddr;
    u16 m_spriteTableAddr;
    u16 m_nameTableAddr;
    u8 m_backgroundTableIdx;
    u8 m_spriteTableIdx;

    u16 m_curScanline;
    u16 m_curCycle;
    u8 m_memoryAccessCycle;
    u8 m_OamIdx;
  };

}