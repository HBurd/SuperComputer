library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity MemoryStage is
    Port(
        input: in memory_latch_t;

        daddr: out std_logic_vector(15 downto 0);
        dwen: out std_logic;
        dwrite: out std_logic_vector(15 downto 0);
        dread: in std_logic_vector(15 downto 0);
        data_fwd: out feedback_t);
end MemoryStage;

architecture behavioral of MemoryStage is

    signal output_data_internal: std_logic_vector(15 downto 0);
    

begin
    -- we read from the address contained in the source register
    -- and write to the address contained in the destination register
    daddr <= input.src when (input.opcode = op_load) else
             x"FFF0" when (input.opcode = op_in) else
             x"FFF2" when (input.opcode = op_out) else
             input.dest;
    
    -- we only ever write the data from the source register
    dwrite <= input.src;
    
    dwen <= '1' when (input.opcode = op_store or input.opcode = op_out) else
            '0';

    -- copy data_1 through unless we're loading new data from memory
    output_data_internal <= dread when (input.opcode = op_load or input.opcode = op_in) else input.execute_output_data.data;

    data_fwd.will_write <= input.execute_output_data.will_write;
    data_fwd.ready <= input.execute_output_data.will_write;   -- After the mem stage we always know the value that will be written
    data_fwd.idx <= input.write_idx;
    data_fwd.data <= output_data_internal;

end behavioral;
