# scripts for parsing http://e-tradition.net/bytes/6502/6502_instruction_set.html
import os, sys

# Address Modes:
# A			....	Accumulator	 	OPC A	 	operand is AC
# abs		....	absolute	 	OPC $HHLL	 	operand is address $HHLL
# abs,X		....	absolute, X-indexed	 	OPC $HHLL,X	 	operand is address incremented by X with carry
# abs,Y		....	absolute, Y-indexed	 	OPC $HHLL,Y	 	operand is address incremented by Y with carry
# #			....	immediate	 	OPC #$BB	 	operand is byte (BB)
# impl		....	implied	 	OPC	 	operand implied
# ind		....	indirect	 	OPC ($HHLL)	 	operand is effective address; effective address is value of address
# X,ind		....	X-indexed, indirect	 	OPC ($BB,X)	 	operand is effective zeropage address; effective address is byte (BB) incremented by X without carry
# ind,Y		....	indirect, Y-indexed	 	OPC ($LL),Y	 	operand is effective address incremented by Y with carry; effective address is word at zeropage address
# rel		....	relative	 	OPC $BB	 	branch target is PC + offset (BB), bit 7 signifies negative offset
# zpg		....	zeropage	 	OPC $LL	 	operand is of address; address hibyte = zero ($00xx)
# zpg,X		....	zeropage, X-indexed	 	OPC $LL,X	 	operand is address incremented by X; address hibyte = zero ($00xx); no page transition
# zpg,Y		....	zeropage, Y-indexed	 	OPC $LL,Y	 	operand is address incremented by Y; address hibyte = zero ($00xx); no page transition

branch_rel = ['BCC', 'BCS', 'BEQ', 'BMI', 'BNE', 'BPL', 'BVC', 'BVS']
branch_abs = ['JMP', 'JSR']
branch_ret = []

addr_map = {
	'A' : 'A',
	'abs' : 'ABS',
	'abs,X' : 'ABS_X',
	'abs,Y' : 'ABS_Y',
	'#' : 'IMM',
	'impl' : '',
	'ind' : 'IND',
	'X,ind' : 'X_IND',
	'ind,Y' : 'IND_Y',
	'rel': 'REL',
	'zpg': 'ZPG',
	'zpg,X' : 'ZPG_X',
	'zpg,Y' : 'ZPG_Y'
}

debug_str = {
	'A' : 'OpToStringA("%s")',
	'abs' : 'OpToStringAbs("%s", ptr[0], ptr[1])',
	'abs,X' : 'OpToStringAbsX("%s", ptr[0], ptr[1])',
	'abs,Y' : 'OpToStringAbsY("%s", ptr[0], ptr[1])',
	'#' : 'OpToStringImm("%s", ptr[0])',
	'impl' : '"%s"',
	'ind' : 'OpToStringInd("%s", ptr[0], ptr[1])',
	'X,ind' : 'OpToStringXInd("%s", ptr[0])',
	'ind,Y' : 'OpToStringIndY("%s", ptr[0])',
	'rel': 'OpToStringRel("%s", ip, ptr[0])',
	'zpg': 'OpToStringZpg("%s", ptr[0])',
	'zpg,X' : 'OpToStringZpgX("%s", ptr[0])',
	'zpg,Y' : 'OpToStringZpgY("%s", ptr[0])'	
}

def parse_op_codes():
	hi_nibble = 0
	ops = []
	instr = []
	debug_printers = []
	valid_opcodes = [[1] * 16 for i in range(16)]
	branch_opcode = [[0] * 16 for i in range(16)]
	for f in open('opcodes.txt').readlines():
		codes = f.strip().split('\t')
		lo_nibble = 0
		for c in codes:
			value = (hi_nibble << 4) + lo_nibble
			lo_nibble += 1
			x = value & 0xf
			y = value >> 4
			# split code in opcode and addr
			s = c.split()
			op = s[0]
			addr = s[1]
			if op == '???':
				valid_opcodes[y][x] = 0
				continue
			if not addr in addr_map:
				print '** Unknown addressing mode: ', addr
				valid_opcodes[y][x] = 0
				continue
			out = op
			if op in branch_rel:
				branch_opcode[y][x] = 1
			elif op in branch_abs:
				branch_opcode[y][x] = 2
			a = addr_map[addr]
			if len(a) > 0:
				out += '_' + a
			ops.append(('%-10s = 0x%02x') % (out, (hi_nibble << 4) + lo_nibble))
			fmt = debug_str[addr];
			s = 'case OpCode::%s: return ' + fmt + ';'
			instr.append(s % (out, op))
		hi_nibble += 1

	print '** OPCODES **'
	print ',\n'.join(ops)

	print '** TO STRING **'
	print '\n'.join(instr)

	# print valid opcodes array
	print '** VALID OPCODES **'
	out = []
	for t in valid_opcodes:
		out.append(",".join([str(x) for x in t]))
	print ',\n'.join(out)
	print

	# print branching opcodes
	print '** BRANCHING OPCODES **'
	out = []
	for t in branch_opcode:
		out.append(",".join([str(x) for x in t]))
	print ',\n'.join(out)
	print

def parse_instr_length():
	instr_len = [[0] * 16 for i in range(16)]
	instr_timing = [[0] * 16 for i in range(16)]
	inside_block = False
	for f in open('timing.txt').readlines():
		if inside_block:
			s = f.strip().split()
			if len(s) == 5 or len(s) == 6:
				ofs = 0 if len(s) == 5 else 1
				instr = int(s[2+ofs], 16)
				lo = instr & 0xf
				hi = instr >> 4
				instr_len[hi][lo] = int(s[3+ofs], 10)
				t = int(s[4+ofs][0], 10)
				# use high 4 bits for special timing flags
				if s[4+ofs][1:] == '*':
					t |= 0x10
				if s[4+ofs][1:] == '**':
					t |= 0x20
				instr_timing[hi][lo] = t
			else:
				inside_block = False
		else:
			if f.find('--------------------------------------------') != -1:
				inside_block = True

	print '** INSTRUCTION LENGTH **'
	out = []
	for t in instr_len:
		out.append(",".join([str(x) for x in t]))
	print ',\n'.join(out)

	print '** INSTRUCTION TIMING **'
	out = []
	for t in instr_timing:
		out.append(",".join([str(x) for x in t]))
	print ',\n'.join(out)

parse_op_codes()
parse_instr_length()