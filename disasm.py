# decoding table from http://www.llx.com/~nparker/a2/opcodes.html

import os, sys
from struct import unpack, unpack_from

# helper around unpack_from to unpack the tuple
def d(str, p, ofs):
	return unpack_from(str, p, ofs)[0]

# addressing modes, instruction size, and formatting function
addr_acc = ['acc', 1, None]
addr_zpg = ['zpg', 2, lambda p, ofs : '$%.2x' % d('B', p, ofs)]
addr_zpg_x = ['zpg, X', 2, lambda p, ofs : '$%.2x, X' % d('B', p, ofs)]
addr_zpg_ind_x = ['(zpg, X)', 2, lambda p, ofs : '($%.2x, X)' % d('B', p, ofs)]
addr_zpg_ind_y = ['(zpg), Y', 2, lambda p, ofs : '($%.2x), Y' % d('B', p, ofs)]
addr_imm = ['#imm', 2, lambda p, ofs : '#$%.2x' % d('B', p, ofs)]
addr_abs = ['abs', 3, lambda p, ofs : '$%.4x' % d('H', p, ofs)]
addr_abs_x = ['abs, X', 3, lambda p, ofs : '$%.4x, X' % d('H', p, ofs)]
addr_abs_y = ['abs, Y', 3, lambda p, ofs : '$%.4x, Y' % d('H', p, ofs)]

named_address = {}
def init_addresses():
	for i in range(1024):
		named_address[0x2000+i*8] = "PPU Control Register 1"
		named_address[0x2001+i*8] = "PPU Control Register 2"
		named_address[0x2002+i*8] = "PPU Status Register"
		named_address[0x2003+i*8] = "Sprite Memory Address"
		named_address[0x2004+i*8] = "Sprite Memory Data"
		named_address[0x2005+i*8] = "Background Scroll"
		named_address[0x2006+i*8] = "PPU Memory Address"
		named_address[0x2007+i*8] = "PPU Memory Data"

	named_address[0x4014] = "DMA";
	named_address[0x4015] = "Sound Switch";
	named_address[0x4016] = "Joystick 1";
	named_address[0x4017] = "Joystick 2";
	named_address[0xfffa] = "NMI vector";
	named_address[0xfffc] = "Reset vector";
	named_address[0xfffe] = "IRQ/BRK vector";


# instructions have the form aaabbbcc, where aaa and cc determine
# opcode, and bbb the addressing mode
c01_ops = {
	0b000 : 'ORA',
	0b001 : 'AND',
	0b010 : 'EOR',
	0b011 : 'ADC',
	0b100 : 'STA',
	0b101 : 'LDA',
	0b110 : 'CMP',
	0b111 : 'SBC'
}

c01_addr = {
	0b000 : addr_zpg_ind_x,
	0b001 : addr_zpg,
	0b010 : addr_imm,
	0b011 : addr_abs,
	0b100 : addr_zpg_ind_y,
	0b101 : addr_zpg_x,
	0b110 : addr_abs_y,
	0b111 : addr_abs_x
}

c10_ops = {
	0b000 : 'ASL',
	0b001 : 'ROL',
	0b010 : 'LSR',
	0b011 : 'ROR',
	0b100 : 'STX',
	0b101 : 'LDX',
	0b110 : 'DEC',
	0b111 : 'INC'
}

c10_addr = {
	0b000 : addr_imm,
	0b001 : addr_zpg,
	0b010 : addr_acc,
	0b011 : addr_abs,
	0b101 : addr_zpg_x,
	0b111 : addr_abs_x
}

c00_ops = {
	0b001 : 'BIT',
	0b010 : 'JMP',
	0b011 : 'JMP (ABS)',
	0b100 : 'STY',
	0b101 : 'LDY',
	0b110 : 'CPY',
	0b111 : 'CPX'
}

c00_addr = {
	0b000 : addr_imm,
	0b001 : addr_zpg,
	0b011 : addr_abs,
	0b101 : addr_zpg_x,
	0b111 : addr_abs_x
}

ctable = { 0b00 : (c00_ops, c00_addr), 0b01 : (c01_ops, c01_addr),
	0b10 : (c10_ops, c10_addr)}

# conditional flags have the form xxy10000
cnd_ops = {
	0x10 : 'BPL',
	0x30 : 'BMI',
	0x50 : 'BVC',
	0x70 : 'BVS',
	0x90 : 'BCC',
	0xb0 : 'BCS',
	0xd0 : 'BNE',
	0xf0 : 'BEQ'
}

# interrupt and subroutine
sub_ops = {
	0x00 : 'BRK',
	0x20 : 'JSR',
	0x40 : 'RTI',
	0x60 : 'RTS'
}

# remaining single byte instructions
single_ops = {
	0x08 : 'PHP',
	0x28 : 'PLP',
	0x48 : 'PHA',
	0x68 : 'PLA',
	0x88 : 'DEY',
	0xa8 : 'TAY',
	0xc8 : 'INY',
	0xe8 : 'INX',

	0x18 : 'CLC',
	0x38 : 'SEC',
	0x58 : 'CLI',
	0x78 : 'SEI',
	0x98 : 'TYA',
	0xb8 : 'CLV',
	0xd8 : 'CLD',
	0xf8 : 'SED'
}

if len(sys.argv) < 2:
	exit(1)

f = open(sys.argv[1], 'rb').read()

# parse ines header
header = d('4c', f, 0)
num_rom_banks = d('B', f, 4)
num_vrom_banks = d('B', f, 5)
flags_1 = d('B', f, 6)
flags_2 = d('B', f, 7)
num_ram_banks = max(1, d('B', f, 8))
pal = d('B', f, 9)

ofs = 16 + (flags_1 & 0b100) * 512

# if only a single rom bank exists, load it into both $8000 and $c000
if num_rom_banks == 1:
	rom_page_0 = f[ofs:ofs+0x4000]
	rom_page_1 = f[ofs:ofs+0x4000]
elif num_rom_banks == 2:
	rom_page_0 = f[ofs:ofs+0x8000]
else:
	print 'only 1-2 rom banks supported'
	exit(1)

nmi_vector = d('H', rom_page_0, 0x7ffa)
reset_vector = d('H', rom_page_0, 0x7ffc)
irq_vector = d('H', rom_page_0, 0x7ffe)

ip = reset_vector
ip_end = 0x8000 + len(rom_page_0) - 6

# list of (addr, str) tuples
disasm = []
subroutines = set()
ofs = ip - 0x8000

init_addresses()

while ip < ip_end:
	op = d('B', rom_page_0, ofs)
	a = op >> 5
	b = (op >> 2) & 0x7
	c = op & 0x3
	try:
		if op in cnd_ops:
			opstr = cnd_ops[op]
			# get the condition destination
			rel = d('b', rom_page_0, ofs + 1)
			opstr += ' %.4x' % (ip + 2 + rel)
			oplen = 2

		elif op in sub_ops:
			opstr = sub_ops[op]
			if opstr == 'jsr':
				s = d('H', rom_page_0, ofs + 1)
				subroutines.add(s)
				opstr += ' %.4x' % s
				oplen = 3
			else:
				oplen = 1

		elif op in single_ops:
			opstr = single_ops[op]
			oplen = 1

		else:
			opcode, addr = ctable[c]
			fn = addr[b][2]
			opstr = opcode[a]
			if fn:
				opstr += ' ' + fn(rom_page_0, ofs + 1)
			# if the value is an absolute value, see if it's a known value
			if addr[b][0] == 'abs':
				a = d('H', rom_page_0, ofs + 1)
				if a in named_address:
					opstr += ' ; ' + named_address[a]

			oplen = addr[b][1]

		# create the binary data for the opcode
		b = []
		for i in range(oplen):
			b.append(d('B', rom_page_0, ofs + i))
		b = ''.join(map(lambda x : '%.2x' % x, b))

		disasm.append((ip, "%.4x %s %s" % (ip, b.ljust(10), opstr)))
	except KeyError:
		# unknown opcode, so print it as data
		disasm.append((ip, "%.4x db %.2x" % (ip, op)))
		oplen = 1
	except:
		break

	ip += oplen
	ofs += oplen

for (ip, dis) in disasm:
	if ip in subroutines:
		print '; SUBROUTINE'
	print dis
