
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
#include "rolling_average.hpp"

#include "../imgui/imgui.h"
#include "imgui_impl_glfw.h"
#include <GLFW/glfw3.h>

using namespace std;
using namespace nes;

namespace nes
{
  PPU g_ppu;
  MMC1 g_mmc1;
  Cpu6502 g_cpu(&g_ppu, &g_mmc1);

  bool executing = true;
  bool runUntilReturn = false;
  bool runUntilBranch = false;

  bool IsRunning()
  {
    return executing || runUntilBranch || runUntilReturn;
  }
}


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

    case sf::Keyboard::S:
      g_ppu.DumpVRom();
      break;

    case sf::Keyboard::O:
      runUntilReturn = true;
      break;

    case sf::Keyboard::Z:
      g_cpu._flags.z ^= g_cpu._flags.z;
      break;

    case sf::Keyboard::R:
      g_cpu.Reset();
      break;

    case sf::Keyboard::F5:
      executing = !executing;
      printf("executing: %s\n", executing ? "Y" : "N");
      break;

    case sf::Keyboard::F11:
    case sf::Keyboard::F7:
      g_cpu.SingleStep();
      break;

    case sf::Keyboard::F8:
      g_cpu.StepOver();
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
      g_cpu._disasmOfs -= 20;
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
      g_cpu._disasmOfs += 20;
      break;
    }

    case sf::Keyboard::Home:
    {
      g_cpu._disasmOfs = 0;
      break;
    }

    case sf::Keyboard::Space:
      executing = false;
      break;

    case sf::Keyboard::J:
    {
      g_cpu._memoryOfs += 10 * 16;
      break;
    }

    case sf::Keyboard::K:
    {
      g_cpu._memoryOfs -= 10 * 16;
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

#ifdef _WIN32
u64 NowNanoseconds()
{
  static bool initialized = false;
  static LARGE_INTEGER _freq;
  if (!initialized)
  {
    initialized = true;
    QueryPerformanceFrequency(&_freq);
  }
  LARGE_INTEGER now;
  QueryPerformanceCounter(&now);

  return NANOSECOND * now.QuadPart / _freq.QuadPart;
}
#else
u64 NowNanoseconds()
{
  u64 now = mach_absolute_time();
  Nanoseconds deltaNsTmp = AbsoluteToNanoseconds(*(AbsoluteTime*)&now);
  u64 nowNs = *(u64*)&deltaNsTmp;
  return nowNs;
}
#endif

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

u32 g_nesPixels[256*240];

int DebuggerMain(int argc, const char* argv[])
{
  // each tick of the main loop does 3 ppu ticks, and 1 cpu tick
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
    g_cpu._breakpoints[x] = 1;
  }

  // Create the main window
  sf::RenderWindow window(sf::VideoMode(1024, 768, 32), "It's just a NES thang");
  window.setVerticalSyncEnabled(true);

  bool useDisasm = argc >= 3;
  if (!useDisasm)
  {
    printf("no disassemly found\n");
  }

  sf::RenderWindow mainWindow(sf::VideoMode(512, 480, 32), "...");
  mainWindow.display();
  sf::Texture mainTexture;
  sf::Sprite mainSprite;
  mainTexture.create(256, 240);
  mainSprite.setTexture(mainTexture, true);

  Status status = LoadINes(argv[1], useDisasm ? argv[2] : nullptr, &g_cpu, &g_ppu);
  if (status != Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  g_cpu.Reset();
  window.display();

  // cpu cylces until the currently running instruction is done
  u32 cpuDelay = 0;

  bool done = false;
  while (!done)
  {
    sf::Event event;

    if (IsRunning())
    {
      g_ppu.Tick();
      g_ppu.Tick();
      g_ppu.Tick();

      // Is there any currently executing CPU instruction?
      if (cpuDelay > 0)
        --cpuDelay;

      if (cpuDelay == 0)
      {
        if (g_cpu.IpAtBreakpoint())
        {
          executing = false;
        }
        else
        {
          g_cpu.Tick();
        }
      }

      size_t elapsedTimers[(int)Timer::Type::NumTimers];

      if (elapsedTimers[(int)Timer::Type::Redraw])
      {
        window.clear();
        g_cpu.RenderState(window);

        mainTexture.update((u8*)g_nesPixels);
        mainWindow.draw(mainSprite);
        mainWindow.display();

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
      }
    }
  }

  return 0;
}

#define CPU_TEST 1


int EmulatorMain(int argc, const char* argv[])
{
  // run the emulator in real time
  executing = true;

  Status status;
#ifdef CPU_TEST
  status = LoadINes("/Users/magnus/Downloads/nestest.nes", nullptr, &g_cpu, &g_ppu);
#else
  if (argc < 2)
    return 1;
  
  status = LoadINes(argv[1], nullptr, &g_cpu, &g_ppu);
#endif
  if (status != Status::OK)
  {
    printf("error loading rom: %s\n", argv[1]);
    return (int)status;
  }

  sf::RenderWindow mainWindow(sf::VideoMode(512, 480, 32), "...");
  sf::Texture mainTexture;
  mainTexture.create(256, 240);
  sf::Sprite mainSprite(mainTexture);

  g_cpu.Reset();
  mainWindow.display();

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

  bool done = false;
  while (!done)
  {

    sf::Event event;

    u64 now_ns = NowNanoseconds();
    double delta_ns = (double)(now_ns - lastTick_ns);
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
        mainTexture.update((u8*)g_nesPixels, 256, 240, 0, 0);
        mainSprite.setTexture(mainTexture, true);
        mainSprite.setScale(2, 2);
        mainWindow.clear();
        mainWindow.draw(mainSprite);
        mainWindow.display();

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

    if (elapsedTimers[(int)Timer::Type::EventPoll])
    {
      mainWindow.pollEvent(event);
      if (event.type == sf::Event::KeyReleased)
      {
        done = HandleKeyboardInput(event);
      }
    }
  }

  return 0;
}

#if 1

#include <vector>

using namespace std;

static void error_callback(int error, const char* description)
{
  fprintf(stderr, "Error %d: %s\n", error, description);
}



void updateTexture(GLuint& texture, const char* buf, int w, int h)
{
  if(texture != 0){
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_BGRA, GL_UNSIGNED_BYTE, buf);
  } else {
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf);
  }
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
}

int main(int argc, char** argv)
{
  // Setup window
  glfwSetErrorCallback(error_callback);
  if (!glfwInit())
    exit(1);
  
  GLFWwindow* window = glfwCreateWindow(1280, 720, "Yet another broken NES emulator!", NULL, NULL);
  glfwMakeContextCurrent(window);
  
  // Setup ImGui binding
  ImGui_ImplGlfw_Init(window, true);
  
  bool show_another_window = false;
  ImVec4 clear_color = ImColor(114, 144, 154);

  // run the emulator in real time
  executing = true;
  
  Status status = LoadINes(argv[1], nullptr, &g_cpu, &g_ppu);
  if (status != Status::OK)
  {
//    printf("error loading rom: %s\n", argv[1]);
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
  
  GLuint textureId = 0;

  // Main loop
  while (!glfwWindowShouldClose(window))
  {
    glfwPollEvents();
    ImGui_ImplGlfw_NewFrame();
    
    ImGuiIO& io = ImGui::GetIO();
    if (io.KeysDown['W']) g_cpu.SetInput(Button::Up, 0);
    if (io.KeysDown['S']) g_cpu.SetInput(Button::Down, 0);
    if (io.KeysDown['R']) g_cpu.SetInput(Button::Start, 0);
    
    u64 now_ns = NowNanoseconds();
    double delta_ns = (double)(now_ns - lastTick_ns);
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
        updateTexture(textureId, (const char*)g_nesPixels, 256, 240);
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
    

    // read memory for nestest
    u8 mem02 = g_cpu.ReadMemory(0x02);
    u8 mem03 = g_cpu.ReadMemory(0x03);
    
    ImGui::Begin("Console output", &show_another_window);
    ImGui::Image((ImTextureID)textureId, ImVec2(256, 256));
    ImGui::Text("nestest: %.2x%.2x", mem02, mem03);
    ImGui::End();
    
    // Rendering
    glViewport(0, 0, (int)ImGui::GetIO().DisplaySize.x, (int)ImGui::GetIO().DisplaySize.y);
    glClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w);
    glClear(GL_COLOR_BUFFER_BIT);
    ImGui::Render();
    glfwSwapBuffers(window);
  }
  
  // Cleanup
  ImGui_ImplGlfw_Shutdown();
  glfwTerminate();
  
  return 0;
}

#else

int main(int argc, const char * argv[])
{
//  int res = EmulatorMain(argc, argv);
  int res = DebuggerMain(argc, argv);
#ifdef _WIN32
  OutputDebugStringA((const char*)&g_cpu._memory[0x6004]);
#endif
  //int res = DebuggerMain(argc, argv);

  return res;
}
#endif