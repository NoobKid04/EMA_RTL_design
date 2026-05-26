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

entity conv33 is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb0, idoutb1, idoutb2, idoutb3, idoutb4, idoutb5, idoutb6, idoutb7, idoutb8, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	iaddrb0, iaddrb1, iaddrb2, iaddrb3, iaddrb4, iaddrb5, iaddrb6, iaddrb7, iaddrb8, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end conv33;

architecture Behavioral of conv33 is
signal ic_comp, icowhc_comp, count_ld, acc_sel, acc_ld, bias_ld : STD_LOGIC;
component conv33_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, ic_comp, icowhc_comp : in STD_LOGIC;
	Done_o, count_ld, enb, acc_sel, acc_ld, ena, bias_ld : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component conv33_datapath
 port (
	RST, CLK : in STD_LOGIC;
	IC, OH, OW, OC, HW, idoutb0, idoutb1, idoutb2, idoutb3, idoutb4, idoutb5, idoutb6, idoutb7, idoutb8 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld, bias_ld : in STD_LOGIC;
    iaddrb0, iaddrb1, iaddrb2, iaddrb3, iaddrb4, iaddrb5, iaddrb6, iaddrb7, iaddrb8, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	ic_comp, icowhc_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : conv33_controller
 port map(
	RST, CLK,
	Start_i, ic_comp, icowhc_comp,
	Done_o, count_ld, enb, acc_sel, acc_ld, ena, bias_ld,
	wea
 );
 Datapath_UNIT : conv33_datapath
 port map(
	RST, CLK,
	C, H, W, C, HW, idoutb0, idoutb1, idoutb2, idoutb3, idoutb4, idoutb5, idoutb6, idoutb7, idoutb8,
	count_ld, acc_sel, acc_ld, bias_ld,
	iaddrb0, iaddrb1, iaddrb2, iaddrb3, iaddrb4, iaddrb5, iaddrb6, iaddrb7, iaddrb8, oaddra, odina,
	ic_comp, icowhc_comp
 );
end Behavioral;
