library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity feedback is
  Port (
    clk: in std_logic;
    rst: in std_logic;
    -- requested register indices
    rd_index1: in unsigned(2 downto 0);
    rd_index2: in unsigned(2 downto 0);
    -- data delivered to execute stage
    rd_data1: out std_logic_vector(15 downto 0);
    rd_data2: out std_logic_vector(15 downto 0);
    -- pipeline control
    bubble: out std_logic;   
    -- feedback from later stages
    ex_fb: in feedback_t;
    mem_fb: in feedback_t;
    wb_fb: in feedback_t);
end feedback;

architecture Behavioral of feedback is

component register_file is
port(
    rst : in std_logic; 
    clk: in std_logic;
    --read signals
    rd_index1: in unsigned(2 downto 0); 
    rd_index2: in unsigned(2 downto 0); 
    rd_data1: out std_logic_vector(15 downto 0); 
    rd_data2: out std_logic_vector(15 downto 0);
    --write signals
    wr_index: in unsigned(2 downto 0);
    wr_data: in std_logic_vector(15 downto 0); 
    wr_enable: in std_logic
);
end component register_file;

signal reg_data1, reg_data2: std_logic_vector(15 downto 0);
signal ex_has_ridx1, ex_has_ridx2, 
       mem_has_ridx1, mem_has_ridx2,
       wb_has_ridx1, wb_has_ridx2 : std_logic;
       
signal ex_writes_to_ridx1, ex_writes_to_ridx2,
       mem_writes_to_ridx1, mem_writes_to_ridx2,
       wb_writes_to_ridx1, wb_writes_to_ridx2: std_logic;
       
signal ridx1_waiting, ridx2_waiting : std_logic;

begin

reg_file: register_file port map(
    rst => rst,
    clk => clk,
    rd_index1 => rd_index1,
    rd_index2 => rd_index2,
    rd_data1 => reg_data1,
    rd_data2 => reg_data2,
    wr_index => wb_fb.idx,
    wr_data => wb_fb.data,
    wr_enable => wb_fb.ready
);

ex_writes_to_ridx1 <= '1' when (ex_fb.idx = rd_index1) and (ex_fb.will_write = '1') else '0';
ex_has_ridx1 <= '1' when (ex_writes_to_ridx1 = '1') and (ex_fb.ready = '1') else '0';

ex_writes_to_ridx2 <= '1' when (ex_fb.idx = rd_index2) and (ex_fb.will_write = '1') else '0';
ex_has_ridx2 <= '1' when (ex_writes_to_ridx2 = '1') and (ex_fb.ready = '1') else '0';

mem_writes_to_ridx1 <= '1' when (mem_fb.idx = rd_index1) and (mem_fb.will_write = '1') else '0';
mem_has_ridx1 <= '1' when (mem_writes_to_ridx1 = '1') and (mem_fb.ready = '1') else '0';

mem_writes_to_ridx2 <= '1' when (mem_fb.idx = rd_index2) and (mem_fb.will_write = '1') else '0';
mem_has_ridx2 <= '1' when (mem_writes_to_ridx2 = '1') and (mem_fb.ready = '1') else '0';

wb_writes_to_ridx1 <= '1' when (wb_fb.idx = rd_index1) and (wb_fb.will_write = '1') else '0';
wb_has_ridx1 <= '1' when (wb_writes_to_ridx1 = '1') and (wb_fb.ready = '1') else '0';

wb_writes_to_ridx2 <= '1' when (wb_fb.idx = rd_index2) and (wb_fb.will_write = '1') else '0';
wb_has_ridx2 <= '1' when (wb_writes_to_ridx2 = '1') and (wb_fb.ready = '1') else '0';
                    
rd_data1 <= ex_fb.data when ex_has_ridx1 = '1'
       else mem_fb.data when ((mem_has_ridx1 = '1') and (ex_writes_to_ridx1 = '0'))
       else wb_fb.data when ((wb_has_ridx1 = '1') and (ex_writes_to_ridx1 = '0') and (mem_writes_to_ridx1 = '0'))
       else reg_data1;

rd_data2 <= ex_fb.data when ex_has_ridx2 = '1'
       else mem_fb.data when ((mem_has_ridx2 = '1') and (ex_writes_to_ridx2 = '0'))
       else wb_fb.data when ((wb_has_ridx2 = '1') and (ex_writes_to_ridx2 = '0') and (mem_writes_to_ridx2 = '0'))
       else reg_data2;
       
-- Results are always ready to be fed back once the instruction is in the MEM stage, so we only
-- need to wait if the instruction we need the data from is in the execute stage and the data's not ready.
ridx1_waiting <= '1' when ((ex_writes_to_ridx1 = '1') and (ex_fb.ready = '0')) else '0'; 
ridx2_waiting <= '1' when ((ex_writes_to_ridx2 = '1') and (ex_fb.ready = '0')) else '0';
                    
bubble <= '1' when (ridx1_waiting = '1') or (ridx2_waiting = '1') else '0';
end Behavioral;
