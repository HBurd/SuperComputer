library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipeline is
  Port (
    rst_ex : in std_logic;
    rst_ld : in std_logic;
    clk : in std_logic;
    
    -- instruction memory interface
    iaddr : out std_logic_vector(15 downto 0);
    iread : in std_logic_vector(15 downto 0);
    
    -- data memory interface
    daddr : out std_logic_vector(15 downto 0);
    dwen : out std_logic;
    dwrite : out std_logic_vector(15 downto 0);
    dread : in std_logic_vector(15 downto 0)
   );
end pipeline;

architecture Behavioral of pipeline is

    component Feedback
        Port(
            rst : in std_logic; 
            clk: in std_logic;
            --read signals
            rd_index1: in unsigned(2 downto 0);
            rd_index2: in unsigned(2 downto 0);
            rd_data1: out std_logic_vector(15 downto 0);
            rd_data2: out std_logic_vector(15 downto 0);
            -- pipeline control
            bubble: out std_logic;
            -- feedback from stages
            ex_fb : in feedback_t;
            mem_fb: in feedback_t;
            wb_fb: in feedback_t
            );
    end component;

    component DecodeStage
        Port (
            input: decode_latch_t;
            write_idx: out unsigned(2 downto 0);
            read_idx_1: out unsigned(2 downto 0);
            read_idx_2: out unsigned(2 downto 0);
            read_data_1: in std_logic_vector(15 downto 0);
            read_data_2: in std_logic_vector(15 downto 0);
            opcode: out opcode_t;
            data_1: out std_logic_vector(15 downto 0);
            data_2: out std_logic_vector(15 downto 0);
            imm_high: out std_logic);
    end component;
    
    component ExecuteStage
        Port(
            input: in execute_latch_t;
            write_data: out std_logic_vector(15 downto 0);
            n: in std_logic;
            z: in std_logic;
            n_next: out std_logic;
            z_next: out std_logic;
            nz_update: out std_logic;
            pc_overwrite: out std_logic;
            pc_value: out std_logic_vector(15 downto 0);
            data_fwd: out feedback_t);
    end component;
    
    component MemoryStage
        Port(
            input: in memory_latch_t;
            output_data: out std_logic_vector(15 downto 0);
            daddr: out std_logic_vector(15 downto 0);
            dwen: out std_logic;
            dwrite: out std_logic_vector(15 downto 0);
            dread: in std_logic_vector(15 downto 0);
            data_fwd: out feedback_t);
    end component;
    
    component WriteBack
        Port (
            input: in writeback_latch_t;
            write_enable: out std_logic;
            data_fwd: out feedback_t);
    end component;
    
    signal rst: std_logic;
    
    signal program_counter : std_logic_vector(15 downto 0);
    signal next_program_counter: std_logic_vector(15 downto 0);
    
    signal decode_latch: decode_latch_t;
    
    -- signals from decode stage
    signal write_idx: unsigned(2 downto 0);
    signal read_idx_1: unsigned(2 downto 0);
    signal read_idx_2: unsigned(2 downto 0);
    signal decode_opcode: opcode_t;
    signal decode_data_1: std_logic_vector(15 downto 0);
    signal decode_data_2: std_logic_vector(15 downto 0);
    signal read_data_1: std_logic_vector(15 downto 0);
    signal read_data_2: std_logic_vector(15 downto 0);
    signal imm_high: std_logic;
    signal bubble: std_logic;
    signal mark_pending, ridx1_pending, ridx2_pending: std_logic;

    
    -- signals from execute stage
    signal execute_latch: execute_latch_t;
    signal execute_output_data: std_logic_vector(15 downto 0);
    signal n, n_next, z, z_next, nz_update: std_logic;
    signal pc_overwrite: std_logic;
    signal pc_value: std_logic_vector(15 downto 0);
    signal branch_mispredict: std_logic;
    signal ex_fb: feedback_t;
    
    -- signals from memory stage
    signal memory_latch: memory_latch_t;
    signal memory_output_data: std_logic_vector(15 downto 0);
    signal mem_fb: feedback_t;
    
    -- signals from writeback stage
    signal writeback_latch: writeback_latch_t;
    signal reg_write_enable: std_logic;
    signal writeback_data: std_logic_vector(15 downto 0);
    signal wb_fb: feedback_t;


begin

rst <= '1' when rst_ex = '1' or rst_ld = '1' else '0';

decode_stage: DecodeStage port map (
    input => decode_latch,
    write_idx => write_idx,
    read_idx_1 => read_idx_1,
    read_idx_2 => read_idx_2,
    read_data_1 => read_data_1,
    read_data_2 => read_data_2,
    data_1 => decode_data_1,
    data_2 => decode_data_2,
    opcode => decode_opcode,
    imm_high => imm_high);

feed_back: FeedBack port map (
    rst => rst,
    clk => clk,
    --read signals
    rd_index1 => read_idx_1,
    rd_index2 => read_idx_2,
    rd_data1 => read_data_1,
    rd_data2 => read_data_2,
    bubble => bubble,
    --write signals
    ex_fb => ex_fb,
    mem_fb => mem_fb,
    wb_fb => wb_fb);

execute_stage: ExecuteStage port map (
    input => execute_latch,
    write_data => execute_output_data,
    n => n,
    z => z,
    n_next => n_next,
    z_next => z_next,
    nz_update => nz_update,
    pc_overwrite => pc_overwrite,
    pc_value => pc_value,
    data_fwd => ex_fb);

memory_stage: MemoryStage port map (
    input => memory_latch,
    output_data => memory_output_data,
    daddr => daddr,
    dwen => dwen,
    dwrite => dwrite,
    dread => dread,
    data_fwd => mem_fb);

writeback_stage: WriteBack port map (
    input => writeback_latch,
    write_enable => reg_write_enable,
    data_fwd => wb_fb);

-- deal with the program counter

iaddr <= program_counter;

next_program_counter <= std_logic_vector(unsigned(program_counter) + x"0002");

process(clk, rst) begin
    if rst_ex = '1' then
        program_counter <= (others => '0');
    elsif rst_ld = '1' then
        program_counter <= x"0002";
    elsif rising_edge(clk) then
        if (pc_overwrite = '1') then
            program_counter <= pc_value;
        else
            if (bubble = '1') then
                program_counter <= program_counter;
            else
                program_counter <= next_program_counter;
            end if;
        end if;
    end if;
end process;

-- n and z flags from the execute stage
process (clk, rst) begin
    if rst = '1' then
        n <= '0';
        z <= '0';
    elsif rising_edge(clk) then
        if (nz_update = '1') then
            n <= n_next;
            z <= z_next;
        end if;
    end if;
end process;

-- if branch is mispredicted, we need to stop the execute latch from being loaded with the 
-- wrong instruction and prevent the pending flags from being set wrong

branch_mispredict <= pc_overwrite; -- assume branches aren't taken

-- process to update latches on clock edge
process(clk, rst, pc_overwrite) begin
    if rst = '1' then
        decode_latch <= (
            instr => (others => '0'),
            pc => (others => '0'),
            next_pc => x"0002");
        execute_latch <= (
            opcode => op_nop,
            data_1 => (others => '0'),
            data_2 => (others => '0'),
            next_pc => x"0002",
            write_idx => (others => '0'),
            imm_high => '0');
        memory_latch <= (
            opcode => op_nop,
            src => (others => '0'),
            dest => (others => '0'),
            write_idx => (others => '0'),
            execute_output_data => (others => '0'));
        writeback_latch <= (
            opcode => op_nop,
            write_idx => (others => '0'),
            memory_output_data => (others => '0'));
    elsif rising_edge(clk) then
        if (pc_overwrite = '1') then
            decode_latch <= (
                instr => (others => '0'),
                pc => unsigned(program_counter),
                next_pc => unsigned(next_program_counter));
        else
            decode_latch <= (
                instr => iread,
                pc => unsigned(program_counter),
                next_pc => unsigned(next_program_counter));
        end if;
        if (pc_overwrite = '1' or bubble = '1') then
            execute_latch <= (
                opcode => op_nop,
                data_1 => (others => '0'),
                data_2 => (others => '0'),
                next_pc => decode_latch.next_pc,
                write_idx => (others => '0'),
                imm_high => '0');
        else
            execute_latch <= (
                opcode => decode_opcode,
                data_1 => decode_data_1,
                data_2 => decode_data_2,
                next_pc => decode_latch.next_pc,
                write_idx => write_idx,
                imm_high => imm_high);
        end if;
        memory_latch <= (
            opcode => execute_latch.opcode,
            src => execute_latch.data_1,
            dest => execute_latch.data_2,
            write_idx => execute_latch.write_idx,
            execute_output_data => execute_output_data);
        writeback_latch <= (
            opcode => memory_latch.opcode,
            write_idx => memory_latch.write_idx,
            memory_output_data => memory_output_data);
    end if;
end process;


end Behavioral;
