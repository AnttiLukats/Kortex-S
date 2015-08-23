----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:33:12 06/02/2012 
-- Design Name: 
-- Module Name:    SARM_INSTR_BCNT - Behavioral 
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

entity SARM_INSTR_BCNT is Port ( 
			CLK 	: in  STD_LOGIC;
         CE 	: in  STD_LOGIC;
         RST 	: in  STD_LOGIC;
			B15	: out  STD_LOGIC;
			RDY	: out  STD_LOGIC;
         BITADDR : out  STD_LOGIC_VECTOR (3 downto 0)
			);
end SARM_INSTR_BCNT;

architecture Behavioral of SARM_INSTR_BCNT is

signal CNT : STD_LOGIC_VECTOR (3 downto 0);
signal B15_i : STD_LOGIC;

begin
	BITADDR <= CNT;
	B15 <= B15_i;
	B15_i <= '1' when CNT="1111" else '0'; 
	
	process(CLK)
		begin		
			if rising_edge(CLK) then
				if CE='1' then
					if RST='1' then
						CNT <= "0000";
						RDY <= '0';
					else
						CNT <= CNT+"0001";
						RDY <= B15_i;
					end if;
				end if;	
			end if;
	end process;

end Behavioral;

