----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:51 06/02/2012 
-- Design Name: 
-- Module Name:    SARM_RA_BCNT - Behavioral 
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

entity SARM_RB_BCNT is Port ( 
			CLK 	: in  STD_LOGIC;
         CE 	: in  STD_LOGIC;
         RST 	: in  STD_LOGIC;
			CY		: out  STD_LOGIC;
         Q 		: out  STD_LOGIC_VECTOR (4 downto 0)
			);
end SARM_RB_BCNT;

architecture Behavioral of SARM_RB_BCNT is

signal CNT : STD_LOGIC_VECTOR (4 downto 0);

begin
	Q 	<= CNT(4 downto 0);
	CY <= '1' when CNT="11111" else '0';
	
	process(CLK)
		begin		
			if rising_edge(CLK) then
				if CE='1' then
					if RST='1' then
						CNT <= "00000";
					else
						CNT <= CNT+"00001";
					end if;
				end if;	
			end if;
	end process;
	
end Behavioral;

