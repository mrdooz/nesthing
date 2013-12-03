
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.hpp"
#include "file_utils.hpp"
#include <vector>
#include <array>
#include <iostream>
#include <algorithm>
#include <unordered_set>

#include <assert.h>
#include <istream>
#include <fstream>
#include <iomanip>
//#include <boost/posix_time.h>

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

  bool executing = false;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

}

bool HandleKeyboardInput(const sf::Event& event)
{
  switch (event.key.code)
  {
    case sf::Keyboard::Escape:
    {
      return true;
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
      sf::Image image;
      image.create(32*8, 30*8);

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
  return false;
}

bool FindRoot()
{
  // find the app.root
  string cur = CurrentDirectory();
  string prev = cur;
  while (true)
  {
    if (FileExists("app.root"))
    {
      return true;
    }

    chdir("..");

    // break if at the root
    string tmp = CurrentDirectory();
    if (tmp == prev)
    {
      return false;
    }
    prev = tmp;
  }
  return false;
}

struct Timer
{
  enum class Type
  {
    EventPoll,
    Redraw,
    CPU,
    PPU,
    NumTimers
  };

  Timer()
  {
    for (size_t i = 0; i < (int)Type::NumTimers; ++i)
    {
      _lastTick[i] = mach_absolute_time();
    }
  }

  void SetInterval(Type type, u64 interval)
  {
    _interval[(int)type] = interval;
  }

  int Elapsed(Type type)
  {
    size_t idx = (size_t)type;
    u64 now = mach_absolute_time();
    u64 lastTick = _lastTick[idx];
    u64 delta = now - lastTick;
    Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);
    u64 deltaNs = *(u64*)&deltaNsTmp;
    if (deltaNs < _interval[idx])
      return 0;

    // return # ticks, and update last tick
    int res = deltaNs / _interval[idx];
    _lastTick[idx] = now;
    return res;
  }

  u64 _lastTick[(int)Type::NumTimers];
  u64 _interval[(int)Type::NumTimers];

}


int main(int argc, const char * argv[])
{
#ifdef _WIN32
  if (!FindRoot())
  {
    return 1;
  }
  ifstream str("nesthing.brk");
#else
  ifstream str("/Users/dooz/projects/nesthing/nesthing.brk");
#endif

  u16 x;
  while (str >> hex >> x)
  {
    cpu.m_breakpoints.insert(x);
  }
  
  // Create the main window
  sf::RenderWindow window(sf::VideoMode(1024, 768, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

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
/*
  u64 start = mach_absolute_time();
  u64 elapsed;
  u64 ns;

  int numTicks = 0;
  while (true)
  {
    cpu.Tick();
    ppu.Tick();
    numTicks++;
    u64 cur = mach_absolute_time();
    elapsed = cur - start;
    Nanoseconds n = AbsoluteToNanoseconds(*(AbsoluteTime*)&elapsed);
    ns = *(u64*)&n;
    if (ns > 1e9)
    {
      break;
    }
  }

  printf("%d ticks in %llu ns", numTicks, ns);
  return 0;
*/
  auto IsRunning = [&]() { return executing || runUntilBranch || runUntilReturn; };

  u64 redrawIntervalMs = 1000;
  int updateFrequency = 1000;

  // Poll for keyboard events at 60 hz
  u64 eventPollIntervalNs = 1e9 / 60;

  Timer timer;
  timer.SetInterval(Timer::Type::EventPoll, 1e9/60);
  timer.SetInterval(Timer::Type::Redraw, 1e9);

  bool done = false;
  u64 lastRedraw = 0;
  u64 lastEventPoll = 0;
  bool redraw = true;
  while (!done)
  {
    tickCount++;

    TODO: add timer with multiple tick slots..

    // Check if we should redraw the window
    u64 now = mach_absolute_time();
    u64 delta = now - lastTick;
    Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);
    u64 deltaNs = *(u64*)&deltaNsTmp;
    if (deltaNs > redrawIntervalMs * 1000000 || !IsRunning())
    {
      redraw = true;
      lastRedraw = now;
    }

    if (deltaNs > eventPollIntervalNs || !IsRunning())
    {
      sf::Event event;
      if ((IsRunning() && window.pollEvent(event)) || (!IsRunning() && window.waitEvent(event)))
      {
        if (event.type == sf::Event::KeyReleased)
        {
          done = HandleKeyboardInput(event);
        }
      }
    }

    lastTick = now;

//    static u16 lastIp = 0;
//    if (lastIp != cpu.m_regs.ip)
//    {
//      printf("ip: %.2x\n", cpu.m_regs.ip);
//      lastIp = cpu.m_regs.ip;
//    }

    if (executing || runUntilReturn || runUntilBranch)
    {

      if ((tickCount % 100) == 0)
      {
        cpu.ExecuteNmi();
      }

      ppu.Tick();
      cpu.Tick();
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
        redraw = true;
        runUntilBranch = false;
        runUntilReturn = false;
        executing = false;
      }
    }

    if (redraw)
    {
      window.clear();
      cpu.RenderState(window);
      window.display();
      redraw = false;
    }
  }

  return 0;
}
