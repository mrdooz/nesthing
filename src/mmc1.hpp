#pragma once
#include "nesthing.hpp"

namespace nes
{
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
}