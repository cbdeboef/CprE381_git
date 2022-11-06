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
      when "101011" =>
        outputData <= "1010100100";

      -- repl.qb
      when "111111" =>
        outputData <= "1010110010";

      -- j
      when "000010" =>
        outputData <= "0011000000";

      -- jal
      when "000011" =>
        outputData <= "0011010000";
      
      when others =>
        outputData <= "0000000000";

    end case;
  end process;

  p_OPCODE : process
    begin

    if (i_D(31 downto 26) = "000000") then
      
      case funcCode is

        -- add
        when "000000" =>
          outputData <= "0011100011";

        -- addu
        when "000001" =>
          outputData <= "0011110011";

        -- and
        when "000011" =>
          outputData <= "1100000011";

        -- not
        when "000100" =>
          outputData <= "0100010011";

        -- nor
        when "000101" =>
          outputData <= "0100100011";

        -- xor
        when "000110" =>
          outputData <= "0100110011";
        
        -- or
        when "000111" =>
          outputData <= "0101000011";

        -- slt
        when "001000" =>
          outputData <= "0101010011";

        -- sll
        when "001001" =>
          outputData <= "0101100011";

        -- srl
        when "001010" =>
          outputData <= "0101110011";

        -- sra
        when "001011" =>
          outputData <= "0101110011";

        -- sub
        when "001100" =>
          outputData <= "0110010011";

        -- jr
        when "001101" =>
          outputData <= "0110100001";

        when others =>
          outputData <= "0000000000";
      
      end case;
    end if;
  end process;

  o_ALUSrc     <= outputData(9);
  o_ALUControl <= outputData(8 downto 4);
  o_memToReg   <= outputData(3);
  o_memWrite   <= outputData(2);
  o_regWrite   <= outputData(1);
  o_regDst     <= outputData(0);

end dataflow;