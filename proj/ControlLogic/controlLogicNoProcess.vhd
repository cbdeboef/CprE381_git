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
       o_regDst     : out std_logic);

end controlLogic;

architecture dataflow of controlLogic is

signal outputData : std_logic_vector(9 downto 0);
signal opcode     : std_logic_vector(5 downto 0);
signal funcCode   : std_logic_vector(5 downto 0);

begin

  opcode <= i_D(31 downto 26);
  funcCode <= i_D(5 downto 0);

  outputData <= 
      
      -- addi
      "1000000010" when opcode = "001000" else

      -- andi
      "1000010010" when opcode = "001100" else

      -- addiu
      "1000100010" when opcode = "001001" else

      -- beq
      "1000110000" when opcode = "000100" else

      -- bne
      "1001000000" when opcode = "000101" else

      -- lui
      "1001010010" when opcode = "001111" else

      -- lw
      "1001101010" when opcode = "100011" else

      --xori
      "1001110010" when opcode = "001110" else

      -- ori
      "1010000010" when opcode = "001101" else

      -- slti
      "1010010000" when opcode = "001010" else

      -- sw
      "1010100100" when opcode = "101011" else

      -- repl.qb
      "1010110010" when opcode = "111111" else

      -- j
      "0011000000" when opcode = "000010" else

      -- jal
      "0011010000" when opcode = "000011" else

      -- add
      "0011100011" when opcode = "000000" else

      -- addu
      "0011110011" when opcode = "000001" else

      -- and
      "1100000011" when opcode = "000011" else

      -- not
      "0100010011" when opcode = "000100" else

      -- nor
      "0100100011" when opcode = "000101" else

      -- xor
      "0100110011" when opcode = "000110" else
      
      -- or
      "0101000011" when opcode = "000111" else

      -- slt
      "0101010011" when opcode = "001000" else

      -- sll
      "0101100011" when opcode = "001001" else

      -- srl
      "0101110011" when opcode = "001010" else

      -- sra
      "0101110011" when opcode = "001011" else

      -- sub
      "0110010011" when opcode = "001100" else

      -- jr
      "0110100001" when opcode = "001101" else

      -- else
      "0000000000";
    


  o_ALUSrc     <= outputData(9);
  o_ALUControl <= outputData(8 downto 4);
  o_memToReg   <= outputData(3);
  o_memWrite   <= outputData(2);
  o_regWrite   <= outputData(1);
  o_regDst     <= outputData(0);

end dataflow;