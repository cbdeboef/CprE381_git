library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_AdderSubtractor is
  generic(gCLK_HPER   : time := 10 ns;
          N : integer := 32);   -- Generic for half of the clock cycle period
end tb_AdderSubtractor;

architecture mixed of tb_AdderSubtractor is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component AdderSubtractor is
  port(i_A                          : in std_logic_vector(N-1 downto 0);
       i_B		                      : in std_logic_vector(N-1 downto 0);
       i_nAddSub                    : in std_logic;
       o_C                          : out std_logic;
       o_O                          : out std_logic_vector);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_A       : std_logic_vector(N-1 downto 0) := X"00000000";
signal s_B       : std_logic_vector(N-1 downto 0) := X"00000000";
signal s_nAddSub : std_logic := '0';
signal s_Cout    : std_logic;
signal s_O       : std_logic_vector(N-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: AdderSubtractor
  port map(
            i_A       => s_A,
            i_B       => s_B,
            i_nAddSub => s_nAddSub,
            o_C       => s_Cout,
            o_O       => s_O);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

-- Test case 1:
-- A = 0, B = 0, C = 0
s_A       <= X"00000000";
s_B       <= X"00000000";
s_nAddSub <= '0';
wait for gCLK_HPER;
-- Expect o_O = 0
-- Expect o_C = 0


-- Test case 2:
-- A = 0x11111111, B = 0x11110000, nAddSub = 1
s_A       <= X"11111111";
s_B       <= X"11110000";
s_nAddSub <= '1';
wait for gCLK_HPER;
-- Expect o_O = 0x00001111 
-- Expect o_C = 1


-- Test case 3:
-- A = 0xFFFFFFFF, B = FFFFFFFF, nAddSub = 0
s_A       <= X"FFFFFFFF";
s_B       <= X"FFFFFFFF";
s_nAddSub <= '0';
wait for gCLK_HPER;
-- Expect o_O = 0xFFFFFFFE
-- Expect o_C = 1


-- Test case 4:
-- A = 0xFFFFFFFF, B = FFFFFFFF, nAddSub = 1
s_A       <= X"FFFFFFFF";
s_B       <= X"FFFFFFFF";
s_nAddSub <= '1';
wait for gCLK_HPER;
-- Expect o_O = 0x00000000
-- Expect o_C = 1


-- Test case 5:
-- A = 00002001, B = 00000721, nAddSub = 0
s_A       <= X"00002001";
s_B       <= X"00000721";
s_nAddSub <= '0';
wait for gCLK_HPER;
-- Expect o_O = 00002722
-- Expect o_C = 0


-- Test case 6:
-- A = 00002001, B = 00000721, nAddSub = 1
s_A       <= X"00002001";
s_B       <= X"00000721";
s_nAddSub <= '1';
wait for gCLK_HPER;
-- Expect o_O = 000018E0
-- Expect o_C = 1

-- Test case 7:
-- A = 0x12352164, B = 0x63367042, nAddSub = 1
s_A       <= X"12352164";
s_B       <= X"63367042";
s_nAddSub <= '1';
wait for gCLK_HPER;
-- Expect o_O = AEFEB122
-- Expect o_C = 0

end process;
end mixed;