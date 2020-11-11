library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.all;
use work.common.all;

entity dpram_tb is end dpram_tb;

architecture behavioural of dpram_tb is
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

    signal clk : std_logic;
    signal rst : std_logic;

    signal rw_addr : std_logic_vector(15 downto 0) := (others => '0');
    signal rw_dout : std_logic_vector(15 downto 0) := (others => '0');
    signal rW_din : std_logic_vector(15 downto 0) := (others => '0');
    signal rw_we : std_logic := '0';

    signal r_addr : std_logic_vector(15 downto 0) := (others => '0');
    signal r_dout : std_logic_vector(15 downto 0) := (others => '0');
begin
    dut: dpram 
    generic map (
        ADDR_WIDTH => 16,
        MEMORY_SIZE => 16*16,
        READ_DATA_WIDTH => 16
    )
    port map(
        clk => clk,
        rst => rst,
        rw_addr => rw_addr,
        rw_dout => rw_dout,
        rw_din => rw_din,
        rw_we => rw_we,
        r_addr => r_addr,
        r_dout => r_dout
    );

    rst <= '0';

    process begin
        rw_we <= '1';
        for i in 0 to 15 loop

            clk <= '0';
            rw_addr <= std_logic_vector(to_unsigned(i, 16));
            rw_din <= std_logic_vector(to_unsigned(i, 16));
            wait for 10 us;

            clk <= '1';
            wait for 10 us;

        end loop;

        rw_we <= '0';
        for i in 0 to 15 loop

            clk <= '0';
            rw_addr <= std_logic_vector(to_unsigned(i, 16));
            r_addr <= std_logic_vector(to_unsigned(15-i, 16));
            wait for 10 us;

            clk <= '1';
            wait for 10 us;
            assert rw_dout = std_logic_vector(to_unsigned(i, 16)) report "RW port did not read expected value" severity ERROR;
            assert r_dout = std_logic_vector(to_unsigned(15-i, 16)) report "R port did not read expected value" severity ERROR;

        end loop;
        

        wait;
    end process;
end behavioural;
