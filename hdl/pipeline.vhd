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
    rst : in std_logic;
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

    component Register_File
        Port(
            rst : in std_logic; 
            clk: in std_logic;
            --read signals
            rd_index1: in std_logic_vector(2 downto 0);
            rd_index2: in std_logic_vector(2 downto 0);
            rd_data1: out std_logic_vector(15 downto 0);
            rd_data2: out std_logic_vector(15 downto 0);
            --write signals
            wr_index: in std_logic_vector(2 downto 0);
            wr_data: in std_logic_vector(15 downto 0);
            wr_enable: in std_logic;
            mark_pending_index: in std_logic_vector(2 downto 0);
            mark_pending: in std_logic;
            ridx1_pending: out std_logic;
            ridx2_pending: out std_logic);
    end component;

    component DecodeStage
        Port (
            instr: in std_logic_vector(15 downto 0);
            write_idx: out unsigned(2 downto 0);
            read_idx_1: out unsigned(2 downto 0);
            read_idx_2: out unsigned(2 downto 0);
            opcode: out opcode_t;
            shift_amt: out unsigned(3 downto 0);
            immediate: out std_logic_vector(7 downto 0);
            imm_high: out std_logic;
            mark_pending: out std_logic;
            ridx1_pending: in std_logic;
            ridx2_pending: in std_logic;
            bubble: out std_logic);
    end component;
    
    component ExecuteStage
        Port(
            input: in execute_latch_t;
            write_data: out std_logic_vector(15 downto 0);
            N: out std_logic;
            Z: out std_logic);
    end component;
    
    component MemoryStage
        Port(
            input: in memory_latch_t;
            output_data: out std_logic_vector(15 downto 0);
            daddr: out std_logic_vector(15 downto 0);
            dwen: out std_logic;
            dwrite: out std_logic_vector(15 downto 0);
            dread: in std_logic_vector(15 downto 0));
    end component;
    
    component WriteBack
        Port (
            input: in writeback_latch_t;
            write_enable: out std_logic;
            writeback_data: out std_logic_vector(15 downto 0);
            pc_overwrite: out std_logic;
            pc_value: out std_logic_vector(15 downto 0);
            N: out std_logic;
            Z: out std_logic;
            NZ_overwrite: out std_logic);
    end component;
    
    signal program_counter : std_logic_vector(15 downto 0);
    
    -- signals from decode stage
    signal write_idx: unsigned(2 downto 0);
    signal read_idx_1: unsigned(2 downto 0);
    signal read_idx_2: unsigned(2 downto 0);
    signal shift_amt: unsigned(3 downto 0);
    signal decode_opcode: opcode_t;
    signal read_data_1: std_logic_vector(15 downto 0);
    signal read_data_2: std_logic_vector(15 downto 0);
    signal immediate: std_logic_vector(7 downto 0);
    signal imm_high: std_logic;
    signal mark_pending: std_logic;
    signal bubble: std_logic;
    signal ridx1_pending: std_logic;
    signal ridx2_pending: std_logic;
    
    -- signals from execute stage
    signal execute_latch: execute_latch_t;
    signal execute_output_data: std_logic_vector(15 downto 0);
    signal execute_N, execute_Z: std_logic;

    -- signals from memory stage
    signal memory_latch: memory_latch_t;
    signal memory_output_data: std_logic_vector(15 downto 0);
    
    -- signals from writeback stage
    signal writeback_latch: writeback_latch_t;
    signal reg_write_enable: std_logic;
    signal writeback_data: std_logic_vector(15 downto 0);
    signal pc_overwrite: std_logic;
    signal pc_value: std_logic_vector(15 downto 0);
    signal N, Z, NZ_overwrite, N_latched, Z_latched: std_logic;
 

begin

decode_stage: DecodeStage port map (
    instr => iread,
    write_idx => write_idx,
    read_idx_1 => read_idx_1,
    read_idx_2 => read_idx_2,
    opcode => decode_opcode,
    shift_amt => shift_amt,
    immediate => immediate,
    imm_high => imm_high,
    mark_pending => mark_pending,
    ridx1_pending => ridx1_pending,
    ridx2_pending => ridx2_pending,
    bubble => bubble);

reg_file: Register_File port map (
    rst => rst,
    clk => clk,
    --read signals
    rd_index1 => std_logic_vector(read_idx_1),
    rd_index2 => std_logic_vector(read_idx_2),
    rd_data1 => read_data_1,
    rd_data2 => read_data_2,
    --write signals
    wr_index => std_logic_vector(writeback_latch.write_idx),
    wr_data => writeback_data,
    wr_enable => reg_write_enable,
    mark_pending_index => std_logic_vector(write_idx),
    mark_pending => mark_pending,
    ridx1_pending => ridx1_pending,
    ridx2_pending => ridx2_pending);

execute_stage: ExecuteStage port map (
    input => execute_latch,
    write_data => execute_output_data,
    N => execute_N,
    Z => execute_Z);

memory_stage: MemoryStage port map (
    input => memory_latch,
    output_data => memory_output_data,
    daddr => daddr,
    dwen => dwen,
    dwrite => dwrite,
    dread => dread);

writeback_stage: WriteBack port map (
    input => writeback_latch,
    write_enable => reg_write_enable,
    writeback_data => writeback_data,
    pc_overwrite => pc_overwrite,
    pc_value => pc_value,
    N => N,
    Z => Z,
    NZ_overwrite => NZ_overwrite);

-- deal with the program counter

iaddr <= program_counter;

process(clk, rst) begin
    if rst = '1' then
        program_counter <= (others => '0');
    elsif rising_edge(clk) then
        if (pc_overwrite = '1') then
            program_counter <= pc_value;
        else
            if (bubble = '1') then
                program_counter <= program_counter;
            else
                program_counter <= std_logic_vector(unsigned(program_counter) + x"0002");
            end if;
        end if;
    end if;
end process;

-- store the N and Z flags
process(clk, rst) begin
    if rst = '1' then
        N_latched <= '0';
        Z_latched <= '0';
    elsif rising_edge(clk) then
        if (NZ_overwrite = '1') then
            N_latched <= N;
            Z_latched <= Z;
        end if;
    end if;
end process;
    
-- process to update pipeline latches
process(clk, rst) begin
    if rst = '1' then
        execute_latch <= (
            opcode => op_nop,
            data_1 => (others => '0'),
            data_2 => (others => '0'),
            write_idx => (others => '0'),
            shift_amt => (others => '0'),
            immediate => (others => '0'),
            imm_high => '0');
        memory_latch <= (
            opcode => op_nop,
            src => (others => '0'),
            dest => (others => '0'),
            write_idx => (others => '0'),
            N => '0',
            Z => '0',
            execute_output_data => (others => '0'));
        writeback_latch <= (
            opcode => op_nop,
            write_idx => (others => '0'),
            execute_output_data => (others => '0'),
            N => '0',
            Z => '0',
            memory_output_data => (others => '0'));
    elsif rising_edge(clk) then
        execute_latch <= (
            opcode => decode_opcode,
            data_1 => read_data_1,
            data_2 => read_data_2,
            write_idx => write_idx,
            shift_amt => shift_amt,
            immediate => immediate,
            imm_high => imm_high);
        memory_latch <= (
            opcode => execute_latch.opcode,
            src => execute_latch.data_1,
            dest => execute_latch.data_2,
            write_idx => execute_latch.write_idx,
            N => execute_N,
            Z => execute_Z,
            execute_output_data => execute_output_data);
        writeback_latch <= (
            opcode => memory_latch.opcode,
            write_idx => memory_latch.write_idx,
            memory_output_data => memory_output_data,
            execute_output_data => memory_latch.execute_output_data,
            N => memory_latch.N,
            Z => memory_latch.Z);
    end if;
end process;


end Behavioral;
