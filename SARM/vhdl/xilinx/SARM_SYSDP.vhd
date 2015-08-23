----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:03:27 06/03/2012 
-- Design Name: 
-- Module Name:    SARM_SYSDP - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity SARM_SYSDP is Port ( 
			CLK 	: in  STD_LOGIC;
         ADDRA : in  STD_LOGIC_VECTOR (15 downto 0);
         ADDRB : in  STD_LOGIC_VECTOR (15 downto 0);
         DINA 	: in  STD_LOGIC;
         DINB 	: in  STD_LOGIC;
         DOA 	: out  STD_LOGIC;
         DOB 	: out  STD_LOGIC;
         WEA 	: in  STD_LOGIC;
         WEB 	: in  STD_LOGIC
			);
end SARM_SYSDP;

architecture Behavioral of SARM_SYSDP is

--signal mem : STD_LOGIC_VECTOR (63 downto 0) := X"FF33900912345678";
--                                               ___R1___|___R0__
--signal mem : STD_LOGIC_VECTOR (63 downto 0) := X"0001002300020010";
signal mem : STD_LOGIC_VECTOR (63 downto 0) := X"0000000300000007";

signal RDOA : STD_LOGIC;
signal RDOB : STD_LOGIC;

signal DOA0 : STD_LOGIC;
signal DOB0 : STD_LOGIC;

signal DOA1 : STD_LOGIC;
signal DOB1 : STD_LOGIC;

signal A6 : STD_LOGIC;
signal B6 : STD_LOGIC;




begin
	--
	--
	--
	
	
--	DOA <= DOA0 when A6='0' else DOA1;
--	DOB <= DOB0 when B6='0' else DOB1;
	
	DOA <= DOA1;
	DOB <= DOB1;
		
	
	--RDOA <= mem(conv_integer(ADDRA(5 downto 0)));
	--RDOB <= mem(conv_integer(ADDRB(5 downto 0)));

	--process(CLK)
	--	begin		
	--		if rising_edge(CLK) then
	--			DOA0 <= RDOA;
	--			DOB0 <= RDOB;
	--			A6 <= ADDRA(6);
	--			B6 <= ADDRB(6);
	--		end if;
	--end process;

   XLXI_2 : RAMB16_S1_S1 port map (
		ADDRA(13 downto 0)	=> ADDRA(13 downto 0),
      ADDRB(13 downto 0)	=> ADDRB(13 downto 0),
      CLKA						=> CLK,
      CLKB						=> CLK,
      DIA(0)					=> DINA,
      DIB(0)					=> DINB,
      ENA						=> '1',
      ENB						=> '1',
      SSRA						=> '0',
      SSRB						=> '0',
      WEA						=> WEA,
      WEB						=> WEB,
      DOA(0)					=> DOA1,
      DOB(0)					=> DOB1
		);



end Behavioral;

