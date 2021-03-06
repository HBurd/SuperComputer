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

use work.common.all;

entity top is
Generic(
    RAM_INIT_FILE : string := "none";
    ROM_INIT_FILE : string := "bootloader.mem");
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
    io2_out: out std_logic_vector(0 downto 0);
    vgaRed: out unsigned(3 downto 0);
    vgaGreen: out unsigned(3 downto 0);
    vgaBlue: out unsigned(3 downto 0);
    Hsync: out std_logic;
    Vsync: out std_logic);
end top;

architecture Behavioral of top is

    component display_controller
        Port(clk, reset: in std_logic;
            hex3, hex2, hex1, hex0: in std_logic_vector(3 downto 0);
            an: out std_logic_vector(3 downto 0);
            sseg: out std_logic_vector(6 downto 0));
    end component;

    component vga_controller
        Port(
            clk100MHz : in std_logic;
            rst : in std_logic;
            char_addr : out unsigned(12 downto 0);
            selected_char: in unsigned(7 downto 0);
            vgaRed: out unsigned(3 downto 0);
            vgaGreen: out unsigned(3 downto 0);
            vgaBlue: out unsigned(3 downto 0);
            Hsync: out std_logic;
            Vsync: out std_logic);
    end component;
    
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
            clk100MHz: in std_logic;
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
            io1_in: in std_logic_vector(15 downto 0);
            io1_out: out std_logic_vector(15 downto 0);
            io2_in: in std_logic_vector(15 downto 0);
            io2_out: out std_logic_vector(15 downto 0);
            -- graphics controller interface
            char_addr : in unsigned(12 downto 0);
            selected_char : out unsigned(7 downto 0));
    end component;
    
    signal rst: std_logic;
    
    signal mem_iaddr, mem_iread, mem_daddr, mem_dread, mem_dwrite : std_logic_vector(15 downto 0);
    signal mem_dwen : std_logic;
    
    signal clk_div : unsigned(63 downto 0);
    
    signal dig0 : std_logic_vector(3 downto 0);
    signal dig1 : std_logic_vector(3 downto 0);
    signal dig2 : std_logic_vector(3 downto 0);
    signal dig3 : std_logic_vector(3 downto 0);

    signal io2_in_internal: std_logic_vector(15 downto 0);
    signal io2_out_internal: std_logic_vector(15 downto 0); 

    signal char_addr : unsigned(12 downto 0);
    signal selected_char : unsigned(7 downto 0);

begin

rst <= '1' when rst_ex = '1' or rst_ld = '1' else '0';

instr_pipeline: pipeline port map(
    clk => clk,
    rst_ex => rst_ex,
    rst_ld => rst_ld,
    iaddr => mem_iaddr,
    iread => mem_iread,
    daddr => mem_daddr,
    dwen => mem_dwen,
    dwrite => mem_dwrite,
    dread => mem_dread);

io2_in_internal(5 downto 0) <= (5 downto 0 => '0');
io2_in_internal(15 downto 6) <= io2_in;
io2_out <= io2_out_internal(0 downto 0);

memory_unit : mmu
    generic map(
        RAM_INIT_FILE => RAM_INIT_FILE,
        ROM_INIT_FILE => ROM_INIT_FILE)
    port map(
        clk => clk,
        clk100MHz => clk100MHz,
        rst => '0',
        -- instruction port
        iaddr => mem_iaddr,
        iout => mem_iread,
        -- data port
        daddr => mem_daddr,
        dwen => mem_dwen,
        dwrite => mem_dwrite,
        dread => mem_dread,
        -- I/O ports
        io1_in => io1_in,
        io1_out => io1_out,
        io2_in => io2_in_internal,
        io2_out => io2_out_internal,
        char_addr => char_addr,
        selected_char => selected_char);

vga : vga_controller
    port map (
        clk100MHz => clk100MHz,
        rst => rst,
        char_addr => char_addr,
        selected_char => selected_char,
        vgaRed => vgaRed,
        vgaGreen => vgaGreen,
        vgaBlue => vgaBlue,
        Hsync => Hsync,
        Vsync => Vsync);
    
dig0 <= std_logic_vector(mem_iaddr(3 downto 0));
dig1 <= std_logic_vector(mem_iaddr(7 downto 4));
dig2 <= std_logic_vector(mem_iaddr(11 downto 8));
dig3 <= std_logic_vector(mem_iaddr(15 downto 12));

D0: display_controller port map (clk => clk_div(16),
                                 reset => '0',
                                 hex3 => dig3,
                                 hex2 => dig2,
                                 hex1 => dig1,
                                 hex0 => dig0,
                                 an => an,
                                 sseg => seg);
       
-- divide 100MHz clk                          
process(clk100MHz) begin
    if rst = '1' then
        clk_div <= (others => '0');
    elsif rising_edge(clk100MHz) then
        clk_div <= clk_div + 1;
    end if;
end process;

end Behavioral;
