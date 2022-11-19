-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_invg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench of an N-bit wide inverter
--              using structural architecture.
--
--
-- NOTES:
-- 8/31/22: Created
-------------------------------------------------------------------------

library IEEE;
library std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_invg32 is
  generic(gCLK_HPER   : time := 10 ns);
end tb_invg32;

architecture mixed of tb_invg32 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Define the ports for the mux2t1_dataflow component
component invg32 is
    port(i_A              : in std_logic_vector(31 downto 0);
         o_F              : out std_logic_vector(31 downto 0));
end component;

-- Signals
signal CLK    : std_logic := '0';
signal s_iA   : std_logic_vector(31 downto 0) := x"00000000";
signal s_O    : std_logic_vector(31 downto 0);

begin
  DUT0: invg32
  port map(i_A      => s_iA,
           o_F      => s_O);

  --This first process is to setup the clock for the test bench
    P_CLK: process
    begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

    -- Enumerate through the test cases
    P_TEST_CASE: process
    begin
        s_iA        <= x"00000000";
        wait for gCLK_HPER*2;
        s_iA        <= x"FFFFFFFF";
        wait for gCLK_HPER*2;
        s_iA        <= x"50505050";
        wait for gCLK_HPER*2;
    end process;

end mixed;