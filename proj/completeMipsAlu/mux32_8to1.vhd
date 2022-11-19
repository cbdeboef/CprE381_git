-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32_8to1
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 8:1 
-- mux.
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity mux32_8to1 is

    port(i_S        : in std_logic_vector(2 downto 0);
         i_D        : in std_logic_aoa(7 downto 0)(31 downto 0);
         o_O        : out std_logic_vector(31 downto 0));

end mux32_8to1;

architecture dataflow of mux32_8to1 is
    signal s_iS : natural;

begin
    s_iS    <= to_integer(unsigned(i_S));
    o_O     <= i_D(s_iS);

end dataflow;