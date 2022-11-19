-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux32_8to1
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the 32 bit
-- 8:1 mux.
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity tb_mux32_2to1 is
    generic(gCLK_HPER   : time := 50 ns);
end tb_mux32_2to1;

architecture behavior of tb_mux32_2to1 is
  
  -- Calculate the clock period as twice the half-period
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component mux32_2to1
        port(i_S        : in std_logic;
             i_A        : in std_logic_vector(31 downto 0);
             i_B        : in std_logic_vector(31 downto 0);
             o_O        : out std_logic_vector(31 downto 0));
    end component;

  -- Temporary signals to connect to the dff component.
    signal s_CLK            : std_logic := '0';
    signal s_S              : std_logic := '0';
    signal s_A              : std_logic_vector(31 downto 0) := X"00000000";
    signal s_B              : std_logic_vector(31 downto 0) := X"00000000";
    signal s_O              : std_logic_vector(31 downto 0);

begin
  DUT: mux32_2to1
  port map(i_S   => s_S,
           i_A   => s_A,
           i_B   => s_B,
           o_O   => s_O);

  -- Clock process
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
    P_Enumerate: process
    begin
        s_A          <= X"000000FF";
        s_B          <= X"ACDCACDC";
        wait for gCLK_HPER;
        s_S             <= '0';
        wait for gCLK_HPER;
        s_S             <= '1';
        wait;
    end process;
  
end behavior;