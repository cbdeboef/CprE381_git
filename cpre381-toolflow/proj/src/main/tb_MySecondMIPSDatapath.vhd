-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_MySecondMIPSDatapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a VHDL testbench for the second MIPS
-- datapath.
--
-- mem load -infile dmem.hex -format hex /tb_MySecondMIPSDatapath/DUT/dmem/ram
-- NOTES:
-- 9/29/22: Created.
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity tb_MySecondMIPSDatapath is
    generic(gCLK_HPER   : time := 50 ns;
            N           : integer := 32;
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 10);
end tb_MySecondMIPSDatapath;

architecture behavior of tb_MySecondMIPSDatapath is
  
  -- Calculate the clock period as twice the half-period
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component MySecondMIPSDatapath
        generic(N               : integer := 32;
                DATA_WIDTH      : natural := 32;
                ADDR_WIDTH      : natural := 10);
        port(CLK                : in std_logic;                             -- Clock input
             c_RST              : in std_logic;                             -- Asynchronous reset for registers
             c_WE               : in std_logic;                             -- Write enable input
             c_nAddSub          : in std_logic;                             -- Select for the add/sub function
             c_ALUSrc           : in std_logic;                             -- Select for the MUX
             c_Ext              : in std_logic;                             -- Select for the bit extender
             c_MemWrite         : in std_logic;                             -- Write enable for the memory
             c_MemtoReg         : in std_logic;                             -- Select for the MUX controlling the data in for the reg
             i_rt               : in std_logic_vector(4 downto 0);          -- Select input for rt
             i_rs               : in std_logic_vector(4 downto 0);          -- Select input for rs
             i_rd               : in std_logic_vector(4 downto 0);          -- Select input for rd
             i_immediate        : in std_logic_vector(15 downto 0);         -- Data for the immediate
             o_C                : out std_logic);                           -- Carry out
    end component;

  -- Temporary signals
    signal s_CLK           : std_logic := '0';
    signal s_cRST          : std_logic := '1';
    signal s_cWE           : std_logic := '0';
    signal s_cnAddSub      : std_logic := '0';
    signal s_cALUSrc       : std_logic := '0';
    signal s_cEXT          : std_logic := '0';
    signal s_cMemWrite     : std_logic := '0';
    signal s_cMemtoReg     : std_logic := '0';
    signal s_irt           : std_logic_vector(4 downto 0) := "00000";
    signal s_irs           : std_logic_vector(4 downto 0) := "00000";
    signal s_ird           : std_logic_vector(4 downto 0) := "00000";
    signal s_iimmediate    : std_logic_vector(15 downto 0) := X"0000";
    signal s_oC            : std_logic;

begin
  DUT: MySecondMIPSDatapath
    generic map(N          => N,
                DATA_WIDTH => DATA_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH)
    port map(CLK                => s_CLK,
             c_RST              => s_cRST,
             c_WE               => s_cWE,
             c_nAddSub          => s_cnAddSub,
             c_ALUSrc           => s_cALUSrc,
             c_EXT              => s_cEXT,
             c_MemWrite         => s_cMemWrite,
             c_MemtoReg         => s_cMemtoReg,
             i_rt               => s_irt,
             i_rs               => s_irs,
             i_rd               => s_ird,
             i_immediate        => s_iimmediate,
             o_C                => s_oC);

  -- Clock process
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
    P_TEST: process
    begin
        s_cWE       <= '1';
        s_cRST      <= '0';
        wait for gCLK_HPER * 2;
        -- 22 test cases

        -- Test Case1: addi -- Reg25 = Reg0 + 0 = 0
        s_ird               <= "11001";                 -- Select the write register
        s_irs               <= "00000";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0000";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;

        -- Test Case2: addi -- Reg 26 = Reg0 + 256 = 256
        s_ird               <= "11010";                 -- Select the write register
        s_irs               <= "00000";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0100";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;        

        -- Test Case3: lw -- Reg1 = Mem[Reg25] = 0xFFFFFFFF
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0000";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;         
        
        -- Test Case4: lw -- Reg2 = Mem[Reg25 + 1] = 0x00000002
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;         
        
        -- Test Case5: add -- Reg1 = Reg1(0xFFFFFFFF) + Reg2(0x00000002)
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;       
        
        -- Test Case6: sw -- Mem[Reg26(256)] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0000";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;   
        
        -- Test Case7: lw -- Reg2 = Mem[2 + Reg25(0)] = FFFFFFFD
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0002";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;       
        
        -- Test Case8: add -- Reg1 = Reg1 + Reg2
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case9: sw -- Mem[1 + Reg26] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11010";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case10: lw -- Reg2 = Mem[3 + Reg25]
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0003";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;    
        
        -- Test Case11: add -- Reg1 = Reg1 + Reg2
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case12: sw -- Mem[2 + Reg26] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11010";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0002";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case13: lw -- Reg2 = Mem[4 + Reg25]
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0004";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;    

        -- Test Case14: add -- Reg1 = Reg1 + Reg2
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case15: sw -- Mem[3 + Reg26] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11010";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0003";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case16: lw -- Reg2 = Mem[5 + Reg25]
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0005";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;    
         
        -- Test Case17: add -- Reg1 = Reg1 + Reg2
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case18: sw -- Mem[4 + Reg26] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11010";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0003";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case19: lw -- Reg2 = Mem[6 + Reg25]
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11001";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0006";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2; 
        
        -- Test Case20: add -- Reg1 = Reg1 + Reg2
        s_ird               <= "00001";                 -- Select the write register
        s_irs               <= "00001";                 -- Select operand i_A
        s_irt               <= "00010";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '0';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        -- Test Case21: addi -- Reg27 = Reg0 + 512
        s_ird               <= "11011";                 -- Select the write register
        s_irs               <= "00000";                 -- Select operand i_A
        s_irt               <= "00000";                 -- Select operand i_B
        s_iimmediate        <= X"0200";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '0';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '0';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '1';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '1';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;       

        -- Test Case22: sw -- Mem[Reg27 - 1] = Reg1
        s_ird               <= "00010";                 -- Select the write register
        s_irs               <= "11011";                 -- Select operand i_A
        s_irt               <= "00001";                 -- Select operand i_B
        s_iimmediate        <= X"0001";                 -- Immediate value
        s_cALUSrc           <= '1';                     -- Control for the alu source, 0 = reg, 1 = immediate
        s_cnAddSub          <= '1';                     -- Control for the ALU, 0 = add, 1 = sub
        s_cEXT              <= '1';                     -- Control for the bit extender, 0 = unsigned, 1 = sign ext
        s_cMemWrite         <= '1';                     -- Control for the memory write, 0 = no memory write, 1 = write to mem
        s_cMemtoReg         <= '0';                     -- Control for the data to reg, 0 = memory to reg, 1 = alu to reg
        s_cWE               <= '0';                     -- Control for reg write, 0 = write disable, 1 = write enable
        wait for gCLK_HPER * 2;  

        wait;
    end process;
  
end behavior;