----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2020 02:39:17 PM
-- Design Name: 
-- Module Name: branch_tb - Behavioral
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

entity branch_tb is
--  Port ( );
end branch_tb;

architecture Behavioral of branch_tb is

    component pipeline
        Port(
            clk: in std_logic;
            rst_ex: in std_logic;
            rst_ld: in std_logic;
            iaddr: out std_logic_vector(15 downto 0);
            iread: in std_logic_vector(15 downto 0);
            daddr: out std_logic_vector(15 downto 0);
            dwen: out std_logic;
            dwrite: out std_logic_vector(15 downto 0);
            dread: in std_logic_vector(15 downto 0));
    end component;

    component mmu
        Generic(
            RAM_INIT_FILE : string := "none";
            ROM_INIT_FILE : string := "none");
        Port(
            clk: in std_logic;
            rst: in std_logic;
            err: out std_logic;
            -- instruction port
            iaddr: in std_logic_vector(15 downto 0);
            iout: out std_logic_vector(15 downto 0);
            -- data port
            daddr: in std_logic_vector(15 downto 0);
            dwen: in std_logic; -- write when 1, read when 0
            dwrite: in std_logic_vector(15 downto 0); -- used when dwen = 1
            dread: out std_logic_vector(15 downto 0); -- valid when dwen = 0
            -- i/o ports
            io_in: in std_logic_vector(15 downto 0);
            io_out: out std_logic_vector(15 downto 0));
    end component;
    
    signal clk, rst: std_logic;
    signal mem_iaddr, mem_iread, mem_daddr, mem_dread, mem_dwrite : std_logic_vector(15 downto 0);
    signal mem_dwen : std_logic;
    
    signal io_in: std_logic_vector(15 downto 0);

begin


    instr_pipeline: pipeline port map(
        clk => clk,
        rst_ex => rst,
        rst_ld => '0',
        iaddr => mem_iaddr,
        iread => mem_iread,
        daddr => mem_daddr,
        dwen => mem_dwen,
        dwrite => mem_dwrite,
        dread => mem_dread);
    
    memory_unit : mmu
        generic map(
            RAM_INIT_FILE => "none",
            --ROM_INIT_FILE => "FORMAT_B_Test_Part1.mem")
            --ROM_INIT_FILE => "FORMAT_B_Test_Part2.mem")
            --ROM_INIT_FILE => "FORMAT_B_Test_Part3.mem")
            ROM_INIT_FILE => "subroutine_test.mem")
        port map(
            clk => clk,
            rst => rst,
            -- instruction port
            iaddr => mem_iaddr,
            iout => mem_iread,
            -- data port
            daddr => mem_daddr,
            dwen => mem_dwen,
            dwrite => mem_dwrite,
            dread => mem_dread,
            -- I/O ports
            io_in => io_in,
            io_out => open);
    
    -- clock process 
    process begin
        clk <= '0';
        wait for 10 us;
        clk <= '1';
        wait for 10 us;
    end process;
    
    -- test process
    process begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);
        io_in <= x"0002";
        wait until rising_edge(clk);
        io_in <= x"0003";
        wait until rising_edge(clk);
        io_in <= x"0001";
        wait until rising_edge(clk);
        io_in <= x"0005";
        wait;
    end process;

end Behavioral;
