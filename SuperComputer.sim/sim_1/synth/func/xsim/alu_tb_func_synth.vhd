-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Wed Feb  5 17:58:27 2020
-- Host        : ws14-18 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/hburd/SuperComputer/SuperComputer.sim/sim_1/synth/func/xsim/alu_tb_func_synth.vhd
-- Design      : top
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity display_controller is
  port (
    seg_OBUF : out STD_LOGIC_VECTOR ( 6 downto 0 );
    an_OBUF : out STD_LOGIC_VECTOR ( 3 downto 0 );
    D : in STD_LOGIC_VECTOR ( 15 downto 0 );
    CLK : in STD_LOGIC
  );
end display_controller;

architecture STRUCTURE of display_controller is
  signal \hex__33\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal plusOp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal q_reg : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \an_OBUF[0]_inst_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \an_OBUF[1]_inst_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \an_OBUF[2]_inst_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \an_OBUF[3]_inst_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \q_reg[0]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \q_reg[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \seg_OBUF[0]_inst_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \seg_OBUF[1]_inst_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \seg_OBUF[2]_inst_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \seg_OBUF[3]_inst_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \seg_OBUF[4]_inst_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \seg_OBUF[5]_inst_i_1\ : label is "soft_lutpair2";
begin
\an_OBUF[0]_inst_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => q_reg(0),
      I1 => q_reg(1),
      O => an_OBUF(0)
    );
\an_OBUF[1]_inst_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => q_reg(1),
      I1 => q_reg(0),
      O => an_OBUF(1)
    );
\an_OBUF[2]_inst_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => q_reg(0),
      I1 => q_reg(1),
      O => an_OBUF(2)
    );
\an_OBUF[3]_inst_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => q_reg(0),
      I1 => q_reg(1),
      O => an_OBUF(3)
    );
\q_reg[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => q_reg(0),
      O => plusOp(0)
    );
\q_reg[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => q_reg(0),
      I1 => q_reg(1),
      O => plusOp(1)
    );
\q_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => plusOp(0),
      Q => q_reg(0),
      R => '0'
    );
\q_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => plusOp(1),
      Q => q_reg(1),
      R => '0'
    );
\seg_OBUF[0]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2094"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(2),
      I2 => \hex__33\(0),
      I3 => \hex__33\(1),
      O => seg_OBUF(0)
    );
\seg_OBUF[1]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A4C8"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(2),
      I2 => \hex__33\(1),
      I3 => \hex__33\(0),
      O => seg_OBUF(1)
    );
\seg_OBUF[2]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A210"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(0),
      I2 => \hex__33\(1),
      I3 => \hex__33\(2),
      O => seg_OBUF(2)
    );
\seg_OBUF[3]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"C214"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(2),
      I2 => \hex__33\(0),
      I3 => \hex__33\(1),
      O => seg_OBUF(3)
    );
\seg_OBUF[4]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5710"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(1),
      I2 => \hex__33\(2),
      I3 => \hex__33\(0),
      O => seg_OBUF(4)
    );
\seg_OBUF[5]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5190"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(2),
      I2 => \hex__33\(0),
      I3 => \hex__33\(1),
      O => seg_OBUF(5)
    );
\seg_OBUF[6]_inst_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4025"
    )
        port map (
      I0 => \hex__33\(3),
      I1 => \hex__33\(0),
      I2 => \hex__33\(2),
      I3 => \hex__33\(1),
      O => seg_OBUF(6)
    );
\seg_OBUF[6]_inst_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => D(7),
      I1 => D(3),
      I2 => D(15),
      I3 => q_reg(0),
      I4 => q_reg(1),
      I5 => D(11),
      O => \hex__33\(3)
    );
\seg_OBUF[6]_inst_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => D(4),
      I1 => D(0),
      I2 => D(12),
      I3 => q_reg(0),
      I4 => q_reg(1),
      I5 => D(8),
      O => \hex__33\(0)
    );
\seg_OBUF[6]_inst_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => D(6),
      I1 => D(2),
      I2 => D(14),
      I3 => q_reg(0),
      I4 => q_reg(1),
      I5 => D(10),
      O => \hex__33\(2)
    );
\seg_OBUF[6]_inst_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFAACCF000AACC"
    )
        port map (
      I0 => D(5),
      I1 => D(1),
      I2 => D(13),
      I3 => q_reg(0),
      I4 => q_reg(1),
      I5 => D(9),
      O => \hex__33\(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top is
  port (
    sw : in STD_LOGIC_VECTOR ( 15 downto 0 );
    CLK100MHZ : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR ( 15 downto 0 );
    an : out STD_LOGIC_VECTOR ( 3 downto 0 );
    seg : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of top : entity is true;
end top;

architecture STRUCTURE of top is
  signal CLK100MHZ_IBUF : STD_LOGIC;
  signal CLK100MHZ_IBUF_BUFG : STD_LOGIC;
  signal LED_OBUF : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal an_OBUF : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal clk : STD_LOGIC;
  signal \count[0]_i_2_n_0\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[32]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[36]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \count_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \count_reg_n_0_[0]\ : STD_LOGIC;
  signal \count_reg_n_0_[10]\ : STD_LOGIC;
  signal \count_reg_n_0_[11]\ : STD_LOGIC;
  signal \count_reg_n_0_[12]\ : STD_LOGIC;
  signal \count_reg_n_0_[13]\ : STD_LOGIC;
  signal \count_reg_n_0_[14]\ : STD_LOGIC;
  signal \count_reg_n_0_[15]\ : STD_LOGIC;
  signal \count_reg_n_0_[17]\ : STD_LOGIC;
  signal \count_reg_n_0_[18]\ : STD_LOGIC;
  signal \count_reg_n_0_[19]\ : STD_LOGIC;
  signal \count_reg_n_0_[1]\ : STD_LOGIC;
  signal \count_reg_n_0_[20]\ : STD_LOGIC;
  signal \count_reg_n_0_[21]\ : STD_LOGIC;
  signal \count_reg_n_0_[22]\ : STD_LOGIC;
  signal \count_reg_n_0_[23]\ : STD_LOGIC;
  signal \count_reg_n_0_[2]\ : STD_LOGIC;
  signal \count_reg_n_0_[3]\ : STD_LOGIC;
  signal \count_reg_n_0_[4]\ : STD_LOGIC;
  signal \count_reg_n_0_[5]\ : STD_LOGIC;
  signal \count_reg_n_0_[6]\ : STD_LOGIC;
  signal \count_reg_n_0_[7]\ : STD_LOGIC;
  signal \count_reg_n_0_[8]\ : STD_LOGIC;
  signal \count_reg_n_0_[9]\ : STD_LOGIC;
  signal hex0 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal hex1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal hex2 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal hex3 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal seg_OBUF : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal \NLW_count_reg[36]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
begin
CLK100MHZ_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => CLK100MHZ_IBUF,
      O => CLK100MHZ_IBUF_BUFG
    );
CLK100MHZ_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => CLK100MHZ,
      O => CLK100MHZ_IBUF
    );
D0: entity work.display_controller
     port map (
      CLK => clk,
      D(15 downto 12) => hex3(3 downto 0),
      D(11 downto 8) => hex2(3 downto 0),
      D(7 downto 4) => hex1(3 downto 0),
      D(3 downto 0) => hex0(3 downto 0),
      an_OBUF(3 downto 0) => an_OBUF(3 downto 0),
      seg_OBUF(6 downto 0) => seg_OBUF(6 downto 0)
    );
\LED_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(0),
      O => LED(0)
    );
\LED_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(10),
      O => LED(10)
    );
\LED_OBUF[11]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(11),
      O => LED(11)
    );
\LED_OBUF[12]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(12),
      O => LED(12)
    );
\LED_OBUF[13]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(13),
      O => LED(13)
    );
\LED_OBUF[14]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(14),
      O => LED(14)
    );
\LED_OBUF[15]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(15),
      O => LED(15)
    );
\LED_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(1),
      O => LED(1)
    );
\LED_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(2),
      O => LED(2)
    );
\LED_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(3),
      O => LED(3)
    );
\LED_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(4),
      O => LED(4)
    );
\LED_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(5),
      O => LED(5)
    );
\LED_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(6),
      O => LED(6)
    );
\LED_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(7),
      O => LED(7)
    );
\LED_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(8),
      O => LED(8)
    );
\LED_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => LED_OBUF(9),
      O => LED(9)
    );
\LED_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex0(0),
      Q => LED_OBUF(0),
      R => '0'
    );
\LED_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex2(2),
      Q => LED_OBUF(10),
      R => '0'
    );
\LED_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex2(3),
      Q => LED_OBUF(11),
      R => '0'
    );
\LED_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex3(0),
      Q => LED_OBUF(12),
      R => '0'
    );
\LED_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex3(1),
      Q => LED_OBUF(13),
      R => '0'
    );
\LED_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex3(2),
      Q => LED_OBUF(14),
      R => '0'
    );
\LED_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex3(3),
      Q => LED_OBUF(15),
      R => '0'
    );
\LED_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex0(1),
      Q => LED_OBUF(1),
      R => '0'
    );
\LED_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex0(2),
      Q => LED_OBUF(2),
      R => '0'
    );
\LED_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex0(3),
      Q => LED_OBUF(3),
      R => '0'
    );
\LED_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex1(0),
      Q => LED_OBUF(4),
      R => '0'
    );
\LED_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex1(1),
      Q => LED_OBUF(5),
      R => '0'
    );
\LED_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex1(2),
      Q => LED_OBUF(6),
      R => '0'
    );
\LED_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex1(3),
      Q => LED_OBUF(7),
      R => '0'
    );
\LED_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex2(0),
      Q => LED_OBUF(8),
      R => '0'
    );
\LED_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => hex2(1),
      Q => LED_OBUF(9),
      R => '0'
    );
\an_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => an_OBUF(0),
      O => an(0)
    );
\an_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => an_OBUF(1),
      O => an(1)
    );
\an_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => an_OBUF(2),
      O => an(2)
    );
\an_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => an_OBUF(3),
      O => an(3)
    );
\count[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \count_reg_n_0_[0]\,
      O => \count[0]_i_2_n_0\
    );
\count_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[0]_i_1_n_7\,
      Q => \count_reg_n_0_[0]\,
      R => '0'
    );
\count_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \count_reg[0]_i_1_n_0\,
      CO(2) => \count_reg[0]_i_1_n_1\,
      CO(1) => \count_reg[0]_i_1_n_2\,
      CO(0) => \count_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \count_reg[0]_i_1_n_4\,
      O(2) => \count_reg[0]_i_1_n_5\,
      O(1) => \count_reg[0]_i_1_n_6\,
      O(0) => \count_reg[0]_i_1_n_7\,
      S(3) => \count_reg_n_0_[3]\,
      S(2) => \count_reg_n_0_[2]\,
      S(1) => \count_reg_n_0_[1]\,
      S(0) => \count[0]_i_2_n_0\
    );
\count_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[8]_i_1_n_5\,
      Q => \count_reg_n_0_[10]\,
      R => '0'
    );
\count_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[8]_i_1_n_4\,
      Q => \count_reg_n_0_[11]\,
      R => '0'
    );
\count_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[12]_i_1_n_7\,
      Q => \count_reg_n_0_[12]\,
      R => '0'
    );
\count_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[8]_i_1_n_0\,
      CO(3) => \count_reg[12]_i_1_n_0\,
      CO(2) => \count_reg[12]_i_1_n_1\,
      CO(1) => \count_reg[12]_i_1_n_2\,
      CO(0) => \count_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[12]_i_1_n_4\,
      O(2) => \count_reg[12]_i_1_n_5\,
      O(1) => \count_reg[12]_i_1_n_6\,
      O(0) => \count_reg[12]_i_1_n_7\,
      S(3) => \count_reg_n_0_[15]\,
      S(2) => \count_reg_n_0_[14]\,
      S(1) => \count_reg_n_0_[13]\,
      S(0) => \count_reg_n_0_[12]\
    );
\count_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[12]_i_1_n_6\,
      Q => \count_reg_n_0_[13]\,
      R => '0'
    );
\count_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[12]_i_1_n_5\,
      Q => \count_reg_n_0_[14]\,
      R => '0'
    );
\count_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[12]_i_1_n_4\,
      Q => \count_reg_n_0_[15]\,
      R => '0'
    );
\count_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[16]_i_1_n_7\,
      Q => clk,
      R => '0'
    );
\count_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[12]_i_1_n_0\,
      CO(3) => \count_reg[16]_i_1_n_0\,
      CO(2) => \count_reg[16]_i_1_n_1\,
      CO(1) => \count_reg[16]_i_1_n_2\,
      CO(0) => \count_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[16]_i_1_n_4\,
      O(2) => \count_reg[16]_i_1_n_5\,
      O(1) => \count_reg[16]_i_1_n_6\,
      O(0) => \count_reg[16]_i_1_n_7\,
      S(3) => \count_reg_n_0_[19]\,
      S(2) => \count_reg_n_0_[18]\,
      S(1) => \count_reg_n_0_[17]\,
      S(0) => clk
    );
\count_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[16]_i_1_n_6\,
      Q => \count_reg_n_0_[17]\,
      R => '0'
    );
\count_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[16]_i_1_n_5\,
      Q => \count_reg_n_0_[18]\,
      R => '0'
    );
\count_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[16]_i_1_n_4\,
      Q => \count_reg_n_0_[19]\,
      R => '0'
    );
\count_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[0]_i_1_n_6\,
      Q => \count_reg_n_0_[1]\,
      R => '0'
    );
\count_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[20]_i_1_n_7\,
      Q => \count_reg_n_0_[20]\,
      R => '0'
    );
\count_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[16]_i_1_n_0\,
      CO(3) => \count_reg[20]_i_1_n_0\,
      CO(2) => \count_reg[20]_i_1_n_1\,
      CO(1) => \count_reg[20]_i_1_n_2\,
      CO(0) => \count_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[20]_i_1_n_4\,
      O(2) => \count_reg[20]_i_1_n_5\,
      O(1) => \count_reg[20]_i_1_n_6\,
      O(0) => \count_reg[20]_i_1_n_7\,
      S(3) => \count_reg_n_0_[23]\,
      S(2) => \count_reg_n_0_[22]\,
      S(1) => \count_reg_n_0_[21]\,
      S(0) => \count_reg_n_0_[20]\
    );
\count_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[20]_i_1_n_6\,
      Q => \count_reg_n_0_[21]\,
      R => '0'
    );
\count_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[20]_i_1_n_5\,
      Q => \count_reg_n_0_[22]\,
      R => '0'
    );
\count_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[20]_i_1_n_4\,
      Q => \count_reg_n_0_[23]\,
      R => '0'
    );
\count_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[24]_i_1_n_7\,
      Q => hex0(0),
      R => '0'
    );
\count_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[20]_i_1_n_0\,
      CO(3) => \count_reg[24]_i_1_n_0\,
      CO(2) => \count_reg[24]_i_1_n_1\,
      CO(1) => \count_reg[24]_i_1_n_2\,
      CO(0) => \count_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[24]_i_1_n_4\,
      O(2) => \count_reg[24]_i_1_n_5\,
      O(1) => \count_reg[24]_i_1_n_6\,
      O(0) => \count_reg[24]_i_1_n_7\,
      S(3 downto 0) => hex0(3 downto 0)
    );
\count_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[24]_i_1_n_6\,
      Q => hex0(1),
      R => '0'
    );
\count_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[24]_i_1_n_5\,
      Q => hex0(2),
      R => '0'
    );
\count_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[24]_i_1_n_4\,
      Q => hex0(3),
      R => '0'
    );
\count_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[28]_i_1_n_7\,
      Q => hex1(0),
      R => '0'
    );
\count_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[24]_i_1_n_0\,
      CO(3) => \count_reg[28]_i_1_n_0\,
      CO(2) => \count_reg[28]_i_1_n_1\,
      CO(1) => \count_reg[28]_i_1_n_2\,
      CO(0) => \count_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[28]_i_1_n_4\,
      O(2) => \count_reg[28]_i_1_n_5\,
      O(1) => \count_reg[28]_i_1_n_6\,
      O(0) => \count_reg[28]_i_1_n_7\,
      S(3 downto 0) => hex1(3 downto 0)
    );
\count_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[28]_i_1_n_6\,
      Q => hex1(1),
      R => '0'
    );
\count_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[0]_i_1_n_5\,
      Q => \count_reg_n_0_[2]\,
      R => '0'
    );
\count_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[28]_i_1_n_5\,
      Q => hex1(2),
      R => '0'
    );
\count_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[28]_i_1_n_4\,
      Q => hex1(3),
      R => '0'
    );
\count_reg[32]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[32]_i_1_n_7\,
      Q => hex2(0),
      R => '0'
    );
\count_reg[32]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[28]_i_1_n_0\,
      CO(3) => \count_reg[32]_i_1_n_0\,
      CO(2) => \count_reg[32]_i_1_n_1\,
      CO(1) => \count_reg[32]_i_1_n_2\,
      CO(0) => \count_reg[32]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[32]_i_1_n_4\,
      O(2) => \count_reg[32]_i_1_n_5\,
      O(1) => \count_reg[32]_i_1_n_6\,
      O(0) => \count_reg[32]_i_1_n_7\,
      S(3 downto 0) => hex2(3 downto 0)
    );
\count_reg[33]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[32]_i_1_n_6\,
      Q => hex2(1),
      R => '0'
    );
\count_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[32]_i_1_n_5\,
      Q => hex2(2),
      R => '0'
    );
\count_reg[35]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[32]_i_1_n_4\,
      Q => hex2(3),
      R => '0'
    );
\count_reg[36]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[36]_i_1_n_7\,
      Q => hex3(0),
      R => '0'
    );
\count_reg[36]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[32]_i_1_n_0\,
      CO(3) => \NLW_count_reg[36]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \count_reg[36]_i_1_n_1\,
      CO(1) => \count_reg[36]_i_1_n_2\,
      CO(0) => \count_reg[36]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[36]_i_1_n_4\,
      O(2) => \count_reg[36]_i_1_n_5\,
      O(1) => \count_reg[36]_i_1_n_6\,
      O(0) => \count_reg[36]_i_1_n_7\,
      S(3 downto 0) => hex3(3 downto 0)
    );
\count_reg[37]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[36]_i_1_n_6\,
      Q => hex3(1),
      R => '0'
    );
\count_reg[38]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[36]_i_1_n_5\,
      Q => hex3(2),
      R => '0'
    );
\count_reg[39]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[36]_i_1_n_4\,
      Q => hex3(3),
      R => '0'
    );
\count_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[0]_i_1_n_4\,
      Q => \count_reg_n_0_[3]\,
      R => '0'
    );
\count_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[4]_i_1_n_7\,
      Q => \count_reg_n_0_[4]\,
      R => '0'
    );
\count_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[0]_i_1_n_0\,
      CO(3) => \count_reg[4]_i_1_n_0\,
      CO(2) => \count_reg[4]_i_1_n_1\,
      CO(1) => \count_reg[4]_i_1_n_2\,
      CO(0) => \count_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[4]_i_1_n_4\,
      O(2) => \count_reg[4]_i_1_n_5\,
      O(1) => \count_reg[4]_i_1_n_6\,
      O(0) => \count_reg[4]_i_1_n_7\,
      S(3) => \count_reg_n_0_[7]\,
      S(2) => \count_reg_n_0_[6]\,
      S(1) => \count_reg_n_0_[5]\,
      S(0) => \count_reg_n_0_[4]\
    );
\count_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[4]_i_1_n_6\,
      Q => \count_reg_n_0_[5]\,
      R => '0'
    );
\count_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[4]_i_1_n_5\,
      Q => \count_reg_n_0_[6]\,
      R => '0'
    );
\count_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[4]_i_1_n_4\,
      Q => \count_reg_n_0_[7]\,
      R => '0'
    );
\count_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[8]_i_1_n_7\,
      Q => \count_reg_n_0_[8]\,
      R => '0'
    );
\count_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \count_reg[4]_i_1_n_0\,
      CO(3) => \count_reg[8]_i_1_n_0\,
      CO(2) => \count_reg[8]_i_1_n_1\,
      CO(1) => \count_reg[8]_i_1_n_2\,
      CO(0) => \count_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \count_reg[8]_i_1_n_4\,
      O(2) => \count_reg[8]_i_1_n_5\,
      O(1) => \count_reg[8]_i_1_n_6\,
      O(0) => \count_reg[8]_i_1_n_7\,
      S(3) => \count_reg_n_0_[11]\,
      S(2) => \count_reg_n_0_[10]\,
      S(1) => \count_reg_n_0_[9]\,
      S(0) => \count_reg_n_0_[8]\
    );
\count_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK100MHZ_IBUF_BUFG,
      CE => '1',
      D => \count_reg[8]_i_1_n_6\,
      Q => \count_reg_n_0_[9]\,
      R => '0'
    );
\seg_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(0),
      O => seg(0)
    );
\seg_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(1),
      O => seg(1)
    );
\seg_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(2),
      O => seg(2)
    );
\seg_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(3),
      O => seg(3)
    );
\seg_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(4),
      O => seg(4)
    );
\seg_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(5),
      O => seg(5)
    );
\seg_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => seg_OBUF(6),
      O => seg(6)
    );
end STRUCTURE;
