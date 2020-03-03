
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
port(
    rst : in std_logic; 
    clk: in std_logic;
    --read signals
    rd_index1: in std_logic_vector(2 downto 0); 
    rd_index2: in std_logic_vector(2 downto 0); 
    rd_data1: out std_logic_vector(15 downto 0); 
    rd_data2: out std_logic_vector(15 downto 0);
    --write signals
    wr_index: in std_logic_vector(2 downto 0);
    wr_data: in std_logic_vector(15 downto 0); 
    wr_enable: in std_logic;
    --pending signals
    mark_pending_index: in std_logic_vector(2 downto 0);
    mark_pending: in std_logic;
    ridx1_pending: out std_logic;
    ridx2_pending: out std_logic
 );
    
end register_file;

architecture behavioural of register_file is

type reg_t is record
    data: std_logic_vector(15 downto 0);
    pending: std_logic;
end record reg_t;

type reg_array is array (integer range 0 to 7) of reg_t;
--internals signals
signal reg_file : reg_array; begin
--write operation 
process(clk, rst)
begin
    if rst = '1' then
        reg_file <= (others => (data => (others => '0'), pending => '0'));
    elsif rising_edge(clk) then
        if (wr_enable = '1') then
            reg_file(to_integer(unsigned(wr_index))) <= (data => wr_data, pending => '0');
        end if;
        -- statements in a process execute sequentially, so this should take
        -- care of the case where the flag is set and cleared on the same cycle
        if (mark_pending = '1') then
            reg_file(to_integer(unsigned(mark_pending_index))).pending <= '1';
        end if;
    end if; 
end process;

--read operation
rd_data1 <=	reg_file(to_integer(unsigned(rd_index1))).data;

rd_data2 <=	reg_file(to_integer(unsigned(rd_index2))).data;

ridx1_pending <= reg_file(to_integer(unsigned(rd_index1))).pending;
ridx2_pending <= reg_file(to_integer(unsigned(rd_index2))).pending;

end behavioural;