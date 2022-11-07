library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity controlLogic is

-- i_dir = 0 -> shift left; i_dir = 1 -> shift right
-- i_signed = 0 -> unsigned; i_singed = 1 -> signed shift
-- shamt: Ammount to shift by. Defined by shamt in R type instructions


  port(i_D : in std_logic_vector(31 downto 0);
       o_ALUSrc     : out std_logic;
       o_ALUControl : out std_logic_vector(4 downto 0);
       -- bit 0: 
       -- bit 1: 
       -- bit 2: 
       -- bit 3: 
       o_memToReg   : out std_logic;
       o_memWrite   : out std_logic;
       o_regWrite   : out std_logic;
       o_regDst     : out std_logic;
       o_jump       : out std_logic;
       o_branch     : out std_logic;
       o_memRead    : out std_logic;
       o_jal        : out std_logic;
       o_jreg       : out std_logic);

end controlLogic;

architecture dataflow of controlLogic is

signal outputData : std_logic_vector(14 downto 0);
signal opcode     : std_logic_vector(5 downto 0);
signal funcCode   : std_logic_vector(5 downto 0);

begin

  opcode <= i_D(31 downto 26);
  funcCode <= i_D(5 downto 0);

  outputData <= 
      
      -- addi
      "100000001000000" when opcode = "001000" else

      -- andi
      "100001001000000" when opcode = "001100" else

      -- addiu
      "100010001000000" when opcode = "001001" else

      -- beq
      "100011000001000" when opcode = "000100" else

      -- bne
      "100100000001000" when opcode = "000101" else

      -- lui
      "100101001000000" when opcode = "001111" else

      -- lw
      "100010101000100" when opcode = "100011" else

      --xori
      "100110001000000" when opcode = "001110" else

      -- ori
      "100111001000000" when opcode = "001101" else

      -- slti
      "101000000000000" when opcode = "001010" else

      -- sw
      "100010010000000" when opcode = "101011" else

      -- repl.qb
      "101001001000000" when opcode = "111111" else

      -- j
      "000000000010000" when opcode = "000010" else

      -- jal
      "001010000010010" when opcode = "000011" else

      -- add
      "000000001100000" when opcode = "000000" else

      -- addu
      "000010001100000" when opcode = "000001" else

      -- and
      "000001001100000" when opcode = "000011" else

      -- not
      "001011001100000" when opcode = "000100" else

      -- nor
      "001100001100000" when opcode = "000101" else

      -- xor
      "000110001100000" when opcode = "000110" else
      
      -- or
      "000111001100000" when opcode = "000111" else

      -- slt
      "001000001100000" when opcode = "001000" else

      -- sll
      "001101001100000" when opcode = "001001" else

      -- srl
      "001110001100000" when opcode = "001010" else

      -- sra
      "001111001100000" when opcode = "001011" else

      -- sub
      "010000001100000" when opcode = "001100" else

      -- subu
      "000011001100000" when opcode = "001100" else

      -- jr
      "000000000100001" when opcode = "001101" else

      -- else
      "000000000000000";
    


  o_ALUSrc     <= outputData(14);
  o_ALUControl <= outputData(13 downto 9);
  o_memToReg   <= outputData(8);
  o_memWrite   <= outputData(7);
  o_regWrite   <= outputData(6);
  o_regDst     <= outputData(5);
  o_jump       <= outputData(4);
  o_branch     <= outputData(3);
  o_memRead    <= outputData(2);
  o_jal        <= outputData(1);
  o_jreg       <= outputData(0);

end dataflow;