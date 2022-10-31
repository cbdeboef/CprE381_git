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

architecture structural of shifter is

    component mux2to1 is
        port(i_D0,i_D1,i_S : in std_logic;
                 o_O : out std_logic);
    end mux2t1_DF;

begin

    

end structural;