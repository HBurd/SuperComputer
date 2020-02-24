library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library xpm;
use xpm.vcomponents.all;

use work.mmu;

entity mmu_tb is end mmu_tb;


architecture Behavioral of mmu_tb is

    component mmu port(
         clk : in std_logic;
         rst : in std_logic;
         err : out std_logic;
         iaddr : in std_logic_vector(15 downto 0);
         iout : out std_logic_vector(15 downto 0);
         daddr : in std_logic_vector(15 downto 0);
         dwen : in std_logic;
         dwrite : in std_logic_vector(15 downto 0);
         dread : out std_logic_vector (15 downto 0);
         io_in : in std_logic_vector (15 downto 0);
         io_out : out std_logic_vector(15 downto 0));
    end component;

    signal clk, reset, err : std_logic;
    signal iaddr, iout : std_logic_vector(15 downto 0);
    signal daddr, din, dout : std_logic_vector(15 downto 0);
    signal dwen : std_logic;
    signal io_in, io_out : std_logic_vector(15 downto 0);
begin

    dut: mmu port map (
            clk => clk,
            rst => reset,
            err => err,
            iaddr => iaddr,
            iout => iout,
            daddr => daddr,
            dwrite => din,
            dwen => dwen,
            dread => dout,
            io_in => io_in,
            io_out => io_out);
    
    process begin -- clock
        clk <= '0'; wait for 10 us;
        clk <= '1'; wait for 10 us;
    end process;
    
    process begin
        iaddr <= (others => '0');
        daddr <= (others => '0');
        din <= (others => '0');
        io_in <= x"F0F0";
        dwen <= '0';
        reset <= '0';
                
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';
        wait until rising_edge(clk);
        
        daddr <= x"0400";
        din <= x"DEAD";
        dwen <= '1';
        
        iaddr <= x"0000";
        
        wait until rising_edge(clk);
        daddr <= x"0401";
        din <= x"BEEF";
        iaddr <= x"0001";
               
        wait until falling_edge(clk);

        assert dout = x"DEAD" report "RAM readback failed :(" severity ERROR;
        
        wait until rising_edge(clk);
        daddr <= x"0400";
        dwen <= '0';
        
        iaddr <= x"0006";
        
        wait until falling_edge(clk);
        
        assert dout = x"BEEF" report "RAM readback failed :(" severity ERROR;
        
        wait until rising_edge(clk);
        daddr <= x"FFF0";
        
        wait until falling_edge(clk);
        assert dout = x"F0F0" report "Input port read failed :(" severity ERROR;
        
        wait until rising_edge(clk);
        daddr <= x"FFF2";
        din <= x"FAFA";
        dwen <= '1';
        
        wait;    
    end process;
    
    


end Behavioral;
