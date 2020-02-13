----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2020 04:17:06 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
    sw : in STD_LOGIC_VECTOR(15 downto 0);
    CLK100MHZ : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR(15 downto 0);
    an : out std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0)
);
end top;

architecture Behavioral of top is

    component display_controller
        Port(clk, reset: in std_logic;
            hex3, hex2, hex1, hex0: in std_logic_vector(3 downto 0);
            an: out std_logic_vector(3 downto 0);
            sseg: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal count : unsigned(63 downto 0);
    
    signal dig0 : std_logic_vector(3 downto 0);
    signal dig1 : std_logic_vector(3 downto 0);
    signal dig2 : std_logic_vector(3 downto 0);
    signal dig3 : std_logic_vector(3 downto 0);

begin

dig0 <= std_logic_vector(count(27 downto 24));
dig1 <= std_logic_vector(count(31 downto 28));
dig2 <= std_logic_vector(count(35 downto 32));
dig3 <= std_logic_vector(count(39 downto 36));

D0: display_controller port map (count(16),
                                 '0',
                                 dig3,
                                 dig2,
                                 dig1,
                                 dig0,
                                 an,
                                 seg);

process (clk100MHz)
begin
    if rising_edge(CLK100MHZ) then
          led <= STD_LOGIC_VECTOR(count(39 downto 24));
          count <= count + 1;
    end if;
end process;



end Behavioral;
