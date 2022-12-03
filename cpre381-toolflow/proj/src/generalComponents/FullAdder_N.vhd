library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       i_C         : in std_logic;
       o_C         : out std_logic;
       o_CMinusOne : out std_logic;
       o_O         : out std_logic_vector(N-1 downto 0));

end FullAdder_N;

architecture structural of FullAdder_N is

  component FullAdder is
    port(i_A                 : in std_logic;
         i_B                 : in std_logic;
         i_C                 : in std_logic;
         o_C                 : out std_logic;
         o_O                 : out std_logic);
  end component;

  signal carry: std_logic_vector(N downto 0);

begin
  
  carry(0) <= i_C;
  -- Instantiate N mux instances.
  G_NBit_FullAdder: for i in 0 to N-1 generate
    MUXI: FullAdder port map(
              i_A     => i_A(i),      -- All instances share the same select input.
              i_B     => i_B(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_C     => carry(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_C     => carry(i+1),
              o_O     => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_FullAdder;
  o_C <= carry(N);
  o_CMinusOne <= carry(N-1);
end structural;
