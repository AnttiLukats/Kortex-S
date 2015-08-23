----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:03:07 06/06/2012 
-- Design Name: 
-- Module Name:    SARM_DECODE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SARM_DECODE is Port ( 
			INSTR : in  STD_LOGIC_VECTOR (15 downto 0);
			
			LALU_OP : out STD_LOGIC_VECTOR (1 downto 0); -- AND/ORR/EOR/0
			useLALU : out STD_LOGIC;
			
			invB    : out STD_LOGIC; -- invert the B/C operand
			op3R    : out STD_LOGIC; -- 1 for 3 Register instructions
			

			INS_BRcc  : out  STD_LOGIC;

			INS_000x 		: out  STD_LOGIC; 
			INS_001x 		: out  STD_LOGIC; 
			INS_010x       : out  STD_LOGIC; 
			INS_0100_01xx  : out  STD_LOGIC;
			INS_0100_00xx  : out  STD_LOGIC;
			INS_0101 		: out  STD_LOGIC; -- STR/STRH/STRB/LDRSB/LDR/LDRH/LDRB/LDRSH
			INS_1011 		: out  STD_LOGIC; -- 
			INS_1100 		: out  STD_LOGIC; -- LDM/STM
	
	
			INS_xxxx_0010 : out  STD_LOGIC;
			INS_xxxx_1010 : out  STD_LOGIC;
	
			INS_STM : out  STD_LOGIC;
			INS_LDM : out  STD_LOGIC;

			INS_SUB : out  STD_LOGIC;


			INS_SH : out  STD_LOGIC; -- any shift op
			INS_MOV : out  STD_LOGIC; -- any mov op, eg no alu operation, just copy
			INS_MOVA : out  STD_LOGIC; -- any mov op, eg no alu operation, just copy


			RWE : out  STD_LOGIC; -- Register Write Enable stage1

			ALUimm : out  STD_LOGIC;
         M64 : out  STD_LOGIC;
         M32R : out  STD_LOGIC;
         M32W : out  STD_LOGIC;
         M32X2 : out  STD_LOGIC
			);
end SARM_DECODE;

architecture Behavioral of SARM_DECODE is

signal INS_000xi : std_logic;
signal INS_001xi : std_logic;
signal INS_010xi : std_logic;
signal INS_0100_01xxi : std_logic;
signal INS_0100_00xxi : std_logic;

signal INS_0101i : std_logic;
signal INS_1011i : std_logic;
signal INS_1100i : std_logic;
signal INS_1110i : std_logic;

signal INS_xxxx_0010i : std_logic;
signal INS_xxxx_1010i : std_logic;

signal INS_LDMi 		: STD_LOGIC;
signal INS_STMi 		: STD_LOGIC;

signal INS_SHi 		: STD_LOGIC;
signal INS_MOVi 		: STD_LOGIC;
signal INS_MOVAi 		: STD_LOGIC;	
		
--signal INS_BRcc		: STD_LOGIC;

signal INS_ADDSUB	  : STD_LOGIC;
signal INS_ADDSUBabc	  : STD_LOGIC;
signal INS_ADDSUBimm   : STD_LOGIC;
signal INS_ADDSUBabcimm   : STD_LOGIC;
signal INS_SUBi	  : STD_LOGIC;

signal INS_ADDCMP44	  : STD_LOGIC;

signal INS_UNDEF     : STD_LOGIC;

begin
	M64 <= 
		INS_ADDSUB or -- OK
		INS_0100_01xxi -- FIXME
		;
	
	M32W <= INS_001xi;
	RWE <= 
		'0' when INS_001xi='1' and INSTR(10 downto 9)="11" else -- CMP Rx, i8
		'1';

	INS_MOVi <= 
		'1' when 
			(INS_001xi='1' and INSTR(12 downto 11)="00") -- MOV r, #
		else -- 
		'0';
	
	INS_SHi <= 
		'1' when 
			(INS_000xi = '1' and INSTR(12 downto 11) /= "11") or -- LSL/LSR/ASR imm
			(INS_0100_00xxi='1' and INSTR(9 downto 7)="001") or -- LSR/LSL r
			(INS_0100_00xxi='1' and INSTR(9 downto 6)="0111") -- ROR r
		else 
		'0';
	
	INS_MOVAi <= INS_0100_01xxi and INSTR(9); -- MOV r,r and BX, BLX?
	INS_ADDCMP44 <= INS_0100_01xxi and not INSTR(9);
	
	INS_ADDSUB <= 
		INS_ADDSUBabcimm or 
		INS_ADDCMP44 -- ADD, CMP
		;
	
	INS_ADDSUBabcimm <= INS_ADDSUBabc or INS_ADDSUBimm;
--	invB <= INS_ADDSUBabcimm and INSTR(9); -- OK 
	invB <= INS_SUBi; -- OK 

	
	INS_SUBi <= 
		'1' when 
				(INS_ADDSUBabcimm='1' and INSTR(9)='1') or 
				(INS_ADDCMP44='1' and INSTR(8)='1')
			else 
		'0';
	
	
	ALUimm <= INS_ADDSUBimm or INS_001xi;
	--
	-- logic operations, when INS_1011=1 only
	-- for SHIFT operations operands are fetched only
	-- processing in next stage
	--
	
	useLALU <= '0' when
		INSTR(9 downto 6)="0101" or
		INSTR(9 downto 6)="0110" or
		INSTR(9 downto 6)="1001" or
		INSTR(9 downto 7)="101" else INS_0100_00xxi;
		
	
	LALU_OP <= 
		"11" when INSTR(9 downto 6) = "0001" else -- EOR
		"10" when INSTR(9 downto 6) = "1100" else -- OR
		"01" when INSTR(8 downto 6) =  "000" else -- AND
		"00"; -- NOT A
	
	-- ADD/SUB
	INS_ADDSUBabc 	<= '1' when	INS_000xi='1' and INSTR(12 downto 10) = "110" else '0'; -- 
	INS_ADDSUBimm	<= '1' when	INS_000xi='1' and INSTR(12 downto 10) = "111" else '0'; -- 


	op3R <= INS_ADDSUBabc or INS_0101i;	-- OK, only those instruction use 3 operand registers

	INS_000xi 		<= '1' when INSTR(15 downto 13) = "000" else '0'; -- 
	INS_001xi 		<= '1' when INSTR(15 downto 13) = "001" else '0'; -- 
   INS_010xi       <= '1' when INSTR(15 downto 13) = "010" else '0'; -- 
   INS_0100_00xxi  <= '1' when (INSTR(12 downto 10) = "000" and INS_000xi='1') else '0';
   INS_0100_01xxi  <= '1' when (INSTR(12 downto 10) = "001" and INS_010xi='1') else '0';
	INS_0101i 		<= '1' when INSTR(15 downto 12) = "0101" else '0'; -- STR/STRH/STRB/LDRSB/LDR/LDRH/LDRB/LDRSH
   INS_1011i 		<= '1' when INSTR(15 downto 12) = "1011" else '0'; -- 
	INS_1100i 		<= '1' when INSTR(15 downto 12) = "1100" else '0'; -- LDM/STM
	
	
	INS_xxxx_0010i <= '1' when INSTR(11 downto 8) = "0010" else '0';
	INS_xxxx_1010i <= '1' when INSTR(11 downto 8) = "1010" else '0';

	
	INS_STMi <= INS_1100i and not INSTR(11);
	INS_LDMi <= INS_1100i and INSTR(11);
	
	
	
	
	INS_BRcc <= '1' when INSTR(15 downto 12) = "1101" else '0'; 
	
	
	
	INS_000x 		<= INS_000xi; -- 
	INS_001x 		<= INS_001xi; -- 
   INS_010x       <= INS_010xi; -- 
   INS_0100_00xx  <= INS_0100_00xxi;
   INS_0100_01xx  <= INS_0100_01xxi;
	INS_0101 		<= INS_0101i; -- STR/STRH/STRB/LDRSB/LDR/LDRH/LDRB/LDRSH
   INS_1011 		<= INS_1011i; -- 
	INS_1100 		<= INS_1100i; -- LDM/STM
	
	
	INS_xxxx_0010 <= INS_xxxx_0010i;
	INS_xxxx_1010 <= INS_xxxx_1010i;

	
	INS_STM <= INS_STMi;
	INS_LDM <= INS_LDMi;	
	
	INS_SH <= INS_SHi;	
	INS_MOV <= INS_MOVi;	
	INS_MOVA <= INS_MOVAi;	
	
	INS_SUB <= INS_SUBi;	
	
		
	
	
	

end Behavioral;

