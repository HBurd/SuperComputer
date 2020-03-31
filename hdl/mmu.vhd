library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

library xpm;
use xpm.vcomponents.all;

-- Memory map:
--
-- 0x0000
-- ROM     addr(12 downto 10) = b"000"
-- 0x03FF
-- 
-- 0x0400
-- RAM     addr(12 downto 10) = b"001"
-- 0x07FF
-- 
-- 0x1000
-- CBUF    addr(12 downto 10) = b"1xx"
-- 0x2000
--
-- 0x0C00
-- unmapped
-- 0xFFEF
--
-- 0xFFF0 input port
-- 0xFFF2 output port
-- 
-- 0xFFF4
-- unmapped
-- 0xFFFF

entity mmu is
  Generic(
    RAM_INIT_FILE : string := "none";
    ROM_INIT_FILE : string := "none");
  Port (
  clk : in std_logic;
  clk100MHz : in std_logic;
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
  io_out : out std_logic_vector(15 downto 0);

  -- graphics controller interface
  char_addr : in unsigned(12 downto 0);
  selected_char : out unsigned(7 downto 0));
end mmu;

architecture Behavioral of mmu is

type dport_addr_type_t is (dport_rom, dport_ram, dport_cbuf, dport_in, dport_out);

signal dport_addr_type : dport_addr_type_t;

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

-- character buffer R/W port
signal cbuf_rw_addr : std_logic_vector (15 downto 0);
signal cbuf_rw_wea : std_logic_vector (0 downto 0);
signal cbuf_rw_din : std_logic_vector(15 downto 0);
signal cbuf_rw_dout : std_logic_vector (15 downto 0);

signal char_word_addr: unsigned(12 downto 0);
signal selected_char_wide : std_logic_vector(15 downto 0);

-- word-rounded addresses
signal rounded_iaddr : std_logic_vector (15 downto 0);
signal rounded_daddr : std_logic_vector (15 downto 0);

-- I/O ports
signal latched_oport_data : std_logic_vector(15 downto 0);

-- error signals
signal daddr_rom_read_error : std_logic;
signal daddr_out_of_range_error : std_logic;
signal iaddr_out_of_range_error : std_logic;

begin
    -- round byte-scale CPU addresses to 16-bit word addresses
    rounded_iaddr(15 downto 0) <= '0' & iaddr(15 downto 1);
    
    rounded_daddr(15 downto 0) <= '0' & daddr(15 downto 1);
    

    -- determine what the data port is accessing
    dport_addr_type <= dport_in when (daddr = x"FFF0" and dwen = '0') else
                       dport_out when (daddr = x"FFF2") else
                       dport_cbuf when (daddr(12) = '1') else
                       dport_ram when (daddr(10) = '1') else
                       dport_rom when (daddr(10) = '0');
    
    -- generate memory addresses from rounded CPU addresses
    ram_rw_addr <= "000000" & rounded_daddr(9 downto 0);

    cbuf_rw_addr <= "000" & rounded_daddr(12 downto 0);
    
    ram_r_addr <= "000000" & rounded_iaddr(9 downto 0);
    
    rom_addr <= "000000" & rounded_iaddr(9 downto 0);
    
    -- hook the data lines
    
    iout <= rom_dout when (iaddr(10) = '0') else ram_r_dout;
    
    dread <= io_in when (dport_addr_type = dport_in) else
             ram_rw_dout when (dport_addr_type = dport_ram) else
             cbuf_rw_dout when (dport_addr_type = dport_cbuf) else
             (others => '0');
             
    io_out <= latched_oport_data;

    ram_rw_din <= dwrite;
    ram_rw_wea(0) <= '1' when (dwen = '1') and (dport_addr_type = dport_ram) else '0';

    cbuf_rw_din <= dwrite;
    cbuf_rw_wea(0) <= '1' when (dwen = '1') and (dport_addr_type = dport_cbuf) else '0';
    
    -- hold the data written to the output port
    process (clk, rst) 
    begin
        if (rst = '1') then
            latched_oport_data <= (others => '0');
        elsif rising_edge(clk) then
            if (dport_addr_type = dport_out) then
                latched_oport_data <= dwrite;
            end if;
        end if;  
    end process;

    char_word_addr <= '0' & char_addr(12 downto 1);
    selected_char <= unsigned(selected_char_wide(7 downto 0)) when char_addr(0) = '0' else unsigned(selected_char_wide(15 downto 8));

    -- Both memories (and all their ports) use a the same clock and rst lines.

    -- xpm_memory_sprom: Single Port ROM
    -- Xilinx Parametrized Macro, version 2017.4
    xpm_memory_sprom_inst: xpm_memory_sprom
    generic map (
        ADDR_WIDTH_A => 16,
        AUTO_SLEEP_TIME => 0,
        ECC_MODE => "no_ecc",
        MEMORY_INIT_FILE => ROM_INIT_FILE,
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
            MEMORY_INIT_FILE => RAM_INIT_FILE,
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

    -- character buffer ram for interacting with the graphics controller
    char_buffer_ram : xpm_memory_dpdistram
        generic map(
            MEMORY_SIZE => 4096 * 8,
            CLOCKING_MODE => "independent_clock",
            MEMORY_INIT_FILE => "none",
            MEMORY_INIT_PARAM => "0",
            USE_MEM_INIT => 0,
            MESSAGE_CONTROL => 0,
            USE_EMBEDDED_CONSTRAINT => 0,
            MEMORY_OPTIMIZATION => "true",
            
            WRITE_DATA_WIDTH_A => 16,
            READ_DATA_WIDTH_A => 16,
            BYTE_WRITE_WIDTH_A => 16,
            ADDR_WIDTH_A => 13,
            READ_RESET_VALUE_A => "0",
            READ_LATENCY_A => 1,
            
            READ_DATA_WIDTH_B => 16,
            ADDR_WIDTH_B => 13,
            READ_RESET_VALUE_B => "0",
            READ_LATENCY_B => 1
        )
        port map (
            -- rw port
            clka => clk,
            rsta => rst,
            ena => '1',
            regcea => '1',
            wea => cbuf_rw_wea,
            addra => cbuf_rw_addr(12 downto 0),
            dina => cbuf_rw_din,
            douta => cbuf_rw_dout,
            
            -- read-only port
            clkb => clk100MHz,
            rstb => rst,
            enb => '1',
            regceb => '1',
            addrb => std_logic_vector(char_word_addr),
            doutb => selected_char_wide
        );

            

end Behavioral;
