(*************************************************** 
* COMMANDER 64 (c)2018 by ir. Marc  Dendooven      *
* El Dendo's Commodore 64 emulator Version II      *
* This file contains the cycle exact cpu emulation *
***************************************************)
unit cpu;
//-------------------------------------------------
interface

procedure cpu_execute_one_cycle;
//-------------------------------------------------

implementation

uses memio;

var	A,X,Y,S: byte;
	IR: byte = 0;
	PC: word = 0;
	CC: 1..2 = 1;
	
procedure error (s: string);
begin
    writeln('--------------------------------------');
    writeln('emulator error: ',s);
    writeln('PC=',hexstr(PC-1,4),' IR=',hexstr(IR,2));
    writeln;
    writeln('Execution has been ended');
    writeln('push return to exit');
    writeln('--------------------------------------');
    readln;
    halt
end;

procedure fetch_opcode_inc_PC;
begin
	IR := peek(PC);
	inc(PC);
	inc(CC)
end;

procedure cycle0;
begin
	writeln('instruction 00');
	CC := 1
end;

procedure cycle1;
begin
	writeln('instruction 01');
	CC := 1
end;

procedure cycle2;
begin
	writeln('instruction 02');
	CC := 1
end;

procedure err;
begin
	error('unknown instruction ')
end;

type instruction = array[1..2] of procedure;

const instructionSet: array[0..3] of instruction = (
//00 instr0
(@fetch_opcode_inc_PC,
 @cycle0),
// 01 instr1
(@fetch_opcode_inc_PC,
 @cycle1),
// 02 instr2
(@fetch_opcode_inc_PC,
 @cycle2),
// 03 unknown instruction
(@fetch_opcode_inc_PC,
 @err)
);


//---------------------------------------------------------------------

procedure cpu_execute_one_cycle;
begin
	instructionSet[IR,CC]
end;

end.
