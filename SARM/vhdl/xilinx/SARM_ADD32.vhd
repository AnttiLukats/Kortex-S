----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:13:35 06/05/2012 
-- Design Name: 
-- Module Name:    SARM_ADD32 - Behavioral 
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

entity SARM_ADD32 is Port ( 
				A 	: in  STD_LOGIC_VECTOR (31 downto 0);
				B 	: in  STD_LOGIC_VECTOR (31 downto 0);
				Q 	: out  STD_LOGIC_VECTOR (31 downto 0)
				);
end SARM_ADD32;

architecture Behavioral of SARM_ADD32 is

begin

	Q 	<= A + B;

end Behavioral;

