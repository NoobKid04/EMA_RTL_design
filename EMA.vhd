----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2026 11:25:43 PM
-- Design Name: 
-- Module Name: EMA - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EMA is
 Port (
    RST, CLK : in STD_LOGIC;
    Start_i : in STD_LOGIC;
	enb : in STD_LOGIC;
	addrb : in STD_LOGIC_VECTOR (15 downto 0);
	doutb : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end EMA;
architecture Behavioral of EMA is
 signal BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld : STD_LOGIC;
 signal BramStart_old : STD_LOGIC_VECTOR(1 downto 0);
 signal Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul : STD_LOGIC;
 signal Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul : STD_LOGIC;
 component EMA_controller
  Port(
    RST, CLK : in STD_LOGIC;
    Start_i : in STD_LOGIC;
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld : out STD_LOGIC;
    BramStart_old : out STD_LOGIC_VECTOR(1 downto 0);
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul : out STD_LOGIC;
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul : in STD_LOGIC;
    Done_o : out STD_LOGIC
  );
 end component;
 component EMA_datapath
  Port (
    RST, CLK : in STD_LOGIC;
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld : in STD_LOGIC;
    BramStart_old : in STD_LOGIC_VECTOR(1 downto 0);
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul : in STD_LOGIC;
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul : out STD_LOGIC;
    enb, ena : in STD_LOGIC;
	wea : in STD_LOGIC_VECTOR (0 downto 0);
	addra, dina, addrb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	doutb : out STD_LOGIC_VECTOR (15 downto 0)
  );
 end component;
begin
 CTRL_UNIT : EMA_controller
  Port map(
    RST, CLK,
    Start_i,
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld,
    BramStart_old,
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul,
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul,
    Done_o
  );
 Datapath_UNIT : EMA_datapath
  Port map(
    RST, CLK,
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld,
    BramStart_old,
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul,
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul,
    enb, '0',
	"0",
	x"0000", x"0000", addrb, x"0010", x"0010", x"0010",
	doutb
  );
end Behavioral;
