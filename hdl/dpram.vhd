library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

-- defines a ram with one read-write port and one read-only port
-- it has a read latency of 0 cycles
-- its reset line synchronously resets the read buffer

entity dpram is
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
end dpram;


architecture behavioral of dpram is
    type memarr is array(0 to MEMORY_SIZE/16) of std_logic_vector(READ_DATA_WIDTH-1 downto 0);

    signal mem : memarr;

begin

    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rw_dout <= (others => '0');
                r_dout <= (others => '0');
            else
                rw_dout <= mem(to_integer(unsigned(rw_addr)));
                r_dout <= mem(to_integer(unsigned(r_addr)));
                if rw_we = '1' then
                    mem(to_integer(unsigned(rw_addr))) <= rw_din;
                end if;
            end if;
        end if;
    end process;

end behavioral;
