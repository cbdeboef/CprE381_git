library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_fetchLogic is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_fetchLogic;

architecture mixed of tb_fetchLogic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component fetchLogic is
  port(i_pcCurrent      : in  std_logic_vector(31 downto 0);
       i_jumpImm   : in  std_logic_vector(25 downto 0);
       i_branchImm : in std_logic_vector(31 downto 0);
       i_jumpSel   : in  std_logic;
       i_branch    : in  std_logic;
       i_ALUZero   : in  std_logic;
       o_pcUpdated     : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_pcCurrent      : std_logic_vector(31 downto 0) := X"00000000";
signal s_jumpImm   : std_logic_vector(25 downto 0) := "00000000000000000000000000";
signal s_branchImm : std_logic_vector(31 downto 0) := X"00000000"; 
signal s_jumpSel   : std_logic := '0';
signal s_branch    : std_logic := '0';
signal s_ALUZero   : std_logic := '0';
signal s_pcUpdated     : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: fetchLogic
  port map(
            i_pcCurrent => s_pcCurrent,
            i_jumpImm   => s_jumpImm,
            i_branchImm => s_branchImm,
            i_jumpSel   => s_jumpSel,
            i_branch    => s_branch,
            i_ALUZero   => s_ALUZero,
            o_pcUpdated => s_pcUpdated);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    s_pcCurrent      <= X"10010000";
    s_jumpImm   <= "11111100000000000000111111";
    s_branchImm <= X"00004321";

    -- Test case 1:
    s_jumpSel   <= '0';
    s_branch    <= '0';
    s_ALUZero   <= '0';
    wait for gCLK_HPER;

    -- Test case 2: 
    s_jumpSel   <= '1';
    s_branch    <= '1';
    s_ALUZero   <= '1';
    wait for gCLK_HPER;

    -- Test case 3: 
    s_jumpSel   <= '0';
    s_branch    <= '1';
    s_ALUZero   <= '1';
    wait for gCLK_HPER;

    -- Test case 4: 
    s_jumpSel   <= '0';
    s_branch    <= '0';
    s_ALUZero   <= '1';
    wait for gCLK_HPER;

    -- Test case 5: 
    s_jumpSel   <= '0';
    s_branch    <= '1';
    s_ALUZero   <= '0';
    wait for gCLK_HPER;

    wait for cCLK_PER;
  end process;
end mixed;