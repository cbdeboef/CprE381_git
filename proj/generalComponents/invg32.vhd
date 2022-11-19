library IEEE;
use IEEE.std_logic_1164.all;

entity invg32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end invg32;

architecture structural of invg32 is
  component invg is
    port(i_A                  : in std_logic;
         o_F                  : out std_logic);
  end component;

begin
  -- Instantiate N invg instances.
  G_NBit: for i in 0 to 31 generate
    Gen: invg 
        port map(i_A      => i_A(i),  
                 o_F      => o_F(i));
  end generate G_NBit;
  
end structural;
