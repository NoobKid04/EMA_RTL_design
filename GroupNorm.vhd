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

entity GroupNorm is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	odina, iaddrb, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end GroupNorm;

architecture Behavioral of GroupNorm is
signal HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done, count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start : STD_LOGIC;
component GroupNorm_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done : in STD_LOGIC;
	Done_o, count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start , enb,  ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component GroupNorm_datapath
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, idoutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start : in STD_LOGIC;
    odina, iaddrb, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : GroupNorm_controller
 port map (
	RST, CLK,
	Start_i, HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done,
	Done_o, count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start , enb,  ena,
	wea
 );
 Datapath_UNIT : GroupNorm_datapath
 port map (
	RST, CLK,
	C, H, W, HW, idoutb,
	count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start,
    odina, iaddrb, oaddra,
	HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done
 );
end Behavioral;
