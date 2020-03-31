library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.Vcomponents.all;

library xpm;
use xpm.vcomponents.all;

entity vga_controller is
    Port (
    clk100MHz: in std_logic; -- Must be 100MHz!!
    rst: in std_logic;
    -- Character buffer interface
    char_addr : out unsigned(12 downto 0);
    selected_char: in unsigned(7 downto 0);
    -- VGA pins
    vgaRed: out unsigned(3 downto 0);
    vgaGreen: out unsigned(3 downto 0);
    vgaBlue: out unsigned(3 downto 0);
    Hsync: out std_logic;
    Vsync: out std_logic);
end vga_controller;

architecture behavioural of vga_controller is

    constant H_FRONT_PORCH_LEN: natural := 16;
    constant H_PULSE_LEN: natural := 96;
    constant H_BACK_PORCH_LEN: natural := 48;
    constant H_ACTIVE_LEN: natural := 640;
    
    constant V_FRONT_PORCH_LEN: natural := 11;
    constant V_PULSE_LEN: natural := 2;
    constant V_BACK_PORCH_LEN: natural := 31;
    constant V_ACTIVE_LEN: natural := 480;
    
    constant H_PULSE_START: natural := H_ACTIVE_LEN + H_FRONT_PORCH_LEN;
    constant V_PULSE_START: natural := V_ACTIVE_LEN + V_FRONT_PORCH_LEN;
    
    constant TOTAL_WIDTH : natural := H_FRONT_PORCH_LEN + H_PULSE_LEN + H_BACK_PORCH_LEN + H_ACTIVE_LEN;
    constant TOTAL_HEIGHT : natural := V_FRONT_PORCH_LEN + V_PULSE_LEN + V_BACK_PORCH_LEN + V_ACTIVE_LEN;

    constant SCREEN_CHAR_WIDTH: natural := 80;
    constant SCREEN_CHAR_HEIGHT: natural := 30;

    signal clk_div: unsigned(1 downto 0);
    signal clk25MHz: std_logic;

    signal h_counter: unsigned(9 downto 0);
    signal v_counter: unsigned(9 downto 0);

    -- character stuff 
    constant CHAR_WIDTH: natural := 8;
    constant CHAR_HEIGHT: natural := 16;
    
    constant CHAR_SPACE_H: natural := 8;
    constant CHAR_SPACE_V: natural := 16;
    
    constant CHAR_ADDR_BITS: natural := 13;
    
    signal char_data: std_logic_vector(127 downto 0);
    
    signal bit_x: unsigned(3 downto 0);
    signal bit_y: unsigned(3 downto 0);
    signal bit_idx: integer;
    
    signal char_x: unsigned(6 downto 0);
    signal char_y: unsigned(5 downto 0);

    signal pixel_value: unsigned(3 downto 0);

begin

    clk25MHz <= clk_div(1);

    -- clk div
    process(clk100MHz, rst) begin
        if rst = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(clk100MHz) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    -- h and v counters
    process(clk25MHz, rst) begin
        if rst = '1' then
            h_counter <= (others => '0');
            v_counter <= (others => '0');
            bit_x <= (others => '0');
            bit_y <= (others => '0');
            char_x <= (others => '0');
            char_y <= (others => '0');
        elsif rising_edge(clk25MHz) then
            if h_counter < TOTAL_WIDTH - 1 then
                h_counter <= h_counter + 1;
                
                if bit_x < CHAR_SPACE_H - 1 then
                    bit_x <= bit_x + 1;
                else
                    bit_x <= (others => '0');
                    char_x <= char_x + 1;
                end if;
            else
                h_counter <= (others => '0');
                bit_x <= (others => '0');
                char_x <= (others => '0');
                
                if v_counter < TOTAL_HEIGHT - 1 then
                    v_counter <= v_counter + 1;
                    
                    if bit_y < CHAR_SPACE_V - 1 then
                        bit_y <= bit_y + 1;
                    else
                        bit_y <= (others => '0');
                        char_y <= char_y + 1;
                    end if;
                else
                    v_counter <= (others => '0');
                    bit_y <= (others => '0');
                    char_y <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    vgaRed <= pixel_value;
    vgaBlue <= pixel_value;
    vgaGreen <= pixel_value;
    
    bit_idx <= to_integer(bit_x + CHAR_WIDTH * bit_y);
    pixel_value <=  x"F" when (char_data(bit_idx) = '1' and bit_x < CHAR_WIDTH and bit_y < CHAR_HEIGHT and char_x < SCREEN_CHAR_WIDTH)
        else x"0";

    Hsync <= '0' when (h_counter < H_PULSE_START + H_PULSE_LEN) and (h_counter >= H_PULSE_START) else '1';
    Vsync <= '0' when (v_counter < V_PULSE_START + V_PULSE_LEN) and (v_counter >= V_PULSE_START) else '1';

    char_addr <= resize(resize(char_x, CHAR_ADDR_BITS) + SCREEN_CHAR_WIDTH * resize(char_y, CHAR_ADDR_BITS), CHAR_ADDR_BITS);

    character_rom: xpm_memory_sprom
        generic map (
            ADDR_WIDTH_A => 7,
            AUTO_SLEEP_TIME => 0,
            ECC_MODE => "no_ecc",
            MEMORY_INIT_FILE => "unifont.mem",
            MEMORY_INIT_PARAM => "0",
            MEMORY_OPTIMIZATION => "true",
            MEMORY_PRIMITIVE => "auto",
            MEMORY_SIZE => 128 * 128,
            MESSAGE_CONTROL => 0,
            READ_DATA_WIDTH_A => 128,
            READ_LATENCY_A => 0,
            READ_RESET_VALUE_A => "0",
            USE_MEM_INIT => 1,
            WAKEUP_TIME => "disable_sleep")
        port map (
            clka => clk100MHz,
            rsta => rst,
            addra => std_logic_vector(selected_char(6 downto 0)),
            douta => char_data,
            ena => '1',

            -- Unused ECC and sleep mode stuff
            dbiterra => open,
            sbiterra => open,
            injectdbiterra => '0',
            injectsbiterra => '0',
            regcea => '1',
            sleep => '0');

end behavioural;
