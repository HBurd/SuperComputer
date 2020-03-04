library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity MemoryStage is
    Port(
        input: in memory_latch_t;
        output_data: out std_logic_vector(15 downto 0);

        daddr: out std_logic_vector(15 downto 0);
        dwen: out std_logic;
        dwrite: out std_logic_vector(15 downto 0);
        dread: in std_logic_vector(15 downto 0));
end MemoryStage;

architecture behavioral of MemoryStage is

begin
    -- we read from the address contained in the source register
    -- and write to the address contained in the destination register
    daddr <= input.src when (input.opcode = op_load) else
             x"FFF0" when (input.opcode = op_in) else
             x"FFF2" when (input.opcode = op_out) else
             input.dest;
    
    -- we only ever write the data from the source register
    dwrite <= input.src;
    
    dwen <= '1' when (input.opcode = op_store) else
            '0';
    
    -- copy data_1 through unless we're loading new data from memory
    output_data <= dread when (input.opcode = op_load or input.opcode = op_in) else input.src;

end behavioral;
