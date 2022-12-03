library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity cascade_or is

    port(i_S        : in std_logic_vector(31 downto 0);
         o_O        : out std_logic);

end cascade_or;

architecture structural of cascade_or is

    component org2 is
        port(i_A            : in std_logic;
             i_B            : in std_logic;
             o_F            : out std_logic);
    end component;

    signal s_c          : std_logic_vector(31 downto 0);

begin

    G_org31: org2
    port map(i_A            => i_S(31),
             i_B            => '0',
             o_F            => s_c(31));

    G_cascade: for i in 0 to 30 generate
        G_org: org2
            port map(i_A            => i_S(30-i),
                     i_B            => s_c(31-i),
                     o_F            => s_c(30-i));
    end generate G_cascade;

    o_O <= s_c(0);

end structural;