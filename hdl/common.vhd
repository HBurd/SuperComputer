package common is

    type alu_mode_t is (alu_nop, alu_add, alu_sub, alu_mul, alu_nand, alu_shl, alu_shr, alu_test);
    
    type opcode_t is (op_nop, op_add, op_sub, op_mul, op_nand, op_shl, op_shr, op_test, op_out, op_in,
        op_brr, op_brr_n, op_brr_z, op_br, op_br_n, op_br_z, op_br_sub, op_return,
        op_load, op_store, op_loadimm, op_mov,
        op_invalid);

end common;

package body common is

end common;