NES Mapper Reader / ROM Fixer / ROM Splitter 1.0 - Programmed by Shawn M. Crawford 
---------------------------------------------------------------------------------
This utility will:
	- read NES Rom Info based on the iNES Header (mapper, mirroring, etc)
	- clean a rom header by blanking out bytes 7 - 15
	- remove the iNES header (to prep for burning to eprom)
	- output the relavent CHR/PRG bin files to burn with eprom burner for
	  dev carts

It's best to use the auto split option unless you know tha the PRG and CHR are incorrect sizes, since this info is based on the iNES header. 

It was programmed in C# with Visual Studio 2008


System Requirements
------------------------
latest .net framework