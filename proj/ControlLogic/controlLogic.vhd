ibrary IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity controlLogic is

-- i_dir = 0 -> shift left; i_dir = 1 -> shift right
-- i_signed = 0 -> unsigned; i_singed = 1 -> signed shift
-- shamt: Ammount to shift by. Defined by shamt in R type instructions


  port(i_D : in std_logic_vector(31 downto 0);
       ALSSrc     : out std_logic;
       ALUControl : out std_logic_vector(3 downto 0);
       memToReg   : out std_logic;
       memWrite   : out std_logic;
       regWrite   : out std_logic;
       regDst     : out std_logic);

end controlLogic;

architecture dataflow of controlLogic is

begin



end controlLogic;