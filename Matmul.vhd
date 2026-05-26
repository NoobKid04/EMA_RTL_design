----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2026 06:19:59 AM
-- Design Name: 
-- Module Name: AvgPoolH - Behavioral
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

entity Matmul is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, C, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end Matmul;

architecture Behavioral of Matmul is
signal count_ld, acc_sel, acc_ld, C_comp, CHW_comp : STD_LOGIC;
component Matmul_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, C_comp, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, acc_sel, acc_ld,  ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component Matmul_datapath
 port (
	RST, CLK : in STD_LOGIC;
	C, HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld : in STD_LOGIC;
    dina, addrb1, addrb2,  addra : out STD_LOGIC_VECTOR (15 downto 0);
	C_comp, CHW_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : Matmul_controller
 port map(
	RST, CLK,
	Start_i, C_comp, CHW_comp,
	Done_o, count_ld, enb, acc_sel, acc_ld,  ena,
	wea
 );
 Datapath_UNIT : Matmul_datapath
 port map(
	RST, CLK,
	C, HW, doutb1, doutb2,
	count_ld, acc_sel, acc_ld,
    dina, addrb1, addrb2,  addra,
	C_comp, CHW_comp
 );
end Behavioral;
