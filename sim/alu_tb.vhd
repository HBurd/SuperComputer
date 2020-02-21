library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.all;
use work.common.all;

entity alu_tb is end alu_tb;

architecture behavioural of alu_tb is
    component alu port(
        alu_mode : in alu_mode_t;
        in1 : in std_logic_vector(15 downto 0);
        in2 : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(15 downto 0);
        z_flag : out std_logic;
        n_flag : out std_logic);
    end component; 
    
    signal rst, clk, z_flag, n_flag : std_logic; 
    signal alu_mode : alu_mode_t; 
    signal in1, in2, result : std_logic_vector(15 downto 0);
    
    begin
    
    dut: alu port map(
        alu_mode => alu_mode,
        in1 => in1,
        in2 => in2,
        result => result,
        z_flag => z_flag,
        n_flag => n_flag        
     );
    process begin
        -- implement the clock
        clk <= '0'; wait for 10 us;
        clk <= '1'; wait for 10 us; 
    end process;
    
    process  begin
        wait until (clk = '0' and clk'event);
        wait until (clk = '0' and clk'event);
        alu_mode <= alu_add;
        in1 <= x"0001";
        in2 <= x"0005";
        wait until (clk = '1' and clk'event);
        assert result = x"0006" report "Addition failed :(" severity ERROR;
        
        wait until (clk = '0' and clk'event);
        alu_mode <= alu_sub;
        in1 <= x"0001";
        in2 <= x"0005";
        wait until (clk = '1' and clk'event);
        assert result = std_logic_vector(to_signed(-4, 16)) report "Subtraction failed :(" severity ERROR;
        
        wait until (clk = '0' and clk'event);
        alu_mode <= alu_mul;
        in1 <= x"0002";
        in2 <= x"0005";        
        wait until (clk = '1' and clk'event);
        assert result = x"000A" report "Multiplication failed :(" severity ERROR;
        
        wait until (clk = '0' and clk'event);
        alu_mode <= alu_nand;
        in1 <= x"0001";
        in2 <= x"0005";       
        wait until (clk = '1' and clk'event);
        assert result = (std_logic_vector(to_unsigned(10#1#, 16)) NAND std_logic_vector(to_unsigned(5, 16))) report "NAND failed :(" severity ERROR;

        wait until (clk = '0' and clk'event);
        
        wait;
    end process;
end behavioural;
