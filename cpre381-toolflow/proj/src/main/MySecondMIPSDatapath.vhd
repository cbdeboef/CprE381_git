-------------------------------------------------------------------------
-- Dylan Blattner
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MySecondMIPSDatapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the second MIPS
-- datapath.
-- NOTES:
-- 10/2/22: Created.
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpre381Custom.all;

entity MySecondMIPSDatapath is
    generic(N               : integer := 32;
            DATA_WIDTH      : natural := 32;
            ADDR_WIDTH      : natural := 10);
    port(CLK                : in std_logic;                             -- Clock input
         c_RST              : in std_logic;                             -- Asynchronous reset for registers
         c_WE               : in std_logic;                             -- Write enable input
         c_nAddSub          : in std_logic;                             -- Select for the add/sub function
         c_ALUSrc           : in std_logic;                             -- Select for the MUX
         c_Ext              : in std_logic;                             -- Select for the bit extender
         c_MemWrite         : in std_logic;                             -- Write enable for the memory
         c_MemtoReg         : in std_logic;                             -- Select for the MUX controlling the data in for the reg
         i_rt               : in std_logic_vector(4 downto 0);          -- Select input for rt
         i_rs               : in std_logic_vector(4 downto 0);          -- Select input for rs
         i_rd               : in std_logic_vector(4 downto 0);          -- Select input for rd
         i_immediate        : in std_logic_vector(15 downto 0);         -- Data for the immediate
         o_C                : out std_logic);                           -- Carry out
end MySecondMIPSDatapath;

architecture structural of MySecondMIPSDatapath is

    component reg is
        generic(N : integer := 32);                                     -- Generic for components that require bit width specified
        port(i_CLK          : in std_logic;                             -- Clock input
             i_RST          : in std_logic;                             -- Asynchronous reset for registers
             i_WE           : in std_logic;                             -- Write enable input
             i_rt           : in std_logic_vector(4 downto 0);          -- Select input for rt
             i_rs           : in std_logic_vector(4 downto 0);          -- Select input for rs
             i_rd           : in std_logic_vector(4 downto 0);          -- Select input for rd
             i_D            : in std_logic_vector(31 downto 0);         -- Data in for rd register
             o_rt           : out std_logic_vector(31 downto 0);        -- Read port for register rt
             o_rs           : out std_logic_vector(31 downto 0));       -- Read port for register rs
    end component;

    component mux32_2to1 is
        port(i_S        : in std_logic;
             i_A        : in std_logic_vector(31 downto 0);
             i_B        : in std_logic_vector(31 downto 0);
             o_O        : out std_logic_vector(31 downto 0));
    end component;

    component AddSub is
        generic(N : integer := 32);
        port(i_A          : in std_logic_vector(N-1 downto 0);
             i_B          : in std_logic_vector(N-1 downto 0);
             nAddSub      : in std_logic;
             o_F          : out std_logic_vector(N-1 downto 0);
             o_C          : out std_logic);
    end component;

    component mem is
        generic(DATA_WIDTH : natural := 32;
                ADDR_WIDTH : natural := 10);                   
        port(clk			: in std_logic;
		     addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		     data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		     we				: in std_logic := '1';
		     q				: out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;    

    component extender16t32 is
        port(i_S            : in std_logic_vector(15 downto 0);
             i_C            : in std_logic;
             o_S            : out std_logic_vector(31 downto 0));
    end component;

    -- Signals
    signal s_reg_iD         : std_logic_vector(31 downto 0);
    signal s_reg_rt         : std_logic_vector(31 downto 0);
    signal s_reg_rs         : std_logic_vector(31 downto 0);
    signal s_mux_F          : std_logic_vector(31 downto 0);
    signal s_imm_ext        : std_logic_vector(31 downto 0);
    signal s_alu_o          : std_logic_vector(31 downto 0);
    signal s_mem_o          : std_logic_vector(31 downto 0);

begin
    -- Instantiating the register
    REGFILE: reg
        generic map(N => N)
        port map(i_CLK          => CLK,
                 i_RST          => c_RST,
                 i_WE           => c_WE,
                 i_rt           => i_rt,
                 i_rs           => i_rs,
                 i_rd           => i_rd,
                 i_D            => s_reg_iD,
                 o_rt           => s_reg_rt,
                 o_rs           => s_reg_rs);

    -- Instantiating the ALU MUX
    MUX_ALU: mux32_2to1
        port map(i_S            => c_ALUSrc,
                 i_A            => s_reg_rt,
                 i_B            => s_imm_ext,
                 o_O            => s_mux_F);

    -- Instantiating the Add/Sub
    ALU: AddSub
        generic map(N => N)
        port map(i_A            => s_reg_rs,
                 i_B            => s_mux_F,
                 nAddSub        => c_nAddSub,
                 o_F            => s_alu_o,
                 o_C            => o_C);

    -- Instantiating the 16-bit to 32-bit extender
    EXTENDER: extender16t32
        port map(i_S            => i_immediate,
                 i_C            => c_Ext,
                 o_S            => s_imm_ext);

    -- Instantiating the memory
    dmem: mem
        generic map(DATA_WIDTH => DATA_WIDTH,
                    ADDR_WIDTH => ADDR_WIDTH)
        port map(clk            => CLK,
                 addr           => s_alu_o (9 downto 0),
                 data           => s_reg_rt,
                 we             => c_MemWrite,
                 q              => s_mem_o);

    -- Instantiating the reg input mux
    MUX_REG: mux32_2to1
        port map(i_S            => c_MemtoReg,
                 i_A            => s_mem_o,
                 i_B            => s_alu_o,
                 o_O            => s_reg_iD);

    

end structural;