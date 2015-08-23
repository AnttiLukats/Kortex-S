--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:08:48 06/02/2012
-- Design Name:   
-- Module Name:   C:/svn/hw/fpga/xilinx/ARM_Cores/SARM/TB_PROC.vhd
-- Project Name:  SARM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SARM_PROC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY TB_PROC IS
END TB_PROC;
 
ARCHITECTURE behavior OF TB_PROC IS 

	procedure rdy(
					signal s: in std_logic
	) is
	begin
		if s='1' then
			wait until s = '0';
		end if;	
   end rdy; 

	procedure shift_ins(
					signal clk: in std_logic;
					signal CE: out std_logic;
               signal DO: out std_logic;
               constant data: in integer) is
	variable tmp : std_logic_vector(15 downto 0);					
	begin
		tmp := std_logic_vector(to_unsigned(data, 16));

		
		CE <= '1';
		
		DO <= tmp(7);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(6);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(5);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(4);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(3);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(2);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(1);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(0);  wait until clk='0'; wait until clk='1';		
		
		DO <= tmp(15); wait until clk='0'; wait until clk='1';
		DO <= tmp(14); wait until clk='0'; wait until clk='1';
		DO <= tmp(13); wait until clk='0'; wait until clk='1';		
		DO <= tmp(12); wait until clk='0'; wait until clk='1';		
		DO <= tmp(11); wait until clk='0'; wait until clk='1';		
		DO <= tmp(10); wait until clk='0'; wait until clk='1';		
		DO <= tmp(9);  wait until clk='0'; wait until clk='1';		
		DO <= tmp(8);  wait until clk='0'; wait until clk='1';		
		
		CE <= '0';
		
		wait until clk='0'; wait until clk='1';		

	end shift_ins;
 
 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SARM_PROC
    PORT(
         sysclk : IN  std_logic;
			sysclk_ce : in STD_LOGIC;
         INSTR_DI : IN  std_logic;
         INSTR_CE : IN  std_logic;
         INSTR_RST : IN  std_logic;
         INSTR_BSY : OUT  std_logic;
         DUMMY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sysclk : std_logic := '0';
   signal INSTR_DI : std_logic := '0';
   signal INSTR_CE : std_logic := '1';
   signal INSTR_RST : std_logic := '1';

 	--Outputs
   signal INSTR_BSY : std_logic := '0';
   signal DUMMY : std_logic;

   -- Clock period definitions
   constant sysclk_period : time := 10ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SARM_PROC PORT MAP (
          sysclk 		=> sysclk,
			 sysclk_ce 	=> '1',
          INSTR_DI 	=> INSTR_DI,
          INSTR_CE 	=> INSTR_CE,
          INSTR_RST 	=> INSTR_RST,
          INSTR_BSY 	=> INSTR_BSY,
			 
          DUMMY 		=> DUMMY
        );

   -- Clock process definitions
   sysclk_process :process
   begin
		sysclk <= '0';
		wait for sysclk_period/2;
		sysclk <= '1';
		wait for sysclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- 
      wait until sysclk='0'; wait until sysclk='1';
		wait until sysclk='0'; wait until sysclk='1';
		
		INSTR_CE <= '0';
		INSTR_RST <= '0';
		wait until sysclk='0'; wait until sysclk='1';
		wait until sysclk='0'; wait until sysclk='1';
		
		
		-- test write back flag decoding
--		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#C800#); -- 0 LDM R0,<empty>
--      rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#CF00#); -- 0 LDM R7,<empty>

--      rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#C8FF#); -- 1 LDM R0,<full>
--      rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#CFFF#); -- 1 LDM R7,<full>
		
--      rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#C9FD#); -- 0 LDM R1,<1111_1101>
--      rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#C902#); -- 1 LDM R1,<0000_0010>

		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#0040#); -- LSL R0, R0, #1 

		-- imm8	
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#2001#); -- MOV R0, #1 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#2103#); -- MOV R1, #3 OK

 		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#460A#); -- MOV R2, R1 
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4402#); -- ADD R2, R0 
		
		
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4052#); -- EOR R2, R2 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#3201#); -- ADD R2, #1 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#3202#); -- ADD R2, #2 OK


		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1842#); -- ADD R2, R0, R1 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#180A#); -- ADD R2, R1, R0 OK

		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1A42#); -- SUB R2, R0, R1  -2 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1A0A#); -- SUB R2, R1, R0  2 OK

		-- imm3
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1D0A#); -- ADD R2, R1, #4  7 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1D4A#); -- ADD R2, R1, #5  8 OK
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#1DCA#); -- ADD R2, R1, #7  10 OK
	

		
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4000#); -- AND R0, R0
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4049#); -- EOR R1, R1
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4048#); -- EOR R0, R1
		
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4052#); -- EOR R2, R2
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#4042#); -- EOR R2, R0
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#430A#); --  OR R2, R1

		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#414A#); -- ADC R2, R1
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#414A#); -- ADC R2, R1
		



		-- imm8	
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#2655#); -- MOV R6, 0x55
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#26FA#); -- MOV R6, 0xFA
		rdy(INSTR_BSY); shift_ins(sysclk, INSTR_CE, INSTR_DI, 16#2633#); -- MOV R6, 0x33
	
		
      
		
		wait for sysclk_period*100;
      

      wait;
   end process;

END;
