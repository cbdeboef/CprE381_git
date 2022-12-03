library IEEE;
use IEEE.std_logic_1164.all;

entity AdderSubtractor is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_A          : in std_logic_vector(N-1 downto 0);
             i_B          : in std_logic_vector(N-1 downto 0);
             i_nAddSub    : in std_logic;
             o_C          : out std_logic;
             o_CMinusOne  : out std_logic;
             o_O          : out std_logic_vector(N-1 downto 0));

end AdderSubtractor;

architecture structural of AdderSubtractor is

    component FullAdder_N is
        port(i_A          : in std_logic_vector(N-1 downto 0);
             i_B          : in std_logic_vector(N-1 downto 0);
             i_C          : in std_logic;
             o_C          : out std_logic;
             o_CMinusOne  : out std_logic;
             o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component mux32_2to1 is
        port(i_S          : in std_logic;
             i_A         : in std_logic_vector(N-1 downto 0);
             i_B         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component onesComp is
        port(i_A          : in std_logic_vector(N-1 downto 0);
             o_F          : out std_logic_vector(N-1 downto 0));
    end component;

    signal s_BInv         : std_logic_vector(N-1 downto 0);
    signal s_muxOut       : std_logic_vector(N-1 downto 0);

begin
  
    g_instOne : onesComp
        port map(i_A  => i_B,
                 o_F  => s_BInv);
    
    g_instTwo : mux32_2to1
        port map(i_S  => i_nAddSub,
                 i_A => i_B,
                 i_B => s_BInv,
                 o_O  => s_muxOut);
    
    g_instThree : FullAdder_N
        port map(i_A  => i_A,
                 i_B  => s_muxOut,
                 i_C  => i_nAddSub,
                 o_CMinusOne => o_CMinusOne,
                 o_C  => o_C,
                 o_O  => o_O);

end structural;