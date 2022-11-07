library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity replQb is
  port(i_D : in  std_logic_vector(7 downto 0);
       o_O : out std_logic_vector(31 downto 0));
end replQb;

architecture dataflow of replQb is
  begin
    o_O <= i_D & i_D & i_D & i_D;
end dataflow;