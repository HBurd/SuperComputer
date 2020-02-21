----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2020 04:17:06 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity top is
Port (
    sw : in STD_LOGIC_VECTOR(15 downto 0);
    CLK100MHZ : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR(15 downto 0);
    an : out std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0);
    io_in: in std_logic_vector(15 downto 0);
    io_out: out std_logic_vector(15 downto 0);
);
end top;

architecture Behavioral of top is

    component display_controller
        Port(clk, reset: in std_logic;
            hex3, hex2, hex1, hex0: in std_logic_vector(3 downto 0);
            an: out std_logic_vector(3 downto 0);
            sseg: out std_logic_vector(6 downto 0));
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

    component MemoryStage
        Port(
            input: in memory_latch_t;
            output_data: out std_logic_vector(15 downto 0);
            daddr: out std_logic_vector(15 downto 0);
            dwen: out std_logic_vector(15 downto 0);
            dwrite: out std_logic_vector(15 downto 0);
            dread: in std_logic_vector(15 downto 0));
    end component;
    
    component WriteBack
        Port (
            opcode: in opcode_t;
            write_enable: out std_logic);
    end component;

    component mmu
        Port(
            clk: in std_logic;
            rst: in std_logic;
            err: out std_logic;
            -- instruction port
            iaddr: in std_logic_vector(15 downto 0);
            iout: out std_logic_vector(15 downto 9);
            -- data port
            daddr: in std_logic_vector(15 downto 0);
            dwen: in std_logic; -- write when 1, read when 0
            dwrite: in std_logic_vector(15 downto 0); -- used when dwen = 1
            dread: out std_logic_vector(15 downto 0); -- valid when dwen = 0
            -- i/o ports
            io_in: in std_logic_vector(15 downto 0);
            io_out: out std_logic_vector(15 downto 0));
    end component;
    
    signal count : unsigned(63 downto 0);
    
    signal dig0 : std_logic_vector(3 downto 0);
    signal dig1 : std_logic_vector(3 downto 0);
    signal dig2 : std_logic_vector(3 downto 0);
    signal dig3 : std_logic_vector(3 downto 0);
    
    signal clk, rst: std_logic;

    signal program_counter : std_logic_vector(15 downto 0);    
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
    
    -- signals from execute stage
    signal execute_latch: execute_latch_t;
    signal execute_output_data: std_logic_vector(15 downto 0);

    -- signals from memory stage
    signal memory_latch: memory_latch_t;
    signal memory_output_data: std_logic_vector(15 downto 0);
    signal daddr: std_logic_vector(15 downto 0);
    signal dwen: std_logic_vector(15 downto 0);
    signal dwrite: std_logic_vector(15 downto 0);
    signal dread: std_logic_vector(15 downto 0);
        
    signal writeback_latch: writeback_latch_t;
    signal reg_write_enable: std_logic;

begin

clk <= count(16);
rst <= '0';

memory_unit : mmu port map(
    clk => clk,
    rst => rst,
    -- instruction port
    iaddr => program_counter,
    iout => fetched_instruction,
    -- data port
    daddr => daddr,
    dwen => dwen,
    dwrite => dwrite,
    dread => dread,
    -- I/O ports
    io_in => io_in,
    io_out => io_out);

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
    write_data => execute_output_data);

memory_stage: MemoryStage port map (
    input => memory_latch,
    output_data => memory_output_data,
    daddr => daddr,
    dwen => dwen,
    dwrite => dwrite,
    dread => dread);

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
        memory_latch <= (
            opcode => op_nop,
            src => (others => '0');
            dest => (others => '0'));
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
        memory_latch <= (
            opcode => execute_latch.opcode,
            src => execute_latch.data_1,
            dest => execute_latch.data_2,
            write_idx => execute_latch.write_idx);
        writeback_latch <= (
            opcode => memory_latch.opcode,
            write_idx => memory_latch.write_idx,
            write_data => memory_output_data);
    end if;
end process;
    
dig0 <= std_logic_vector(execute_output_data(3 downto 0));
dig1 <= std_logic_vector(execute_output_data(7 downto 4));
dig2 <= std_logic_vector(execute_output_data(11 downto 8));
dig3 <= std_logic_vector(execute_output_data(15 downto 12));

D0: display_controller port map (clk,
                                 '0',
                                 dig3,
                                 dig2,
                                 dig1,
                                 dig0,
                                 an,
                                 seg);

process (clk100MHz)
begin
    if rising_edge(CLK100MHZ) then
          led <= STD_LOGIC_VECTOR(count(39 downto 24));
          count <= count + 1;
    end if;
end process;



end Behavioral;
