----------------------------------------------------------------------------------
-- Company: Trioflex OU
-- Engineer: Antti Lukats
-- 
-- Create Date:    09:10:22 05/30/2012 
-- Design Name:     
-- Module Name:    SARM_DECODE - Behavioral 
-- Project Name: 
-- Target Devices: Any FPGA
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

entity SARM_PROC is Port ( 
			sysclk   	: in STD_LOGIC;
			sysclk_ce   : in STD_LOGIC;
			--
			-- Instruction streaming interface
			-- MSBit first as it comes from SPI flash Low byte first
			--
			INSTR_DI 	: in STD_LOGIC;  -- serial data from serialized code memory storage
			INSTR_CE 	: in STD_LOGIC;  -- clock enable for serialized data
			INSTR_RST 	: in STD_LOGIC;  -- reset instruction deserializer
			INSTR_BSY 	: out STD_LOGIC; -- deserializer busy
			--
			--
			--
			

			
			DUMMY    : out STD_LOGIC
			);
end SARM_PROC;

architecture Behavioral of SARM_PROC is


	COMPONENT SARM_DES
	PORT(
		CLK 		: IN std_logic;
		CE 		: IN std_logic;
		DI 		: IN std_logic;          
		DES 		: OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT SARM_INSTR_BCNT
	PORT(
		CLK 		: IN std_logic;
		CE 		: IN std_logic;
		RST 		: IN std_logic;          
		B15		: out  STD_LOGIC;
		RDY		: out  STD_LOGIC;
		BITADDR 	: OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT SARM_SRL16
	PORT(
		CLK 		: IN std_logic;
		CE 		: IN std_logic;
		ADDR 		: IN std_logic_vector(2 downto 0);
		DI 		: IN std_logic;          
		DO 		: OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT SARM_DEC_i_ofs
	PORT(
		inst : IN std_logic_vector(15 downto 12);          
		ilsb : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;	

	COMPONENT SARM_RB_BCNT
	PORT(
		CLK 	: IN std_logic;
		CE 	: IN std_logic;
		RST 	: IN std_logic;
		CY		: out  STD_LOGIC;
		Q 		: OUT std_logic_vector(4 downto 0)          
		);
	END COMPONENT;

	COMPONENT SARM_iram16
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		DI : IN std_logic;
		ADDR : IN std_logic_vector(3 downto 0);          
		Q : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SARM_SYSDP
	PORT(
		CLK : IN std_logic;
		ADDRA : IN std_logic_vector(15 downto 0);
		ADDRB : IN std_logic_vector(15 downto 0);
		DINA : IN std_logic;
		DINB : IN std_logic;
		WEA : IN std_logic;
		WEB : IN std_logic;          
		DOA : OUT std_logic;
		DOB : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SARM_LALU
	PORT(
		A : IN std_logic;
		B : IN std_logic;
		OP : IN std_logic_vector(1 downto 0);          
		Q : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SARM_SR32
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		DI : IN std_logic;          
		Q : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT SARM_SR32LD
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		DI : IN std_logic;
		LOAD : IN std_logic;          
		D : IN std_logic_vector(31 downto 0);
		Q : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT SARM_ADD32
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);          
		Q : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT SARM_AALU
	PORT(
		A : IN std_logic;
		B : IN std_logic;
		CI : IN std_logic;
		CO : OUT std_logic;
		Q : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SARM_DECODE
	PORT(
		INSTR : IN std_logic_vector(15 downto 0);   

		useLALU : OUT std_logic;
		LALU_OP : out STD_LOGIC_VECTOR (1 downto 0);
		op3R    : out STD_LOGIC; -- 1 for 3 Register instructions
		invB    : out STD_LOGIC; -- invert the B/C operand

		INS_BRcc  : out  STD_LOGIC;
		
			INS_000x 		: out  STD_LOGIC; 
			INS_001x 		: out  STD_LOGIC; 
			INS_010x       : out  STD_LOGIC; 
			INS_0100_01xx  : out  STD_LOGIC;
			INS_0100_00xx  : out  STD_LOGIC;
			INS_0101 		: out  STD_LOGIC; -- STR/STRH/STRB/LDRSB/LDR/LDRH/LDRB/LDRSH
			INS_1011 		: out  STD_LOGIC; -- 
			INS_1100 		: out  STD_LOGIC; -- LDM/STM
	
	
			INS_xxxx_0010 : out  STD_LOGIC;
			INS_xxxx_1010 : out  STD_LOGIC;
			INS_SH : out  STD_LOGIC; -- any shift op
			INS_MOV : out  STD_LOGIC; -- any mov op, eg no alu operation, just copy
			INS_MOVA : out  STD_LOGIC; -- any mov op, eg no alu operation, just copy

	
			INS_STM : out  STD_LOGIC;
			INS_LDM : out  STD_LOGIC;	
			INS_SUB : out  STD_LOGIC;

			RWE : out  STD_LOGIC;			
		ALUimm : out  STD_LOGIC;
		M64 : OUT std_logic;
		M32R : OUT std_logic;
		M32W : OUT std_logic;
		M32X2 : OUT std_logic
		);
	END COMPONENT;

signal ce : std_logic; 


--
-- Deserializes 16 bit instruction that is being shifted in
--
signal DES : std_logic_vector(15 downto 0); -- serialize
signal DES_BITADDR : std_logic_vector(3 downto 0); -- count bits

signal DES_B15 : std_logic; -- signal all 15 bits shifted, next is last
signal DES_RDY : std_logic; -- signal all bits collected, ready to flush

signal EXE_RDY : std_logic; -- execution unit ready, get next instruction in

signal EXE_WREN : std_logic; -- write next instr bits into EXEcution unit
signal EXE_WREN1 : std_logic; -- write next instr bits into EXEcution unit

signal EXE_RST  : std_logic; -- write next instr bits into EXEcution unit

signal SNEXTB  : std_logic; -- 1 when stage should process next bit
signal EVENODD  : std_logic; -- 1 when stage should process next bit

signal M64 	  : std_logic;
signal M32R   : std_logic;
signal M32W   : std_logic;
signal M32X2  : std_logic;
signal RWE  : std_logic;


--
-- on the fly decoding of Write back flag for LDM instruction
--
signal WB_DES : std_logic;			-- valid when DES[15..0] is valid
signal WB_INSTR : std_logic;     -- valid when INSTR[15..0] is valid

--
-- Deserializes 16 bit instruction that is being processed
--
signal INSTR : std_logic_vector(15 downto 0);



--
-- Dual port RAM addressing and control logic
--
signal RA_ba : std_logic_vector(4 downto 0); -- bit number in PORT A
signal RB_ba : std_logic_vector(4 downto 0); -- bit number in PORT B
signal RB_cy : std_logic; -- carry out
signal RB_cy2 : std_logic; -- carry out

signal RA_ra : std_logic_vector(3 downto 0); -- reg number in PORT A
signal RB_ra : std_logic_vector(3 downto 0); -- reg number in PORT B
signal RC_ra : std_logic_vector(3 downto 0); -- reg number in PORT C time muxed with B

signal RB_i8 : std_logic; -- 

signal RA_CE : std_logic; -- 
signal RB_CE : std_logic; -- 

signal RI_ba : std_logic_vector(3 downto 0);
signal RI_ba_next : std_logic_vector(3 downto 0);

-- instr bit ram
signal iram_addr : std_logic_vector(3 downto 0);
signal iram0_sel : std_logic; -- 
signal iram0_seldo : std_logic; -- 
signal iram0_we : std_logic; -- 
signal iram1_we : std_logic; -- 

signal iram0_do : std_logic; -- 
signal iram1_do : std_logic; -- 
signal iram_do : std_logic; -- 
signal iram_do_i : std_logic; -- 

signal imm_done : std_logic;
signal ALUimm : std_logic;

signal SYSDP_ADDRA : std_logic_vector(15 downto 0);
signal SYSDP_ADDRB : std_logic_vector(15 downto 0);
signal SYSDP_DOA   : std_logic;
signal SYSDP_DOAn  : std_logic; -- A or inverse A

signal SYSDP_DOB   : std_logic;
signal SYSDP_DOBn   : std_logic;

signal SYSDP_DINB  : std_logic;
signal SYSDP_WEB   : std_logic;

signal op3R : std_logic;

signal useLALU : std_logic;
signal LALU_OP : std_logic_vector(1 downto 0);
signal LALU_A : std_logic;
signal LALU_B : std_logic;
signal LALU_Q : std_logic;

signal AALU_Q : std_logic;
signal AALU_C : std_logic;
signal AALU_CY : std_logic;
signal AALU_CO : std_logic;
signal invB    : STD_LOGIC; -- invert the B/C operand

--
-- Result valid FLAG = 1 when serial unit result bit is valid
-- The result is either written to the DPRAM or discarded
--
signal RES_VALID : std_logic;
signal S1ACT : std_logic;
signal S2ACT : std_logic; -- stage 2

signal ABIT0 : std_logic;


--
-- ALU Z flag calculated on result of the operation OR ing all bits
-- 
signal ALU_Z : std_logic;


signal OP_AplusB : std_logic_vector(31 downto 0);
signal OP_A : std_logic_vector(31 downto 0);
signal OP_B : std_logic_vector(31 downto 0);





-- debug visibility registers

signal dbg_SYSDP_A_sr : std_logic_vector(31 downto 0);
signal dbg_SYSDP_B_sr : std_logic_vector(31 downto 0);
signal dbg_SYSDP_A : std_logic_vector(31 downto 0);
signal dbg_SYSDP_B : std_logic_vector(31 downto 0);

signal dbg_LALU_sr : std_logic_vector(31 downto 0);
signal dbg_LALU : std_logic_vector(31 downto 0);

signal dbg_AALU_sr : std_logic_vector(31 downto 0);
signal dbg_AALU : std_logic_vector(31 downto 0);

signal dbg_IMM_sr : std_logic_vector(31 downto 0);
signal dbg_IMM : std_logic_vector(31 downto 0);

signal dbg_R0_sr : std_logic_vector(31 downto 0);
signal dbg_R0 : std_logic_vector(31 downto 0);

signal dbg_R1_sr : std_logic_vector(31 downto 0);
signal dbg_R1 : std_logic_vector(31 downto 0);

signal dbg_R2_sr : std_logic_vector(31 downto 0);
signal dbg_R2 : std_logic_vector(31 downto 0);

signal dbg_R3_sr : std_logic_vector(31 downto 0);
signal dbg_R3 : std_logic_vector(31 downto 0);


--------------------------------------

signal INS_000x : std_logic;
signal INS_001x : std_logic;
signal INS_010x : std_logic;
signal INS_0100_01xx : std_logic;
signal INS_0100_00xx : std_logic;

signal INS_0101 : std_logic;
signal INS_1011 : std_logic;
signal INS_1100 : std_logic;
signal INS_1110 : std_logic;

signal INS_xxxx_0010 : std_logic;
signal INS_xxxx_1010 : std_logic;

signal INS_LDM 		: STD_LOGIC;
signal INS_STM 		: STD_LOGIC;
	
signal INS_SH 		: STD_LOGIC;
signal INS_MOV 		: STD_LOGIC;
signal INS_MOVA 		: STD_LOGIC;
			
				
	
signal INS_BRcc		: STD_LOGIC;
signal INS_ADDSUB	   : STD_LOGIC;
signal INS_SUB	   : STD_LOGIC;

signal INS_UNDEF     : STD_LOGIC;

signal imm_i_lsb     : std_logic_vector(3 downto 0);
signal imm_i_msb     : std_logic_vector(3 downto 0);



begin
   ce <= sysclk_ce;

	DUMMY <= WB_INSTR xor 

		INS_BRcc xor
		ALU_Z xor
	   OP_AplusB(31) xor 
	   OP_AplusB(23) xor 
		OP_AplusB(9) xor 
		OP_AplusB(0) xor OP_A(0) xor OP_B(0);

	--
	-- deserialize instruction into 16 bit word
	--
	Inst_SARM_DES: SARM_DES PORT MAP(
		CLK 	=> sysclk,
		CE 	=> INSTR_CE,
		DI 	=> INSTR_DI,
		DES 	=> DES
	);   

	Inst_SARM_INSTR_BCNT: SARM_INSTR_BCNT PORT MAP(
		CLK 		=> sysclk,
		CE 		=> INSTR_CE,
		RST 		=> INSTR_RST,
		B15		=> DES_B15,
		RDY		=> DES_RDY,
		BITADDR 	=> DES_BITADDR
	);

	-- write enable for transfer to EXEcution unit input boundary latches
   EXE_WREN <= DES_RDY and EXE_RDY;
	EXE_RST  <= EXE_WREN or INSTR_RST;
	
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if INSTR_RST = '1' then
					INSTR 		<= X"0000";	-- NOP
					WB_INSTR 	<= '0';
					INSTR_BSY	<= '0';
					EXE_RDY 		<= '1';
				elsif EXE_WREN = '1' then
					INSTR 		<= DES;	-- latch deserialized instruction
					WB_INSTR 	<= WB_DES;
					
					 
					INSTR_BSY <= '0';
					EXE_RDY   <= '0';
					
					
					
				elsif DES_B15='1' and EXE_RDY='0' then
					INSTR_BSY <= '1';
				elsif RB_cy2='1' then
					-- FIXME
				   
					EXE_RDY <= '1';
				end if;	
			end if;
	end process;	

	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if EXE_WREN = '1' then
					RB_cy2   	<= '0';
				else
					RB_cy2   	<= RB_cy;
				end if;	
				
				EXE_WREN1 <= EXE_WREN;
			end if;
	end process;	


	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if INSTR_RST = '1' then
					iram0_sel 	<= '0';
				elsif INSTR_CE = '1' and DES_B15='1'then
					iram0_sel <= not iram0_sel; -- select another iram storage ramX
				end if;	
			end if;
	end process;	

	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if EXE_WREN = '1' then 
					iram0_seldo <= iram0_sel;
				end if;		
			end if;
	end process;	

	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if EXE_WREN = '1' then 
					ABIT0 <= '1';
				elsif RES_VALID='1' then
					ABIT0 <= '0';
				end if;		
			end if;
	end process;


   --
	-- write back decoder, 1 LUT4 (for Xilinx architecture)
	-- 
	Inst_SARM_SRL16: SARM_SRL16 PORT MAP(
		CLK 	=> sysclk,
		CE 	=> INSTR_CE,
		ADDR 	=> DES(10 downto 8),
		DI 	=> INSTR_DI,
		DO 	=> WB_DES			-- bit to be latched as write_back
	);
	--
	-- lowest bit of the immediate data within instr bit ram 0/6
	--
	Inst_SARM_DEC_i_ofs: SARM_DEC_i_ofs PORT MAP(
		inst 	=> INSTR(15 downto 12),
		ilsb 	=> imm_i_lsb
	);

	--
	-- dual 16 bit RAM's for instruction storage
	--
	Inst_SARM_iram16_0: SARM_iram16 PORT MAP(
		CLK 	=> sysclk,
		CE 	=> iram0_we,
		DI 	=> INSTR_DI,
		ADDR 	=> iram_addr,
		Q 		=> iram0_do
	);
	Inst_SARM_iram16_1: SARM_iram16 PORT MAP(
		CLK 	=> sysclk,
		CE 	=> iram1_we,
		DI 	=> INSTR_DI,
		ADDR 	=> iram_addr,
		Q 		=> iram1_do
	);
	
	iram0_we <=     iram0_sel and INSTR_CE;
	iram1_we <= not iram0_sel and INSTR_CE;
	
	--
	-- bit address should start from 0 or 6 
	--
	--RI_ba     <= (RB_ba(3 downto 0) + imm_i_lsb);
	iram_addr <= RI_ba xor "1000";
	
   imm_i_msb <= "1000" when RB_i8='1' else "1001"; 
	RI_ba_next <= RI_ba + "0001"; 
	
	iram_do_i <= '0' when imm_done='1' else iram1_do when iram0_seldo = '1' else iram0_do;
	iram_do <= iram_do_i;
	
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN1='1' then
						RI_ba <= imm_i_lsb;
						imm_done<='0';
					elsif RI_ba_next = imm_i_msb and RES_VALID='1' then
					  --
					  imm_done <= '1';
					elsif SNEXTB='1' then
						RI_ba <= RI_ba_next;
					end if;
					-- we need to delay one clock to get aligned with sync SYSDP output
					--iram_do <= iram_do_i;
				end if;	
			end if;
	end process;	
	
	

--------------------

	Inst_SARM_SYSDP: SARM_SYSDP PORT MAP(
		CLK 	=> sysclk,
		ADDRA => SYSDP_ADDRA(15 downto 0),
		ADDRB => SYSDP_ADDRB(15 downto 0),
		DINA 	=> '0',
		DINB 	=> SYSDP_DINB,
		DOA 	=> SYSDP_DOA,
		DOB 	=> SYSDP_DOB,
		WEA 	=> '0',
		WEB 	=> SYSDP_WEB
	);

	--
	-- deserialize operand for MUL, DP operand OP_B
	--
	Inst_SARM_SR32B: SARM_SR32 PORT MAP(
		CLK 	=> sysclk,
		CE 	=> '1', -- FIXME
		DI 	=> SYSDP_DOB,
		Q 		=> OP_B
	);


	Inst_SARM_SR32LD_A: SARM_SR32LD PORT MAP(
		CLK 	=> sysclk,
		CE 	=> '1',
		DI 	=> SYSDP_DOA,
		LOAD 	=> EXE_WREN, -- fixme
		D 		=> OP_AplusB,
		Q 		=> OP_A
	);


	Inst_SARM_ADD32: SARM_ADD32 PORT MAP(
		A 		=> OP_A,
		B 		=> OP_B,
		Q 		=> OP_AplusB
	);



   
	
	-- Logic ALU
	-- functions: OR, EOR, AND, NAND
	Inst_SARM_LALU: SARM_LALU PORT MAP(
		A 	=> SYSDP_DOA, --iram_do,
		B 	=> SYSDP_DOB,
		OP => LALU_OP,
		Q 	=> LALU_Q
	);

	-- we need A inversion for: SUB, SBC, BIC, MVN
	-- FIXME
	SYSDP_DOAn <= SYSDP_DOA when INS_MOV='0' else '0';
   SYSDP_DOBn <= '0' when INS_MOVA='1' else iram_do when ALUimm='1' else SYSDP_DOB xor invB;

	Inst_SARM_AALU: SARM_AALU PORT MAP(
		A 		=> SYSDP_DOAn, 
		B 		=> SYSDP_DOBn,
		CI 	=> AALU_CY,
		CO 	=> AALU_CO,		-- this should be saved to C bit if C bit update is enabled
		Q 		=> AALU_Q
	);

   AALU_CY <= 
		'1' when INS_SUB='1' and ABIT0='1' else -- for SUB we need to invert incoming CARRY flag, once
		AALU_C ;

	--
	-- fix this, need use CY-in if instruction needs it ADC, SBC
	--
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN='1' then
						AALU_C <= '0';
					elsif RES_VALID='1' then
						AALU_C <= AALU_CO;
					end if;
				end if;	
			end if;
	end process;	

   -- Result is valid 1 clock delayed, and each clock when Bit count is advanced
	RES_VALID <= S1ACT and SNEXTB;

	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN='1' then
						ALU_Z <= '1'; -- always ZERO when new instr exec's
					else
						if SYSDP_DINB = '1' and RES_VALID='1' then
							ALU_Z <= '0';
						end if;
					end if;
				end if;	
			end if;
	end process;	


   SYSDP_WEB <= RES_VALID and RWE;

	--
	-- Calculate even odd subcycles for the serial process
	-- only used for 64 clock transfer cycle!
	--
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN='1' then
						EVENODD <= '1';	-- 
					else
						EVENODD <= EVENODD xor '1';
					end if;
				end if;	
			end if;
	end process;	
	
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN='1' or RB_cy2='1' or S2ACT='1' then
						S1ACT <= '0';
					else
						S1ACT <= '1'; -- 
					end if;
				end if;	
			end if;
	end process;

	process(sysclk)
		begin		
			if rising_edge(sysclk) then
				if ce='1' then
					if EXE_WREN='1' or RB_cy2='1' then
						S2ACT <= '0';
					elsif S1ACT='1' and INS_SH='1' and RB_ba(3)='1' then
						S2ACT <= '1'; -- for Shift instr first cycle is 8 clocks only
					end if;
				end if;	
			end if;
	end process;
	
	
	
	--
	-- Serial engine advance to next bit
	--
	SNEXTB <= (not EVENODD) when M64='1' else '1';

	--
	-- Counters for Dual Port RAM addresses
	--
	
	--
	-- advance on every clock for x32 or on each odd clock for x64 transfers
	--
	RB_CE <= ce and (SNEXTB or EXE_RST);
	--
	-- Bit address withing register
	-- 
	Inst_SARM_RB_BCNT: SARM_RB_BCNT PORT MAP(
		CLK 	=> sysclk,
		CE 	=> RB_CE,		   -- RB clock enable
		RST 	=> EXE_RST,		-- Clear to 0, when new instruction going to execution
		CY    => RB_cy,
		Q 		=> RB_ba			-- RAM side B bit address
	);

	--
	-- Register address
	--
	RB_i8 <= INS_1100 or INS_001x;
	
	RB_ra(2 downto 0) <= 
		INSTR(10 downto 8) when RB_i8 = '1' else	-- LSB is 8 or 0?
		INSTR(2 downto 0);
	RB_ra(3) <= INSTR(7) when INS_0100_01xx='1' else '0';

	RC_ra(2 downto 0) <= 
		INSTR(8 downto 6);
	RC_ra(3) <= '0';

	
	-- BIT address on B port, always incrementing 0..31
	SYSDP_ADDRB(4 downto 0) <= RB_ba when M32W='0' else (RB_ba+"11111");
	-- register address on B port: 
	-- destination, or source and destination registers
	SYSDP_ADDRB(8 downto 5) <= RB_ra when (op3R='0' or SNEXTB='1') else RC_ra;
	
	-- register offset in SYSDP block ram
	SYSDP_ADDRB(15 downto 9) <= "0000000"; -- RAM or regs accessed

	--
	--
	--
   SYSDP_DINB <= 
		LALU_Q when useLALU='1' else
		AALU_Q;
		

	--	
	-- Register A, either 0..7 or 0..15
	-- FIXME special case for R15!	
	--
	RA_ra(2 downto 0) <= INSTR(5 downto 3) when RB_i8='0' else INSTR(10 downto 8);
	RA_ra(3) <= INSTR(6) when INS_0100_01xx='1' else '0';
	
	SYSDP_ADDRA(4 downto 0) <= RB_ba; -- xor "11111";
	-- register address on B port: 
	-- destination, or source and destination registers
	SYSDP_ADDRA(8 downto 5) <= RA_ra;
	-- register offset in SYSDP block ram
	SYSDP_ADDRA(15 downto 9) <= "0000000"; -- only registers accessed from port A
	
	
	--
	--
	--
	Inst_SARM_DECODE: SARM_DECODE PORT MAP(
		INSTR 	=> INSTR,
		
		INS_BRcc => INS_BRcc,

		useLALU => useLALU,	
		LALU_OP 	=> LALU_OP, 
		op3R 		=> op3R,
		invB     => invB,
	
			INS_000x => INS_000x, 
			INS_001x => INS_001x, 
			INS_010x => INS_010x, 
			INS_0100_01xx => INS_0100_01xx,
			INS_0100_00xx => INS_0100_00xx,
			INS_0101 => INS_0101,
			INS_1011 => INS_1011,
			INS_1100 => INS_1100,
	
	
			INS_xxxx_0010 => INS_xxxx_0010,
			INS_xxxx_1010 => INS_xxxx_1010,
	
			INS_STM => INS_STM,
			INS_LDM => INS_LDM,	
			INS_SUB => INS_SUB,
			INS_SH => INS_SH,	
			INS_MOV => INS_MOV,	
			INS_MOVA => INS_MOVA,	
			
	RWE => RWE,
	ALUimm => ALUimm,
		M64 		=> M64,
		M32R 		=> M32R,
		M32W 		=> M32W,
		M32X2 	=> M32X2
	);




	

	--
	-- debug visibility...
	--
	process(sysclk)
		begin		
			if rising_edge(sysclk) then
			   if SNEXTB = '1' then
					-- shift in what comes out from SYSDP ram and Instr bitram 
					dbg_IMM_sr <= iram_do & dbg_IMM_sr(31 downto 1);
					dbg_SYSDP_A_sr <= SYSDP_DOAn & dbg_SYSDP_A_sr(31 downto 1);
					dbg_SYSDP_B_sr <= SYSDP_DOBn & dbg_SYSDP_B_sr(31 downto 1);
					dbg_LALU_sr <= LALU_Q & dbg_LALU_sr(31 downto 1);
					dbg_AALU_sr <= AALU_Q & dbg_AALU_sr(31 downto 1);
				end if;
				
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 5)="000" then
					dbg_R0_sr <= SYSDP_DINB & dbg_R0_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 5)="001" then
					dbg_R1_sr <= SYSDP_DINB & dbg_R1_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 5)="010" then
					dbg_R2_sr <= SYSDP_DINB & dbg_R2_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 5)="011" then
					dbg_R3_sr <= SYSDP_DINB & dbg_R3_sr(31 downto 1);
				end if;
				
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 0)="00011111" then
					dbg_R0 <= SYSDP_DINB & dbg_R0_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 0)="00111111" then
					dbg_R1 <= SYSDP_DINB & dbg_R1_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 0)="01011111" then
					dbg_R2 <= SYSDP_DINB & dbg_R2_sr(31 downto 1);
				end if;
			   if SYSDP_WEB = '1' and SYSDP_ADDRB(7 downto 0)="01111111" then
					dbg_R3 <= SYSDP_DINB & dbg_R3_sr(31 downto 1);
				end if;

				
				
				if EXE_WREN='1' then
					dbg_IMM <= dbg_IMM_sr;
					dbg_LALU <= dbg_LALU_sr;
					dbg_AALU <= dbg_AALU_sr;					
					dbg_SYSDP_A <= dbg_SYSDP_A_sr;
					dbg_SYSDP_B <= dbg_SYSDP_B_sr;
					
				end if;
			end if;
	end process;	
	



end Behavioral;

