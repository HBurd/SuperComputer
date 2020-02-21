library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BarrelShifter is
    Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
           shift_amt : in STD_LOGIC_VECTOR (3 downto 0);
           l_shifted : out STD_LOGIC_VECTOR (15 downto 0);
           r_shifted : out STD_LOGIC_VECTOR (15 downto 0));
end BarrelShifter;

architecture Behavioral of BarrelShifter is

    signal l_shift_1: std_logic_vector(15 downto 0);
    signal l_shift_2: std_logic_vector(15 downto 0);
    signal l_shift_4: std_logic_vector(15 downto 0);
    
    signal r_shift_1: std_logic_vector(15 downto 0);
    signal r_shift_2: std_logic_vector(15 downto 0);
    signal r_shift_4: std_logic_vector(15 downto 0);

begin

    l_shift_1 <= input(14 downto 0) & "0" when shift_amt(0) = '1'
        else input;
    l_shift_2 <= l_shift_1(13 downto 0) & "00" when shift_amt(1) = '1'
        else l_shift_1;
    l_shift_4 <= l_shift_2(11 downto 0) & x"0" when shift_amt(2) = '1'
        else l_shift_2;
    l_shifted <= l_shift_4(7 downto 0) & x"00" when shift_amt(3) = '1'
        else l_shift_4;
            
    r_shift_1 <= "0" & input(15 downto 1) when shift_amt(0) = '1'
        else input;
    r_shift_2 <= "00" & r_shift_1(15 downto 2) when shift_amt(1) = '1'
        else r_shift_1;
    r_shift_4 <= x"0" & r_shift_2(15 downto 4) when shift_amt(2) = '1'
        else r_shift_2;
    r_shifted <= x"00" & r_shift_4(15 downto 8) when shift_amt(3) = '1'
        else r_shift_4;

end Behavioral;
