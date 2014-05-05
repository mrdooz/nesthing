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
    void ExecuteNmi();
    bool InNmi() const;

    void SetIp(u32 v);
    u8 SingleStep();
    Status Reset();

    void Transfer(u8* dst, u8* src);
    void WriteRegisterAndFlags(u8* reg, u8 value);
    void WriteMemory(u16 addr, u8 value);
    u8 ReadMemory(u16 addr);

    void SetFlags(u8 value);

    void RenderState(sf::RenderWindow& window);
    void RenderStack(sf::RenderWindow& window);
    void RenderMemory(sf::RenderWindow& window, u16 ofs);
    void RenderRegisters(sf::RenderWindow& window);
    void RenderDisassembly(sf::RenderWindow& window);
    bool ByteVisible(u16 addr) const;

    void Push16(u16 value);
    void Push8(u8 value);
    u16 Pop16();
    u8 Pop8();

    void DoBinOp(BinOp op, s8* reg, u8 value);
    void UpdateCursorPos(int delta);
    void ToggleBreakpointAtCursor();
    void RunToCursor();
    bool IpAtBreakpoint();
    void StepOver();

    OpCode PeekOp();

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
    } m_flags;

    vector<u8> m_memory;
    vector<u8> m_memoryAge;

    vector<PrgRom> m_prgRom;

    size_t m_currentBank;

    struct  
    {
      u16 ip;
      u8 s;
      u8 a, x, y;
    } m_regs;

    sf::Font font;

    size_t m_memoryOfs;
    size_t disasmOfs;

    InterruptVectors m_interruptVector;

    enum {
      PermanentBreakpoint = 1 << 0,
      TemporaryBreakpoint = 1 << 1,
    };
    vector<u8> m_breakpoints;

    // TODO: replace with a higher level NES thing that contains both the PPU and the CPU
    PPU* m_ppu;
    MMC1* m_mmc1;

    bool m_freeMovement;
    u16 m_cursorIp;
    u16 m_storedIp;
    u8 m_storedFlags;
    bool m_inNmi;

    bool m_loadButtonStates;
    u8 m_buttonState[8];
    u8 m_buttonIdx;

    u16 m_dmaReadAddr;
    u16 m_dmaBytesLeft;
  };
}

