library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity forwarder is
  Port (
    clk: in std_logic;
    rst: in std_logic;
    -- requested register indices
    rd_index1: in std_logic_vector(2 downto 0);
    rd_index2: in std_logic_vector(2 downto 0);
    -- data delivered to execute stage
    rd_data1: out std_logic_vector(15 downto 0);
    rd_data2: out std_logic_vector(15 downto 0);
    -- pending signals
    mark_pending_index: in std_logic_vector(2 downto 0);
    mark_pending: in std_logic;
    ridx1_pending: out std_logic;
    ridx2_pending: out std_logic;    
    -- feedback from later stages
    ex_output_data: in std_logic_vector(15 downto 0);
    ex_wr_index: in std_logic_vector(2 downto 0);
    
    mem_output_data: in std_logic_vector(15 downto 0);
    mem_wr_index: in std_logic_vector(2 downto 0);
    
    wb_wr_index: in std_logic_vector(2 downto 0); 
    wb_wr_data: in std_logic_vector(15 downto 0);
    wb_wr_enable: in std_logic);
end forwarder;

architecture Behavioral of forwarder is

component register_file is
port(
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
    --pending signals
    mark_pending_index: in std_logic_vector(2 downto 0);
    mark_pending: in std_logic;
    ridx1_pending: out std_logic;
    ridx2_pending: out std_logic
);
end component register_file;

signal reg_data1, reg_data2: std_logic_vector(15 downto 0);

begin

reg_file: register_file port map(
    rst => rst,
    clk => clk,
    rd_index1 => rd_index1,
    rd_index2 => rd_index2,
    rd_data1 => reg_data1,
    rd_data2 => reg_data2,
    wr_index => wb_wr_index,
    wr_data => wb_wr_data,
    wr_enable => wb_wr_enable,
    mark_pending_index => mark_pending_index,
    mark_pending => mark_pending,
    ridx1_pending => ridx1_pending,
    ridx2_pending => ridx2_pending
);

rd_data1 <= reg_data1 when true else
            ex_output_data when false else
            mem_output_data when false;            

rd_data2 <= reg_data2 when true else
            ex_output_data when false else
            mem_output_data when false;

end Behavioral;
