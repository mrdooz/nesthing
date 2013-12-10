
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
#include <windows.h>
#include <direct.h>
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
  namespace
  {
    u64 NANOSECOND = 1000000000;
  }
  PPU ppu;
  MMC1 mmc1;
  Cpu6502 cpu(&ppu, &mmc1);

  bool executing = true;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

  bool IsRunning()
  {
    return executing || runUntilBranch || runUntilReturn;
  }
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
      printf("executing: %s\n", executing ? "Y" : "N");
      break;

    case sf::Keyboard::F11:
    case sf::Keyboard::F7:
      cpu.SingleStep();
      break;

    case sf::Keyboard::F9:
      cpu.ToggleBreakpointAtCursor();
      break;

    case sf::Keyboard::F10:
      if (event.key.shift)
      {
        cpu.RunToCursor();
        executing = true;
      }
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

    case sf::Keyboard::Space:
      executing = false;
      break;

    case sf::Keyboard::J:
    {
      cpu.m_memoryOfs += 10 * 16;
      break;
    }

    case sf::Keyboard::K:
    {
      cpu.m_memoryOfs -= 10 * 16;
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
#ifdef _WIN32
    QueryPerformanceFrequency(&_performanceFrequency);
    LARGE_INTEGER now;
    QueryPerformanceCounter(&now);
#endif

    for (size_t i = 0; i < (int)Type::NumTimers; ++i)
    {
#ifdef _WIN32
      _lastTick[i] = now.QuadPart;
#else
      _lastTick[i] = mach_absolute_time();
#endif
    }
  }

  void SetInterval(Type type, u64 interval)
  {
    _interval[(int)type] = interval;
  }

  size_t Elapsed(Type type)
  {
    size_t idx = (size_t)type;
#ifdef _WIN32
    LARGE_INTEGER tmp;
    QueryPerformanceCounter(&tmp);
    u64 now = tmp.QuadPart;
#else
    u64 now = mach_absolute_time();
#endif

    u64 lastTick = _lastTick[idx];
    u64 delta = now - lastTick;
#ifdef _WIN32
    u64 deltaNs = NANOSECOND * (now - lastTick) / _performanceFrequency.QuadPart;
#else
    Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);
    u64 deltaNs = *(u64*)&deltaNsTmp;
#endif
    if (deltaNs < _interval[idx])
      return 0;

    // return # ticks, and update last tick
    size_t res = (size_t)(deltaNs / _interval[idx]);
    _lastTick[idx] = now;
    return res;
  }

#ifdef _WIN32
  LARGE_INTEGER _performanceFrequency;
#endif
  u64 _lastTick[(int)Type::NumTimers];
  u64 _interval[(int)Type::NumTimers];

};


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

  Timer timer;
  timer.SetInterval(Timer::Type::EventPoll, NANOSECOND/60);
  timer.SetInterval(Timer::Type::Redraw, NANOSECOND/10);

  // master clock = 236250000 / 11
  u64 masterClock = 236250000;

  timer.SetInterval(Timer::Type::CPU, NANOSECOND / (236250000 / (11 * 12)));
  timer.SetInterval(Timer::Type::PPU, NANOSECOND / (236250000 / (11 * 4)));

  LARGE_INTEGER start, freq;
  QueryPerformanceFrequency(&freq);
  QueryPerformanceCounter(&start);


  bool done = false;
  bool swapped = false;
  while (!done)
  {
    sf::Event event;
    if (IsRunning())
    {
      tickCount++;

      if ((tickCount % 1000000) == 0)
      {
        LARGE_INTEGER now;
        QueryPerformanceCounter(&now);
        double dd = (now.QuadPart - start.QuadPart) / (double)freq.QuadPart;
        printf("%lf\n", tickCount / dd);
        tickCount = 0;
        start = now;
      }

      if (timer.Elapsed(Timer::Type::Redraw) > 0)
      {
        window.clear();
        cpu.RenderState(window);
        window.display();
      }

      if (!swapped)
      {
        if (timer.Elapsed(Timer::Type::EventPoll) > 0)
        {
          window.pollEvent(event);
          if (event.type == sf::Event::KeyReleased)
          {
            done = HandleKeyboardInput(event);
          }
        }
      }
      swapped = false;

      for (size_t i = 0, e = timer.Elapsed(Timer::Type::CPU); i < e; ++i)
      {
        cpu.Tick();
      }

      for (size_t i = 0, e = timer.Elapsed(Timer::Type::PPU); i < e; ++i)
      {
        ppu.Tick();
      }

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

      if (cpu.IpAtBreakpoint())
      {
        runUntilBranch = false;
        runUntilReturn = false;
        executing = false;
      }
    }
    else
    {
      window.clear();
      cpu.RenderState(window);
      window.display();

      window.waitEvent(event);
      if (event.type == sf::Event::KeyReleased)
      {
        done = HandleKeyboardInput(event);
        swapped = true;
      }
    }
  }

  return 0;
}
