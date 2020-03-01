library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;


entity WriteBack is
    Port (
        input: in writeback_latch_t;
        write_enable: out std_logic;
        writeback_data: out std_logic_vector(15 downto 0);
        pc_overwrite: out std_logic;
        pc_value: out std_logic_vector(15 downto 0);
        N: out std_logic;
        Z: out std_logic;
        NZ_overwrite: out std_logic);
end WriteBack;

architecture Behavioral of WriteBack is

begin
        write_enable <= '1' when (input.opcode = op_add
                                or input.opcode = op_sub
                                or input.opcode = op_mul
                                or input.opcode = op_muh
                                or input.opcode = op_nand
                                or input.opcode = op_shl
                                or input.opcode = op_shr
                                or input.opcode = op_in
                                or input.opcode = op_br_sub
                                or input.opcode = op_load
                                or input.opcode = op_loadimm
                                or input.opcode = op_mov)
        else '0';

        writeback_data <= input.execute_output_data when (
                            input.opcode = op_add
                         or input.opcode = op_sub
                         or input.opcode = op_mul
                         or input.opcode = op_muh
                         or input.opcode = op_nand
                         or input.opcode = op_shl
                         or input.opcode = op_shr
                         or input.opcode = op_loadimm
                         or input.opcode = op_mov)
            else input.memory_output_data when (
                                input.opcode = op_in
                             or input.opcode = op_load) 
            else (others => '0');
                           
        pc_overwrite <= '1' when input.opcode = op_brr or input.opcode = op_br
            else '0';

        pc_value <= input.execute_output_data; -- use this for branch instructions

        N <= input.N;
        Z <= input.Z;
        NZ_overwrite <= '1' when (input.opcode = op_test) else '0';
end Behavioral;
