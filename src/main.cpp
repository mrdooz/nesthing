
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.hpp"
#include <vector>
#include <array>
#include <iostream>
#include <algorithm>
#include <unordered_set>

#include <assert.h>
#include <istream>
#include <fstream>
#include <iomanip>

#ifdef _WIN32
#else
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <CoreServices/CoreServices.h>
#endif

#include "cpu.hpp"
#include "ppu.hpp"
#include "mmc1.hpp"

using namespace std;
using namespace nes;

namespace nes
{
  PPU ppu;
  MMC1 mmc1;
  Cpu6502 cpu(&ppu, &mmc1);
}


int main(int argc, const char * argv[])
{
  ifstream str("nesthing.brk");

  u16 x;
  while (str >> hex >> x)
  {
    //cpu.m_breakpoints.insert(x);
  }
  
  // Create the main window
  sf::RenderWindow window(sf::VideoMode(1024, 768, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

  sf::Image image;
  image.create(32*8, 30*8);

  if (argc < 2)
  {
    return 1;
  }
  
  Status status = LoadINes(argv[1], &cpu, &ppu);
  if (status != Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  cpu.Reset();
  cpu.RenderState(window);
  window.display();

#ifdef _WIN32
  u64 lastTick = 0;
#else
  u64 lastTick = mach_absolute_time();
#endif
  u64 tickCount = 0;
  bool executing = false;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

  auto IsRunning = [&]() { return executing || runUntilBranch || runUntilReturn; };

  int updateFrequency = 1000;

  bool done = false;
  while (!done)
  {
    tickCount++;

    if ((IsRunning() && ((tickCount % updateFrequency) == 0)) || !IsRunning())
    {
      window.clear();
    }

    sf::Event event;
    if ((IsRunning() && window.pollEvent(event)) || (!IsRunning() && window.waitEvent(event)))
    {
      if (event.type == sf::Event::KeyReleased)
      {
        switch (event.key.code)
        {
          case sf::Keyboard::Escape:
          {
            done = true;
            break;
          }

          case sf::Keyboard::B:
          {
            runUntilBranch = true;
            break;
          }

          case sf::Keyboard::D:
          {
            if (!cpu.m_prgRom.empty())
            {
              for (auto& d : cpu.m_prgRom[0].disasm)
              {
                printf("%.4x  %s\n", d.first, d.second.c_str());
              }
            }
            break;
          }

          case sf::Keyboard::S:
          {
            for (size_t i = 0; i < 30*8; ++i)
            {
              ppu.DrawScanline(image);
            }

#if _WIN32
            image.saveToFile("c:/temp/tjong.png");
#else
            image.saveToFile("/Users/dooz/tmp/tjong.png");
#endif
            break;
          }

          case sf::Keyboard::O:
          {
            runUntilReturn = true;
            break;
          }

          case sf::Keyboard::Z:
            cpu.m_flags.z ^= cpu.m_flags.z;
            break;

          case sf::Keyboard::R:
          {
            cpu.Reset();
            break;
          }

          case sf::Keyboard::F5:
            executing = !executing;
            break;

          case sf::Keyboard::F11:
          case sf::Keyboard::F7:
            cpu.SingleStep();
            break;

          case sf::Keyboard::F9:
            cpu.ToggleBreakpointAtCursor();
            break;

          case sf::Keyboard::PageUp:
          {
            cpu.disasmOfs -= 20;
            break;
          }

          case sf::Keyboard::Up:
          {
            cpu.UpdateCursorPos(-1);
            break;
          }

          case sf::Keyboard::Down:
          {
            cpu.UpdateCursorPos(1);
            break;
          }

          case sf::Keyboard::PageDown:
          {
            cpu.disasmOfs += 20;
            break;
          }

          case sf::Keyboard::Home:
          {
            cpu.disasmOfs = 0;
            break;
          }

          case sf::Keyboard::J:
          {
            cpu.memoryOfs += 10 * 16;
            break;
          }

          case sf::Keyboard::K:
          {
            cpu.memoryOfs -= 10 * 16;
            break;
          }

        }
      }
    }

    if (executing || runUntilReturn || runUntilBranch)
    {
      ppu.Tick();
      cpu.Tick();

      if ((tickCount % 10) == 0)
      {
        cpu.ExecuteNmi();
      }
/*
      u64 now = mach_absolute_time();
      u64 delta = now - lastTick;
      Nanoseconds deltaNs = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);

      // 236250000.0 / 11
      s64 masterClock = 236250000;
      // Time between master clock ticks (ns)
      double masterClockTickInterval = 1e9 / (masterClock / 11.0);

      u64 d = ((u64)deltaNs.hi << 32ul) + (u64)deltaNs.lo;
      if (d > masterClockTickInterval)
      {
        tickCount++;

        if ((tickCount % 4) == 0)
        {
          ppu.Tick();
        }

        if ((tickCount % 12) == 0)
        {
          cpu.Tick();

        }
        lastTick = now;
      }
 */
      if (runUntilReturn)
      {
        OpCode op = cpu.PeekOp();
        if (op == OpCode::RTS || op == OpCode::RTI)
        {
          runUntilReturn = false;
        }
      }

      if (runUntilBranch)
      {
        OpCode op = cpu.PeekOp();
        if (g_branchingOpCodes[(u8)op])
        {
          runUntilBranch = false;
        }
      }

      if (cpu.m_breakpoints.find(cpu.m_regs.ip) != cpu.m_breakpoints.end())
      {
        cpu.ExecuteNmi();
        runUntilBranch = false;
        runUntilReturn = false;
        executing = false;
      }
    }

    if ((IsRunning() && ((tickCount % updateFrequency) == 0)) || !IsRunning())
    {
      cpu.RenderState(window);
      window.display();
    }

  }

  return 0;
}
