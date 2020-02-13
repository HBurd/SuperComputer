library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library xpm;
use xpm.vcomponents.all;

entity mmu_tb is end mmu_tb;


architecture Behavioral of mmu_tb is
    signal clk, reset : std_logic;
    signal ram_rw_addr, ram_rw_din, ram_rw_dout : std_logic_vector(15 downto 0);
    signal ram_rw_wea : std_logic_vector(0 downto 0);
    signal ram_r_addr, ram_r_dout : std_logic_vector(15 downto 0);
begin
    
    process begin -- clock
        clk <= '0'; wait for 10 us;
        clk <= '1'; wait for 10 us;
    end process;
    
    process begin
        wait until (clk = '1' and clk'event);
        wait until (clk = '1' and clk'event);
        
        ram_rw_addr <= x"0000";
        ram_rw_din <= x"3210";
        ram_rw_wea <= "1";
        
        wait until (clk = '1' and clk'event);
        
        ram_rw_addr <= x"0003";
        ram_rw_din <= x"abcd";
        ram_rw_wea <= "1";
        
        wait until (clk = '1' and clk'event);
        
        ram_rw_wea <= "0";      
        ram_rw_addr <= x"0000";
        
        wait until (clk = '1' and clk'event);

        ram_rw_wea <= "0";      
        ram_rw_addr <= x"0001";
        wait until (clk = '1' and clk'event);
        
        ram_rw_addr <= x"0002";
        
        wait until (clk = '1' and clk'event);
        
        ram_rw_addr <= x"0003";
        
        wait until (clk = '1' and clk'event);
        
        ram_rw_addr <= x"0004";
        
        wait;    
    end process;
    

    -- xpm_memory_dpdistram: Dual Port Distributed RAM
    -- Xilinx Parametrized Macro, version 2017.4
    xpm_memory_dpdistram_inst : xpm_memory_dpdistram
        generic map(
            MEMORY_SIZE => 1024 * 8,
            CLOCKING_MODE => "common_clock",
            MEMORY_INIT_FILE => "none",
            MEMORY_INIT_PARAM => "",
            USE_MEM_INIT => 1,
            MESSAGE_CONTROL => 0,
            USE_EMBEDDED_CONSTRAINT => 0,
            MEMORY_OPTIMIZATION => "true",
            
            WRITE_DATA_WIDTH_A => 16,
            READ_DATA_WIDTH_A => 16,
            BYTE_WRITE_WIDTH_A => 16,
            ADDR_WIDTH_A => 16,
            READ_RESET_VALUE_A => "0",
            READ_LATENCY_A => 0,
            
            READ_DATA_WIDTH_B => 16,
            ADDR_WIDTH_B => 16,
            READ_RESET_VALUE_B => "0",
            READ_LATENCY_B => 0
        )
        port map (
            -- rw port
            clka => clk,
            rsta => reset,
            ena => '1',
            regcea => '1',
            wea => ram_rw_wea,
            addra => ram_rw_addr,
            dina => ram_rw_din,
            douta => ram_rw_dout,
            
            -- read-only port
            clkb => clk,
            rstb => reset,
            enb => '1',
            regceb => '1',
            addrb => ram_r_addr,
            doutb => ram_r_dout
        );

end Behavioral;
