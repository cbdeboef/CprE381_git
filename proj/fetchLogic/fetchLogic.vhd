library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fetchLogic is

  port(i_pcCurrent : in  std_logic_vector(31 downto 0);
       i_jumpImm   : in  std_logic_vector(25 downto 0);
       i_branchImm : in std_logic_vector(31 downto 0);
       i_jumpSel   : in  std_logic;
       i_branch    : in  std_logic;
       i_ALUZero   : in  std_logic;
       o_pcUpdated : out std_logic_vector(31 downto 0));

end fetchLogic;

architecture dataflow of fetchLogic is

    signal s_pcPlusFour    : std_logic_vector(31 downto 0) := X"00000000";
    

begin

    s_pcPlusFour <= std_logic_vector(unsigned(i_pcCurrent) + 4);

    o_pcUpdated <= s_pcPlusFour(31 downto 28) & i_jumpImm & "00" when i_jumpSel = '1' else
                   std_logic_vector(signed(s_pcPlusFour) + signed(i_branchImm(29 downto 0) & "00")) when (i_jumpSel = '0') and (i_branch = '1') and (i_ALUZero = '1') else
                   s_pcPlusFour when i_jumpSel = '0' and (i_branch = '0' or i_ALUZero = '0');

    
end dataflow;