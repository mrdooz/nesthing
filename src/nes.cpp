#include "nes.hpp"
#include "cpu.hpp"
#include "ppu.hpp"
#include "mmc1.hpp"
#include "nes_helpers.hpp"

using namespace nes;

NES::NES()
    : m_cpu(0)
    , m_ppu(0)
    , m_mmc1(0)
{
}

NES::~NES()
{
  SAFE_DELETE(m_cpu);
  SAFE_DELETE(m_ppu);
  SAFE_DELETE(m_mmc1);
}
