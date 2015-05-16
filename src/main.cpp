
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
#define NOMINMAX
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

  return (u64)(1e9 * now.QuadPart / _freq.QuadPart);
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

vector<u32> g_nesPixels(256*240);
GLuint textureId = 0;
GLuint nameTable0 = 0;

enum BreakpointFlags
{
  BP_NORMAL   =   1 << 0,
  BP_HIDDEN   =   1 << 1,
};

u8 g_breakPoints[64*1024];

static void error_callback(int error, const char* description)
{
  fprintf(stderr, "Error %d: %s\n", error, description);
}

void updateMonoTexture(GLuint& texture, const char* buf, int w, int h)
{
  if (texture != 0)
  {
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_R, GL_UNSIGNED_BYTE, buf);
  }
  else
  {
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, 1, w, h, 0, GL_R, GL_UNSIGNED_BYTE, buf);
  }

  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
}

void updateTexture(GLuint& texture, const char* buf, int w, int h)
{
  if (texture != 0)
  {
    glBindTexture(GL_TEXTURE_2D, texture);
#ifdef _WIN32
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buf);
#else
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_BGRA, GL_UNSIGNED_BYTE, buf);
#endif
  }
  else
  {
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
#ifdef _WIN32
    glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf);
#else
    glTexImage2D(GL_TEXTURE_2D, 0, 4, w, h, 0, GL_BGRA, GL_UNSIGNED_BYTE, buf);
#endif
  }

  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
}

void DrawPPU()
{
  static GLuint nameTables[4] = { 0, 0, 0, 0 };

  for (int i = 0; i < 4; ++i)
  {
    updateMonoTexture(nameTables[i], (const char*)&g_ppu._memory[0x2000+i*0x400], 64, 16);
  }

  ImGui::Begin("PPU");

  ImGui::Image((ImTextureID)nameTables[0], ImVec2(64, 16));
  ImGui::Image((ImTextureID)nameTables[1], ImVec2(64, 16));
  ImGui::Image((ImTextureID)nameTables[2], ImVec2(64, 16));
  ImGui::Image((ImTextureID)nameTables[3], ImVec2(64, 16));

  ImGui::End();

}

void DrawMemory(u16 addr, u16 len)
{
  ImGui::Begin("Memory");

  u8* mem = &g_cpu._memory[addr];
  u16 endAddr = addr + len;
  while (addr < endAddr)
  {
    ImGui::Text("%.4X  %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X",
        addr,
        mem[0x0], mem[0x1], mem[0x2], mem[0x3], mem[0x4], mem[0x5], mem[0x6], mem[0x7],
        mem[0x8], mem[0x9], mem[0xa], mem[0xb], mem[0xc], mem[0xd], mem[0xe], mem[0xf]);

    mem += 16;
    addr += 16;
  }

  ImGui::End();
}

void DrawDebugger()
{
  ImGui::Begin("Debugger");
  ImGui::Text("IP:0x%.4X  SP:0x%.2X  A:0x%.2X  X:0x%.2X  Y:0x%.2X",
      g_cpu._regs.ip, g_cpu._regs.s, g_cpu._regs.a, g_cpu._regs.x, g_cpu._regs.y);

  ImGui::Text("C:%d  Z:%d  I:%d  V:%d  S:%d",
      g_cpu._flags.c, g_cpu._flags.z, g_cpu._flags.i, g_cpu._flags.v, g_cpu._flags.s);
  ImGui::Separator();
  ImGui::Columns(2);
  ImGui::SetColumnOffset(1, 150);

  u8* mem = g_cpu._memory.data();
  u16 ip = g_cpu._regs.ip;
  for (u32 i = 0; i < 20; ++i)
  {
    u8 op = mem[ip];
    u32 len = g_instrLength[op];

    ImVec4 col = (g_breakPoints[ip] & BP_NORMAL) ? ImVec4(1, 1, 0, 1) : ImVec4(1, 1, 1, 1);
    
    switch (len)
    {
      case 1: ImGui::TextColored(col, "%.4X    %.2X", ip, op); break;
      case 2: ImGui::TextColored(col, "%.4X    %.2X %.2X", ip, op, mem[ip + 1]); break;
      case 3: ImGui::TextColored(col, "%.4X    %.2X %.2X %.2X", ip, op, mem[ip + 1], mem[ip + 2]); break;
    }

    ip += len;
  }

  ImGui::NextColumn();
  ip = g_cpu._regs.ip;
  for (u32 i = 0; i < 20; ++i)
  {
    u8 op = mem[ip];
    u8 addressingMode = g_addressingModes[op];
    u32 len = g_instrLength[op];

    u8 imm8 = mem[ip+1];
    u16 imm16 = mem[ip+1] + (mem[ip+2] << 8);

    switch (addressingMode)
    {
      case IMPLIED: case ACC:
        ImGui::Text(g_formatStrings[op]);
        break;

      case ABS: case ABS_X: case ABS_Y:
        ImGui::Text(g_formatStrings[op], imm16);
        break;

      case IMM: case ZPG: case ZPG_X: case ZPG_Y: case REL: case IND: case X_IND: case IND_Y:
        if (g_branchingOpCodes[op] == 1)
          // relative
          ImGui::Text(g_formatStrings[op], ip + len + (s8)imm8);
        else if (g_branchingOpCodes[op] == 2)
          // absolute
          ImGui::Text(g_formatStrings[op], imm16);
        else
          ImGui::Text(g_formatStrings[op], imm8);

        break;
    }

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
//  Status status = LoadINes("/Users/dooz/Dropbox/nes/MarioBros.nes", &g_cpu, &g_ppu);
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

  double screenPeriod_ns = 1e9 / 20;
  
  // keep track of accumulated time to know when to tick ppu/cpu
  double ppuAcc_ns = 0;
  double cpuAcc_ns = 0;
  double mcAcc_ns = 0;
  double screenAcc_ns = 0;
  double elapsedTime_ns = 0;

  u64 lastTick_ns = NowNanoseconds();
  u64 totalTicks = 0;
  u64 mcTicks = 0;
  u64 cpuTicks = 0;
  u64 ppuTicks = 0;


  // cpu cylces until the currently running instruction is done
  u32 cpuDelay = 0;
  RollingAverage<double> avgTick(1000);
  

  u64 start_ns = NowNanoseconds();

  bool paused = true;
  bool singleStep = false;
  bool stepOver = false;

  // 0x8135 = jmp to title start
  g_breakPoints[0x805b] = BP_NORMAL;

  // Main loop
  while (!glfwWindowShouldClose(window))
  {
    glfwPollEvents();
    ImGui_ImplGlfw_NewFrame();
    
    ImGuiIO& io = ImGui::GetIO();
    if (g_KeyUpTrigger.IsTriggered('W')) g_cpu.SetInput(Button::Up, 0);
    if (g_KeyUpTrigger.IsTriggered('S')) g_cpu.SetInput(Button::Down, 0);
    if (g_KeyUpTrigger.IsTriggered('R')) g_cpu.SetInput(Button::Start, 0);
    if (g_KeyUpTrigger.IsTriggered('P')) paused = !paused;
    if (g_KeyUpTrigger.IsTriggered('O')) singleStep = true;

    u64 now_ns = NowNanoseconds();
    double delta_ns = (double)(now_ns - lastTick_ns);
    lastTick_ns = now_ns;
    avgTick.AddSample(delta_ns);
    screenAcc_ns += delta_ns;

    if (paused)
    {
      if (g_KeyUpTrigger.IsTriggered('I'))
      {
        // handle "step over" by inserting a hidden breakpoint at the next instruction
        u16 ip = g_cpu._regs.ip;
        if (g_cpu._memory[ip] == OpCode::JSR_ABS)
        {
          g_breakPoints[ip+3] |= BP_HIDDEN;
          paused = false;
        }
      }

      if (singleStep)
      {
        if (g_ppu.TriggerNmi())
        {
          updateTexture(textureId, (const char*)g_nesPixels.data(), 256, 240);
          g_cpu.ExecuteNmi();
        }

        g_cpu.Tick();

        g_ppu.Tick();
        g_ppu.Tick();
        g_ppu.Tick();

        singleStep = false;
      }
    }
    else
    {
      elapsedTime_ns += delta_ns;
      mcAcc_ns += delta_ns;
      ppuAcc_ns += delta_ns;
      cpuAcc_ns += delta_ns;

      while (ppuAcc_ns > ppuPeriod_ns)
      {
        ppuAcc_ns -= ppuPeriod_ns;
        ++ppuTicks;

        g_ppu.Tick();

        if (g_ppu.TriggerNmi())
        {
          updateTexture(textureId, (const char*)g_nesPixels.data(), 256, 240);
          g_cpu.ExecuteNmi();
        }
      }

      while (cpuAcc_ns > cpuPeriod_ns)
      {
        cpuAcc_ns -= cpuPeriod_ns;
        ++cpuTicks;

        // Is there any currently executing CPU instruction?
        if (cpuDelay > 0)
          --cpuDelay;

        if (cpuDelay == 0)
          cpuDelay = g_cpu.Tick();

        u16 ip = g_cpu._regs.ip;
        if (g_breakPoints[ip])
        {
          // if this breakpoint was hidden, remove it
          g_branchingOpCodes[ip] &= ~BP_HIDDEN;
          paused = true;
          break;
        }
      }

      while (mcAcc_ns > mcPeriod_ns)
      {
        mcAcc_ns -= mcPeriod_ns;
        ++mcTicks;
      }

      ++totalTicks;
    }

//    if (screenAcc_ns > screenPeriod_ns)
    {
      ImGui::Begin("Console output");
      ImGui::Image((ImTextureID)textureId, ImVec2(256, 240));
      double elapsed = max(1.0, elapsedTime_ns / 1e9);
      ImGui::Text("CPU speed: %.2f hz", cpuTicks / elapsed);
      ImGui::Text("PPU speed: %.2f hz", ppuTicks / elapsed);
      ImGui::Text("MC speed: %.2f hz", mcTicks / elapsed);
      ImGui::End();

      DrawDebugger();
      DrawMemory(0x0000, 0x800);
      DrawPPU();

      // Rendering
      glViewport(0, 0, (int)ImGui::GetIO().DisplaySize.x, (int)ImGui::GetIO().DisplaySize.y);
      glClearColor(clearColor.x, clearColor.y, clearColor.z, clearColor.w);
      glClear(GL_COLOR_BUFFER_BIT);
      ImGui::Render();
      glfwSwapBuffers(window);

      screenAcc_ns = 0;
    }
  }
  
  // Cleanup
  ImGui_ImplGlfw_Shutdown();
  glfwTerminate();
  
  return 0;
}
