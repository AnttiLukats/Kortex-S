----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:16 06/03/2012 
-- Design Name: 
-- Module Name:    SARM_LALU - Behavioral 
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

entity SARM_LALU is Port ( 
			A : in  STD_LOGIC;
         B : in  STD_LOGIC;
         OP : in  STD_LOGIC_VECTOR (1 downto 0);
         Q : out  STD_LOGIC
			);
end SARM_LALU;

architecture Behavioral of SARM_LALU is

signal aorb : std_logic;
signal axorb : std_logic;
signal aandb : std_logic;


begin
	-- 
	-- Logic operations
	-- 
--	Q <= 
	--	(A xor B) when OP="11" else
	--	(A  or B) when OP="10" else
	--	(A and B) when OP="01" else
	--	('0');
		
	Q <= 
		(	(A xor B) and     OP(1) and     OP(0) ) or 
		(	(A or B)  and     OP(1) and not OP(0) ) or 
		(	(A and B) and not OP(1) and     OP(0) );
			
--   XLXI_1 : LUT4 port map (
--				I0=>A,
--            I1=>B,
--            I2=>OP(1),
--            I3=>OP(0),
--            O=>Q
--				);
		
		

end Behavioral;

