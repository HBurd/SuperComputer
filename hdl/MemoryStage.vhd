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
    -- we read from the source during a load
    -- and write to the destination during a store
    daddr <= input.src when (input.opcode = op_load) else
             input.dest;
    
    -- we only ever write from the source register 
    dwrite <= input.src;
    
    dwen <= '1' when (input.opcode = op_store) else
            '0';
    
    -- copy data_1 through unless we're loading new data from memory
    output_data <= dread when (input.opcode = op_load) else input.src;

end behavioral;
