#include "nes.hpp"
#include "cpu.hpp"
#include "ppu.hpp"
#include "mmc1.hpp"

using namespace nes;

#define SAFE_DELETE(x) { delete(x); (x) = 0; }

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
