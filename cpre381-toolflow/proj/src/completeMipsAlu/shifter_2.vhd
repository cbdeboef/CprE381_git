library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- i_dir = 0 -> shift left; i_dir = 1 -> shift right
-- i_signed = 0 -> unsigned; i_singed = 1 -> signed shift
-- shamt: Ammount to shift by. Defined by shamt in R type instructions

entity shifter_2 is
  port(i_signed, i_dir  : in std_logic;
       i_D              : in std_logic_vector(7 downto 0);
       i_shamt          : in std_logic_vector(2 downto 0);
       o_O              : out std_logic_vector(7 downto 0));
end shifter_2;

architecture structural of shifter_2 is

    component mux2t1_dataflow is
        port(i_D0,i_D1,i_S      : in std_logic;
             o_O                : out std_logic);
    end component;

    component invg is
        port(i_A            : in std_logic;
             o_F            : out std_logic);
    end component;

    signal s_mux0           : std_logic_vector(7 downto 0);
    signal s_mux1           : std_logic_vector(7 downto 0);
    signal s_D              : std_logic_vector(7 downto 0);
    signal s_O              : std_logic_vector(7 downto 0);
    signal s_shamt0         : std_logic;
    signal s_shamt1         : std_logic;
    signal s_shamt2         : std_logic;

begin
    -- This controls the shift direction
    G_BitOrder: for i in 0 to 7 generate
        s_D(i)  <= i_D(i) when i_dir = '0' else i_D(7-i);
        o_O(i)  <= s_O(i) when i_dir = '0' else s_O(7-i);
    end generate G_BitOrder;
           
    -- First layer of the muxes, controlled by lsb (bit 0)
    invg0: invg
        port map(i_A    => i_shamt(0),
                 o_F    => s_shamt0);

    G_Barrel_BIT0_0: mux2t1_dataflow
        port map(i_D0           => s_D(7),
                 i_D1           => s_D(0),
                 i_S            => s_shamt0,
                 o_O            => s_mux0(0));

    G_Barrel_BIT0: for i in 1 to 7 generate
        MUX0: mux2t1_dataflow
            port map(i_D0       => s_D(i-1),
                     i_D1       => s_D(i),
                     i_S        => s_shamt0,
                     o_O        => s_mux0(i));
    end generate G_Barrel_BIT0;

    -- Second layer of the muxes, controlled by bit 1
    invg1: invg
        port map(i_A    => i_shamt(1),
                 o_F    => s_shamt1);

    G_Barrel_BIT1_0: for i in 0 to 1 generate           -- Generates mux 0-1
        MUX1_0: mux2t1_dataflow
            port map(i_D0       => s_mux0(6+i),
                     i_D1       => s_mux0(i),
                     i_S        => s_shamt1,
                     o_O        => s_mux1(i));
        end generate G_Barrel_BIT1_0;       

    G_Barrel_BIT1: for i in 2 to 7 generate                 -- Generates mux 2-7
        MUX1: mux2t1_dataflow
            port map(i_D0       => s_mux0(i-2),
                     i_D1       => s_mux0(i),
                     i_S        => s_shamt1,
                     o_O        => s_mux1(i));
    end generate G_Barrel_BIT1;        

    -- Third layer of the muxes, controlled by bit 2
    invg2: invg
        port map(i_A    => i_shamt(2),
                 o_F    => s_shamt2);

    G_Barrel_BIT2_0: for i in 0 to 3 generate               -- Generates mux 0-3
        MUX2_0: mux2t1_dataflow
            port map(i_D0       => s_mux1(4+i),
                     i_D1       => s_mux1(i),
                     i_S        => s_shamt2,
                     o_O        => s_O(i));
        end generate G_Barrel_BIT2_0;       

    G_Barrel_BIT2: for i in 4 to 7 generate                 -- Generates mux 4-7
        MUX2: mux2t1_dataflow
            port map(i_D0       => s_mux1(i-4),
                     i_D1       => s_mux1(i),
                     i_S        => s_shamt2,
                     o_O        => s_O(i));
    end generate G_Barrel_BIT2;               
    

end structural;