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

entity AvgPoolH is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	write_en : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end AvgPoolH;

architecture Behavioral of AvgPoolH is
signal count_ld, X_add_ld, X_div_ld, X_add_mux, Div_start, CHW_comp_ld, W_comp, Div_done, CHW_comp : STD_LOGIC;
component AvgPoolH_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, W_comp, Div_done, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, X_add_mux, X_add_ld, X_div_ld, Div_start, CHW_comp_ld, ena : out STD_LOGIC;
	write_en : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component AvgPoolH_datapath
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, X_add_ld, X_div_ld, X_add_mux, Div_start, CHW_comp_ld : in STD_LOGIC;
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	W_comp, CHW_comp, Div_done : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : AvgPoolH_controller
 port map(
	RST, CLK,
	Start_i, W_comp, Div_done, CHW_comp,
	Done_o, count_ld, enb, X_add_mux, X_add_ld, X_div_ld, Div_start, CHW_comp_ld, ena, 
	write_en
 );
 Datapath_UNIT : AvgPoolH_datapath
 port map(
	RST, CLK,
	C, H, W, HW, doutb,
	count_ld, X_add_ld, X_div_ld, X_add_mux, Div_start, CHW_comp_ld,
	dina, addrb, addra,
	W_comp, CHW_comp, Div_done
 );
end Behavioral;
