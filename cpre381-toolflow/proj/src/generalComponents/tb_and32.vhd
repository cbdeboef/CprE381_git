library IEEE;
library std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_and32 is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_and32;

architecture mixed of tb_and32 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component and32 is
    port(i_A          : in std_logic_vector(31 downto 0);
         i_B          : in std_logic_vector(31 downto 0);
         o_F          : out std_logic_vector(31 downto 0));
end component;

-- Signals
signal CLK    : std_logic := '0';
signal s_iA   : std_logic_vector(31 downto 0) := X"00000000";
signal s_iB   : std_logic_vector(31 downto 0) := X"00000000";
signal s_O    : std_logic_vector(31 downto 0);

begin
  DUT0: and32
  port map(i_A      => s_iA,
           i_B      => s_iB,
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
        s_iA        <= X"00000000";
        s_iB        <= X"00000000";
        wait for gCLK_HPER;
        s_iA        <= X"80808080";
        s_iB        <= X"FFFFFFFF";
        wait for gCLK_HPER;
        s_iA        <= X"FFFFFFFF";
        s_iB        <= X"00000000";
        wait for gCLK_HPER;
    end process;

end mixed;