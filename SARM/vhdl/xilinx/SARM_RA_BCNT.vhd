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

entity SARM_RA_BCNT is
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           RST : out  STD_LOGIC;
           Q : in  STD_LOGIC_VECTOR (4 downto 0));
end SARM_RA_BCNT;

architecture Behavioral of SARM_RA_BCNT is

begin


end Behavioral;

