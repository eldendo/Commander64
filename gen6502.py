print("6502 table generator")
print("(c)2018 by ir. Marc Dendooven")
print


mnem01 = ['ORA','AND','EOR','ADC','STA','LDA','CMP','SBC']
mnem10 = ['ASL','ROL','LSR','ROR','STX','LDX','DEC','INC']
mnem00 = ['ERR','BIT','JMP','JMP','STY','LDY','CPY','CPX']
mnemBra = ['BPL','BMI','BVC','BVS','BCC','BCS','BNE','BEQ']
mnemOther1 = ['BRK','JSR','RTI','RTS']
mnemOther2 = ['PHP','PLP','PHA','PLA','DEY','TAY','INY','INX']
mnemOther3 = ['CLC','SEC','CLI','SEI','TYA','CLV','CLD','SED']
mnemOther4 = ['TXA','TXS','TAX','TSX','DEX','ERR','NOP']
mmod01 = ['(zp,X)','zp','#imm','abs','(zp),Y','zp,X','abs,Y','abs,X']
mmod10 = ['#imm','zp','acc','abs','ERR','zp,X','ERR','abs,X']
mmod10alt = ['#imm','zp','acc','abs','ERR','zp,Y','ERR','abs,Y']
mmod00 = ['#imm','zp','ERR','abs','ERR','zp,X','ERR','abs,X']

readInst = ['LDA','LDX','LDY','EOR','AND','ORA','ADC','SBC','CMP','BIT','LAX','NOP'] # LAE SHS
readModWriteInst = ['ASL','LSR','ROL','ROR','INC','DEC','SLO','SRE','RLA','RRA','ISB','DCP']
writeInstr =['STA','STX','STY','SAX']



error = [True]*256
mnemonic = ["ERROR"]*256
memmode = ["-"]*256
cycles = [['err']*7]*256



def drawTable():

	print('              '.format(),end='')
	for l in range(16):
		print('{0: <14}'.format('x'+hex(l)[2:3],' '),end='')
	print(end='\n')
	for h in range(16):
			print('{0: <14}'.format(hex(h)[2:3]+'x  '),end='')
			for l in range(16):
						opc = h*16+l
						if error[opc]: print('{0: <14}'.format('ERROR'),end='')
						else: print('{0: <14}'.format(mnemonic[opc]+' '+memmode[opc]),end='')
			print(end='\n')


	
for opc in range(256):
	aaa = (opc & 0b11100000) >> 5
	bbb = (opc & 0b00011100) >> 2
	cc  = opc & 0b00000011
	
	if cc==0b01: 
		error[opc]=False;
		mnemonic[opc]=mnem01[aaa]; 
		memmode[opc]=mmod01[bbb]
	elif cc==0b10:
		if (bbb != 0b100) and (bbb != 0b110):
			error[opc]=False; mnemonic[opc]=mnem10[aaa]
			if (aaa==4) or (aaa==5): memmode[opc]=mmod10alt[bbb]
			else: memmode[opc]=mmod10[bbb]
	elif cc==0b00:
		if (aaa != 0) and (bbb != 0b010) and (bbb != 0b100) and (bbb != 0b110): 
			error[opc]=False; mnemonic[opc]=mnem00[aaa]; memmode[opc]=mmod00[bbb]
			if opc==0x6c: memmode[opc] = '(abs)'
			
	if opc in  [0x89,
				0x02,0x22,0x42,0x62,0x82,0xc2,0xe2,0x8a,0xaa,0xca,0xea,0x9e,
				0x20,0x40,0x60,0x80,0x44,0x64,0x34,0x54,0x74,0xD4,0xF4,0x3C,0x5C,0x7C,0x9C,0xDC,0xFC]:
		error[opc]=True
		
	if opc in [0x10,0x30,0x50,0x70,0x90,0xb0,0xd0,0xf0]:
		error[opc] = False; mnemonic[opc] = mnemBra[opc>>5];memmode[opc] = 'rel'
	if opc in [0x00,0x20,0x40,0x60]:
		error[opc] = False; mnemonic[opc] = mnemOther1[opc>>5];memmode[opc] = '-'
		if opc==0x20: memmode[opc] = 'abs'
	if opc in [0x08,0x28,0x48,0x68,0x88,0xa8,0xc8,0xe8]:
		error[opc] = False; mnemonic[opc] = mnemOther2[opc>>5]; memmode[opc] = '-'			
	if opc in [0x18,0x38,0x58,0x78,0x98,0xb8,0xd8,0xf8]:
			error[opc] = False; mnemonic[opc] = mnemOther3[opc>>5]; memmode[opc] = '-'
	if opc in [0x8a,0x9a,0xaa,0xba,0xca,0xea]:
			error[opc] = False; mnemonic[opc] = mnemOther4[(opc>>4)-8]; memmode[opc] = '-'			
	
drawTable()
