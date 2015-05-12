#include "cpu.hpp"
#include "nes_helpers.hpp"
#include "ppu.hpp"
#include "mmc1.hpp"
#include <assert.h>

using namespace nes;

namespace
{
  size_t MEMORY_SIZE = 64 * 1024;
}

Cpu6502::Cpu6502(PPU* ppu, MMC1* mmc1)
  : _memory(MEMORY_SIZE)
  , _currentBank(0)
  , _disasmOfs(0)
  , _memoryOfs(0)
  , _ppu(ppu)
  , _cursorIp(0)
  , m_inNmi(false)
  , m_buttonIdx(0)
  , m_dmaBytesLeft(0)
{
  _flags.reg = 0x20;

  memset(&_regs, 0, sizeof(_regs));
  memset(m_buttonState, 0, sizeof(m_buttonState));
  _flags.r = 1;
}

OpCode Cpu6502::PeekOp()
{
  return (OpCode) _memory[_regs.ip];
}

void Cpu6502::ExecuteNmi()
{
  if (m_inNmi)
  {
    return;
  }

  // push ip on stack
  Push16(_regs.ip);

  // push regs on stack
  u8 t = _flags.reg;
  // set bit 54 to proper values (10)
  t &= ~0x30;
  t |= 0x20;
  Push8(t);

  _regs.ip = _interruptVector.nmi;
  m_inNmi = true;
}

void Cpu6502::Tick()
{
  SingleStep();
}

void Cpu6502::SetIp(u32 v)
{
  _regs.ip = v;
}

Status Cpu6502::Reset()
{
  // Turn off interrupts
  _flags.i = 1;

  // Point the stack ptr to the top of the stack
  _regs.s = 0xff;

  if (_prgRom.size() == 1)
  {
    // copy the ROM at 0x8000 to 0xc000
    _prgRom.push_back(_prgRom.front());
    _prgRom.back().base = 0xc000;
  }

  if (_prgRom.size() >= 2)
  {
    memcpy(&_memory[0x8000], &_prgRom[0].data[0], 16 * 1024);
    memcpy(&_memory[0xC000], &_prgRom[1].data[0], 16 * 1024);
  }
//  else
//  {
//    LOG("Invalid PRG-ROM count: %lu", _prgRom.size());
//    return Status::ERROR_LOADING_ROM;
//  }

  // Get the current interrupt table, and start executing the
  // reset interrupt
  _interruptVector = *(InterruptVectors*)&_memory[0xfffa];
  _regs.ip = _interruptVector.reset;
  _cursorIp = _regs.ip;
  _currentBank = 0;

  return Status::OK;
}

void Cpu6502::SetInput(Button btn, int controller)
{
  // note, only controller 0 is supported right now
  int btnIdx = (int)btn;
  m_tmpButtonState[btnIdx] = true;
}


void Cpu6502::DoBinOp(BinOp op, s8* reg, u8 value)
{
  if (op == BinOp::OR)
    *reg = *reg | value;
  else if (op == BinOp::AND)
    *reg = *reg & value;
  else if (op == BinOp::XOR)
    *reg = *reg ^ value;
  
  SetFlags(*reg);
}

void Cpu6502::WriteMemory(u16 addr, u8 value)
{
  if (addr >= 0x2000 && addr <= 0x3fff)
  {
    // Check for PPU writes
    _ppu->WriteMemory(addr, value);
  }
  else if (addr >= 0x8000)
  {
    // Check for writes to MMC1 registers
//    m_mmc1->Write(addr, value);
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
       _ppu->WriteMemory(0x2003, 0);
      break;

      case 0x4016:
        // a high lsb means read controller input into the shift register
        if (value & 1)
        {
          memcpy(m_buttonState, m_tmpButtonState, sizeof(m_tmpButtonState));
        }
        else
        {
          m_buttonIdx = 0;
          memset(m_tmpButtonState, 0, sizeof(m_tmpButtonState));
        }
        break;

    default:
      _memory[addr] = value;
      break;
    }

  }

}

u8 Cpu6502::ReadMemory(u16 addr)
{
  if (addr >= 0x2000 && addr <= 0x2007)
  {
    return _ppu->ReadMemory(addr);
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

  return _memory[addr];
}

u16 Cpu6502::ReadMemory16(u16 addr)
{
  return ReadMemory(addr) + (ReadMemory(addr+1) << 8);
}


void Cpu6502::SetFlags(u8 value)
{
  _flags.z = value == 0 ? 1 : 0;
  _flags.s = value & 0x80 ? 1 : 0;
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
  _memory[0x100 + _regs.s-1] = (u8)(value & 0xff);
  _memory[0x100 + _regs.s-0] = (u8)((value >> 8) & 0xff);
  _regs.s -= 2;
}

void Cpu6502::Push8(u8 value)
{
  _memory[0x100 + _regs.s] = value;
  _regs.s--;
}

u16 Cpu6502::Pop16()
{
  _regs.s += 2;
  return (u16) _memory[0x100 + _regs.s-1] + ((u16) _memory[0x100 + _regs.s] << 8);
}

u8 Cpu6502::Pop8()
{
  _regs.s++;
  return _memory[0x100 + _regs.s];
}

u8 Cpu6502::SingleStep()
{
  // If in a DMA transfer, just do the transfer
  if (m_dmaBytesLeft)
  {
    _ppu->WriteMemory(0x2004, _memory[m_dmaReadAddr++]);
    m_dmaBytesLeft--;
    // 2 ticks for a DMA byte transfer
    return 2;
  }

  u8 op8 = _memory[_regs.ip];
  OpCode op = (OpCode)op8;
  if (!g_validOpCodes[op8])
  {
    ++_regs.ip;
    return 1;
  }

  // Load values depending on addressing mode
  AddressingMode addrMode = (AddressingMode)g_addressingModes[op8];
  u8 lo = 0, hi = 0;
  u16 addr = 0;
  switch (addrMode)
  {
    case AddressingMode::ABS:
      addr = ReadMemory16(_regs.ip + 1);
      break;

    case AddressingMode::ABS_X:
      addr = ReadMemory16(_regs.ip + 1) + _regs.x;
      break;

    case AddressingMode::ABS_Y:
      addr = ReadMemory16(_regs.ip + 1) + _regs.y;
      break;

    case AddressingMode::IMM:
      lo = _memory[_regs.ip+1];
      break;

    case AddressingMode::ZPG:
      addr = _memory[_regs.ip+1];
      break;

    case AddressingMode::ZPG_X:
      addr = (_memory[_regs.ip+1] + _regs.x) & 0xff;
      break;

    case AddressingMode::ZPG_Y:
      addr = (_memory[_regs.ip+1] + _regs.y) & 0xff;
      break;

    case AddressingMode::IND:
      addr = _memory[_regs.ip+1] + (_memory[_regs.ip+2] << 8);
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    case AddressingMode::X_IND:
      // addr is zeropage address
      addr = (_memory[_regs.ip+1] + _regs.x) & 0xff;
      // read real address from zeropage
      addr = ReadMemory16(addr);
      break;

    case AddressingMode::IND_Y:
      // addr is zeropage
      addr = _memory[_regs.ip+1];
      // read zeropage address, and add Y
      addr = ReadMemory16(addr) + _regs.y;
      break;

    case AddressingMode::REL:
      lo = _memory[_regs.ip+1];
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
      _regs.ip += (s8)lo;
    }
  };

  auto fnBranchFlagSet = [&](u8 flag){
    if (flag)
    {
      _regs.ip += (s8)lo;
    }
  };

  u8 tmp0, tmp1;
  u16 tmp16;
  switch (op)
  {
    case OpCode::BRK:
      Push16(_regs.ip + opLength - 1);
      Push8(_flags.reg | 0x30);
      _flags.i = 1;
      _regs.ip = _interruptVector.brk;
      ipUpdated = true;
      break;

    case OpCode::LSR_A:
    case OpCode::LSR_ABS:
    case OpCode::LSR_ABS_X:
    case OpCode::LSR_ZPG:
    case OpCode::LSR_ZPG_X:
      {
        u8 t = op == OpCode::LSR_A ? _regs.a : ReadMemory(addr);
        _flags.c = t & 1;
        t = t >> 1;
        if (op == OpCode::LSR_A)
          _regs.a = t;
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
        u8 t = op == OpCode::ASL_A ? _regs.a : ReadMemory(addr);
        _flags.c = (t & 0x80) ? 1 : 0;
        t = t << 1;
        if (op == OpCode::ASL_A)
          _regs.a = t;
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
        u8 t = op == OpCode::ROL_A ? _regs.a : ReadMemory(addr);
        u8 c = _flags.c;
        _flags.c = (t & 0x80) ? 1 : 0;
        t = (t << 1) + (c ? 1 : 0);
        if (op == OpCode::ROL_A)
          _regs.a = t;
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
        u8 t = op == OpCode::ROL_A ? _regs.a : ReadMemory(addr);
        u8 c = _flags.c;
        _flags.c = (t & 0x1) ? 1 : 0;
        t = (t >> 1) + (c ? 0x80 : 0);
        if (op == OpCode::ROL_A)
          _regs.a = t;
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
      DoBinOp(BinOp::AND, (s8*)&_regs.a, (s8)lo);
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
      DoBinOp(BinOp::OR, (s8*)&_regs.a, (s8)lo);
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
      DoBinOp(BinOp::XOR, (s8*)&_regs.a, (s8)lo);
      break;

    case OpCode::CLD:
      _flags.d = 0;
      break;

    case OpCode::CLV:
      _flags.v = 0;
      break;

    case OpCode::CLI:
      _flags.i = 0;
      break;

    case OpCode::SEI:
      _flags.i  = 1;
      break;

    case OpCode::CLC:
      _flags.c = 0;
      break;

    case OpCode::SEC:
      _flags.c = 1;
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
        tmp16 = (u16) _regs.a - (u16)lo - (1 - _flags.c);
        tmp0 = (u8)tmp16;
        tmp1 = _regs.a;
        WriteRegisterAndFlags(&_regs.a, (u8)tmp16);
        _flags.v = ((tmp1 ^ tmp0) & 0x80) && ((tmp1 ^ lo) & 0x80);
        _flags.c = tmp16 < 0x100;
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
        s16 res = (s8)lo + (s8) _regs.a + _flags.c;
        WriteRegisterAndFlags(&_regs.a, (u8)res);
        _flags.v = res > 127 || res < -128 ? 1 : 0;
        _flags.c = res > 255 ? 1 : 0;
        break;
      }

    case OpCode::BIT_ZPG:
    case OpCode::BIT_ABS:
      {
        // A and M. M7 -> flags.s, m6 -> flags.v
        u8 m = ReadMemory(addr);
        u8 res = (u8) _regs.a & m;
        _flags.z = res == 0 ? 1 : 0;
        _flags.v = (m & 0x40) == 0x40 ? 1 : 0;
        _flags.s = (m & 0x80) == 0x80 ? 1 : 0;
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
      WriteRegisterAndFlags(&_regs.x, _regs.x - 1);
      break;

    case OpCode::DEY:
      WriteRegisterAndFlags(&_regs.y, _regs.y - 1);
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
      WriteRegisterAndFlags(&_regs.x, _regs.x + 1);
      break;

    case OpCode::INY:
      WriteRegisterAndFlags(&_regs.y, _regs.y + 1);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Transfer
      //////////////////////////////////////////////////////////////////////////
    case OpCode::TAX:
      Transfer(&_regs.x, &_regs.a);
      break;

    case OpCode::TAY:
      Transfer(&_regs.y, &_regs.a);
      break;

    case OpCode::TSX:
      Transfer(&_regs.x, &_regs.s);
      break;

    case OpCode::TXS:
      // Note, TXS doesn't set flags
      _regs.s = _regs.x;
      break;

    case OpCode::TXA:
      Transfer(&_regs.a, &_regs.x);
      break;

    case OpCode::TYA:
      Transfer(&_regs.a, &_regs.y);
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
      WriteMemory(addr, (u8) _regs.a);
      break;

    case OpCode::STX_ABS:
    case OpCode::STX_ZPG:
    case OpCode::STX_ZPG_Y:
      WriteMemory(addr, (u8) _regs.x);
      break;

    case OpCode::STY_ABS:
    case OpCode::STY_ZPG:
    case OpCode::STY_ZPG_X:
      WriteMemory(addr, (u8) _regs.y);
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
      WriteRegisterAndFlags(&_regs.a, lo);
      break;

    case OpCode::LDX_ABS:
    case OpCode::LDX_ABS_Y:
    case OpCode::LDX_ZPG:
    case OpCode::LDX_ZPG_Y:
      lo = ReadMemory(addr);
    case OpCode::LDX_IMM:
      WriteRegisterAndFlags(&_regs.x, lo);
      break;

    case OpCode::LDY_ABS:
    case OpCode::LDY_ABS_X:
    case OpCode::LDY_ZPG:
    case OpCode::LDY_ZPG_X:
      lo = ReadMemory(addr);
    case OpCode::LDY_IMM:
      WriteRegisterAndFlags(&_regs.y, lo);
      break;

      //////////////////////////////////////////////////////////////////////////
      // Stack instructions
      //////////////////////////////////////////////////////////////////////////
    case OpCode::PHA:
      Push8(_regs.a);
      break;

    case OpCode::PLA:
      _regs.a = Pop8();
      SetFlags(_regs.a);
      break;

    case OpCode::PHP:
      // bit 4 set if BRK/PHP
      // bit 5 always set
      Push8(_flags.reg | (0x30));
      break;

    case OpCode::PLP:
      _flags.reg = Pop8();
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
      tmp16 = _regs.a - lo;
      WriteMemory(addr, (u8)tmp16);
      SetFlags((u8)tmp16);
      _flags.c = tmp16 < 0x100;
      break;

    case OpCode::CPX_ABS:
    case OpCode::CPX_ZPG:
      lo = ReadMemory(addr);
    case OpCode::CPX_IMM:
      tmp16 = (u16)_regs.x - (u16)lo;
      tmp0 = (u8)tmp16;
      WriteMemory(addr, tmp0);
      SetFlags(tmp0);
      _flags.c = tmp16 < 0x100;
      break;
            
    case OpCode::CPY_ABS:
    case OpCode::CPY_ZPG:
      lo = ReadMemory(addr);
    case OpCode::CPY_IMM:
      tmp16 = (u16)_regs.y - (u16)lo;
      tmp0 = (u8)tmp16;
      WriteMemory(addr, tmp0);
      SetFlags(tmp0);
      _flags.c = tmp16 < 0x100;
      break;

      //////////////////////////////////////////////////////////////////////////
      // Branching instructions
      //////////////////////////////////////////////////////////////////////////

    case OpCode::BPL_REL:
      fnBranchFlagNotSet(_flags.s);
      break;

    case OpCode::BMI_REL:
      fnBranchFlagSet(_flags.s);
      break;

    case OpCode::BVC_REL:
      fnBranchFlagNotSet(_flags.v);
      break;

    case OpCode::BVS_REL:
      fnBranchFlagSet(_flags.v);
      break;

    case OpCode::BCC_REL:
      fnBranchFlagNotSet(_flags.c);
      break;

    case OpCode::BCS_REL:
      fnBranchFlagSet(_flags.c);
      break;

    case OpCode::BNE_REL:
      fnBranchFlagNotSet(_flags.z);
      break;

    case OpCode::BEQ_REL:
      fnBranchFlagSet(_flags.z);
      break;

    case OpCode::JMP_IND:
      _regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::JMP_ABS:
      _regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::JSR_ABS:
      // push the return address - 1 on the stack
      Push16(_regs.ip + opLength - 1);
      _regs.ip = addr;
      ipUpdated = true;
      break;

    case OpCode::RTI:
    {
      u8 t = Pop8();
      // remove bit 4
      _flags.reg = t & ~0x10;
      _regs.ip = Pop16();
      ipUpdated = true;
      m_inNmi = false;
      break;
    }
      
    case OpCode::RTS:
      _regs.ip = Pop16() + 1;
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
    _regs.ip += opLength;
  }

  return g_instructionTiming[(u8)op];
}
