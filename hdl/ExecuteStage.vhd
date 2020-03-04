library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity ExecuteStage is
    Port(
        input: in execute_latch_t;
        n: in std_logic;
        z: in std_logic;
        write_data: out std_logic_vector(15 downto 0);
        n_next: out std_logic;
        z_next: out std_logic;
        nz_update: out std_logic;
        pc_overwrite: out std_logic;
        pc_value: out std_logic_vector(15 downto 0));
end ExecuteStage;

architecture Behavioral of ExecuteStage is

    component Alu
        Port (
            in1 : in STD_LOGIC_VECTOR (15 downto 0);
            in2 : in STD_LOGIC_VECTOR (15 downto 0);
            alu_mode : in alu_mode_t;
            result : out STD_LOGIC_VECTOR (31 downto 0);
            z_flag : out STD_LOGIC;
            n_flag : out STD_LOGIC);
    end component;
    
    signal alu_mode: alu_mode_t;
    signal alu_in_1: std_logic_vector(15 downto 0);
    signal alu_in_2: std_logic_vector(15 downto 0);
    signal alu_result: std_logic_vector(31 downto 0);
    
begin

    exec_alu: Alu port map(
        alu_mode => alu_mode,
        in1 => alu_in_1,
        in2 => alu_in_2,
        result => alu_result,
        z_flag => z_next,
        n_flag => n_next
    );

    alu_mode <= alu_add when input.opcode = op_add
                          or input.opcode = op_brr
                          or input.opcode = op_brr_n
                          or input.opcode = op_brr_z
                          or input.opcode = op_br
                          or input.opcode = op_br_n
                          or input.opcode = op_br_z
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

    write_data <= alu_result(31 downto 16) when input.opcode = op_muh else
        input.data_1(15 downto 8) & input.data_2(7 downto 0) when (input.opcode = op_loadimm and input.imm_high = '0') else
        input.data_2(7 downto 0) & input.data_1(7 downto 0) when (input.opcode = op_loadimm and input.imm_high = '1') else
        input.data_1 when (input.opcode = op_mov or input.opcode = op_return) else
        alu_result(15 downto 0);
        
    nz_update <= '1' when alu_mode = alu_test else '0';
    
    pc_overwrite <= '1' when input.opcode = op_brr or input.opcode = op_br or input.opcode = op_br_sub or input.opcode = op_return
                    or ((input.opcode = op_brr_n or input.opcode = op_br_n) and n = '1')
                    or ((input.opcode = op_brr_z or input.opcode = op_br_z) and z = '1')
                else '0';
    
    pc_value <= alu_result(15 downto 0);

end Behavioral;
