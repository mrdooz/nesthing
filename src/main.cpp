
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
}

RollingAverage<double> s_timeElapsed(100);

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

u32 g_nesPixels[256*240];

static void error_callback(int error, const char* description)
{
  fprintf(stderr, "Error %d: %s\n", error, description);
}

void updateTexture(GLuint& texture, const char* buf, int w, int h)
{
  if (texture != 0)
  {
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_BGRA, GL_UNSIGNED_BYTE, buf);
  }
  else
  {
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf);
  }

  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
}

void DrawDebugger()
{
  ImGui::Begin("Debugger");
  ImGui::Text("IP: 0x%.4x", g_cpu._regs.ip);
  ImGui::Columns(2);
  ImGui::SetColumnOffset(1, 150);

  u8* mem = g_cpu._memory.data();
  u16 ip = g_cpu._regs.ip;
  for (u32 i = 0; i < 20; ++i)
  {
    u8 op = mem[ip];
    u32 len = g_instrLength[op];

    switch (len)
    {
      case 1: ImGui::Text("%.4x    %.2x", ip, op); break;
      case 2: ImGui::Text("%.4x    %.2x %.2x", ip, op, mem[ip+1]); break;
      case 3: ImGui::Text("%.4x    %.2x %.2x %.2x", ip, op, mem[ip+1], mem[ip+2]); break;
      case 4: ImGui::Text("%.4x    %.2x %.2x %.2x %.2x", ip, op, mem[ip+1], mem[ip+2], mem[ip+3]); break;
      case 5: ImGui::Text("%.4x    %.2x %.2x %.2x %.2x %.2x", ip, op, mem[ip+1], mem[ip+2], mem[ip+3], mem[ip+4]); break;
    }

    ip += len;
  }

  ImGui::NextColumn();
  ip = g_cpu._regs.ip;
  for (u32 i = 0; i < 20; ++i)
  {
    ImGui::Text("tjong");
    u8 op = mem[ip];
    u32 len = g_instrLength[op];

    ip += len;
  }

  ImGui::End();
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
  
  ImVec4 clearColor = ImColor(114, 144, 154);

  Status status = LoadINes(argv[1], &g_cpu, &g_ppu);
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
  
  u64 start_ns = NowNanoseconds();

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
    
    
    ImGui::Begin("Console output");
    ImGui::Image((ImTextureID)textureId, ImVec2(256, 256));
    double elapsed = (now_ns - start_ns) / 1e9;
    ImGui::Text("CPU speed: %.2f hz", cpuTicks / elapsed);
    ImGui::Text("PPU speed: %.2f hz", ppuTicks / elapsed);
    ImGui::Text("MC speed: %.2f hz", mcTicks / elapsed);
    ImGui::End();

    DrawDebugger();


    // Rendering
    glViewport(0, 0, (int)ImGui::GetIO().DisplaySize.x, (int)ImGui::GetIO().DisplaySize.y);
    glClearColor(clearColor.x, clearColor.y, clearColor.z, clearColor.w);
    glClear(GL_COLOR_BUFFER_BIT);
    ImGui::Render();
    glfwSwapBuffers(window);
  }
  
  // Cleanup
  ImGui_ImplGlfw_Shutdown();
  glfwTerminate();
  
  return 0;
}
