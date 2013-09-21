
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.h"
#include <vector>
#include <iostream>

using namespace std;

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
    
    const NesHeader& header = *(NesHeader*)&data[0];
 
    u8* base = &data[sizeof(header) + (header.flags0.trainer ? 512 : 0)];
    u32 ip = 0;
    u32 prevIp = 0;

    vector<u16> branchDestinations;
//    FindJumpDestinations(base, branchDestinations);
    size_t branchIdx = 0;
    
    bool dataMode = false;
    while (ip < min(65535, header.numRomBanks * 16*1024))
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

