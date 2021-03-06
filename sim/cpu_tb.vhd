----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2020 04:48:23 PM
-- Design Name: 
-- Module Name: cpu_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_tb is
--  Port ( );
end cpu_tb;

architecture Behavioral of cpu_tb is

component top
    Generic(
        RAM_INIT_FILE : string := "none";
        ROM_INIT_FILE : string := "none");
    Port (
        clk : in STD_LOGIC;
        rst_ex : in std_logic;
        rst_ld : in std_logic;
        clk100MHz : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        io1_in: in std_logic_vector(15 downto 0);
        io1_out: out std_logic_vector(15 downto 0);
        io2_in: in std_logic_vector(15 downto 6);
        io2_out: out std_logic_vector(0 downto 0));
end component;

signal clk, rst: std_logic;
signal in_signal: std_logic_vector(15 downto 0);
signal out_signal: std_logic_vector(15 downto 0);

begin

    -- clock process
    process begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    dut: top
    generic map(
    RAM_INIT_FILE => "none",
    ROM_INIT_FILE => "bootloader.mem"
    ) 
    port map (
        clk => clk,
        rst_ex => '0',
        rst_ld => rst,
        clk100MHz => '0',
        an => open,
        seg => open,
        io1_in => in_signal,
        io1_out => out_signal,
        io2_in => x"AA" & "10",
        io2_out => open
    );
    
    in_signal <= x"0050";
    
    process begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';
        wait;
    end process;

end Behavioral;
