#include "mmc1.hpp"

using namespace nes;

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
