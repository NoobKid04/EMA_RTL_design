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

entity conv11 is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	iaddrb, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end conv11;

architecture Behavioral of conv11 is
signal ic_comp, iocn_comp, count_ld, acc_sel, acc_ld, bias_ld : STD_LOGIC;
component conv11_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, ic_comp, iocn_comp : in STD_LOGIC;
	Done_o, count_ld, enb, acc_sel, acc_ld, ena, bias_ld : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component conv11_datapath
 port (
	RST, CLK : in STD_LOGIC;
	IC, OH, OW, OC, idoutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld, bias_ld : in STD_LOGIC;
    iaddrb, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	ic_comp, iocn_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : conv11_controller
 port map(
	RST, CLK,
	Start_i, ic_comp, iocn_comp,
	Done_o, count_ld, enb, acc_sel, acc_ld, ena, bias_ld,
	wea
 );
 Datapath_UNIT : conv11_datapath
 port map(
	RST, CLK,
	C, H, W, C, idoutb,
	count_ld, acc_sel, acc_ld, bias_ld,
	iaddrb, oaddra, odina,
	ic_comp, iocn_comp
 );
end Behavioral;
