(********************************************** 
* COMMANDER 64 (c)2018 by ir. Marc  Dendooven *
* El Dendo's Commodore 64 emulator Version II *
* This file contains the main program         *
* Version: Chapter 1                          *
**********************************************)
program com64;

uses cpu, memio;

begin
	writeln('+-------------------------------------------------------+');
	writeln('| Welcome to COMMANDER 64 (c)2018 by ir. Marc Dendooven |');
	writeln('| El Dendo''s Commodore 64 emulator Version II           |');
	writeln('| This is a complete new version of ED64                |');
	writeln('| The goal will be an emulation as exact as possible    |');
	writeln('+-------------------------------------------------------+');
	
	poke($0000,$01);
    	poke($0001,$00);
    	poke($0002,$03);
	while true do cpu_execute_one_cycle	
end.
