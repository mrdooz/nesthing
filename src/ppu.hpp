#pragma once

#include "nesthing.hpp"

namespace nes
{
  struct PPU
  {
    PPU();
    void Tick();
    void WriteMemory(u16 addr, u8 value);
    u8 ReadMemory(u16 addr);
    void DumpVRom();
    void DumpNameTable(u16 nameTableOfs, Image *image);

    void SetControl1(u8 value);
    void SetControl2(u8 value);

    bool TriggerNmi();

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
    } _control1;

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
    } _status;

    struct OamEntry
    {
      u8 vpos;
      u8 tile;
      u8 palette : 2;
      u8 reserverd : 3;
      u8 prio : 1;
      u8 hflip : 1;
      u8 vflip : 1;
      u8 hpos;
    };

    union
    {
      OamEntry _oam[64];
      u8 _spriteRam[256];
    };

    union
    {
      OamEntry _secondaryOam[8];
      u8 _secondaryOamRaw[32];
    };

    bool _hiLoLatch; // false = low byte
    u16 _writeAddr;
    u16 _readAddr;

    u8 _spriteRamOfs;

    bool _evenFrame;
    u8 _hscroll;
    u8 _vscroll;
    vector<u8> _memory;

    u16 _backgroundTableAddr;
    u16 _spriteTableAddr;
    u16 _nameTableAddr;
    u8 _numSprites;

    s16 _curScanline;
    u16 _scanlineTick;
    u8 _oamIdx;
    bool _triggerNmi;
  };

}