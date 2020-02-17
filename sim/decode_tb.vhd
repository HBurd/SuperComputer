----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2020 04:07:26 PM
-- Design Name: 
-- Module Name: decode_tb - Behavioral
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
use ieee.numeric_std.all;

use work.common.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decode_tb is
--  Port ( );
end decode_tb;

architecture Behavioral of decode_tb is

    component DecodeStage is
    Port (
        clk, rst: in std_logic;
        instr: in std_logic_vector(15 downto 0);
        rega_idx: out unsigned(2 downto 0);
        regb_idx: out unsigned(2 downto 0);
        regc_idx: out unsigned(2 downto 0);
        opcode: out opcode_t
    );
    end component;
    
    signal instr: std_logic_vector(15 downto 0);
    signal rega_idx: unsigned(2 downto 0);
    signal regb_idx: unsigned(2 downto 0);
    signal regc_idx: unsigned(2 downto 0);
    signal opcode: opcode_t;
    signal clk, rst: std_logic;

    begin

    dut: DecodeStage port map(
        clk => clk,
        rst => rst,
        instr => instr,
        rega_idx => rega_idx,
        regb_idx => regb_idx,
        regc_idx => regc_idx,
        opcode => opcode
    );
    
    process begin
        clk <= '0';
        -- test format A1
        -- add r6 r3 r2
        instr <= "0000001" & "110" & "011" & "010";
        wait for 10 us;
        
        clk <= '1';
        wait for 10 us;
        
        assert opcode = op_add;
        assert rega_idx = 6 report "Bad rega index" severity ERROR;
        assert regb_idx = 3 report "Bad regb index" severity ERROR;
        assert regc_idx = 2 report "Bad regc index" severity ERROR;
        
        wait for 10 us;
        
        -- make sure instruction was latched
        -- nop
        instr <= "0000000000000000";
        
        wait for 10 us;
        
        assert opcode = op_add report "Bad opcode" severity ERROR;
        assert rega_idx = 6 report "Bad rega index" severity ERROR;
        assert regb_idx = 3 report "Bad regb index" severity ERROR;
        assert regc_idx = 2 report "Bad regc index" severity ERROR;
        
        wait for 10 us;
        clk <= '0';
        
        wait for 10 us;
        clk <= '1';
        
        wait for 10 us;
        assert opcode = op_nop report "Bad opcode" severity ERROR;
        
        wait;
    end process;

end Behavioral;
