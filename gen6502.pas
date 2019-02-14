program gen6502;

uses sysutils;

type instruction =  record
			error: boolean; // set if illegal or not implemented
			mnemonic: string;
			memmode: string;
		    end;

const 	mnem01 : array[0..7] of string = ('ORA','AND','EOR','ADC','STA','LDA','CMP','SBC');
	mnem10 : array[0..7] of string = ('ASL','ROL','LSR','ROR','STX','LDX','DEC','INC');
	mnem00 : array[0..7] of string = ('ERR','BIT','JMP','JMP','STY','LDY','CPY','CPX');
	mmod01 : array[0..7] of string = ('(zp,X)','zp','#imm','abs','(zp),Y','zp,X','abs,Y','abs,X');
	mmod10 : array[0..7] of string = ('#imm','zp','acc','abs','ERR','zp,X','ERR','abs,X');
	mmod10alt : array[0..7] of string = ('#imm','zp','acc','abs','ERR','zp,Y','ERR','abs,Y');
	mmod00 : array[0..7] of string = ('#imm','zp','ERR','abs','ERR','zp,X','ERR','abs,X');	
	mnemBra : array[0..7] of string = ('BPL','BMI','BVC','BVS','BCC','BCS','BNE','BEQ');	
	mnemOther1 : array[0..3] of string = ('BRK','JSR','RTI','RTS');
	mnemOther2 : array[0..7] of string = ('PHP','PLP','PHA','PLA','DEY','TAY','INY','INX');
	mnemOther3 : array[0..7] of string = ('CLC','SEC','CLI','SEI','TYA','CLV','CLD','SED');
	mnemOther4 : array[8..14] of string = ('TXA','TXS','TAX','TSX','DEX','ERR','NOP');
		
var 	opc,aaa,bbb,cc: byte;
	table: array[0..255] of instruction;

	
procedure drawTable;
var 	
	h,l: byte;
	fmt: string;
begin
	fmt := '%-14s';
	write('    ');for l := 0 to 15 do write(format(fmt,['x'+hexstr(l,1)]));
	writeln;
	for h := 0 to 15 do
		begin
			write(hexstr(h,1),'x  ');
			for l := 0 to 15 do
				begin
					with table[h*16+l] do 
						if error then write(format(fmt,['ERROR'])) else write(format(fmt,[mnemonic+' '+memmode]));
				end;
			writeln
		end
end;

begin
	for opc := 0 to 255 do 
	begin
		// opc = aaabbbcc
		aaa := opc >> 5;
		bbb := (opc and %00011100)>>2;
		cc := opc and %00000011;
		with table[opc] do
		begin	
			error := true; //will be set to false if implemented
			case cc of
			%01: begin error := false; mnemonic := mnem01[aaa]; memmode := mmod01[bbb] end;
			%10: if (bbb <> %100) and (bbb <> %110) then 
					 begin
						error := false; mnemonic:= mnem10[aaa]; 
						if (aaa=4) or (aaa=5) then memmode := mmod10alt[bbb] else memmode := mmod10[bbb];
					 end;
			%00: if (aaa <> 0) and (bbb <> %010) and (bbb <> %100) and (bbb <> %110) then  
					begin
						error := false; mnemonic := mnem00[aaa]; memmode := mmod00[bbb];
						if opc=$6c then memmode := '(abs)'
					end;
//			%11: write('ILL;')
			end;
			if opc in  [	$89,
					$02,$22,$42,$62,$82,$c2,$e2,$8a,$aa,$ca,$ea,$9e,
					$20,$40,$60,$80,$44,$64,$34,$54,$74,$D4,$F4,$3C,$5C,$7C,$9C,$DC,$FC] then error := true;
			if opc in [$10,$30,$50,$70,$90,$b0,$d0,$f0] then 
				begin
					error := false; mnemonic := mnemBra[opc>>5];memmode := 'rel';
				end;
			if opc in [$00,$20,$40,$60] then 
				begin
					error := false; mnemonic := mnemOther1[opc>>5];
					if opc=$20 then memmode := 'abs' else memmode := '-'
				end;
			if opc in [$08,$28,$48,$68,$88,$a8,$c8,$e8] then 
				begin
					error := false; mnemonic := mnemOther2[opc>>5]; memmode := '-'
				end;			
			if opc in [$18,$38,$58,$78,$98,$b8,$d8,$f8] then 
				begin
					error := false; mnemonic := mnemOther3[opc>>5]; memmode := '-'
				end;
			if opc in [$8a,$9a,$aa,$ba,$ca,$ea] then 
				begin
					error := false; mnemonic := mnemOther4[opc>>4]; memmode := '-'
				end;				
		end
	end;
	
	drawTable;

end.

