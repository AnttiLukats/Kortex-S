----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:52 06/02/2012 
-- Design Name: 
-- Module Name:    SARM_DEC_i_ofs - Behavioral 
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

entity SARM_DEC_i_ofs is Port ( 
		inst : in  STD_LOGIC_VECTOR (15 downto 12);
      ilsb : out  STD_LOGIC_VECTOR (3 downto 0)
		);
end SARM_DEC_i_ofs;

architecture Behavioral of SARM_DEC_i_ofs is

signal i6: std_logic;
begin
	--
	-- 1 LUT4
	-- 
	i6 <= 
		'1' when inst(15 downto 13) =  "000" else -- LSL/LSR/ASR i5 ADD/SUB i3
		'1' when inst(15 downto 12) = "0000" else -- LDR/STR
		'1' when inst(15 downto 12) = "0000" else -- STRB/LDRB
		'1' when inst(15 downto 12) = "0000" else -- STRH/LDRH
		'0';

	ilsb(0) <= '0';
	ilsb(1) <= i6;
	ilsb(2) <= i6;
	ilsb(3) <= '0';

end Behavioral;

