library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_shifter is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_shifter;

architecture mixed of tb_shifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component shifter is
  port(i_signed, i_dir            : in std_logic;
       i_D	    	                : in std_logic_vector(7 downto 0);
       i_shamt                    : in std_logic_vector(2 downto 0);
       o_O                        : out std_logic_vector(7 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_signed : std_logic := '0';
signal s_dir    : std_logic := '0';
signal s_D      : std_logic_vector(7 downto 0) := X"00";
signal s_shamt  : std_logic_vector(2 downto 0) := "000";
signal s_o      : std_logic_vector(7 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: shifter
  port map(
            i_signed => s_signed,
            i_dir    => s_dir,
            i_D      => s_D,
            i_shamt  => s_shamt,
            o_O      => s_O);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1: Shift to Left
    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "000";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '1';
    s_shamt <= "001";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "010";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "011";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "100";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "101";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "110";
    wait for gCLK_HPER;    

    s_D <= X"81";
    s_dir <= '0';
    --s_signed <= '0';
    s_shamt <= "111";
    wait for gCLK_HPER;

    -- Test case 2: Shift to Right
    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "000";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '1';
    s_shamt <= "001";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "010";
    wait for gCLK_HPER;

    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "011";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "100";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "101";
    wait for gCLK_HPER;
    
    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "110";
    wait for gCLK_HPER;    

    s_D <= X"81";
    s_dir <= '1';
    --s_signed <= '0';
    s_shamt <= "111";
    wait for gCLK_HPER;    
 
  end process;
end mixed;