library IEEE;
use IEEE.std_logic_1164.all;

entity and32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end and32;

architecture structural of and32 is
  component andg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

begin
  G_NBit_and2: for i in 0 to 31 generate
    andI: andg2 
        port map(i_A      => i_A(i),
                 i_B      => i_B(i),
                 o_F      => o_F(i));
  end generate G_NBit_and2;
  
end structural;
