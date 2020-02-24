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
  rst : in std_logic;
  err : out std_logic; -- something has gone wrong
  
  -- the instruction port:
  iaddr : in std_logic_vector (15 downto 0);
  iout : out std_logic_vector (15 downto 0);
  
  -- the data port
  daddr : in std_logic_vector (15 downto 0);
  dwen : in std_logic; -- write when 1, read when 0
  dwrite : in std_logic_vector (15 downto 0); -- used when dwen = 1
  dread : out std_logic_vector (15 downto 0); -- only valid when dwen = 0
  
  -- the I/O ports
  io_in : in std_logic_vector (15 downto 0);
  io_out : out std_logic_vector(15 downto 0)
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

-- I/O ports
signal i_port_read : std_logic;
signal o_port_write : std_logic;
signal latched_oport_data : std_logic_vector(15 downto 0);

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
    
    -- detect IO port accesses
    i_port_read <= '1' when (daddr = x"FFF0" and dwen = '0') else '0';
    o_port_write <= '1' when (daddr = x"FFF2" and dwen = '1') else '0';
    
    -- check for problems
    err <= daddr_rom_read_error or daddr_rom_read_error or daddr_out_of_range_error or iaddr_out_of_range_error;
    daddr_rom_read_error <= '1' when (daddr(10) = '0') else '0'; -- data port trying to read from rom
    daddr_out_of_range_error <= '1' when (i_port_read = '0') and (o_port_write = '0') and (or_reduce(daddr(15 downto 11)) = '1') else '0'; -- data port trying to read from illegal address
    iaddr_out_of_range_error <= or_reduce(iaddr(15 downto 11)); -- instruction port tying to read from illegal address
    
    -- generate memory addresses from rounded CPU addresses
    ram_rw_addr <= rounded_daddr;
    
    ram_r_addr <= rounded_iaddr(15 downto 11) & '0' & rounded_iaddr(9 downto 0);
    
    rom_addr <= rounded_iaddr(15 downto 11) & '0' & rounded_iaddr(9 downto 0);
    
    -- hook the data lines
    
    iout <= rom_dout when (iaddr(10) = '0') else ram_r_dout;
    
    dread <= io_in when (i_port_read = '1') else ram_rw_dout;
    
    io_out <= latched_oport_data;

    ram_rw_din <= dwrite;
    ram_rw_wea(0) <= dwen;
    
    -- hold the data written to the output port
    process (clk, rst) 
    begin
        if (rst = '1') then
            latched_oport_data <= (others => '0');
        elsif rising_edge(clk) then
            if (o_port_write = '1') then
                latched_oport_data <= dwrite;
            end if;
        end if;  
    end process;

    -- Both memories (and all their ports) use a the same clock and rst lines.

    -- xpm_memory_sprom: Single Port ROM
    -- Xilinx Parametrized Macro, version 2017.4
    xpm_memory_sprom_inst: xpm_memory_sprom
    generic map (
        ADDR_WIDTH_A => 16,
        AUTO_SLEEP_TIME => 0,
        ECC_MODE => "no_ecc",
        MEMORY_INIT_FILE => "../misc/format_a_test.mem",
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
        rsta => rst,
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
            rsta => rst,
            ena => '1',
            regcea => '1',
            wea => ram_rw_wea,
            addra => ram_rw_addr,
            dina => ram_rw_din,
            douta => ram_rw_dout,
            
            -- read-only port
            clkb => clk,
            rstb => rst,
            enb => '1',
            regceb => '1',
            addrb => ram_r_addr,
            doutb => ram_r_dout
        );
            

end Behavioral;
