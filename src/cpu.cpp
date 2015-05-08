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
  : _memory(MEMORY_SIZE)
  , _memoryAge(MEMORY_SIZE)
  , _breakpoints(MEMORY_SIZE)
  , _currentBank(0)
  , _disasmOfs(0)
  , _memoryOfs(0)
  , _ppu(ppu)
  , _freeMovement(true)
  , _cursorIp(0)
  , m_inNmi(false)
  , m_buttonIdx(0)
  , m_dmaBytesLeft(0)
{
  _flags.reg = 0x20;

  memset(&_regs, 0, sizeof(_regs));
  memset(m_buttonState, 0, sizeof(m_buttonState));
  memset(_memoryAge.data(), 0, sizeof(MEMORY_SIZE));
  memset(_breakpoints.data(), 0, sizeof(MEMORY_SIZE));
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
  Push8(_flags.reg);

//  m_storedIp = _regs.ip;
//  m_storedFlags = _flags.reg;
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

  if (_prgRom.size() == 2)
  {
    memcpy(&_memory[0x8000], &_prgRom[0].data[0], 16 * 1024);
    memcpy(&_memory[0xC000], &_prgRom[1].data[0], 16 * 1024);
  }
  else
  {
    LOG("Invalid PRG-ROM count: %lu", _prgRom.size());
    return Status::ERROR_LOADING_ROM;
  }

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
//          memset(m_buttonState, 0, sizeof(m_buttonState));
        }
        break;

    default:
      if (!ByteVisible(addr))
      {
        _memoryOfs = addr;
      }
      _memory[addr] = value;
      _memoryAge[addr] = MEMORY_FADE;
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

u16 Cpu6502::CpuRead16(u16 addr)
{
  u8 lo = _memory[addr+0];
  u8 hi = _memory[addr+1];
  return (hi << 8) + lo;
}

bool Cpu6502::PageCrossed(u16 a, u16 b)
{
  // check the high bits to determine if a page boundary has been crossed
  return (a & 0xff00) != (b & 0xff00);
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
    printf("Invalid op-code: %d\n", (int)op);
    ++_regs.ip;
    return 1;
  }

  // Load values depending on addressing mode
  AddressingMode addrMode = (AddressingMode)g_addressingModes[op8];
  
  // lo/hi are used when assigning values to registers. The idea is that in immediate
  // addressing modes, lo is set in the switch clause below, while in non-immediate, the
  // address is calculated, and this is then used to load lo.
  u8 lo = 0, hi = 0;
  u16 addr = 0;
  bool pageCrossed = false;
  switch (addrMode)
  {
    // Absolute (r = MEM[addr])
    case AddressingMode::ABS:
      addr = CpuRead16(_regs.ip+1);
      break;

    // Absolute (r = MEM[addr+X])
    case AddressingMode::ABS_X:
      addr = CpuRead16(_regs.ip+1) + _regs.x;
      pageCrossed = PageCrossed(addr, addr - _regs.x);
      break;
      
    // Absolute (r = MEM[addr+Y])
    case AddressingMode::ABS_Y:
      addr = CpuRead16(_regs.ip+1) + _regs.y;
      pageCrossed = PageCrossed(addr, addr - _regs.y);
      break;

    case AddressingMode::IMM:
      addr = _regs.ip+1;
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
      addr = (_memory[_regs.ip+1] + _regs.x) & 0xff;
      lo = ReadMemory(addr);
      hi = ReadMemory(addr+1);
      addr = lo + (hi << 8);
      break;

    // Note, Indirected Index are always zero paged
    case AddressingMode::IND_Y:
    {
      u16 tmp0 = _memory[_regs.ip+1];
      u16 tmp1 = CpuRead16(tmp0) + _regs.y;
      addr = tmp1;
      PageCrossed(tmp1, tmp1 - _regs.y);
      break;
    }

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
  
  // todo: make instruction families
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
    case OpCode::AND_IMM:
      lo = ReadMemory(addr);
      DoBinOp(BinOp::AND, (s8*)&_regs.a, (s8)lo);
      break;

    case OpCode::ORA_ABS:
    case OpCode::ORA_ABS_X:
    case OpCode::ORA_ABS_Y:
    case OpCode::ORA_ZPG:
    case OpCode::ORA_ZPG_X:
    case OpCode::ORA_X_IND:
    case OpCode::ORA_IND_Y:
    case OpCode::ORA_IMM:
      lo = ReadMemory(addr);
      DoBinOp(BinOp::OR, (s8*)&_regs.a, (s8)lo);
      break;

    case OpCode::EOR_ABS:
    case OpCode::EOR_ABS_X:
    case OpCode::EOR_ABS_Y:
    case OpCode::EOR_ZPG:
    case OpCode::EOR_ZPG_X:
    case OpCode::EOR_X_IND:
    case OpCode::EOR_IND_Y:
    case OpCode::EOR_IMM:
      lo = ReadMemory(addr);
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
    case OpCode::SBC_IMM:
      lo = ReadMemory(addr);
      {
        tmp16 = _regs.a - lo - (1 - _flags.c);
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
    case OpCode::ADC_IMM:
      {
        lo = ReadMemory(addr);
        u8 a = _regs.a;
        s16 res = (s16)lo + (s16)a + (s16)_flags.c;
        WriteRegisterAndFlags(&_regs.a, (u8)res);
        
//        _flags.v = res < 128 || res > 383;
//        V = 1 when U1 + U2 <  128 or  U1 + U2 >  383 ($17F)
//        _flags.v = !((a ^ lo) & 0x80) && ((a ^ lo) & 0x80) ? 1 : 0;
        _flags.v = (res > 127 || res < -128) ? 1 : 0;
        _flags.c = (res > 255) ? 1 : 0;
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
      Transfer(&_regs.s, &_regs.x);
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
    case OpCode::LDA_IMM:
      lo = ReadMemory(addr);
      WriteRegisterAndFlags(&_regs.a, lo);
      break;

    case OpCode::LDX_ABS:
    case OpCode::LDX_ABS_Y:
    case OpCode::LDX_ZPG:
    case OpCode::LDX_ZPG_Y:
    case OpCode::LDX_IMM:
      lo = ReadMemory(addr);
      WriteRegisterAndFlags(&_regs.x, lo);
      break;

    case OpCode::LDY_ABS:
    case OpCode::LDY_ABS_X:
    case OpCode::LDY_ZPG:
    case OpCode::LDY_ZPG_X:
    case OpCode::LDY_IMM:
      lo = ReadMemory(addr);
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
    case OpCode::CMP_IMM:
      lo = ReadMemory(addr);
      tmp16 = _regs.a - lo;
      WriteMemory(addr, (u8)tmp16);
      SetFlags((u8)tmp16);
      _flags.c = tmp16 < 0x100;
      break;

    case OpCode::CPX_ABS:
    case OpCode::CPX_ZPG:
    case OpCode::CPX_IMM:
      lo = ReadMemory(addr);
      tmp16 = (u16)_regs.x - (u16)lo;
      tmp0 = (u8)tmp16;
      WriteMemory(addr, tmp0);
      SetFlags(tmp0);
      _flags.c = tmp16 < 0x100;
      break;
            
    case OpCode::CPY_ABS:
    case OpCode::CPY_ZPG:
    case OpCode::CPY_IMM:
      lo = ReadMemory(addr);
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

  if (_freeMovement)
  {
    _cursorIp = _regs.ip;
  }

  const u8 INC_ON_PAGE_CROSS_MASK = 0x10;
  const u8 BRANCH_INC_ON_PAGE_CROSS_MAX = 0x20;
  const u8 TIMING_MASK = 0xf;
  
  u8 rawTime = g_instructionTiming[(u8)op];
  u8 correctedTime = rawTime & TIMING_MASK;
  if (pageCrossed && (rawTime & INC_ON_PAGE_CROSS_MASK))
    correctedTime += 1;
  
  return correctedTime;
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
  text.setFont(_font);
  text.setCharacterSize(16);

  u8* p = &_memory[ofs];
  u8* age = &_memoryAge[ofs];
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
  text.setFont(_font);
  text.setCharacterSize(16);
  text.setColor(sf::Color(255,255,255,255));

  for (size_t i = 0; i < 30; ++i)
  {
    char buf[32];
    u32 cur = 0x1ff - i * 2;
    sprintf(buf, "%.4x %.2x%.2x", cur, _memory[cur], _memory[cur - 1]);
    text.setString(buf);
    text.setPosition(pos);
    text.setColor(cur == 0x100 + _regs.s ? sf::Color::Yellow : sf::Color::White);
    window.draw(text);
    pos.y += 15;
  }
}

void Cpu6502::UpdateCursorPos(int delta)
{
  // find current prg rom
  for (auto& rom : _prgRom)
  {
    if (rom.base <= _regs.ip && rom.base + rom.data.size() > _regs.ip)
    {

      typedef pair<u32, string> Val;
      auto it = find_if(_disasm.begin(), _disasm.end(), [=](const Val& a)
      {
        return a.first == _cursorIp;
      });

      if (it == _disasm.end())
      {
        return;
      }

      int idx = it - _disasm.begin();
      idx = max(0, min((int)_disasm.size()-1, idx + delta));
      _cursorIp = _disasm[idx].first;
      return;
    }
  }
}

void Cpu6502::ToggleBreakpointAtCursor()
{
  _breakpoints[_cursorIp] = !_breakpoints[_cursorIp];

  if (FILE* f = fopen("/Users/dooz/projects/nesthing/nesthing.brk", "wt"))
  {
    for (auto& b: _breakpoints)
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
  u8 bp = _breakpoints[_regs.ip];
  if (bp == 0)
    return false;

  // reset the breakpoint if temporary
  _breakpoints[_regs.ip] &= ~TemporaryBreakpoint;
  return true;
}


void Cpu6502::RunToCursor()
{
  _breakpoints[_cursorIp] |= TemporaryBreakpoint;
}

void Cpu6502::StepOver()
{
  // check if the current instruction is a jump
  OpCode op = PeekOp();
  if (op == OpCode::JSR_ABS)
    _breakpoints[_regs.ip + g_instrLength[(u32)OpCode::JSR_ABS]] |= TemporaryBreakpoint;
  else
    SingleStep();
}

bool Cpu6502::ByteVisible(u16 addr) const
{
  size_t memoryRows = 30;
  return addr >= _memoryOfs && addr < _memoryOfs + memoryRows * 16;
}


void Cpu6502::RenderState(sf::RenderWindow& window)
{
  RenderRegisters(window);
  RenderDisassembly(window);
  RenderStack(window);
  RenderMemory(window, _memoryOfs);
}

void Cpu6502::RenderRegisters(sf::RenderWindow& window)
{
  sf::Vector2f pos(0,0);
  sf::Text text;
  text.setFont(_font);
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

  fnDrawFlag("C", _flags.c);
  fnDrawFlag("Z", _flags.z);
  fnDrawFlag("I", _flags.i);
  fnDrawFlag("D", _flags.d);
  fnDrawFlag("B", _flags.b);
  fnDrawFlag("V", _flags.v);
  fnDrawFlag("S", _flags.s);

  text.setColor(sf::Color::White);
  pos.x += 20;
  fnRegister8("A", _regs.a);
  fnRegister8("X", _regs.x);
  fnRegister8("Y", _regs.y);
  fnRegister16("IP", _regs.ip);
  fnRegister8("S", _regs.s);
}

void Cpu6502::RenderDisassembly(sf::RenderWindow& window)
{
  sf::Vector2f pos = sf::Vector2f(0, 20);
  sf::Text text;
  text.setFont(_font);
  text.setCharacterSize(16);

  auto& rom = _prgRom[_currentBank];
  u32 ofs = _interruptVector.reset;

  // Look for the current IP in the disassemble block (ideally it should always be there..)
  typedef pair<u32, string> Val;
  auto it = find_if(_disasm.begin(), _disasm.end(),
      [=](const Val& a) { return a.first == (_freeMovement ? _cursorIp : _regs.ip); });

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
    if (_breakpoints[curIp] == PermanentBreakpoint)
    {
      text.setColor(curIp == _regs.ip ? sf::Color(255, 165, 0, 255) : sf::Color::Red);
    }
    else
    {
      text.setColor(curIp == _regs.ip ? sf::Color::Yellow : sf::Color::White);
    }
    if (curIp == _cursorIp)
    {
      currentRect.setPosition(pos.x, pos.y+3);
      window.draw(currentRect);
    }

    window.draw(text);
    pos.y += rowHeight;
  }

}

