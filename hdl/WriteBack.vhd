library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;


entity WriteBack is
    Port (
        opcode: in opcode_t;
        write_enable: out std_logic);
end WriteBack;

architecture Behavioral of WriteBack is

begin
    write_enable <= '1' when (opcode = op_add
                              or opcode = op_sub
                              or opcode = op_mul
                              or opcode = op_nand
                              or opcode = op_shl
                              or opcode = op_shr
                              or opcode = op_in
                              or opcode = op_loadimm
                              or opcode = op_br_sub
                              or opcode = op_load
                              or opcode = op_loadimm
                              or opcode = op_mov)
        else '0';

end Behavioral;
