library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity shifter is

-- i_dir = 0 -> shift left; i_dir = 1 -> shift right
-- i_signed = 0 -> unsigned; i_singed = 1 -> signed shift
-- shamt: Ammount to shift by. Defined by shamt in R type instructions


  port(i_signed, i_dir : in std_logic;
       i_D            : in std_logic_vector(31 downto 0);
       i_shamt        : in std_logic_vector(4 downto 0);
       o_O            : out std_logic_vector(31 downto 0));
end shifter;

architecture dataflow of shifter is

    signal shift_concat : std_logic_vector(31 downto 0) := (others => '0');
    signal shift_concat_ones : std_logic_vector(31 downto 0) := (others => '1');
    signal output_buffer : std_logic_vector(31 downto 0) := (others => '0');

begin
     -- Shift Left
    o_O <= i_D(31-to_integer(unsigned(i_shamt)) downto 0) & shift_concat(to_integer(unsigned(i_shamt))-1 downto 0) when (i_dir = '0') else
    
     -- Shift Right unsigned
           shift_concat(to_integer(unsigned(i_shamt))-1 downto 0) & i_D(31 downto to_integer(unsigned(i_shamt))) when i_dir = '1' and (i_signed = '0' or i_D(31) = '0') else

     -- Shift Right Signed
           shift_concat_ones(to_integer(unsigned(i_shamt))-1 downto 0) & i_D(31 downto to_integer(unsigned(i_shamt))) when i_dir = '1' and i_signed = '1' and i_D(31) = '1' else

           X"00000000";

end dataflow;