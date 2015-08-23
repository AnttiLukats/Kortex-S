----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:37:46 06/06/2012 
-- Design Name: 
-- Module Name:    SARM_SR32 - Behavioral 
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

entity SARM_SR32LD is Port ( 
			CLK : in  STD_LOGIC;
         CE : in  STD_LOGIC;
         DI : in  STD_LOGIC;
			LOAD : in  STD_LOGIC;
			D : in  STD_LOGIC_VECTOR (31 downto 0);
         Q : out  STD_LOGIC_VECTOR (31 downto 0)
			);
end SARM_SR32LD;

architecture Behavioral of SARM_SR32LD is

signal Qi : STD_LOGIC_VECTOR (31 downto 0);

begin
	Q <= Qi;
	
	process(CLK)
		begin		
			if rising_edge(CLK) then
				if CE='1' then
					if LOAD='1' then 
						Qi <= D;
					else	
						Qi <= (DI & Qi(31 downto 1));
					end if;
				end if;	
			end if;
	end process;

end Behavioral;

