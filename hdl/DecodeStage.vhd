----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2020 03:41:19 PM
-- Design Name: 
-- Module Name: DecodeStage - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.common.all;

entity DecodeStage is
    Port (
        instr: in std_logic_vector(15 downto 0);
        write_idx: out unsigned(2 downto 0);
        read_idx_1: out unsigned(2 downto 0);
        read_idx_2: out unsigned(2 downto 0);
        opcode: out opcode_t;
        shift_amt: out unsigned(3 downto 0);
        immediate: out std_logic_vector(7 downto 0);
        imm_high: out std_logic
    );
end DecodeStage;

architecture Behavioral of DecodeStage is

-- fmt a4 isn't in the spec, but the out instruction effectively has its own format because 'ra' specifies a read index rather than a write index
type instr_fmt_t is (fmt_a0, fmt_a1, fmt_a2, fmt_a3, fmt_a4, fmt_b1, fmt_b2, fmt_l1, fmt_l2, fmt_invalid);

signal opcode_unsigned: unsigned(6 downto 0);
signal opcode_internal: opcode_t;
signal instr_fmt: instr_fmt_t;

begin

opcode_unsigned <= unsigned(instr(15 downto 9));
opcode_internal <=
    op_nop when opcode_unsigned = 0 else
    op_add when opcode_unsigned = 1 else
    op_sub when opcode_unsigned = 2 else
    op_mul when opcode_unsigned = 3 else
    op_nand when opcode_unsigned = 4 else
    op_shl when opcode_unsigned = 5 else
    op_shr when opcode_unsigned = 6 else
    op_test when opcode_unsigned = 7 else
    op_muh when opcode_unsigned = 8 else
    op_out when opcode_unsigned = 32 else
    op_in when opcode_unsigned = 33 else
    op_brr when opcode_unsigned = 64 else
    op_brr_n when opcode_unsigned = 65 else
    op_brr_z when opcode_unsigned = 66 else
    op_br when opcode_unsigned = 67 else
    op_br_n when opcode_unsigned = 68 else
    op_br_z when opcode_unsigned = 69 else
    op_br_sub when opcode_unsigned = 70 else
    op_return when opcode_unsigned = 71 else
    op_load when opcode_unsigned = 16 else
    op_store when opcode_unsigned = 17 else
    op_loadimm when opcode_unsigned = 18 else
    op_mov when opcode_unsigned = 19 else
    op_invalid;

instr_fmt <=
    fmt_a0 when (opcode_internal = op_nop or opcode_internal = op_return) else
    fmt_a1 when (opcode_internal = op_add or opcode_internal = op_sub or opcode_internal = op_mul or opcode_internal = op_muh or opcode_internal = op_nand) else
    fmt_a2 when (opcode_internal = op_shl or opcode_internal = op_shr) else
    fmt_a3 when (opcode_internal = op_in) else
    fmt_a4 when (opcode_internal = op_test or opcode_internal = op_out) else
    fmt_b1 when (opcode_internal = op_brr or opcode_internal = op_brr_n or opcode_internal = op_brr_z) else
    fmt_b2 when (opcode_internal = op_br or opcode_internal = op_br_n or opcode_internal = op_br_z or opcode_internal = op_br_sub) else
    fmt_l1 when (opcode_internal = op_loadimm) else
    fmt_l2 when (opcode_internal = op_load or opcode_internal = op_store or opcode_internal = op_mov) else
    fmt_invalid;

opcode <= opcode_internal;
write_idx <= unsigned(instr(8 downto 6)) when (instr_fmt = fmt_a1 or instr_fmt = fmt_a2 or instr_fmt = fmt_a3 or instr_fmt = fmt_b2 or instr_fmt = fmt_l2)
    else "111" when instr_fmt = fmt_l1
    else (others => '0');
read_idx_1 <= unsigned(instr(5 downto 3)) when (instr_fmt = fmt_a1 or instr_fmt = fmt_l2)
    else unsigned(instr(8 downto 6)) when (instr_fmt = fmt_a4 or instr_fmt = fmt_a2)
    else "111" when instr_fmt = fmt_l1  -- loadimm loads into r7
    else (others => '0');
read_idx_2 <= unsigned(instr(2 downto 0)) when (instr_fmt = fmt_a1)
    else unsigned(instr(8 downto 6)) when (instr_fmt = fmt_l2)
    else (others => '0');

shift_amt <= unsigned(instr(3 downto 0)) when (instr_fmt = fmt_a2) else (others => '0');

immediate <= instr(7 downto 0);
imm_high <= instr(8);

end Behavioral;
