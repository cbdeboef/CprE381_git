-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32_2to1
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 2:1 
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

entity mux32_2to1 is

    port(i_S        : in std_logic;
         i_A        : in std_logic_vector(31 downto 0);
         i_B        : in std_logic_vector(31 downto 0);
         o_O        : out std_logic_vector(31 downto 0));

end mux32_2to1;

architecture dataflow of mux32_2to1 is

begin
    o_O <= i_A when (i_S = '0') else
           i_B when (i_S = '1') else
           X"00000000";

end dataflow;