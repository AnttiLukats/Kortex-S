----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:27:00 06/02/2012 
-- Design Name: 
-- Module Name:    SARM_DES - Behavioral 
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

entity SARM_DES is Port ( 
				CLK	: in  STD_LOGIC;
				CE 	: in  STD_LOGIC;
				DI 	: in  STD_LOGIC;
				DES 	: out  STD_LOGIC_VECTOR (15 downto 0)
				);
end SARM_DES;

architecture Behavioral of SARM_DES is

signal SR : STD_LOGIC_VECTOR (15 downto 0);

begin
	DES <= SR(7 downto 0) & SR(15 downto 8);

	process(CLK)
		begin		
			if rising_edge(CLK) then
				if CE='1' then
					SR <= SR(14 downto 0) & DI;
				end if;
			end if;
	end process;

end Behavioral;

