#ifndef __nesthing__nes_helpers__
#define __nesthing__nes_helpers__

#include "opcodes.hpp"

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

struct NesHeader
{
    u8 id[4];
    u8 numRomBanks;
    u8 numVRomBanks;
    struct
    {
        u8 batteryBacked    : 1;
        u8 trainer          : 1;
        u8 fourScreenVraw   : 1;
        u8 reserved         : 1;
        u8 mapperLowNibble  : 4;
    } flags0;
    struct
    {
        u8 vsSystem         : 1;
        u8 reserved         : 3;
        u8 mapperHiNibble   : 4;
    } flags1;
    u8 numRamBanks;
    u8 flags2;
    u8 reserved[6];
};

extern const char* OpCodeToString(OpCode op, u16 ip, const u8* ptr);
extern int g_instrLength[];
extern u8 g_validOpCodes[];
extern u8 g_branchingOpCodes[];

#endif /* defined(__nesthing__nes_helpers__) */
