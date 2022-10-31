library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_controlLogic is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_controlLogic;

architecture mixed of tb_controlLogic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component controlLogic is
port( i_D          : in std_logic_vector(27 downto 0);
      i_ALUSrc     : out std_logic;
      i_ALUControl : out std_logic_vector(3 downto 0);
      i_memToReg   : out std_logic;
      i_memWrite   : out std_logic;
      i_regWrite   : out std_logic;
      i_regDst     : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_D           : std_logic_vector(31 downto 0) := X"00000000";
signal s_ALUSrc      : std_logic := '0';
signal s_ALUControl  : std_logic_vector(3 downto 0) := "0000";
signal s_memToReg    : std_logic := '0';
signal s_memWrite    : std_logic := '0';
signal s_regWrite    : std_logic := '0';
signal s_regDst      : std_logic := '0';


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: controlLogic
  port map(i_D          => s_D,
           i_ALUSrc     => s_ALUSrc,
           i_ALUControl => s_ALUControl,
           i_memToReg   => s_memToReg,
           i_memWrite   => s_memWrite,
           i_regWrite   => s_regWrite,
           i_regDst     => s_regDst);
            
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    
    

    
    wait for cCLK_PER;
  end process;
end mixed;