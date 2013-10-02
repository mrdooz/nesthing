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
    array<u8, 16*1024> data;
    vector<pair<u32, string> > disasm;
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

    void Tick();

    void SetIp(u32 v);
    u8 SingleStep();
    void Reset();

    void Transfer(u8* dst, u8* src);
    void WriteRegisterAndFlags(u8* reg, u8 value);
    void WriteMemory(u16 addr, u8 value);
    void LoadAbsolute(u16 addr, u8* reg);
    u8 ReadMemory(u16 addr);

    void SetFlags(u8 value);

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
      u8 a, x, y;
    } regs;

    sf::Font font;

    size_t memoryOfs;
    size_t disasmOfs;

    InterruptVectors m_interruptVector;

    unordered_set<u16> m_breakpoints;

    // TODO: replace with a higher level NES thing that contains both the PPU and the CPU
    PPU* m_ppu;
    MMC1* m_mmc1;
  };
}

