library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.all;
use work.common.all;

entity sprom_tb is end sprom_tb;

architecture behavioural of sprom_tb is
    component sprom is 
        Generic(
        ADDR_WIDTH : natural;
        MEMORY_INIT_FILE : string;
        MEMORY_SIZE : natural;
        READ_DATA_WIDTH : natural
      );
      Port ( 
        clk : in std_logic;
        rst : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        dout : out std_logic_vector(READ_DATA_WIDTH-1 downto 0)
      );
    end component;

      signal clk : std_logic;
      signal rst : std_logic;
      signal addr : std_logic_vector(15 downto 0);
      signal dout : std_logic_vector(15 downto 0);
begin
    dut: sprom 
    generic map (
        ADDR_WIDTH => 16,
        MEMORY_INIT_FILE => "sim/sprom_contents.mem",
        MEMORY_SIZE => 16*16,
        READ_DATA_WIDTH => 16
    )
    port map(
        clk => clk,
        rst => rst,
        addr => addr,
        dout => dout
    );

    rst <= '0';

    process begin
        for i in 0 to 15 loop
            clk <= '0';
            addr <= std_logic_vector(to_unsigned(i, 16));
            wait for 10 us;
            clk <= '1';
            wait for 10 us;
        end loop;

        wait;
    end process;
end behavioural;
