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
        instr: in std_logic_vector(15 downto 0);
        write_idx: out unsigned(2 downto 0);
        read_idx_1: out unsigned(2 downto 0);
        read_idx_2: out unsigned(2 downto 0);
        opcode: out opcode_t;
        shift_amt: out unsigned(3 downto 0)
    );
    end component;
    
    signal instr: std_logic_vector(15 downto 0);
    signal rega_idx: unsigned(2 downto 0);
    signal regb_idx: unsigned(2 downto 0);
    signal regc_idx: unsigned(2 downto 0);
    signal opcode: opcode_t;
    signal shift_amt: unsigned(3 downto 0);

    begin

    dut: DecodeStage port map(
        instr => instr,
        write_idx => rega_idx,
        read_idx_1 => regb_idx,
        read_idx_2 => regc_idx,
        opcode => opcode,
        shift_amt => shift_amt
    );
    
    process begin
        -- test format A1
        -- instruction: add r6 r3 r2
        instr <= "0000001" & "110" & "011" & "010";
        wait for 10 us;
        assert opcode = op_add report "Bad opcode" severity ERROR;
        assert rega_idx = 6 report "Bad rega index" severity ERROR;
        assert regb_idx = 3 report "Bad regb index" severity ERROR;
        assert regc_idx = 2 report "Bad regc index" severity ERROR;
        
        -- test formatl A2
        -- instruction: shl r5 13
        wait for 10 us;
        instr <= "0000101" & "101" & "00" & "1101";
        wait for 10 us;
        assert opcode = op_shl report "Bad opcode" severity ERROR;
        assert rega_idx = 5 report "Bad rega index" severity ERROR;
        assert shift_amt = 13 report "Bad shift amount" severity ERROR;
        
        -- test format A3
        -- instruction: test r4
        wait for 10 us;
        instr <= "0000111" & "100" & "000000";
        wait for 10 us;
        assert opcode = op_test report "Bad opcode" severity ERROR;
        assert rega_idx = 4 report "Bad rega index" severity ERROR;
        
        -- test format A0
        -- instruction: nop
        wait for 10 us;
        instr <= "0000000000000000";
        wait for 10 us;
        assert opcode = op_nop report "Bad opcode" severity ERROR;
        
        wait;
    end process;

end Behavioral;
