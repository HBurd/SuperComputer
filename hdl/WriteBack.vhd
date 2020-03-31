library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;


entity WriteBack is
    Port (
        input: in writeback_latch_t;
        write_enable: out std_logic;
        data_fwd: out feedback_t);
end WriteBack;

architecture Behavioral of WriteBack is

begin

        write_enable <= input.memory_output_data.will_write;
        data_fwd <= input.memory_output_data;
        
end Behavioral;
