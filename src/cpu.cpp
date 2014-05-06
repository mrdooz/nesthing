#include "cpu.hpp"
#include "nes_helpers.hpp"
#include "ppu.hpp"
#include "mmc1.hpp"
#include <assert.h>

using namespace nes;

namespace
{
  size_t MEMORY_SIZE = 64 * 1024;
  u8 MEMORY_FADE = 32;
}

Cpu6502::Cpu6502(PPU* ppu, MMC1* mmc1)
  : m_memory(MEMORY_SIZE)
  , m_memoryAge(MEMORY_SIZE)
  , m_breakpoints(MEMORY_SIZE)
  , m_currentBank(0)
  , disasmOfs(0)
  , m_memoryOfs(0)
  , m_ppu(ppu)
  , m_mmc1(mmc1)
  , m_freeMovement(true)
  , m_cursorIp(0)
  , m_inNmi(false)
  , m_loadButtonStates(false)
  , m_buttonIdx(0)
  , m_dmaBytesLeft(0)
{
  memset(&m_flags, 0, sizeof(m_flags));
  memset(&m_regs, 0, sizeof(m_regs));
  memset(m_buttonState, 0, sizeof(m_buttonState));
  memset(m_memoryAge.data(), 0, sizeof(MEMORY_SIZE));
  memset(m_breakpoints.data(), 0, sizeof(MEMORY_SIZE));
  m_flags.r = 1;
}

OpCode Cpu6502::PeekOp()
{
  return (OpCode) m_memory[m_regs.ip];
}

void Cpu6502::ExecuteNmi()
{
  if (m_inNmi)
  {
    return;
  }

  // TODO: proper NMI handling (pushing cpu regs on stack etc)
  m_storedIp = m_regs.ip;
  m_storedFlags = m_flags.reg;
  m_regs.ip = m_interruptVector.nmi;
  m_inNmi = true;
}

void Cpu6502::Tick()
{
  SingleStep();
}

void Cpu6502::SetIp(u32 v)
{
  m_regs.ip = v;
}

Status Cpu6502::Reset()
{
  // Turn off interrupts
  m_flags.i = 1;

  // Point the stack ptr to the top of the stack
  m_regs.s = 0xff;

  if (m_prgRom.size() == 1)
  {
    // copy the ROM at 0x8000 to 0xc000
    m_prgRom.push_back(m_prgRom.front());
    m_prgRom.back().base = 0xc000;
  }

  if (m_prgRom.size() == 2)
  {
    memcpy(&m_memory[0x8000], &m_prgRom[0].data[0], 16 * 1024);
    memcpy(&m_memory[0xC000], &m_prgRom[1].data[0], 16 * 1024);
  }
  else
  {
    LOG("Invalid PRG-ROM count: %lu", m_prgRom.size());
    return Status::ERROR_LOADING_ROM;
  }

  // Get the current interrupt table, and start executing the
  // reset interrupt
  m_interruptVector = *(InterruptVectors*)&m_memory[0xfffa];
  m_regs.ip = m_interruptVector.reset;
  m_cursorIp = m_regs.ip;
  m_currentBank = 0;

  return Status::OK;
}

void Cpu6502::DoBinOp(BinOp op, s8* reg, u8 value)
{
  switch (op)
  {
  case BinOp::OR:
    {
      *reg = *reg | value;
      break;
    }

  case BinOp::AND:
    {
      *reg = *reg & value;
      break;
    }

  case BinOp::XOR:
    {
      *reg = *reg ^ value;
      break;
    }

  }
  SetFlags(*reg);
}

void Cpu6502::WriteMemory(u16 addr, u8 value)
{
  if (addr >= 0x2000 && addr <= 0x3fff)
  {
    // Check for PPU writes
    m_ppu->WriteMemory(addr, value);

  }
  else if (addr >= 0x8000)
  {
    // Check for writes to MMC1 registers
    m_mmc1->Write(addr, value);
  }
  else
  {
    switch (addr)
    {
    case 0x4014:
      // Enter DMA mode (writes 256 bytes to 0x2004, 2 bytes per cycle)
      // and write the first byte
      m_dmaReadAddr = 0x100 * (u16)value;
      m_dmaBytesLeft = 256;
      // HACK: write to 2003 to reset the ppu sprite offset
       m_ppu->WriteMemory(0x2003, 0);
      break;

      case 0x4016:
        // lsb controls if the button states should be read or not
        m_loadButtonStates = (value & 1) != 0;
        break;

    default:
      if (!ByteVisible(addr))
      {
        m_memoryOfs = addr;
      }
      m_memory[addr] = value;
      m_memoryAge[addr] = MEMORY_FADE;
      break;
    }

  }

}
u8 Cpu6502::ReadMemory(u16 addr)
{
  if (addr >= 0x2000 && addr <= 0x2007)
  {
    return m_ppu->ReadMemory(addr);
  }
  else if (addr == 0x4016)
  {
    if (m_buttonIdx < 8)
    {
      return m_buttonState[m_buttonIdx++];
    }
    else
    {
      return 0;
    }
  }

  return m_memory[addr];
}

void Cpu6502::SetFlags(u8 value)
{
  m_flags.z = value == 0 ? 1 : 0;
  m_flags.s = value & 0x80 ? 1 : 0;
}


void Cpu6502::Transfer(u8* dst, u8* src)
{
  *dst = *src;
  SetFlags(*dst);
}

void Cpu6502::WriteRegisterAndFlags(u8* reg, u8 value)
{
  *reg = value;
  SetFlags(value);
}

void Cpu6502::Push16(u16 value)
{
  m_memory[0x100 + m_regs.s-1] = (u8)(value & 0xff);
  m_memory[0x100 + m_regs.s-0] = (u8)((value >> 8) & 0xff);
  m_regs.s -= 2;
}

void Cpu6502::Push8(u8 value)
{
  m_memory[0x100 + m_regs.s] = value;
  m_regs.s--;
}

u16 Cpu6502::Pop16()
{
  m_regs.s += 2;
  return (u16) m_memory[0x100 + m_regs.s-1] + ((u16) m_memory[0x100 + m_regs.s] << 8);
}

u8 Cpu6502::Pop8()
{
  m_regs.s++;
  return m_memory[0x100 + m_regs.s];
}

u8 Cpu6502::SingleStep()
{
  // If in a DMA transfer, just do the transfer
  if (m_dmaBytesLeft)
  {
    m_ppu->WriteMemory(0x2004, m_memory[m_dmaReadAddr++]);
    m_dmaBytesLeft--;
    // 2 ticks for a DMA byte transfer
    return 2;
  }

  u8 op8 = m_memory[m_regs.ip];
  OpCode op = (OpCode)op8;
  if (!g_validOpCodes[op8])
  {
    ++m_regs.ip;
    return 1;
  }

  // Load values depending on addressing mode
  AddressingMode addrMode = (AddressingMode)g_addressingModes[op8];
  u8 lo = 0, hi = 0;
  u16 addr = 0;
  switch (addrMode)
  {
    case AddressingMode::ABS:
      addr = m_memory[m_regs.ip+1] + (m_memory[m_regs.ip+2] << 8);
      break;

    case AddressingMode::ABS_X:
      addr = m_memory[m_regs.ip+1] + (m_memory[m_regs.ip+2] << 8) + m_regs.x;
      break;

    case AddressingMode::ABS_Y:
      addr = m_memory[m_regs.ip+1] + (m_memory[m_regs.ip+2] << 8) + m_regs.y;
      break;

    case AddressingMode::IMM:
      lo = m_memory[m_regs.ip+1];
      break;

    case AddressingMode::ZPG:
      addr = m_memory[m_regs.ip+1];
      break;

    case AddressingMode::ZPG_X:
      addr = (m_memory[m_regs.ip+1] + m_regs.x) & 0xff;
      break;

    case AddressingMode::ZPG_Y:
      addr = (m_memory[m_regs.ip+1] + m_regs.y) & 0xff;
      break;

    case AddressingMode::IND:
      addr = m_memory[m_regs.ip+1] + (m_memory[m_regs.ip+2] << 8);
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    case AddressingMode::X_IND:
      addr = (m_memory[m_regs.ip+1] + m_regs.x) & 0xff;
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    case AddressingMode::IND_Y:
      addr = m_memory[m_regs.ip+1];
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8) + m_regs.y;
      break;

    case AddressingMode::REL:
      lo = m_memory[m_regs.ip+1];
      break;

    case AddressingMode::IMPLIED:
    case AddressingMode::ACC:
      break;
  }

  int opLength = g_instrLength[op8];
  bool ipUpdated = false;

  auto fnBranchFlagNotSet = [&](u8 flag){
    if (!flag)
    {
      m_regs.ip += (s8)lo;
    }
  };

  auto fnBranchFlagSet = [&](u8 flag){
    if (flag)
    {
      m_regs.ip += (s8)lo;
    }
  };

  switch (op)
  {
    case OpCode::BRK:
      m_regs.ip = m_interruptVector.brk;
      ipUpdated = true;
      break;

    case OpCode::LSR_A:
    case OpCode::LSR_ABS:
    case OpCode::LSR_ABS_X:
    case OpCode::LSR_ZPG:
    case OpCode::LSR_ZPG_X:
      {
        u8 t = op == OpCode::LSR_A ? m_regs.a : ReadMemory(addr);
        m_flags.c = t & 1;
        t = t >> 1;
        if (op == OpCode::LSR_A)
          m_regs.a = t;
        else
          WriteMemory(addr, t);
        SetFlags(t);
        break;
      }

    case OpCode::ASL_A:
    case OpCode::ASL_ABS:
    case OpCode::ASL_ABS_X:
    case OpCode::ASL_ZPG:
    case OpCode::ASL_ZPG_X:
      {
        u8 t = op == OpCode::ASL_A ? m_regs.a : ReadMemory(addr);
        m_flags.c = (t & 0x80) ? 1 : 0;
        t = t << 1;
        if (op == OpCode::ASL_A)
          m_regs.a = t;
        else
          WriteMemory(addr, t);
        SetFlags(t);
        break;
      }

    case OpCode::ROL_A:
    case OpCode::ROL_ABS:
    case OpCode::ROL_ABS_X:
    case OpCode::ROL_ZPG:
    case OpCode::ROL_ZPG_X:
      {
        u8 t = op == OpCode::ROL_A ? m_regs.a : ReadMemory(addr);
        u8 c = m_flags.c;
        m_flags.c = (t & 0x80) ? 1 : 0;
        t = (t << 1) + (c ? 1 : 0);
        if (op == OpCode::ROL_A)
          m_regs.a = t;
        else
          WriteMemory(addr, t);
        SetFlags(t);
        break;
      }

    case OpCode::ROR_A:
    case OpCode::ROR_ABS:
    case OpCode::ROR_ABS_X:
    case OpCode::ROR_ZPG:
    case OpCode::ROR_ZPG_X:
      {
        u8 t = op == OpCode::ROL_A ? m_regs.a : ReadMemory(addr);
        u8 c = m_flags.c;
        m_flags.c = (t & 0x1) ? 1 : 0;
        t = (t >> 1) + (c ? 0x80 : 0);
        if (op == OpCode::ROL_A)
          m_regs.a = t;
        else
          WriteMemory(addr, t);
        SetFlags(t);
        break;
      }

    case OpCode::AND_ABS:
    case OpCode::AND_ABS_X:
    case OpCode::AND_ABS_Y:
    case OpCode::AND_ZPG:
    case OpCode::AND_ZPG_X:
    case OpCode::AND_X_IND:
    case OpCode::AND_IND_Y:
      lo = ReadMemory(addr);
    case OpCode::AND_IMM:
      DoBinOp(BinOp::AND, (s8*)&m_regs.a, (s8)lo);
      break;

    case OpCode::ORA_ABS:
    case OpCode::ORA_ABS_X:
    case OpCode::ORA_ABS_Y:
    case OpCode::ORA_ZPG:
    case OpCode::ORA_ZPG_X:
    case OpCode::ORA_X_IND:
    case OpCode::ORA_IND_Y:
      lo = ReadMemory(addr);
    case OpCode::ORA_IMM:
      DoBinOp(BinOp::OR, (s8*)&m_regs.a, (s8)lo);
      break;

    case OpCode::EOR_ABS:
    case OpCode::EOR_ABS_X:
    case OpCode::EOR_ABS_Y:
    case OpCode::EOR_ZPG:
    case OpCode::EOR_ZPG_X:
    case OpCode::EOR_X_IND:
    case OpCode::EOR_IND_Y:
      lo = ReadMemory(addr);
    case OpCode::EOR_IMM:
      DoBinOp(BinOp::XOR, (s8*)&m_regs.a, (s8)lo);
      break;

    case OpCode::CLD:
      m_flags.d = 0;
      break;

    case OpCode::CLV:
      m_flags.v = 0;
      break;

    case OpCode::CLI:
      m_flags.i = 1;
      break;

    case OpCode::SEI:
      m_flags.i  = 0;
      break;

    case OpCode::CLC:
      m_flags.c = 0;
      break;

    case OpCode::SEC:
      m_flags.c = 1;
      break;

    case OpCode::SBC_ABS:
    case OpCode::SBC_ABS_X:
    case OpCode::SBC_ABS_Y:
    case OpCode::SBC_IND_Y:
    case OpCode::SBC_X_IND:
    case OpCode::SBC_ZPG:
    case OpCode::SBC_ZPG_X:
      lo = ReadMemory(addr);
    case OpCode::SBC_IMM:
      {
        s16 res = (s8) m_regs.a - (s8)lo - (1 - m_flags.c);
        WriteRegisterAndFlags(&m_regs.a, (u8)res);
        m_flags.v = res > 127 || res < -128 ? 1 : 0;
        m_flags.c = res > 0 && res < 255;
        break;
      }

    case OpCode::ADC_ABS:
    case OpCode::ADC_ABS_X:
    case OpCode::ADC_ABS_Y:
    case OpCode::ADC_IND_Y:
    case OpCode::ADC_X_IND:
    case OpCode::ADC_ZPG:
    case OpCode::ADC_ZPG_X:
      lo = ReadMemory(addr);
    case OpCode::ADC_IMM:
      {
        s16 res = (s8)lo + (s8) m_regs.a + m_flags.c;
        WriteRegisterAndFlags(&m_regs.a, (u8)res);
        m_flags.v = res > 127 || res < -128 ? 1 : 0;
        m_flags.c = res > 255 ? 1 : 0;
        break;
      }

    case OpCode::BIT_ZPG:
    case OpCode::BIT_ABS:
      {
        // A and M. M7 -> flags.s, m6 -> flags.v
        u8 m = ReadMemory(addr);
        u8 res = (u8) m_regs.a & m;
        m_flags.z = res == 0 ? 1 : 0;
        m_flags.v = (m & 0x40) == 0x40 ? 1 : 0;
        m_flags.s = (m & 0x80) == 0x80 ? 1 : 0;
        break;
      }

    case OpCode::DEC_ABS:
    case OpCode::DEC_ABS_X:
    case OpCode::DEC_ZPG:
    case OpCode::DEC_ZPG_X:
      {
        u8 tmp = ReadMemory(addr);
        --tmp;
        SetFlags(tmp);
        WriteMemory(addr, tmp);
        break;
      }

    case OpCode::DEX:
      WriteRegisterAndFlags(&m_regs.x, m_regs.x - 1);
      break;

    case OpCode::DEY:
      WriteRegisterAndFlags(&m_regs.y, m_regs.y - 1);
      break;


    case OpCode::INC_ABS:
    case OpCode::INC_ABS_X:
    case OpCode::INC_ZPG:
    case OpCode::INC_ZPG_X:
      {
        u8 tmp = ReadMemory(addr);
        ++tmp;
        SetFlags(tmp);
        WriteMemory(addr, tmp);
        break;
      }

    case OpCode::INX:
      WriteRegisterAndFlags(&m_regs.x, m_regs.x + 1);
      break;

    case OpCode::INY:
      WriteRegisterAndFlags(&m_regs.y, m_regs.y + 1);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Transfer
      //////////////////////////////////////////////////////////////////////////
    case OpCode::TAX:
      Transfer(&m_regs.x, &m_regs.a);
      break;

    case OpCode::TAY:
      Transfer(&m_regs.y, &m_regs.a);
      break;

    case OpCode::TSX:
      Transfer(&m_regs.x, &m_regs.s);
      break;

    case OpCode::TXS:
      Transfer(&m_regs.s, &m_regs.x);
      break;

    case OpCode::TXA:
      Transfer(&m_regs.a, &m_regs.x);
      break;

    case OpCode::TYA:
      Transfer(&m_regs.a, &m_regs.y);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Store
      //////////////////////////////////////////////////////////////////////////
    case OpCode::STA_ABS:
    case OpCode::STA_ABS_X:
    case OpCode::STA_ABS_Y:
    case OpCode::STA_ZPG:
    case OpCode::STA_ZPG_X:
    case OpCode::STA_X_IND:
    case OpCode::STA_IND_Y:
      WriteMemory(addr, (u8) m_regs.a);
      break;

    case OpCode::STX_ABS:
    case OpCode::STX_ZPG:
    case OpCode::STX_ZPG_Y:
      WriteMemory(addr, (u8) m_regs.x);
      break;

    case OpCode::STY_ABS:
    case OpCode::STY_ZPG:
    case OpCode::STY_ZPG_X:
      WriteMemory(addr, (u8) m_regs.y);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Load
      //////////////////////////////////////////////////////////////////////////
    case OpCode::LDA_ABS:
    case OpCode::LDA_ABS_X:
    case OpCode::LDA_ABS_Y:
    case OpCode::LDA_ZPG:
    case OpCode::LDA_ZPG_X:
    case OpCode::LDA_X_IND:
    case OpCode::LDA_IND_Y:
      lo = ReadMemory(addr);
    case OpCode::LDA_IMM:
      WriteRegisterAndFlags(&m_regs.a, lo);
      break;

    case OpCode::LDX_ABS:
    case OpCode::LDX_ABS_Y:
    case OpCode::LDX_ZPG:
    case OpCode::LDX_ZPG_Y:
      lo = ReadMemory(addr);
    case OpCode::LDX_IMM:
      WriteRegisterAndFlags(&m_regs.x, lo);
      break;

    case OpCode::LDY_ABS:
    case OpCode::LDY_ABS_X:
    case OpCode::LDY_ZPG:
    case OpCode::LDY_ZPG_X:
      lo = ReadMemory(addr);
    case OpCode::LDY_IMM:
      WriteRegisterAndFlags(&m_regs.y, lo);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Stack instructions
      //////////////////////////////////////////////////////////////////////////
    case OpCode::PHA:
      Push8(m_regs.a);
      break;

    case OpCode::PLA:
      m_regs.a = Pop8();
      break;

    case OpCode::PHP:
      Push8(m_flags.reg);
      break;

    case OpCode::PLP:
      m_flags.reg = Pop8();
      break;

    case OpCode::CMP_ABS:
    case OpCode::CMP_ABS_X:
    case OpCode::CMP_ABS_Y:
    case OpCode::CMP_X_IND:
    case OpCode::CMP_IND_Y:
    case OpCode::CMP_ZPG:
    case OpCode::CMP_ZPG_X:
      lo = ReadMemory(addr);
    case OpCode::CMP_IMM:
      m_flags.z = lo == (u8) m_regs.a ? 1 : 0;
      m_flags.s = (m_regs.a & 0x80) == 0x80 ? 1 : 0;
      m_flags.c = m_regs.a >= lo ? 1 : 0;
      break;

    case OpCode::CPX_ABS:
    case OpCode::CPX_ZPG:
      lo = ReadMemory(addr);
    case OpCode::CPX_IMM:
      m_flags.z = lo == (u8) m_regs.x ? 1 : 0;
      m_flags.s = (m_regs.x & 0x80) == 0x80 ? 1 : 0;
      m_flags.c = m_regs.x >= lo ? 1 : 0;
      break;

    case OpCode::CPY_ABS:
    case OpCode::CPY_ZPG:
      lo = ReadMemory(addr);
    case OpCode::CPY_IMM:
      m_flags.z = lo == (u8) m_regs.y ? 1 : 0;
      m_flags.s = (m_regs.y & 0x80) == 0x80 ? 1 : 0;
      m_flags.c = m_regs.y >= lo ? 1 : 0;
      break;

      //////////////////////////////////////////////////////////////////////////
      // Branching instructions
      //////////////////////////////////////////////////////////////////////////

    case OpCode::BPL_REL:
      fnBranchFlagNotSet(m_flags.s);
      break;

    case OpCode::BMI_REL:
      fnBranchFlagSet(m_flags.s);
      break;

    case OpCode::BVC_REL:
      fnBranchFlagNotSet(m_flags.v);
      break;

    case OpCode::BVS_REL:
      fnBranchFlagSet(m_flags.v);
      break;

    case OpCode::BCC_REL:
      fnBranchFlagNotSet(m_flags.c);
      break;

    case OpCode::BCS_REL:
      fnBranchFlagSet(m_flags.c);
      break;

    case OpCode::BNE_REL:
      fnBranchFlagNotSet(m_flags.z);
      break;

    case OpCode::BEQ_REL:
      fnBranchFlagSet(m_flags.z);
      break;

    case OpCode::JMP_IND:
      m_regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::JMP_ABS:
      m_regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::JSR_ABS:
      // push the return address - 1 on the stack
      Push16(m_regs.ip + opLength - 1);
      m_regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::RTI:
      break;

    case OpCode::RTS:
      m_regs.ip = Pop16() + 1;
      ipUpdated = true;
      break;

    case OpCode::NOP:
      break;

    case OpCode::SED:
      break;

    default:
      assert(!"IMPLEMENT ME!");
      break;
  }

  // Update the IP if the instruction itself hasn't done it already (f ex JMP, JSR, RTS)
  if (!ipUpdated)
  {
    m_regs.ip += opLength;
  }
  if (m_freeMovement)
  {
    m_cursorIp = m_regs.ip;
  }

  if (m_inNmi && PeekOp() == OpCode::RTI)
  {
    m_regs.ip = m_storedIp;
    m_storedFlags = m_flags.reg;
    m_inNmi = false;
  }

  return g_instructionTiming[(u8)op];
}

sf::Color ColorLerp(const sf::Color& a, const sf::Color& b, float t)
{
  return sf::Color(
      (u8)(a.r +  t * (b.r - a.r)),
      (u8)(a.g +  t * (b.g - a.g)),
      (u8)(a.b +  t * (b.b - a.b)),
      (u8)(a.a +  t * (b.a - a.a)));
}

void Cpu6502::RenderMemory(sf::RenderWindow& window, u16 ofs)
{
  sf::Vector2f pos(600,20);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);

  u8* p = &m_memory[ofs];
  u8* age = &m_memoryAge[ofs];
  for (size_t i = 0; i < 30; ++i)
  {
    pos.x = 600;
    char buf[128];
    // write address
    sprintf(buf, "%.4x", (u32)(ofs + i * 16));
    text.setString(buf);
    text.setPosition(pos);
    pos.x += 50;
    text.setColor(sf::Color::White);
    window.draw(text);

    // write bytes, fading by age
    for (size_t j = 0; j < 16; ++j)
    {
      if (age[j] > 0)
      {
        text.setColor(ColorLerp(sf::Color::White, sf::Color::Red, age[j] / (float)MEMORY_FADE));
        age[j]--;
      }
      else
      {
        text.setColor(sf::Color::White);
      }
      sprintf(buf, "%.2x ", p[j]);
      text.setString(buf);
      text.setPosition(pos);
      window.draw(text);
      pos.x += 20;
    }
    p += 16;
    age += 16;
    pos.y += 15;
  }
}

void Cpu6502::RenderStack(sf::RenderWindow& window)
{
  sf::Vector2f pos(500,20);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);
  text.setColor(sf::Color(255,255,255,255));

  for (size_t i = 0; i < 30; ++i)
  {
    char buf[32];
    u32 cur = 0x1ff - i * 2;
    sprintf(buf, "%.4x %.2x%.2x", cur, m_memory[cur], m_memory[cur - 1]);
    text.setString(buf);
    text.setPosition(pos);
    text.setColor(cur == 0x100 + m_regs.s ? sf::Color::Yellow : sf::Color::White);
    window.draw(text);
    pos.y += 15;
  }
}

void Cpu6502::UpdateCursorPos(int delta)
{
  // find current prg rom
  for (auto& rom : m_prgRom)
  {
    if (rom.base <= m_regs.ip && rom.base + rom.data.size() > m_regs.ip)
    {

      typedef pair<u32, string> Val;
      auto it = find_if(_disasm.begin(), _disasm.end(), [=](const Val& a)
      {
        return a.first == m_cursorIp;
      });

      if (it == _disasm.end())
      {
        return;
      }

      int idx = it - _disasm.begin();
      idx = max(0, min((int)_disasm.size()-1, idx + delta));
      m_cursorIp = _disasm[idx].first;
      return;
    }
  }
}

void Cpu6502::ToggleBreakpointAtCursor()
{
  m_breakpoints[m_cursorIp] = !m_breakpoints[m_cursorIp];

  if (FILE* f = fopen("/Users/dooz/projects/nesthing/nesthing.brk", "wt"))
  {
    for (auto& b: m_breakpoints)
    {
      fprintf(f, "0x%.4x\n", b);
    }

    fclose(f);
  }
}

bool Cpu6502::IpAtBreakpoint()
{
  // To make things like "run to cursor" and "step over" easier, we
  // insert temporary breakpoints into the breakpoint list. These are
  // removed once hit
  u8 bp = m_breakpoints[m_regs.ip];
  if (bp == 0)
    return false;

  // reset the breakpoint if temporary
  m_breakpoints[m_regs.ip] &= ~TemporaryBreakpoint;
  return true;
}


void Cpu6502::RunToCursor()
{
  m_breakpoints[m_cursorIp] |= TemporaryBreakpoint;
}

void Cpu6502::StepOver()
{
  // check if the current instruction is a jump
  OpCode op = PeekOp();
  if (op == OpCode::JSR_ABS)
    m_breakpoints[m_regs.ip + g_instrLength[(u32)OpCode::JSR_ABS]] |= TemporaryBreakpoint;
  else
    SingleStep();
}

bool Cpu6502::ByteVisible(u16 addr) const
{
  size_t memoryRows = 30;
  return addr >= m_memoryOfs && addr < m_memoryOfs + memoryRows * 16;
}


void Cpu6502::RenderState(sf::RenderWindow& window)
{
  RenderRegisters(window);
  RenderDisassembly(window);
  RenderStack(window);
  RenderMemory(window, m_memoryOfs);
}

void Cpu6502::RenderRegisters(sf::RenderWindow& window)
{
  sf::Vector2f pos(0,0);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);

  // write flags
  auto fnDrawFlag = [&](const char* flag, u8 value) {
    text.setPosition(pos);
    text.setColor(value ? sf::Color::Red : sf::Color::White);
    text.setString(flag);
    window.draw(text);
    pos.x += 10;
  };

  auto fnRegister8 = [&](const char* reg, u8 value) {
    text.setPosition(pos);
    char buf[32];
    int numChars = sprintf(buf, "%s: %.2x", reg, value);
    text.setString(buf);
    window.draw(text);
    pos.x += numChars * 10;
  };

  auto fnRegister16 = [&](const char* reg, u16 value) {
    text.setPosition(pos);
    char buf[32];
    int numChars = sprintf(buf, "%s: %.4x", reg, value);
    text.setString(buf);
    window.draw(text);
    pos.x += numChars * 10;
  };

  fnDrawFlag("C", m_flags.c);
  fnDrawFlag("Z", m_flags.z);
  fnDrawFlag("I", m_flags.i);
  fnDrawFlag("D", m_flags.d);
  fnDrawFlag("B", m_flags.b);
  fnDrawFlag("V", m_flags.v);
  fnDrawFlag("S", m_flags.s);

  text.setColor(sf::Color::White);
  pos.x += 20;
  fnRegister8("A", m_regs.a);
  fnRegister8("X", m_regs.x);
  fnRegister8("Y", m_regs.y);
  fnRegister16("IP", m_regs.ip);
  fnRegister8("S", m_regs.s);
}

void Cpu6502::RenderDisassembly(sf::RenderWindow& window)
{
  sf::Vector2f pos = sf::Vector2f(0, 20);
  sf::Text text;
  text.setFont(font);
  text.setCharacterSize(16);

  auto& rom = m_prgRom[m_currentBank];
  u32 ofs = m_interruptVector.reset;

  // Look for the current IP in the disassemble block (ideally it should always be there..)
  typedef pair<u32, string> Val;
  auto it = find_if(_disasm.begin(), _disasm.end(),
      [=](const Val& a) { return a.first == (m_freeMovement ? m_cursorIp : m_regs.ip); });

  if (it == _disasm.end())
    return;

  sf::RectangleShape currentRect;
  int rowHeight = 15;
  int rowWidth = 400;

  currentRect.setFillColor(Color::Transparent);
  currentRect.setOutlineColor(Color::Blue);
  currentRect.setOutlineThickness(2);
  currentRect.setSize(sf::Vector2f((float)rowWidth, (float)rowHeight));

  int startIdx = max(0, (int)(it - _disasm.begin()) - 10);
  int endIdx = min((int)_disasm.size(), startIdx + 30);
  int cnt = 0;
  for (int i = startIdx; i < endIdx; ++i, ++cnt)
  {
    text.setPosition(pos);
    const pair<u32, string>& d = _disasm[i];

    u32 curIp = d.first;

    text.setString(d.second.c_str());
    if (m_breakpoints[curIp] == PermanentBreakpoint)
    {
      text.setColor(curIp == m_regs.ip ? sf::Color(255, 165, 0, 255) : sf::Color::Red);
    }
    else
    {
      text.setColor(curIp == m_regs.ip ? sf::Color::Yellow : sf::Color::White);
    }
    if (curIp == m_cursorIp)
    {
      currentRect.setPosition(pos.x, pos.y+3);
      window.draw(currentRect);
    }

    window.draw(text);
    pos.y += rowHeight;
  }

}

