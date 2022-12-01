library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity completeMipsAlu is
    generic(N : integer := 32);
    port(i_ALUControl     : in  std_logic_vector(13 downto 0);
         i_portOne        : in  std_logic_vector(31 downto 0);
         i_portTwo        : in  std_logic_vector(31 downto 0);
         i_shamt          : in  std_logic_vector(4 downto 0);
         o_ALUOut         : out std_logic_vector(31 downto 0);
         o_zero           : out std_logic;
         o_overflow       : out std_logic);
end completeMipsAlu;

architecture structural of completeMipsAlu is

    component or32 is
        port(i_A          : in std_logic_vector(31 downto 0);
             i_B          : in std_logic_vector(31 downto 0);
             o_F          : out std_logic_vector(31 downto 0));     
    end component;

    component xor32 is
        port(i_A          : in std_logic_vector(31 downto 0);
             i_B          : in std_logic_vector(31 downto 0);
             o_F          : out std_logic_vector(31 downto 0));     
    end component;

    component xorg2 is
        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
    end component;

    component invg32 is
        port(i_A          : in std_logic_vector(31 downto 0);
             o_F          : out std_logic_vector(31 downto 0));     
    end component;

    component invg is
        port(i_A          : in std_logic;
             o_F          : out std_logic);
    end component;

    component and32 is
        port(i_A          : in std_logic_vector(31 downto 0);
             i_B          : in std_logic_vector(31 downto 0);
             o_F          : out std_logic_vector(31 downto 0));     
    end component;

    component andg2 is
        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
    end component;

    component mux32_8to1 is
        port(i_S        : in std_logic_vector(2 downto 0);
             i_D        : in std_logic_aoa(7 downto 0)(31 downto 0);
             o_O        : out std_logic_vector(31 downto 0));
    end component;

    component mux32_2to1 is
        port(i_S        : in std_logic;
             i_A        : in std_logic_vector(31 downto 0);
             i_B        : in std_logic_vector(31 downto 0);
             o_O        : out std_logic_vector(31 downto 0));
    end component;

    component mux5_2to1 is
        port(i_S        : in std_logic;
             i_A        : in std_logic_vector(4 downto 0);
             i_B        : in std_logic_vector(4 downto 0);
             o_O        : out std_logic_vector(4 downto 0));
    end component;    

    component mux2t1_dataflow is
        port(i_S              : in std_logic;
             i_D0             : in std_logic;
             i_D1             : in std_logic;
             o_O              : out std_logic);
    end component;

    component replQb is
        port(i_D : in  std_logic_vector(7 downto 0);
             o_O : out std_logic_vector(31 downto 0));
    end component;

    component cascade_or is
        port(i_S        : in std_logic_vector(31 downto 0);
             o_O        : out std_logic);
    end component;

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
             i_D              : in std_logic_vector(31 downto 0);
             i_shamt          : in std_logic_vector(4 downto 0);
             o_O              : out std_logic_vector(31 downto 0));
    end component;

    -- Signals
    -- Mux
    signal s_cMuxZero       : std_logic_vector(31 downto 0);
    signal s_cMuxJal        : std_logic_vector(31 downto 0);
    signal s_cMuxLui        : std_logic_vector(4 downto 0);
    signal s_cMuxSlt        : std_logic_vector(4 downto 0);
    signal s_cOut           : std_logic_aoa(7 downto 0)(31 downto 0);

    -- Adder/Sub
    signal s_adderC                 : std_logic;
    signal s_adderCMinusOne         : std_logic;
    signal s_adderOut               : std_logic_vector(31 downto 0);

    -- Cascade OR
    signal s_cascade                : std_logic;
    signal s_cascadeNOT             : std_logic;

    -- Overflow
    signal s_overflow               : std_logic;

    -- Shifter
    signal s_shifterOut             : std_logic_vector(31 downto 0);

begin

    -- All the 32 bit 2:1 mux, named with the control bit
    G_cMuxZero: mux32_2to1
    port map(i_S        => i_ALUControl(13),
             i_A        => i_portOne,
             i_B        => X"00000000",
             o_O        => s_cMuxZero);

    G_cMuxJal: mux32_2to1
    port map(i_S        => i_ALUControl(12),
             i_A        => i_portTwo,
             i_B        => X"00000008",
             o_O        => s_cMuxJal);             

    G_cBne: mux2t1_dataflow
    port map(i_S        => i_ALUControl(10),
             i_D0       => s_cascadeNOT,
             i_D1       => s_cascade,
             o_O        => o_zero);       
             
    G_cShiftEn: mux32_2to1
    port map(i_S        => i_ALUControl(6),
             i_A        => s_adderOut,
             i_B        => s_shifterOut,
             o_O        => s_cOut(0));     
             
    G_cMuxLui: mux5_2to1
    port map(i_S        => i_ALUControl(8),
             i_A        => i_shamt,
             i_B        => "10000",
             o_O        => s_cMuxLui);       
             
    G_cMuxSlt: mux5_2to1
    port map(i_S        => i_ALUControl(7),
             i_A        => s_cMuxLui,
             i_B        => "11111",
             o_O        => s_cMuxSlt);      
             
    G_cOut: mux32_8to1
    port map(i_S        => i_ALUControl(2 downto 0),
             i_D        => s_cOut,
             o_O        => o_ALUOut);           

    -- Add/Sub
    G_Adder_Sub: AdderSubtractor
    generic map(N => N)
    port map(i_A          => s_cMuxZero,
             i_B          => s_cMuxJal,
             i_nAddSub    => i_ALUControl(11),
             o_C          => s_adderC,
             o_CMinusOne  => s_adderCMinusOne,
             o_O          => s_adderOut);

    -- Cascade OR Gate
    G_cascOR: cascade_or
    port map(i_S        => s_adderOut,
             o_O        => s_cascade);

    G_cascNOT: invg
    port map(i_A          => s_cascade,
             o_F          => s_cascadeNOT);

    -- Overflow detect
    G_overflowXOR: xorg2
    port map(i_A          => s_adderC,
             i_B          => s_adderCMinusOne,
             o_F          => s_overflow);

    G_overflowAND: andg2
    port map(i_A          => s_overflow,
             i_B          => i_ALUControl(9),
             o_F          => o_overflow);    

    -- Shifter
    G_moveBits: shifter
    port map(i_signed       => i_ALUControl(4),
             i_dir          => i_ALUControl(3),
             i_D            => s_adderOut,
             i_shamt        => s_cMuxSlt,
             o_O            => s_shifterOut);

    -- Basic logic gates
    G_orifyer: or32
    port map(i_A          => i_portOne,
             i_B          => i_portTwo,
             o_F          => s_cOut(1));  

    G_xorifyer: xor32
    port map(i_A          => i_portOne,
             i_B          => i_portTwo,
             o_F          => s_cOut(2));            
             
    G_NOTorifyer: invg32
    port map(i_A          => s_cOut(1),
             o_F          => s_cOut(3));   
             
    G_NOT: invg32
    port map(i_A          => i_portOne,
             o_F          => s_cOut(4));    
             
    G_andifyer: and32
    port map(i_A          => i_portOne,
             i_B          => i_portTwo,
             o_F          => s_cOut(5));     
             
    G_moreBits: replQb
    port map(i_D            => i_portTwo(7 downto 0),
             o_O            => s_cOut(6));    
             
    -- Misc
    s_cOut(7)       <= X"00000000";

end structural;