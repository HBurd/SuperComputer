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
    seg : out std_logic_vector(6 downto 0)
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
            shift_amt: out unsigned(3 downto 0));
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
            input: in execute_input_t;
            write_data: out std_logic_vector(15 downto 0));
    end component;
    
    signal count : unsigned(63 downto 0);
    
    signal dig0 : std_logic_vector(3 downto 0);
    signal dig1 : std_logic_vector(3 downto 0);
    signal dig2 : std_logic_vector(3 downto 0);
    signal dig3 : std_logic_vector(3 downto 0);
    
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
    
    signal execute_input: execute_input_t;
    
    -- signals from execute stage
    signal write_data: std_logic_vector(15 downto 0);

begin

clk <= count(16);
rst <= '0';
fetched_instruction <= (others => '0');

decode_stage: DecodeStage port map (
    instr => fetched_instruction,
    write_idx => write_idx,
    read_idx_1 => read_idx_1,
    read_idx_2 => read_idx_2,
    opcode => decode_opcode,
    shift_amt => shift_amt);
    
reg_file: Register_File port map (
    rst => rst,
    clk => '0',
    --read signals
    rd_index1 => std_logic_vector(read_idx_1),
    rd_index2 => std_logic_vector(read_idx_2),
    rd_data1 => read_data_1,
    rd_data2 => read_data_2,
    --write signals
    wr_index => std_logic_vector(write_idx),
    wr_data => write_data,
    wr_enable => '0');
    
process(clk, rst) begin
    if rst = '1' then
        execute_input <= (
            opcode => op_nop,
            data_1 => (others => '0'),
            data_2 => (others => '0'),
            write_idx => (others => '0'),
            shift_amt => (others => '0'));
    elsif rising_edge(clk) then
        execute_input <= (
            opcode => decode_opcode,
            data_1 => read_data_1,
            data_2 => read_data_2,
            write_idx => write_idx,
            shift_amt => shift_amt);
    end if;
end process;
    
execute_stage: ExecuteStage port map (
    input => execute_input,
    write_data => write_data);
    

dig0 <= std_logic_vector(write_data(3 downto 0));
dig1 <= std_logic_vector(write_data(7 downto 4));
dig2 <= std_logic_vector(write_data(11 downto 8));
dig3 <= std_logic_vector(write_data(15 downto 12));

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
