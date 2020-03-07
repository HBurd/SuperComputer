library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common is

    type alu_mode_t is (alu_nop, alu_add, alu_sub, alu_mul, alu_muh, alu_nand, alu_shl, alu_shr, alu_test);
    
    type opcode_t is (op_nop, op_add, op_sub, op_mul, op_muh, op_nand, op_shl, op_shr, op_test, op_out, op_in,
        op_brr, op_brr_n, op_brr_z, op_br, op_br_n, op_br_z, op_br_sub, op_return,
        op_load, op_store, op_loadimm, op_mov,
        op_invalid);
        
    type execute_latch_t is record
        opcode: opcode_t;
        data_1: std_logic_vector(15 downto 0);
        data_2: std_logic_vector(15 downto 0);
        next_pc: unsigned(15 downto 0);
        write_idx: unsigned(2 downto 0);
        imm_high: std_logic;
    end record execute_latch_t;

    type memory_latch_t is record
        opcode: opcode_t;
        src: std_logic_vector(15 downto 0);
        dest: std_logic_vector(15 downto 0);
        -- for later stages
        write_idx: unsigned(2 downto 0);
        execute_output_data: std_logic_vector(15 downto 0);
    end record memory_latch_t;
    
    type writeback_latch_t is record
        opcode: opcode_t;
        write_idx: unsigned(2 downto 0);
        execute_output_data: std_logic_vector(15 downto 0);
        memory_output_data: std_logic_vector(15 downto 0);
    end record writeback_latch_t;
    
    type feedback_t is record
        idx: std_logic_vector(2 downto 0);
        data: std_logic_vector(15 downto 0);
        ready: std_logic;
        will_write: std_logic;
    end record feedback_t;

end common;

package body common is

end common;
