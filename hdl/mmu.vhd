library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

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
  io1_in : in std_logic_vector (15 downto 0);  -- 0xfff0
  io1_out : out std_logic_vector(15 downto 0); -- 0xfff2
  io2_in : in std_logic_vector (15 downto 0);  -- 0xfff4
  io2_out : out std_logic_vector(15 downto 0);  -- 0xfff6

  -- graphics controller interface
  char_addr : in unsigned(12 downto 0);
  selected_char : out unsigned(7 downto 0));
end mmu;

architecture Behavioral of mmu is

    component sprom
        Generic(
          ADDR_WIDTH : natural := 16;
          MEMORY_INIT_FILE : string := "none";
          MEMORY_SIZE : natural := 16*2048;
          READ_DATA_WIDTH : natural := 16
        );
        Port ( 
          clk : in std_logic;
          rst : in std_logic;
          addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
          dout : out std_logic_vector(READ_DATA_WIDTH-1 downto 0)
        );
    end component;

    component dpram
        Generic(
          ADDR_WIDTH : natural := 16;
          MEMORY_SIZE : natural := 16*2048;
          READ_DATA_WIDTH : natural := 16
        );
        Port ( 
          clk : in std_logic;
          rst : in std_logic;

          -- rw port
          rw_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
          rw_dout : out std_logic_vector(READ_DATA_WIDTH-1 downto 0);
          rw_din : in std_logic_vector(READ_DATA_WIDTH-1 downto 0);
          rw_we : in std_logic;

          -- r port
          r_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
          r_dout : out std_logic_vector(READ_DATA_WIDTH-1 downto 0)
        );
    end component;

    type dport_addr_type_t is (dport_rom, dport_ram, dport_cbuf, dport_in1, dport_out1, dport_in2, dport_out2, dport_invalid);

    signal dport_addr_type : dport_addr_type_t;

    -- rom read port
    signal rom_addr : std_logic_vector (15 downto 0);
    signal rom_dout : std_logic_vector (15 downto 0);

    -- ram R/W port
    signal ram_rw_addr : std_logic_vector (15 downto 0);
    signal ram_rw_wea : std_logic;
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

    signal latched_out1_data : std_logic_vector(15 downto 0);
    signal latched_out2_data : std_logic_vector(15 downto 0);

    -- error signals
    signal daddr_rom_read_error : std_logic;
    signal daddr_out_of_range_error : std_logic;
    signal iaddr_out_of_range_error : std_logic;

begin
    -- round byte-scale CPU addresses to 16-bit word addresses
    rounded_iaddr(15 downto 0) <= '0' & iaddr(15 downto 1);
    
    rounded_daddr(15 downto 0) <= '0' & daddr(15 downto 1);
    
    -- determine what the data port is accessing
    dport_addr_type <= dport_in1 when (daddr = x"FFF0" and dwen = '0') else
                       dport_out1 when (daddr = x"FFF2" and dwen = '1') else
                       dport_in2 when (daddr = x"FFF4" and dwen = '0') else
                       dport_out2 when (daddr = x"FFF6" and dwen = '1') else
                       dport_cbuf when (daddr(12) = '1') else
                       dport_ram when (daddr(10) = '1') else
                       dport_rom when (daddr(10) = '0') else
                       dport_invalid;
    
    -- generate memory addresses from rounded CPU addresses
    ram_rw_addr <= "000000" & rounded_daddr(9 downto 0);

    cbuf_rw_addr <= "000" & rounded_daddr(12 downto 0);
    
    ram_r_addr <= "000000" & rounded_iaddr(9 downto 0);
    
    rom_addr <= "000000" & rounded_iaddr(9 downto 0);
    
    -- hook the data lines
    
    iout <= rom_dout when (iaddr(10) = '0') else ram_r_dout;
    
    dread <= io1_in when (dport_addr_type = dport_in1) else
             io2_in when (dport_addr_type = dport_in2) else
             ram_rw_dout when (dport_addr_type = dport_ram) else
             cbuf_rw_dout when (dport_addr_type = dport_cbuf) else
             (others => '0');
             
    io1_out <= latched_out1_data;
    io2_out <= latched_out2_data;

    ram_rw_din <= dwrite;
    ram_rw_wea <= '1' when (dwen = '1') and (dport_addr_type = dport_ram) else '0';

    cbuf_rw_din <= dwrite;
    cbuf_rw_wea(0) <= '1' when (dwen = '1') and (dport_addr_type = dport_cbuf) else '0';
    
    -- hold the data written to the output port
    process (clk, rst) 
    begin
        if (rst = '1') then
            latched_out1_data <= (others => '0');
            latched_out2_data <= (others => '0');
        elsif rising_edge(clk) then
            if (dport_addr_type = dport_out1) then
                latched_out1_data <= dwrite;
            elsif (dport_addr_type = dport_out2) then
                latched_out2_data <= dwrite;
            end if;
        end if;  
    end process;

    char_word_addr <= '0' & char_addr(12 downto 1);
    selected_char <= unsigned(selected_char_wide(7 downto 0)) when char_addr(0) = '0' else unsigned(selected_char_wide(15 downto 8));

    -- Both memories (and all their ports) use a the same clock and rst lines.


    sprom_inst: sprom
    generic map (
        ADDR_WIDTH => 16,
        MEMORY_INIT_FILE => ROM_INIT_FILE,
        MEMORY_SIZE => 1024 * 8,
        READ_DATA_WIDTH => 16
    )
    port map (
        clk => clk,
        rst => rst,
        addr => rom_addr,
        dout => rom_dout
    );

    dpram_inst: dpram
    generic map (
        ADDR_WIDTH => 16,
        MEMORY_SIZE => 1024 * 8,
        READ_DATA_WIDTH => 16
    )
    port map (
        clk => clk,
        rst => rst,

        -- rw port
        rw_addr => ram_rw_addr,
        rw_dout => ram_rw_dout,
        rw_din => ram_rw_din,
        rw_we => ram_rw_wea,

        -- r port
        r_addr => ram_r_addr,
        r_dout => ram_r_dout
    );

    ---- xpm_memory_dpdistram: Dual Port Distributed RAM
    ---- Xilinx Parametrized Macro, version 2017.4
    --xpm_memory_dpdistram_inst : xpm_memory_dpdistram
    --    generic map(
    --        MEMORY_SIZE => 1024 * 8,
    --        CLOCKING_MODE => "common_clock",
    --        MEMORY_INIT_FILE => RAM_INIT_FILE,
    --        MEMORY_INIT_PARAM => "",
    --        USE_MEM_INIT => 1,
    --        MESSAGE_CONTROL => 0,
    --        USE_EMBEDDED_CONSTRAINT => 0,
    --        MEMORY_OPTIMIZATION => "true",
    --        
    --        WRITE_DATA_WIDTH_A => 16,
    --        READ_DATA_WIDTH_A => 16,
    --        BYTE_WRITE_WIDTH_A => 16,
    --        ADDR_WIDTH_A => 16,
    --        READ_RESET_VALUE_A => "0",
    --        READ_LATENCY_A => 0,
    --        
    --        READ_DATA_WIDTH_B => 16,
    --        ADDR_WIDTH_B => 16,
    --        READ_RESET_VALUE_B => "0",
    --        READ_LATENCY_B => 0
    --    )
    --    port map (
    --        -- rw port
    --        clka => clk,
    --        rsta => rst,
    --        ena => '1',
    --        regcea => '1',
    --        wea => ram_rw_wea,
    --        addra => ram_rw_addr,
    --        dina => ram_rw_din,
    --        douta => ram_rw_dout,
    --        
    --        -- read-only port
    --        clkb => clk,
    --        rstb => rst,
    --        enb => '1',
    --        regceb => '1',
    --        addrb => ram_r_addr,
    --        doutb => ram_r_dout
    --    );

    ---- character buffer ram for interacting with the graphics controller
    --char_buffer_ram : xpm_memory_dpdistram
    --    generic map(
    --        MEMORY_SIZE => 4096 * 8,
    --        CLOCKING_MODE => "independent_clock",
    --        MEMORY_INIT_FILE => "none",
    --        MEMORY_INIT_PARAM => "0",
    --        USE_MEM_INIT => 0,
    --        MESSAGE_CONTROL => 0,
    --        USE_EMBEDDED_CONSTRAINT => 0,
    --        MEMORY_OPTIMIZATION => "true",
    --        
    --        WRITE_DATA_WIDTH_A => 16,
    --        READ_DATA_WIDTH_A => 16,
    --        BYTE_WRITE_WIDTH_A => 16,
    --        ADDR_WIDTH_A => 13,
    --        READ_RESET_VALUE_A => "0",
    --        READ_LATENCY_A => 1,
    --        
    --        READ_DATA_WIDTH_B => 16,
    --        ADDR_WIDTH_B => 13,
    --        READ_RESET_VALUE_B => "0",
    --        READ_LATENCY_B => 1
    --    )
    --    port map (
    --        -- rw port
    --        clka => clk,
    --        rsta => rst,
    --        ena => '1',
    --        regcea => '1',
    --        wea => cbuf_rw_wea,
    --        addra => cbuf_rw_addr(12 downto 0),
    --        dina => cbuf_rw_din,
    --        douta => cbuf_rw_dout,
    --        
    --        -- read-only port
    --        clkb => clk100MHz,
    --        rstb => rst,
    --        enb => '1',
    --        regceb => '1',
    --        addrb => std_logic_vector(char_word_addr),
    --        doutb => selected_char_wide
    --    );

            

end Behavioral;
