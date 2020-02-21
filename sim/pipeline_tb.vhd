library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.common.all;

entity pipeline_tb is
--  Port ( );
end pipeline_tb;

architecture Behavioral of pipeline_tb is

    component DecodeStage
        Port (
            instr: in std_logic_vector(15 downto 0);
            write_idx: out unsigned(2 downto 0);
            read_idx_1: out unsigned(2 downto 0);
            read_idx_2: out unsigned(2 downto 0);
            opcode: out opcode_t;
            shift_amt: out unsigned(3 downto 0);
            immediate: out std_logic_vector(7 downto 0);
            imm_high: out std_logic);
    end component;
    
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
            wr_enable: in std_logic);
    end component;
    
    component ExecuteStage
        Port(
            input: in execute_latch_t;
            write_data: out std_logic_vector(15 downto 0));
    end component;
    
    component WriteBack
        Port (
            opcode: in opcode_t;
            write_enable: out std_logic);
    end component;
    
    signal clk, rst: std_logic;
        
    signal fetched_instruction: std_logic_vector(15 downto 0);
    
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
    
    signal execute_latch: execute_latch_t;
    
    -- signals from execute stage
    signal write_data: std_logic_vector(15 downto 0);
    
    signal writeback_latch: writeback_latch_t;
    
    signal reg_write_enable: std_logic;

begin

    decode_stage: DecodeStage port map (
        instr => fetched_instruction,
        write_idx => write_idx,
        read_idx_1 => read_idx_1,
        read_idx_2 => read_idx_2,
        opcode => decode_opcode,
        shift_amt => shift_amt,
        immediate => immediate,
        imm_high => imm_high);
    
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
        wr_data => writeback_latch.write_data,
        wr_enable => reg_write_enable);
    
    execute_stage: ExecuteStage port map (
        input => execute_latch,
        write_data => write_data);
        
    writeback_stage: WriteBack port map (
        opcode => writeback_latch.opcode,
        write_enable => reg_write_enable);

    -- process for pipeline latches
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
            writeback_latch <= (
                opcode => op_nop,
                write_idx => (others => '0'),
                write_data => (others => '0'));
        elsif rising_edge(clk) then
            execute_latch <= (
                opcode => decode_opcode,
                data_1 => read_data_1,
                data_2 => read_data_2,
                write_idx => write_idx,
                shift_amt => shift_amt,
                immediate => immediate,
                imm_high => imm_high);
            writeback_latch <= (
                opcode => execute_latch.opcode,
                write_idx => execute_latch.write_idx,
                write_data => write_data);
        end if;
    end process;

    -- clock process
    process begin
        clk <= '0';
        wait for 10 us;
        clk <= '1';
        wait for 10 us;
    end process;

    process begin
        rst <= '1';
        fetched_instruction <= (others => '0');
        wait until rising_edge(clk);
        wait until falling_edge(clk);
        rst <= '0';

        wait until rising_edge(clk);
        
        fetched_instruction <= "0010010" & "0" & x"07";
        wait until rising_edge(clk);
        fetched_instruction <= (others => '0'); -- nop
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        fetched_instruction <= "0010010" & "1" & x"ff";
        wait until rising_edge(clk);
        fetched_instruction <= (others => '0'); -- nop
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        wait;
    end process;

end Behavioral;
