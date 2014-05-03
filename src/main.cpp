
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
  PPU g_ppu;
  MMC1 g_mmc1;
  Cpu6502 g_cpu(&g_ppu, &g_mmc1);

  bool executing = false;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

  bool IsRunning()
  {
    return executing || runUntilBranch || runUntilReturn;
  }
}

template <typename V, typename S = V>
struct RollingAverage
{
  RollingAverage(size_t numSamples)
    : _samples(numSamples)
    , _samplesUsed(0)
    , _nextSample(0)
    , _sum(0)
  {
  }

  void AddSample(V v)
  {
    if (_samplesUsed < _samples.size())
    {
      _samples[_samplesUsed++] = v;
      _sum += v;
    }
    else
    {
      _sum -= _samples[_nextSample];
      _sum += v;
      _samples[_nextSample] = v;
      _nextSample = (_nextSample + 1) % _samples.size();
    }
  }

  V GetAverage() const
  {
    return _samplesUsed == 0 ? 0 : _sum / _samplesUsed;
  }

  V GetPeak() const
  {
    V m = std::numeric_limits<V>::min();
    for (size_t i = 0; i < _samplesUsed; ++i)
    {
      m = max(m, _samples[i]);
    }
    return m;
  }

  vector<V> _samples;
  size_t _samplesUsed;
  size_t _nextSample;
  S _sum;
};

RollingAverage<double> s_timeElapsed(100);

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
      if (!g_cpu.m_prgRom.empty())
      {
        for (auto& d : g_cpu.m_prgRom[0].disasm)
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
        g_ppu.DrawScanline(i, image);
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
      g_cpu.m_flags.z ^= g_cpu.m_flags.z;
      break;

    case sf::Keyboard::R:
    {
      g_cpu.Reset();
      break;
    }

    case sf::Keyboard::F5:
      executing = !executing;
      printf("executing: %s\n", executing ? "Y" : "N");
      break;

    case sf::Keyboard::F11:
    case sf::Keyboard::F7:
      g_cpu.SingleStep();
      break;

    case sf::Keyboard::F9:
      g_cpu.ToggleBreakpointAtCursor();
      break;

    case sf::Keyboard::F10:
      if (event.key.shift)
      {
        g_cpu.RunToCursor();
        executing = true;
      }
      break;

    case sf::Keyboard::PageUp:
    {
      g_cpu.disasmOfs -= 20;
      break;
    }

    case sf::Keyboard::Up:
    {
      g_cpu.UpdateCursorPos(-1);
      break;
    }

    case sf::Keyboard::Down:
    {
      g_cpu.UpdateCursorPos(1);
      break;
    }

    case sf::Keyboard::PageDown:
    {
      g_cpu.disasmOfs += 20;
      break;
    }

    case sf::Keyboard::Home:
    {
      g_cpu.disasmOfs = 0;
      break;
    }

    case sf::Keyboard::Space:
      executing = false;
      break;

    case sf::Keyboard::J:
    {
      g_cpu.m_memoryOfs += 10 * 16;
      break;
    }

    case sf::Keyboard::K:
    {
      g_cpu.m_memoryOfs -= 10 * 16;
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

u64 NowNanoseconds()
{
  u64 now = mach_absolute_time();
  Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&now);
  u64 nowNs = *(u64*)&deltaNsTmp;
  return nowNs;
}

struct Timer
{
  enum class Type
  {
    EventPoll,
    Redraw,
    CPU,
    PPU,
    OneSecond,
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

  void Elapsed(size_t* numTicks)
  {
#ifdef _WIN32
    LARGE_INTEGER tmp;
    QueryPerformanceCounter(&tmp);
    u64 now = tmp.QuadPart;
#else
    u64 now = mach_absolute_time();
#endif

    size_t numTimers = (size_t)Type::NumTimers;
    // iterate all the timers, and calc number of ticks for each one
    for (size_t i = 0; i < numTimers; ++i)
    {
      if (_interval[i] == 0)
        continue;

      u64 lastTick = _lastTick[i];
      u64 delta = now - lastTick;
#ifdef _WIN32
      u64 deltaNs = NANOSECOND * (now - lastTick) / _performanceFrequency.QuadPart;
#else
      Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&delta);
      u64 deltaNs = *(u64*)&deltaNsTmp;
#endif
      if (deltaNs < _interval[i])
      {
        numTicks[i] = 0;
      }
      else
      {
        // set # ticks, and update last tick
        numTicks[i] = (size_t)(deltaNs / _interval[i]);
        _lastTick[i] = now;
      }
    }
  }

#ifdef _WIN32
  LARGE_INTEGER _performanceFrequency;
#endif
  u64 _lastTick[(int)Type::NumTimers];
  u64 _interval[(int)Type::NumTimers];
};

int main2(int argc, const char* argv[])
{
  Timer timer;
  timer.SetInterval(Timer::Type::OneSecond, NANOSECOND);

  Status status = LoadINes(argv[1], &g_cpu, &g_ppu);
  if (status != Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  g_cpu.Reset();


  // NTSC subcarrier frequency: 39375000 / 11
  // The master clock frequency is 6 times the subcarrier frequency
  // see http://wiki.nesdev.com/w/index.php/Overscan
  u64 masterClock = 39375000 / 11 * 6;

  // ns between master, ppu and cpu ticks
  double mcPeriod_ns = 1e9 / masterClock;
  double ppuPeriod_ns = 1e9 / (masterClock / 4);
  double cpuPeriod_ns = 1e9 / (masterClock / 12);

  // keep track of accumulated time to know when to tick ppu/cpu
  double ppuAcc_ns = 0;
  double cpuAcc_ns = 0;
  double mcAcc_ns = 0;

  double elapsedTime_ns = 0;

  u64 lastTick_ns = NowNanoseconds();
  u64 totalTicks = 0;
  u64 mcTicks = 0;
  u64 cpuTicks = 0;
  u64 ppuTicks = 0;

  // cpu cylces until the currently running instruction is done
  u32 cpuDelay = 0;
  RollingAverage<double> avgTick(1000);
  while (true)
  {
    u64 now_ns = NowNanoseconds();
    double delta_ns = now_ns - lastTick_ns;
    avgTick.AddSample(delta_ns);
    lastTick_ns = now_ns;
    elapsedTime_ns += delta_ns;

    mcAcc_ns += delta_ns;
    ppuAcc_ns += delta_ns;
    cpuAcc_ns += delta_ns;

    while (ppuAcc_ns > ppuPeriod_ns)
    {
      g_ppu.Tick();
      ppuAcc_ns -= ppuPeriod_ns;
      ++ppuTicks;

      if (g_ppu.TriggerNmi())
      {
        g_cpu.ExecuteNmi();
      }
    }

    while (cpuAcc_ns > cpuPeriod_ns)
    {
      // Is there any currently executing CPU instruction?
      if (cpuDelay > 0)
        --cpuDelay;

      if (cpuDelay == 0)
        g_cpu.Tick();

      cpuAcc_ns -= cpuPeriod_ns;
      ++cpuTicks;
    }

    while (mcAcc_ns > mcPeriod_ns)
    {
      mcAcc_ns -= mcPeriod_ns;
      ++mcTicks;
    }

    ++totalTicks;

    // add the time delta to the timers
    s_timeElapsed.AddSample(delta_ns);

    size_t elapsedTimers[(int)Timer::Type::NumTimers];
    timer.Elapsed(elapsedTimers);

    if (elapsedTimers[(size_t)Timer::Type::OneSecond])
    {
      printf("ratio master: %f\nratio cpu: %f\nratio ppu: %f\navg: %f\n",
          (double)mcTicks / totalTicks,
          (double)cpuTicks / totalTicks,
          (double)ppuTicks / totalTicks,
          avgTick.GetAverage());
    }

//    if (elapsedTime_ns > 10 * 1e9)
//      break;
  }

  return 0;

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
    g_cpu.m_breakpoints[x] = 1;
  }

  sf::RenderWindow tileWindow(sf::VideoMode(256, 256, 32), "Tilesets");

  // Create the main window
  sf::RenderWindow window(sf::VideoMode(1024, 768, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);


  if (argc < 2)
  {
    return 1;
  }
  
  Status status = LoadINes(argv[1], &g_cpu, &g_ppu);
  if (status != Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  g_cpu.Reset();
  window.display();

#ifdef _WIN32
  //u64 lastTick = 0;
#else
  u64 lastTick = mach_absolute_time();
#endif
  u64 tickCount = 0;

  Timer timer;
  timer.SetInterval(Timer::Type::EventPoll, NANOSECOND/60);
  timer.SetInterval(Timer::Type::Redraw, NANOSECOND/10);

  u64 masterClock = 39375000 / 11 * 6;

  timer.SetInterval(Timer::Type::CPU, NANOSECOND / (236250000 / (11 * 12)));
  timer.SetInterval(Timer::Type::PPU, NANOSECOND / (236250000 / (11 * 4)));

  timer.SetInterval(Timer::Type::OneSecond, NANOSECOND);

 #ifdef _WIN32
  LARGE_INTEGER start, freq, lastTickCtr;
  QueryPerformanceFrequency(&freq);
  QueryPerformanceCounter(&start);
  QueryPerformanceCounter(&lastTickCtr);

  u64 lastTick = lastTickCtr.QuadPart / freq.QuadPart;
  u64 tickIntervalCtr = freq.QuadPart / ticksPerSecond;
#endif

  u64 ticksPerSecond = 50;
  double tickInterval = 1.0 / ticksPerSecond;
  u64 masterClocksPerTick = masterClock / ticksPerSecond;
  u64 masterClocksLastTick = 0;

  bool done = false;
  bool swapped = false;
  u64 prevNs = NowNanoseconds();
  while (!done)
  {
    sf::Event event;
    if (IsRunning())
    {
      tickCount++;

#ifdef _WIN32
      LARGE_INTEGER nowCtr;
      QueryPerformanceCounter(&nowCtr);
      double diff = (double)(nowCtr.QuadPart - lastTickCtr.QuadPart) / tickIntervalCtr;
#endif
      u64 nowNs = NowNanoseconds();
      double diff = (nowNs - prevNs) / 1e9;
      prevNs = nowNs;
      s_timeElapsed.AddSample(diff);

      size_t elapsedTimers[(int)Timer::Type::NumTimers];
      timer.Elapsed(elapsedTimers);

      if (elapsedTimers[(size_t)Timer::Type::OneSecond])
      {
        printf("avg: %f (peak: %f)\n", s_timeElapsed.GetAverage(), s_timeElapsed.GetPeak());
      }

      if (diff > tickInterval)
//      if ((u64)(nowCtr.QuadPart - lastTickCtr.QuadPart) > tickIntervalCtr)
      {
        // number of ticks until next cpu instruction can be executed
        size_t tickDelay = 0;
        // Do master ticks. 3 ppu ticks per cpu tick
        for (size_t i = 0; i < masterClocksPerTick/4; ++i)
        {
          for (size_t j = 0; j < 3; ++j)
          {
            g_ppu.Tick();
            if (g_ppu.TriggerNmi())
            {
              g_cpu.ExecuteNmi();
            }
          }

          // check if the CPU has finished its previous instruction
          if (tickDelay == 0)
          {
            tickDelay = g_cpu.SingleStep();

            // update these guys to break
            if (runUntilReturn)
            {
              OpCode op = g_cpu.PeekOp();
              if (op == OpCode::RTS || op == OpCode::RTI)
              {
                runUntilReturn = false;
              }
            }
            if (runUntilBranch)
            {
              OpCode op = g_cpu.PeekOp();
              if (g_branchingOpCodes[(u8)op])
              {
                runUntilBranch = false;
              }
            }

            if (g_cpu.IpAtBreakpoint())
            {
              runUntilBranch = false;
              runUntilReturn = false;
              executing = false;
            }
          }
          else
          {
            tickDelay--;
          }
        }
        //lastTickCtr = nowCtr;
      }

      if (elapsedTimers[(int)Timer::Type::Redraw])
      {
        window.clear();
        g_cpu.RenderState(window);
        window.display();
      }

      if (elapsedTimers[(int)Timer::Type::EventPoll])
      {
        window.pollEvent(event);
        if (event.type == sf::Event::KeyReleased)
        {
          done = HandleKeyboardInput(event);
        }
      }
    }
    else
    {
      window.clear();
      g_cpu.RenderState(window);
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
