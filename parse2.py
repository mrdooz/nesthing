from bs4 import BeautifulSoup
from collections import defaultdict
import pprint
pp = pprint.PrettyPrinter(indent=4)

d = open('opcode_list.html')

soup = BeautifulSoup(d)

branch_rel = ['BCC', 'BCS', 'BEQ', 'BMI', 'BNE', 'BPL', 'BVC', 'BVS']
branch_abs = ['JMP', 'JSR']
branch_ret = []

addressing_mode = {
    'impl' : (0, ''),
    'A' : (1, 'A'),
    'abs' : (2, 'ABS'),
    'abs,X' : (3, 'ABS_X'),
    'abs,Y' : (4 ,'ABS_Y'),
    '#' : (5, 'IMM'),
    'ind' : (6, 'IND'),
    'X,ind' : (7, 'X_IND'),
    'ind,Y' : (8, 'IND_Y'),
    'rel': (9, 'REL'),
    'zpg': (10, 'ZPG'),
    'zpg,X' : (11, 'ZPG_X'),
    'zpg,Y' : (12, 'ZPG_Y')
}

format_str = {
    'impl': '',
    'A': 'A',
    'abs': '$%.4X',
    'abs,X' : '$%.4X,X',
    'abs,Y' : '$%.4X, Y',
    '#' : '#$%.2X',
    'ind' : '($%.2X)',
    'X,ind' : '(X, $%.2X)',
    'ind,Y' : '($%.2X),Y',
    'rel': '$%.2X',
    'zpg': '$%.2X',
    'zpg,X' : '$%.2X,X',
    'zpg,Y' : '$%.2X,Y',
}

opcode_desc = {
    'ADC': 'add with carry',
    'AND': 'and (with accumulator)',
    'ASL': 'arithmetic shift left',
    'BCC': 'branch on carry clear',
    'BCS': 'branch on carry set',
    'BEQ': 'branch on equal (zero set)',
    'BIT': 'bit test',
    'BMI': 'branch on minus (negative set)',
    'BNE': 'branch on not equal (zero clear)',
    'BPL': 'branch on plus (negative clear)',
    'BRK': 'interrupt',
    'BVC': 'branch on overflow clear',
    'BVS': 'branch on overflow set',
    'CLC': 'clear carry',
    'CLD': 'clear decimal',
    'CLI': 'clear interrupt disable',
    'CLV': 'clear overflow',
    'CMP': 'compare (with accumulator)',
    'CPX': 'compare with X',
    'CPY': 'compare with Y',
    'DEC': 'decrement',
    'DEX': 'decrement X',
    'DEY': 'decrement Y',
    'EOR': 'exclusive or (with accumulator)',
    'INC': 'increment',
    'INX': 'increment X',
    'INY': 'increment Y',
    'JMP': 'jump',
    'JSR': 'jump subroutine',
    'LDA': 'load accumulator',
    'LDX': 'load X',
    'LDY': 'load Y',
    'LSR': 'logical shift right',
    'NOP': 'no operation',
    'ORA': 'or with accumulator',
    'PHA': 'push accumulator',
    'PHP': 'push processor status (SR)',
    'PLA': 'pull accumulator',
    'PLP': 'pull processor status (SR)',
    'ROL': 'rotate left',
    'ROR': 'rotate right',
    'RTI': 'return from interrupt',
    'RTS': 'return from subroutine',
    'SBC': 'subtract with carry',
    'SEC': 'set carry',
    'SED': 'set decimal',
    'SEI': 'set interrupt disable',
    'STA': 'store accumulator',
    'STX': 'store X',
    'STY': 'store Y',
    'TAX': 'transfer accumulator to X',
    'TAY': 'transfer accumulator to Y',
    'TSX': 'transfer stack pointer to X',
    'TXA': 'transfer X to accumulator',
    'TXS': 'transfer X to stack pointer',
    'TYA': 'transfer Y to accumulator',
}

opcodes = {}

# create a 16x16 array for the op codes
tmp = [x.text for x in soup.find_all('td')]
cells = [tmp[i*17+1: i*17+17] for i in range(16)]

for hi in range(16):
    for lo in range(16):
        v = ((hi << 4) + lo)
        code = '%.2X' % ((hi << 4) + lo)
        op = cells[hi][lo]
        if op.startswith('???'):
            opcodes[v] = None
        else:
            # split off the indexing mode
            fam, addr = op.split()
            c = {
                'opcode': op,
                'desc': opcode_desc[fam],
                'mode': addressing_mode[addr],
                'abs_branch': fam in branch_abs,
                'rel_branch': fam in branch_rel,
                'fmt_str': fam + ((' ' + format_str[addr]) if len(addressing_mode[addr][1]) > 0 else ''),
                }
            opcodes[v] = c


# pp.pprint(opcodes)
res = []
for i in range(256):
    if not opcodes[i]:
        res.append('""')
    else:
        res.append('"' + opcodes[i]['fmt_str'] + '"')

print ','.join(res)
