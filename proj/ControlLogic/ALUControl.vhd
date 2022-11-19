library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUControl is
  port(i_ALUControl : in  std_logic_vector(5 downto 0);
       o_O : out std_logic_vector(13 downto 0));
end ALUControl;

architecture dataflow of ALUControl is
  begin
    o_O <= 
            -- add w/ overflow
            "00001000000000" when i_D = "00000" else

            -- and
            "00000000000101" when i_D = "00001" else

            -- add w/o overflow
            "00000000000000" when i_D = "00010" else

            -- sub w/o overflow
            "00100000000000" when i_D = "00011" else

            -- sub w/o overflow, !zero
            "00110000000000" when i_D = "00100" else

            -- lui (shift portTwo by 16)
            "10000101000000" when i_D = "00101" else

            -- xor
            "00000000000010" when i_D = "00110" else

            -- or
            "00000000000001" when i_D = "00111" else

            -- slti/slt (sub, shift right 31)
            "00101011000000" when i_D = "01000" else

            -- repl.qb
            "00000000000110" when i_D = "01001" else

            -- jal
            "01001000100000" when i_D = "01010" else

            -- not
            "00000000000100" when i_D = "01011" else

            -- nor
            "00000000000011" when i_D = "01100" else

            -- sll
            "10000001000000" when i_D = "01101" else

            -- srl
            "10000001001000" when i_D = "01110" else

            -- sra
            "10000001011000" when i_D = "01111" else

            -- sub w/ overflow
            "00101000000000" when i_D = "10000";
end dataflow;