
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.h"
#include <vector>
#include <iostream>
#include <algorithm>

using namespace std;
/*
struct INesHeader
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
  } flags6;
  struct
  {
    u8 vsSystem         : 1;
    u8 reserved         : 3;
    u8 mapperHiNibble   : 4;
  } flags7;
  u8 numRamBanks;
  u8 flags2;
  u8 reserved[6];
};
*/
void DumpHeader(const INesHeaderCommon* header)
{
  printf("%c%c%c\n", header->id[0], header->id[1], header->id[2]);
  printf("ROM banks: %d, VROM banks: %d\n", header->numRomBanks, header->numVRomBanks);
  printf("flags6: %s mirroring, battery: %d, trainer: %d, 4 screen: %d\n",
    header->flags6.verticalMirroring ? "v" : "h", header->flags6.batteryBacked,
    header->flags6.trainer, header->flags6.fourScreenVraw);
  printf("flags7: vs system: %d\n",
    header->flags7.vsSystem);

  if (header->flags7.ines2 == 0)
  {
    const INesHeader1* header1 = (INesHeader1*)header;
    printf("mapper: %.2x\n", (header->flags7.mapperHiNibble << 4) + header->flags6.mapperLowNibble);
  }
  else
  {
    // If in ines 2.0 format, ignore hiNibble, because DiskDude! might have overwritten it!
    const INesHeader1* header1 = (INesHeader1*)header;
    printf("mapper: %.2x\n", header->flags6.mapperLowNibble);
  }
}

void FindJumpDestinations(const u8* base, vector<u16>& branchDestinations)
{
    u16 ip = 0;
    while (ip < 16*1024)
    {
        u8 op = base[ip];
        if (g_validOpCodes[op])
        {
            u16 nextIp = ip + g_instrLength[op];
            u8 branching = g_branchingOpCodes[op];
            if (branching)
            {
                u16 dest = nextIp;
                if (branching == 1)
                {
                    // relative
                    u8 ofs = base[ip+1];
                    if (ofs & 0x80)
                    {
                        dest -= (ofs & 0x7f);
                    }
                    else
                    {
                        dest += (ofs & 0x7f);
                    }
                }
                else if (branching == 2)
                {
                    // abs
                    dest = base[ip+1] + ((u16)base[ip+2] << 8);
                }

                if (!binary_search(branchDestinations.begin(), branchDestinations.end(), dest))
                {
                    auto it = lower_bound(branchDestinations.begin(), branchDestinations.end(), dest);
                    branchDestinations.insert(it, dest);
                }
            }
            ip = nextIp;
        }
        else
        {
            ++ip;
        }
    }
}


int main(int argc, const char * argv[])
{
    if (argc < 2)
    {
        return 1;
    }
    
    FILE* f = fopen(argv[1], "rb");
    if (!f)
    {
        printf("file not found: %s", argv[1]);
        return 1;
    }
    
    fseek(f, 0, SEEK_END);
    long fileSize = ftell(f);
    fseek(f, 0, SEEK_SET);

    vector<u8> data(fileSize);
    fread(&data[0], fileSize, 1, f);
    
    const INesHeaderCommon* header = (INesHeaderCommon*)&data[0];
    DumpHeader(header);

    if (header->flags6.mapperLowNibble != 1)
    {
      printf("Only mapper 1 is supported\n");
      return 1;
    }
 
    size_t numBanks = header->numRomBanks;
    u8* base = &data[16 + (header->flags6.trainer ? 512 : 0)];
    u32 ip = 0;
    u32 prevIp = 0;

    vector<u16> branchDestinations;
    FindJumpDestinations(base, branchDestinations);
    size_t branchIdx = 0;
    
    // the 3 interrupt vectors should be at the end of back 1 (16k prg-rom)
    struct InterruptVectors
    {
      u16 nmi;
      u16 reset;
      u16 brk;
    };

    const InterruptVectors* v = (InterruptVectors*)&base[numBanks*16*1024-sizeof(InterruptVectors)];

    bool dataMode = false;
    while (ip < min(65535u, header->numRomBanks * 16*1024u))
    {
        if (branchIdx < branchDestinations.size())
        {
            while (branchIdx < branchDestinations.size())
            {
                if (branchDestinations[branchIdx] >= ip)
                {
                    break;
                }
                ++branchIdx;
            }
            // If we skip over a branch destination, wind the ip back to the destination
            // Because of >=, we also handle the case when we are on a destination
            if (prevIp < branchDestinations[branchIdx] && ip >= branchDestinations[branchIdx])
            {
                printf(";----------------** (%.4x)\n", branchDestinations[branchIdx]);
                ip = branchDestinations[branchIdx++];
                dataMode = false;
            }
        }
        else
        {
            dataMode = false;
        }
        
        u8 op = base[ip];
        prevIp = ip;
        if (!dataMode && g_validOpCodes[op])
        {
            OpCode op2 = (OpCode)op;
            u32 nextIp = ip + g_instrLength[op];
            printf("%.4x    %s\n", ip, OpCodeToString(OpCode(op), nextIp, &base[ip+1]));
            ip = nextIp;
            
            // If the instruction is a JMP, go into datamode until the next branch destination
            if (op2 == OpCode::JMP_ABS || op2 == OpCode::JMP_IND)
            {
                printf(";----------------!!\n");
                dataMode = true;
            }
            
            if (op2 == OpCode::RTS || op2 == OpCode::RTI)
            {
                printf(";------------------\n");
            }
                
        }
        else
        {
            dataMode = true;
            printf("%.4x    db %.2x\n", ip, op);
            ++ip;
        }
    }
    
    return 0;
}

