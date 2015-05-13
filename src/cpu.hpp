#pragma once

#include "nesthing.hpp"
#include "opcodes.hpp"

namespace nes
{
  struct PPU;
  struct MMC1;

  // the 3 interrupt vectors are at the back of the last bank
  struct InterruptVectors
  {
    u16 nmi;
    u16 reset;
    u16 brk;
  };

  struct PrgRom
  {
    u16 base;
    array<u8, 16*1024> data;
  };
  
  enum class Button
  {
    A,
    B,
    Select,
    Start,
    Up,
    Down,
    Left,
    Right
  };

  struct Cpu6502
  {
    enum class BinOp
    {
      OR,
      AND,
      XOR
    };

    Cpu6502(PPU* ppu, MMC1* mmc1);

    u8 Tick();
    void ExecuteNmi();
    bool InNmi() const;
    Status Reset();
    
    void SetInput(Button btn, int controller);

    void Transfer(u8* dst, u8* src);
    void WriteRegisterAndFlags(u8* reg, u8 value);
    void WriteMemory(u16 addr, u8 value);
    u8 ReadMemory(u16 addr);
    u16 ReadMemory16(u16 addr);

    u8 ReadCpuMemory8(u16 addr);
    u16 ReadCpuMemory16(u16 addr);

    void RelBranchOnFlag(u8 flag, u8 ofs);
    void RelBranchOnNegFlag(u8 flag, u8 ofs);

    void SetFlagsZS(u8 value);

    void Push16(u16 value);
    void Push8(u8 value);
    u16 Pop16();
    u8 Pop8();

    void DoBinOp(BinOp op, u8* reg, u8 value);
    OpCode PeekOp();

    struct CpuFlags
    {
      union
      {
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
        };
        u8 reg;
      };
    };

    CpuFlags _flags;

    static_assert(sizeof(CpuFlags) == sizeof(u8), "invalid flag size");

    vector<u8> _memory;

    // TODO: some kind of cartridge abstraction here that implements bank switching etc
    vector<PrgRom> _prgRom;
    size_t _currentBank;

    struct  
    {
      u16 ip;
      u8 s;
      u8 a, x, y;
    } _regs;

    InterruptVectors _interruptVector;

    // TODO: replace with a higher level NES thing that contains both the PPU and the CPU
    PPU* _ppu;
    //MMC1* m_mmc1;

    bool m_inNmi;

    // A, B, Select, Start, Up, Down, Left, Right.
    u8 m_tmpButtonState[8];
    u8 m_buttonState[8];
    u8 m_buttonIdx;

    u16 m_dmaReadAddr;
    u16 m_dmaBytesLeft;
  };
}

