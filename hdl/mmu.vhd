library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;

library UNISIM;
use UNISIM.VComponents.all;

library xpm;
use xpm.vcomponents.all;


entity mmu is
  Port (
  clk : in std_logic;
  reset : in std_logic;
  error : out std_logic; -- something has gone wrong
  
  -- the instruction port:
  iaddr : in std_logic_vector (15 downto 0);
  iouta : out std_logic_vector (15 downto 0);
  
  -- the data port
  daddr : in std_logic_vector (15 downto 0);
  dwen : in std_logic; -- write when 1, read when 0
  din : in std_logic_vector (15 downto 0); -- used when web = 1
  dout : out std_logic_vector (15 downto 0) -- only valid when web = 0
  );
end mmu;

architecture Behavioral of mmu is
-- rom read port
signal rom_addr : std_logic_vector (15 downto 0);
signal rom_dout : std_logic_vector (15 downto 0);

-- ram R/W port
signal ram_rw_addr : std_logic_vector (15 downto 0);
signal ram_rw_wea : std_logic_vector (0 downto 0);
signal ram_rw_din : std_logic_vector(15 downto 0);
signal ram_rw_dout : std_logic_vector (15 downto 0);

-- ram read port
signal ram_r_addr : std_logic_vector (15 downto 0);
signal ram_r_dout : std_logic_vector (15 downto 0);

-- word-rounded addresses
signal rounded_iaddr : std_logic_vector (15 downto 0);
signal rounded_daddr : std_logic_vector (15 downto 0);

-- error signals
signal daddr_rom_read_error : std_logic;
signal daddr_out_of_range_error : std_logic;
signal iaddr_out_of_range_error : std_logic;

begin
    -- round byte-scale CPU addresses to 16-bit word addresses
    rounded_iaddr(15 downto 1) <= iaddr(15 downto 1);
    rounded_iaddr(0) <= '0';
    
    rounded_daddr(15 downto 1) <= daddr(15 downto 1);
    rounded_daddr(0) <= '0';
    
    -- check for problems
    error <= daddr_rom_read_error or daddr_rom_read_error or daddr_out_of_range_error or iaddr_out_of_range_error;
    daddr_rom_read_error <= '1' when (daddr(10) = '0') else '0'; -- data port trying to read from rom
    daddr_out_of_range_error <= or_reduce(daddr(15 downto 11)); -- data port trying to read from illegal address
    iaddr_out_of_range_error <= or_reduce(iaddr(15 downto 11)); -- instruction port tying to read from illegal address
    
    -- generate memory addresses from rounded CPU addresses
    ram_rw_addr <= rounded_daddr;
    
    ram_r_addr <= rounded_iaddr(15 downto 11) & '0' & rounded_iaddr(9 downto 0);
    rom_addr <= rounded_iaddr(15 downto 11) & '0' & rounded_iaddr(9 downto 0);
    
        

    -- Both memories (and all their ports) use a the same clock and reset lines.

    -- xpm_memory_sprom: Single Port ROM
    -- Xilinx Parametrized Macro, version 2017.4
    xpm_memory_sprom_inst: xpm_memory_sprom
    generic map (
        ADDR_WIDTH_A => 16,
        AUTO_SLEEP_TIME => 0,
        ECC_MODE => "no_ecc",
        MEMORY_INIT_FILE => "none",
        MEMORY_INIT_PARAM => "0",
        MEMORY_OPTIMIZATION => "true",
        MEMORY_PRIMITIVE => "auto",
        MEMORY_SIZE => 128 * 8,
        MESSAGE_CONTROL => 0,
        READ_DATA_WIDTH_A => 16,
        READ_LATENCY_A => 0,
        READ_RESET_VALUE_A => "0",
        USE_MEM_INIT => 1,
        WAKEUP_TIME => "disable_sleep"
    )
    port map (
        clka => clk,
        rsta => reset,
        addra => rom_addr,
        douta => rom_dout,
        ena => '1',
        
        
        -- Unused ECC and sleep mode stuff
        dbiterra => open,
        sbiterra => open,
        injectdbiterra => '0',
        injectsbiterra => '0',
        regcea => '1',
        sleep => '0'
     );
    
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