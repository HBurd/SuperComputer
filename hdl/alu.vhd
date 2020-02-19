library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity alu is
    Port ( in1 : in STD_LOGIC_VECTOR (15 downto 0);
           in2 : in STD_LOGIC_VECTOR (15 downto 0);
           alu_mode : in alu_mode_t;
           result : out STD_LOGIC_VECTOR (15 downto 0);
           z_flag : out STD_LOGIC;
           n_flag : out STD_LOGIC);
end alu;

architecture Behavioral of alu is
signal sum : signed(15 downto 0);
signal difference: signed(15 downto 0);
signal product: signed(31 downto 0);
signal l_shifted: std_logic_vector(15 downto 0);
signal r_shifted: std_logic_vector(15 downto 0);
signal internal_result : STD_LOGIC_VECTOR (15 downto 0);
begin

sum <= signed(in1) + signed(in2);
difference <= signed(in1) - signed(in2);
product <= signed(in1) * signed(in2);

--left_shift: process(in1, in2)
--begin
--    for i in 0 to 15 loop
--        if (std_logic_vector(to_unsigned(i, in2'length)) = in2) then
--            l_shifted(15 downto i) <= in1 ((15 - i) downto 0);
--            l_shifted((i-1) downto 0) <= (others => '0');
--        end if;
--    end loop;
--end process left_shift;

--right_shift: process(in1, in2)
--begin
--    for i in 0 to 15 loop
--        if (std_logic_vector(to_unsigned(i, in2'length)) = in2) then
--            l_shifted((15 - i) downto 0) <= in1 (15 downto i);
--            l_shifted((15 downto (15 - i)) <= (others => '0');
--        end if;
--    end loop;
--end process right_shift;


internal_result <=
    std_logic_vector(sum) when (alu_mode = alu_add) else
    std_logic_vector(difference) when (alu_mode = alu_sub) else
    std_logic_vector(product(15 downto 0)) when (alu_mode = alu_mul) else
    in1 NAND in2 when (alu_mode = alu_nand) else
    in1 when (alu_mode = alu_test)
    else (others => '0');
    
z_flag <=
    '1' when (internal_result = x"0000") else
    '0';
    
n_flag <= internal_result(15);

result <= internal_result;

end Behavioral;
