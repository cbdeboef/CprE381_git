library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_completeMipsAlu is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_completeMipsAlu;

architecture mixed of tb_completeMipsAlu is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component completeMipsAlu is
port(i_ALUControl     : in  std_logic_vector(13 downto 0);
     i_portOne        : in  std_logic_vector(31 downto 0);
     i_portTwo        : in  std_logic_vector(31 downto 0);
     i_shamt          : in  std_logic_vector(4 downto 0);
     o_ALUOut         : out std_logic_vector(31 downto 0);
     o_zero           : out std_logic;
     o_overflow       : out std_logic);
end component;

signal CLK, reset : std_logic := '0';

signal s_ALUControl : std_logic_vector(13 downto 0) := "00000000000000";
signal s_portOne    : std_logic_vector(31 downto 0) := X"00000000";
signal s_portTwo    : std_logic_vector(31 downto 0) := X"00000000";
signal s_shamt      : std_logic_vector(4 downto 0)  := "00000";
signal s_ALUOut     : std_logic_vector(31 downto 0) := X"00000000";
signal s_zero       : std_logic := '0';
signal s_overflow   : std_logic := '0';

begin

    DUT0: completeMipsAlu
    port map(i_ALUControl => s_ALUControl,
             i_portOne    => s_portOne,
             i_portTwo    => s_portTwo,
             i_shamt      => s_shamt,
             o_ALUOut     => s_ALUOut,       
             o_zero       => s_zero,
             o_overflow   => s_overflow);

P_TEST_CASES: process
begin
wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

-- ADD w/ overflow 
-- Test case 1:
s_ALUControl <= "00001000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 3:
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;




-- AND 
-- Test case 1:
s_ALUControl <= "00000000000101";





-- ADD w/o overflow
-- Test case 1:
s_ALUControl <= "00001000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 3:
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;





-- SUB w/o overflow
-- Test case 1:
s_ALUControl <= "00100000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

-- Test case 3:
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- BNE (Sub, !zero, no overflow)
-- Test case 1:
s_ALUControl <= "00110000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";





-- LUI (read2, shift 16 fill 0's)
-- Test case 1:
s_ALUControl <= "10000101000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

s_portOne    <= X"80000000";
s_portTwo    <= X"0000FFFF";







-- XOR
-- Test case 1:
s_ALUControl <= "00000000000010";



-- OR
-- Test case 1:
s_ALUControl <= "00000000000001";



-- SLT (sub -> "0...00 MSB")
-- Test case 1:
s_ALUControl <= "00101011000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_portOne    <= X"0000FFFF";
s_portTwo    <= X"000FFFFF";

wait for gCLK_HPER;

s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_portOne    <= X"00000001";
s_portTwo    <= X"0000000F";

wait for gCLK_HPER;



-- repl.qb
-- Test case 1:
s_ALUControl <= "00000000000110";
s_shamt      <= "00000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"000000FF";

wait for gCLK_HPER;

s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"000000F0";

wait for gCLK_HPER;





-- JAL
-- Test case 1:
s_ALUControl <= "01001000100000";
s_shamt      <= "00000";
s_portOne    <= X"10010000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

s_portOne    <= X"1001000F";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;






-- NOT
-- Test case 1:
s_ALUControl <= "00000000000100";


-- NOR
-- Test case 1:
s_ALUControl <= "00000000000011";



-- Barrel SLL
-- Test case 1:
s_ALUControl <= "10000001000000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- Barrel SRL
-- Test case 1:
s_ALUControl <= "10000001001000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;





-- Barrel SRA
-- Test case 1:
s_ALUControl <= "10000001011000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- SUB w/ Overflow
-- Test case 1:
s_ALUControl <= "00101000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

-- Test case 3:
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;



end process;
end mixed;