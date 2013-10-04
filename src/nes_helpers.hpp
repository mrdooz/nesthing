#pragma once

#include "opcodes.hpp"
#include "nesthing.hpp"

namespace nes
{
  /*
 
   0-3      String "NES^Z" used to recognize .NES files.
   4        Number of 16kB ROM banks.
   5        Number of 8kB VROM banks.
   6        bit 0     1 for vertical mirroring, 0 for horizontal mirroring.
   bit 1     1 for battery-backed RAM at $6000-$7FFF.
   bit 2     1 for a 512-byte trainer at $7000-$71FF.
   bit 3     1 for a four-screen VRAM layout.
   bit 4-7   Four lower bits of ROM Mapper Type.
   7        bit 0     1 for VS-System cartridges.
   bit 1-3   Reserved, must be zeroes!
   bit 4-7   Four higher bits of ROM Mapper Type.
   8        Number of 8kB RAM banks. For compatibility with the previous
   versions of the .NES format, assume 1x8kB RAM page when this
   byte is zero.
   9        bit 0     1 for PAL cartridges, otherwise assume NTSC.
   bit 1-7   Reserved, must be zeroes!
   10-15    Reserved, must be zeroes!
   16-...   ROM banks, in ascending order. If a trainer is present, its
   512 bytes precede the ROM bank contents.
   ...-EOF  VROM banks, in ascending order.
   */

  // 6502 is LE
  #pragma pack(push, 1)
  // bytes 0..7 are common between iNES1 and iNES2
  struct INesHeaderCommon
  {
    u8 id[4];
    u8 numRomBanks;
    u8 numVRomBanks;
    struct
    {
      u8 verticalMirroring  : 1;
      u8 batteryBacked      : 1;
      u8 trainer            : 1;
      u8 fourScreenVraw     : 1;
      u8 mapperLowNibble    : 4;
    } flags6;
    struct
    {
      u8 vsSystem           : 1;  // VS Unisystem
      u8 playerchoice       : 1;  // PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
      u8 ines2              : 2;  // If equal to 10, flags 8-15 are in NES 2.0 format
      u8 mapperHiNibble     : 4;
    } flags7;
  };

  struct INesHeader1 : public INesHeaderCommon
  {
      u8 numRamBanks;
      struct
      {
        u8 tvSystem             : 1;  // 0: NTSC, 1: PAL
        u8 reserved             : 7;
      } flags9;

      struct  
      {
        u8 tvSystem             : 2;  // TV system (0: NTSC; 2: PAL; 1/3: dual compatible)
        u8 reserved             : 2;
        u8 sram                 : 1;  // SRAM in CPU $6000-$7FFF is 0: present; 1: not present
        u8 busConflicts         : 1;  // 0: Board has no bus conflicts; 1: Board has bus conflicts
        u8 reserved2            : 2;
      } flaags10;
      u8 reserved[6];
  };

  struct INesHeader2 : public INesHeaderCommon
  {
    struct
    {
      u8 mapper : 4;
      u8 submappers : 4;
    } flags8;

    struct 
    {
      u8 extraPrgRom : 4;
      u8 extraChrRom : 4;
    } flags9;

    struct
    {
      u8 nonBatteryBackedPrgRam : 4;
      u8 batteryBackedPrgRam : 4;
    } flags10;
  };

  #pragma pack(pop)

  const char* OpCodeToString(OpCode op, u16 ip, const u8* ptr);

  struct Cpu6502;
  struct PPU;
  Status LoadINes(const char* filename, Cpu6502* cpu, PPU* ppu);

  void DumpHeader1(const INesHeader1* header);
  void DumpHeader2(const INesHeader2* header);
  void DumpHeader(const INesHeaderCommon* header);
  void Disassemble(const u8* data, size_t len, u32 org, vector<pair<u32, string>>* output);

  void FindJumpDestinations(const u8* base, std::vector<u16>& branchDestinations);

  extern int g_instrLength[];
  extern u8 g_validOpCodes[];
  extern u8 g_branchingOpCodes[];
  extern u8 g_instructionTiming[];
  extern u8 g_addressingModes[];
  extern u8 g_NesPalette[];

#ifdef _WIN32
void LogConsole(char const * const format, ... );
#define LOG(...) LogConsole(__VA_ARGS__);
#else
#define LOG(...) printf(__VA_ARGS__);
#endif

}
