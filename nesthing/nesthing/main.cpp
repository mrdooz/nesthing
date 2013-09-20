
#include <stdint.h>

#include "nesthing.hpp"
#include "opcodes.hpp"
#include "nes_helpers.h"
#include <vector>
#include <iostream>

using namespace std;


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
    
    int codeStart = sizeof(header) + (header.flags0.trainer ? 512 : 0);
    
    int opCodes = 0;
    u8* ptr = &data[codeStart];
    while (opCodes < 512)
    {
        u8 op = *ptr;
        if (g_validOpCodes[op])
        {
            OpCode op2 = (OpCode)op;
            cout << OpCodeToString(op2, ptr + 1) << endl;
            ptr += g_instrLength[op];
        }
        else
        {
            cout << "db " << op << endl;
            ++ptr;
        }
        opCodes++;
    }
    
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}

