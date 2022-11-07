library IEEE;
use IEEE.std_logic_1164.all;

entity completeMipsAlu is
    port(i_ALUControl     : in   std_logic_vector(4 downto 0);
         i_portOne        : in  std_logic_vector(31 downto 0);
         i_portTwo        : in  std_logic_vector(31 downto 0);
         i_shamt          : 
         o_ALUOut         : out std_logic_vector(31 downto 0);
         o_zero           : out std_logic;
         o_overflow       : out std_logic);

component AdderSubtractor is
    generic(N : integer := 32);
        port(i_A          : in std_logic_vector(31 downto 0);
             i_B          : in std_logic_vector(31 downto 0);
             i_nAddSub    : in std_logic;
             o_C          : out std_logic;
             o_CMinusOne  : out std_logic;
             o_O          : out std_logic_vector(31 downto 0));
end component;

component shifter is
    port(i_signed, i_dir  : in std_logic;
       i_D              : in std_logic_vector(7 downto 0);
       i_shamt          : in std_logic_vector(2 downto 0);
       o_O              : out std_logic_vector(7 downto 0));
end component;

begin
    g_AdderSubtractor : AdderSubtractor
        port map(i_A         =>
                 i_B         =>
                 i_nAddSub   =>
                 o_C         =>
                 o_CMinusOne =>
                 o_O         => );

    g_shifter : shifter
        port map(i_signed 
                 i_dir    
                 i_shamt  
                 o_O      );


