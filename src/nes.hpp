#pragma once

namespace nes
{
  class Cpu6502;
  class PPU;
  class MMC1;

  class NES
  {
  public:
    NES();
    ~NES();

    private:

    Cpu6502* m_cpu;
    PPU* m_ppu;
    MMC1* m_mmc1;
  };
}