library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

-- defines a single port read only memory
-- it has a read latency of 0 cycles
-- its reset line synchronously resets the read buffer

entity sprom is
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
end sprom;


architecture behavioral of sprom is
    type memarr is array(0 to MEMORY_SIZE/16) of std_logic_vector(READ_DATA_WIDTH-1 downto 0);

    impure function load_from_file(filename : string) return memarr is
        file f : text;
        variable cur : line;
        variable word : std_logic_vector(READ_DATA_WIDTH - 1 downto 0);
        variable result : memarr := (others => (others => '0'));
    begin
        if (filename /= "none") then
            file_open(f, filename);
            for i in 0 to MEMORY_SIZE/16 loop
                exit when endfile(f);
                readline(f, cur);
                hread(cur, word);
                result(i) := std_logic_vector(resize(unsigned(word), READ_DATA_WIDTH));
            end loop;
        end if;

        return result;
    end function;

    signal mem : memarr := load_from_file(MEMORY_INIT_FILE);

begin
    process (clk, rst)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                dout <= (others => '0');
            else
                dout <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end behavioral;
