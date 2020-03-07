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

    signal will_write: std_logic;

begin
        will_write <= '1' when (input.opcode = op_add
                                or input.opcode = op_sub
                                or input.opcode = op_mul
                                or input.opcode = op_muh
                                or input.opcode = op_nand
                                or input.opcode = op_shl
                                or input.opcode = op_shr
                                or input.opcode = op_in
                                or input.opcode = op_br_sub  -- subroutine saves PC to R7
                                or input.opcode = op_load
                                or input.opcode = op_loadimm
                                or input.opcode = op_mov)
            else '0';

        write_enable <= will_write;
        
        -- Forwarding
        data_fwd.will_write <= will_write;
        data_fwd.ready <= will_write;
        data_fwd.idx <= input.write_idx;
        data_fwd.data <= input.memory_output_data;
        
end Behavioral;
