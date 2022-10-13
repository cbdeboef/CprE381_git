library IEEE;
use IEEE.std_logic_1164.all;


entity shifter is

-- i_dir = 0 -> shift left; i_dir = 1 -> shift right
-- i_signed = 0 -> unsigned; i_singed = 1 -> signed shift
-- shamt: Ammount to shift by. Defined by shamt in R type instructions


  port(i_signed,i_dir : in std_logic;
       i_D            : in std_logic_vector(31 downto 0);
       i_shamt        : in std_logic_vector(4 downto 0);
       o_O            : out std_logic_vector(31 downto 0));
end shifter;

architecture dataflow of shifter is

signal s_signedFlag : std_logic := 0;

begin

    -- Shift Left
    o_O <= i_D;
    if i_dir = '0'
        for i in (31 - i_shamt downto 0) loop
            o_O(i + i_shamt) <= i_D(i);
            o_O(i) <= 0;
        end loop
    end if
    
    -- Shift Right
    o_O <= i_D;
    if i_dir = '1'

    -- Loop through elements and set o_O term
        for i in (31 - i_shamt downto 0) loop
            o_O(i) <= i_D(i + i_shamt);

    -- Check if need to sign extend. If yes, set terms to 1. If not, set to 0
    -- Only sets terms o_O(31) to o_O(31 - shamt). All else left alone        
            if (i_D(31) = 1) & (i_signed = 1) & (i + i_shamt > 31 - shamt)
                o_O(i + i_shamt) <= 1;
            elsif ((i_D(31) = 0) | (i_signed = 0)) & (i + i_shamt > 31 - shamt)
                o_O(i + i_shamt) <= 0;
            end if

        end loop
    end if

end dataflow;