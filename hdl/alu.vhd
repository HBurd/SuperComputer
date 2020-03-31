library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity alu is
    Port ( in1 : in STD_LOGIC_VECTOR (15 downto 0);
           in2 : in STD_LOGIC_VECTOR (15 downto 0);
           alu_mode : in alu_mode_t;
           result : out STD_LOGIC_VECTOR (31 downto 0);
           z_flag : out STD_LOGIC;
           n_flag : out STD_LOGIC;
           o_flag : out STD_LOGIC);
end alu;

architecture Behavioral of alu is

    component BarrelShifter is
        Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
               shift_amt : in STD_LOGIC_VECTOR (3 downto 0);
               l_shifted : out STD_LOGIC_VECTOR (15 downto 0);
               r_shifted : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

    signal sum : signed(15 downto 0);
    signal difference : signed(15 downto 0);
    signal product : signed(31 downto 0);
    signal internal_result : STD_LOGIC_VECTOR (31 downto 0);
    signal l_shifted : std_logic_vector (15 downto 0);
    signal r_shifted : std_logic_vector (15 downto 0);

begin

    sum <= signed(in1) + signed(in2);
    difference <= signed(in1) - signed(in2);
    product <= signed(in1) * signed(in2);
    
    shifter: BarrelShifter port map(
        input => in1,
        shift_amt => in2(3 downto 0),
        l_shifted => l_shifted,
        r_shifted => r_shifted);
    
    internal_result <= x"0000" & std_logic_vector(sum) when (alu_mode = alu_add)
        else x"0000" & std_logic_vector(difference) when (alu_mode = alu_sub)
        else std_logic_vector(product) when (alu_mode = alu_mul or alu_mode = alu_muh)
        else x"0000" & (in1 NAND in2) when (alu_mode = alu_nand)
        else x"0000" & in1 when (alu_mode = alu_test)
        else x"0000" & l_shifted when alu_mode = alu_shl
        else x"0000" & r_shifted when alu_mode = alu_shr
        else (others => '0');
    
    z_flag <=
        '1' when (internal_result = x"00000000") else
        '0';
    
    n_flag <= internal_result(15);
    
    o_flag <= '0' when (internal_result(31 downto 15) = (16 downto 0 => '0')) or (internal_result(31 downto 15) = (16 downto 0 => '0')) else '1';
    
    result <= internal_result;

end Behavioral;
