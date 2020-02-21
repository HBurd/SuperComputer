library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.all;
use work.common.all;

entity execute_tb is
--  Port ( );
end execute_tb;

architecture Behavioral of execute_tb is

    component ExecuteStage is
        Port(
            input: in execute_latch_t;
            write_data: out std_logic_vector(15 downto 0));
    end component;
    
    signal execute_input: execute_latch_t;
    signal write_data: std_logic_vector(15 downto 0);

begin

    dut: ExecuteStage port map (
        input => execute_input,
        write_data => write_data
    );

    process begin
        -- test add
        execute_input <= (
            opcode => op_add,
            data_1 => x"1234",
            data_2 => x"0123",
            write_idx => "000",
            shift_amt => "0000",
            immediate => x"00",
            imm_high => '0');
            
        wait for 10 us;
        assert unsigned(write_data) = unsigned(execute_input.data_1) + unsigned(execute_input.data_2)
            report "Bad output for add instruction" severity ERROR;
        
        wait for 10 us;
        execute_input.opcode <= op_sub;
        
        wait for 10 us;
        assert unsigned(write_data) = unsigned(execute_input.data_1) - unsigned(execute_input.data_2)
            report "Bad output for sub instruction" severity ERROR;
        
        wait for 10 us;
        execute_input.opcode <= op_mul;
        execute_input.data_1 <= x"0005";
        execute_input.data_2 <= x"0007";
        
        wait for 10 us;
        assert unsigned(write_data) = resize(unsigned(execute_input.data_1) * unsigned(execute_input.data_2), 16)
            report "Bad output for mul instruction" severity ERROR;
            
        wait for 10 us;
        execute_input.opcode <= op_nand;
        execute_input.data_1 <= x"fefe";
        execute_input.data_2 <= x"dead";
        
        wait for 10 us;
        assert write_data = (execute_input.data_1 NAND execute_input.data_2)
            report "Bad output for nand instruction" severity ERROR;
            
        wait for 10 us;
        execute_input.opcode <= op_shl;
        execute_input.shift_amt <= x"5";
        
        wait for 10 us;
        assert unsigned(write_data) = resize(unsigned(execute_input.data_1) * x"0020", 16)
            report "Bad output for shl instruction";
        
        wait;
    end process;


end Behavioral;
