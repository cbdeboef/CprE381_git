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
port( i_D          : in std_logic_vector(31 downto 0);
      o_ALUSrc     : out std_logic;
      o_ALUControl : out std_logic_vector(4 downto 0);
      o_memToReg   : out std_logic;
      o_memWrite   : out std_logic;
      o_regWrite   : out std_logic;
      o_regDst     : out std_logic;
      o_jump       : out std_logic;
      o_branch     : out std_logic;
      o_memRead    : out std_logic;
      o_jal        : out std_logic;
      o_jreg       : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_D           : std_logic_vector(31 downto 0) := X"00000000";
signal s_ALUSrc      : std_logic := '0';
signal s_ALUControl  : std_logic_vector(4 downto 0) := "00000";
signal s_memToReg    : std_logic := '0';
signal s_memWrite    : std_logic := '0';
signal s_regWrite    : std_logic := '0';
signal s_regDst      : std_logic := '0';
signal s_jump        : std_logic := '0';
signal s_branch      : std_logic := '0';
signal s_memRead     : std_logic := '0';
signal s_jal         : std_logic := '0';
signal s_jreg        : std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: controlLogic
  port map(i_D          => s_D,
           o_ALUSrc     => s_ALUSrc,
           o_ALUControl => s_ALUControl,
           o_memToReg   => s_memToReg,
           o_memWrite   => s_memWrite,
           o_regWrite   => s_regWrite,
           o_regDst     => s_regDst,
           o_jump       => s_jump,
           o_branch     => s_branch,
           o_memRead    => s_memRead,
           o_jal        => s_jal,
           o_jreg       => s_jreg);
            
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_D <= "00100000000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 2:
    s_D <= "00110000000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 3:
    s_D <= "00100100000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 4:
    s_D <= "00010000000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 5:
    s_D <= "00010100000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 6:
    s_D <= "00111100000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 7:
    s_D <= "10001100000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 8:
    s_D <= "00111000000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 9:
    s_D <= "00110100000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 10:
    s_D <= "00101000000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 11:
    s_D <= "10101100000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 12:
    s_D <= "11111100000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 13:
    s_D <= "00001000000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 14:
    s_D <= "00001100000000000000000000000000";

    wait for gCLK_HPER;

    -- Test case 15:
    s_D <= "00000000000000000000000000000000";
    
    wait for gCLK_HPER;

    -- Test case 16:
    s_D <= "00000000000000000000000000000001";

    wait for gCLK_HPER;

    -- Test case 17:
    s_D <= "00000000000000000000000000000010";
    
    wait for gCLK_HPER;

    -- Test case 18:
    s_D <= "00000000000000000000000000000011";

    wait for gCLK_HPER;

    -- Test case 19:
    s_D <= "00000000000000000000000000000100";
    
    wait for gCLK_HPER;

    -- Test case 20:
    s_D <= "00000000000000000000000000000101";

    wait for gCLK_HPER;

    -- Test case 21:
    s_D <= "00000000000000000000000000000110";
    
    wait for gCLK_HPER;

    -- Test case 22:
    s_D <= "00000000000000000000000000000111";

    wait for gCLK_HPER;

    -- Test case 23:
    s_D <= "00000000000000000000000000001000";
    
    wait for gCLK_HPER;

    -- Test case 24:
    s_D <= "00000000000000000000000000001001";

    wait for gCLK_HPER;

    -- Test case 25:
    s_D <= "00000000000000000000000000001010";

    wait for gCLK_HPER;

    -- Test case 26:
    s_D <= "00000000000000000000000000001011";
    
    wait for gCLK_HPER;

    -- Test case 27:
    s_D <= "00000000000000000000000000001100";

    wait for gCLK_HPER;

    -- Test case 28:
    s_D <= "00000000000000000000000000001101";
    
    wait for cCLK_PER;
  end process;
end mixed;