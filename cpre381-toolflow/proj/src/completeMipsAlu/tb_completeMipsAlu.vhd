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
signal count        : std_logic_vector(7 downto 0) := X"00";

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
count <= X"01";
s_ALUControl <= "00001000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
count <= X"02";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 3:
count <= X"03";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"80000000";

wait for gCLK_HPER;




-- AND 
-- Test case 1:
count <= X"04";
s_ALUControl <= "00000000000101";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;
count <= X"05";
s_portOne    <= X"F0F0F0F0";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;
count <= X"06";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;



-- ADD w/o overflow
-- Test case 1:
count <= X"07";
s_ALUControl <= "00000000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
count <= X"08";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 3:
count <= X"09";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;





-- SUB w/o overflow
-- Test case 1:
count <= X"0A";
s_ALUControl <= "00100000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
count <= X"0B";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

-- Test case 3:
count <= X"0C";
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- BNE (Sub, !zero, no overflow)
-- Test case 1:
count <= X"0D";
s_ALUControl <= "00110000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"0E";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

count <= X"0F";
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;





-- LUI (read2, shift 16 fill 0's)
-- Test case 1:
count <= X"10";
s_ALUControl <= "10000101000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"11";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

count <= X"12";
s_portOne    <= X"80000000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;







-- XOR
-- Test case 1:
s_ALUControl <= "00000000000010";
count <= X"13";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;
count <= X"14";
s_portOne    <= X"F0F0F0F0";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;
count <= X"15";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;


-- OR
-- Test case 1:
s_ALUControl <= "00000000000001";
count <= X"16";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;
count <= X"17";
s_portOne    <= X"F0F0F0F0";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;
count <= X"18";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;


-- SLT (sub -> "0...00 MSB")
-- Test case 1:
count <= X"19";
s_ALUControl <= "00101011001000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"1A";
s_portOne    <= X"0000FFFF";
s_portTwo    <= X"000FFFFF";

wait for gCLK_HPER;

count <= X"1B";
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"1C";
s_portOne    <= X"00000001";
s_portTwo    <= X"0000000F";

wait for gCLK_HPER;



-- repl.qb
-- Test case 1:
count <= X"1D";
s_ALUControl <= "00000000000110";
s_shamt      <= "00000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"1E";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"000000FF";

wait for gCLK_HPER;

count <= X"1F";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"000000F0";

wait for gCLK_HPER;





-- JAL
-- Test case 1:
count <= X"20";
s_ALUControl <= "01001000100000";
s_shamt      <= "00000";
s_portOne    <= X"10010000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

count <= X"21";
s_portOne    <= X"1001000F";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;






-- NOT
-- Test case 1:
s_ALUControl <= "00000000000100";
count <= X"22";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;
count <= X"23";
s_portOne    <= X"F0F0F0F0";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;
count <= X"24";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;

-- NOR
-- Test case 1:
s_ALUControl <= "00000000000011";
count <= X"25";
s_portOne    <= X"FFFF0000";
s_portTwo    <= X"0000FFFF";

wait for gCLK_HPER;
count <= X"26";
s_portOne    <= X"F0F0F0F0";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;
count <= X"27";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"0F0F0F0F";

wait for gCLK_HPER;


-- Barrel SLL
-- Test case 1:
count <= X"28";
s_ALUControl <= "10000001000000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

count <= X"29";
s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

count <= X"2A";
s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- Barrel SRL
-- Test case 1:
count <= X"2B";
s_ALUControl <= "10000001001000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

count <= X"2C";
s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

count <= X"2D";
s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

count <= X"2E";
s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;





-- Barrel SRA
-- Test case 1:
count <= X"2F";
s_ALUControl <= "10000001011000";
s_shamt      <= "01000";
s_portOne    <= X"00000000";
s_portTwo    <= X"FFFFFFFF";

wait for gCLK_HPER;

count <= X"30";
s_shamt      <= "01000";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

count <= X"31";
s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"80000001";

wait for gCLK_HPER;

count <= X"32";
s_shamt      <= "00001";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;






-- SUB w/ Overflow
-- Test case 1:
count <= X"33";
s_ALUControl <= "00101000000000";
s_shamt      <= "00000";
s_portOne    <= X"00000001";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;

-- Test case 2:
count <= X"34";
s_portOne    <= X"FFFFFFFF";
s_portTwo    <= X"FFFF0000";

wait for gCLK_HPER;

-- Test case 3:
count <= X"35";
s_portOne    <= X"80000000";
s_portTwo    <= X"00000001";

wait for gCLK_HPER;



end process;
end mixed;