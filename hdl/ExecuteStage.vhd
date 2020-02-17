----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2020 02:34:21 PM
-- Design Name: 
-- Module Name: ExecuteStage - Behavioral
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

entity ExecuteStage is
Port(
    clk, rst: in std_logic;
    opcode: in opcode_t;
    shift_amt: in unsigned(3 downto 0);
    read_data_1: in std_logic_vector(15 downto 0);
    read_data_2: in std_logic_vector(15 downto 0);
    write_idx: in unsigned(2 downto 0);
    write_data: out std_logic_vector(15 downto 0));
end ExecuteStage;

architecture Behavioral of ExecuteStage is

begin


end Behavioral;
