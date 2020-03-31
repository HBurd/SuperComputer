library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity ExecuteStage is
    Port(
        input: in execute_latch_t;
        n_old: in std_logic;
        z_old: in std_logic;
        o_old: in std_logic;
        n_next: out std_logic;
        z_next: out std_logic;
        o_next: out std_logic;
        pc_overwrite: out std_logic;
        pc_value: out std_logic_vector(15 downto 0);
        data_fwd: out feedback_t;
        overflow_word_old: in std_logic_vector(15 downto 0);
        overflow_word_next: out std_logic_vector(15 downto 0));
end ExecuteStage;

architecture Behavioral of ExecuteStage is

    component Alu
        Port (
            in1 : in STD_LOGIC_VECTOR (15 downto 0);
            in2 : in STD_LOGIC_VECTOR (15 downto 0);
            alu_mode : in alu_mode_t;
            result : out STD_LOGIC_VECTOR (31 downto 0);
            z_flag : out STD_LOGIC;
            n_flag : out STD_LOGIC;
            o_flag : out STD_LOGIC);
    end component;
    
    signal alu_mode: alu_mode_t;
    signal alu_in_1: std_logic_vector(15 downto 0);
    signal alu_in_2: std_logic_vector(15 downto 0);
    signal alu_result: std_logic_vector(31 downto 0);
    signal write_data_internal: std_logic_vector(15 downto 0);
    signal will_write: std_logic;
    
    signal alu_n, alu_z, alu_o: std_logic;
    
begin

    exec_alu: Alu port map(
        alu_mode => alu_mode,
        in1 => alu_in_1,
        in2 => alu_in_2,
        result => alu_result,
        z_flag => alu_z,
        n_flag => alu_n,
        o_flag => alu_o
    );

    alu_mode <= alu_add when input.opcode = op_add
                          or input.opcode = op_brr
                          or input.opcode = op_brr_n
                          or input.opcode = op_brr_z
                          or input.opcode = op_brr_o
                          or input.opcode = op_br
                          or input.opcode = op_br_n
                          or input.opcode = op_br_z
                          or input.opcode = op_br_o
                          or input.opcode = op_br_sub else
                alu_sub when input.opcode = op_sub else
                alu_mul when input.opcode = op_mul or input.opcode = op_muh else
                alu_nand when input.opcode = op_nand else
                alu_shl when input.opcode = op_shl else
                alu_shr when input.opcode = op_shr else
                alu_test when input.opcode = op_test else
                alu_nop;

    alu_in_1 <= input.data_1;
    alu_in_2 <= input.data_2;

    write_data_internal <= alu_result(31 downto 16) when input.opcode = op_muh else
        input.data_1(15 downto 8) & input.data_2(7 downto 0) when (input.opcode = op_loadimm and input.imm_high = '0') else
        input.data_2(7 downto 0) & input.data_1(7 downto 0) when (input.opcode = op_loadimm and input.imm_high = '1') else
        input.data_1 when (input.opcode = op_mov) else
        std_logic_vector(input.next_pc) when input.opcode = op_br_sub else
        overflow_word_old when ((input.opcode = op_br_o or input.opcode = op_brr_o) and o_old = '1') else
        alu_result(15 downto 0);

    n_next <= alu_n when input.opcode = op_test else n_old;
    z_next <= alu_z when input.opcode = op_test else z_old;
    o_next <= alu_o when input.opcode = op_mul else o_old;

    overflow_word_next <= alu_result(31 downto 16) when input.opcode = op_mul else overflow_word_old;

    pc_overwrite <= '1' when input.opcode = op_brr or input.opcode = op_br or input.opcode = op_br_sub or input.opcode = op_return
                    or ((input.opcode = op_brr_n or input.opcode = op_br_n) and n_old = '1')
                    or ((input.opcode = op_brr_z or input.opcode = op_br_z) and z_old = '1')
                    or ((input.opcode = op_brr_o or input.opcode = op_br_o) and o_old = '1')
                else '0';

    pc_value <= input.data_1 when input.opcode = op_return else
        alu_result(15 downto 0);
        
    -- Forwarding
    will_write <= '1' when input.opcode = op_add
                          or input.opcode = op_sub
                          or input.opcode = op_mul
                          or input.opcode = op_nand
                          or input.opcode = op_shl
                          or input.opcode = op_shr
                          or input.opcode = op_in
                          or input.opcode = op_br_sub
                          or input.opcode = op_load
                          or input.opcode = op_loadimm
                          or input.opcode = op_mov
                          or ((input.opcode = op_brr_o or input.opcode = op_br_o) and o_old = '1')
                      else '0';
    data_fwd.will_write <= will_write;
    data_fwd.ready <= '1' when input.opcode /= op_in and input.opcode /= op_load and will_write = '1' else '0';
    data_fwd.idx <= input.write_idx;
    data_fwd.data <= write_data_internal;

end Behavioral;
