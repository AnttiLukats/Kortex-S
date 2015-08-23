----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:25:46 06/06/2012 
-- Design Name: 
-- Module Name:    SARM_AALU - Behavioral 
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

entity SARM_AALU is Port ( 
			A : in  STD_LOGIC;
         B : in  STD_LOGIC;
         CI : in  STD_LOGIC;
         CO : out  STD_LOGIC;
         Q : out  STD_LOGIC
			);
end SARM_AALU;

architecture Behavioral of SARM_AALU is

signal Qi: std_logic_vector(2 downto 0);
signal Ai: std_logic_vector(2 downto 0);
signal Bi: std_logic_vector(2 downto 0);

begin
	Ai <= '0' & A & CI;
	Bi <= '0' & B & '1';
   Qi <= Ai + Bi;
	Q  <= Qi(1);
	CO <= Qi(2); 

end Behavioral;

