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

entity Sigmoid2D is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end Sigmoid2D;

architecture Behavioral of Sigmoid2D is
signal count_ld, cn_comp : STD_LOGIC;
component Sigmoid2D_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, cn_comp : in STD_LOGIC;
	Done_o, count_ld, enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component Sigmoid2D_datapath
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	cn_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : Sigmoid2D_controller
 port map(
	RST, CLK,
	Start_i, cn_comp,
	Done_o, count_ld, enb, ena,
	wea
 );
 Datapath_UNIT : Sigmoid2D_datapath
 port map(
	RST, CLK,
	C, H, W, doutb,
	count_ld,
    dina, addrb, addra,
	cn_comp
 );
end Behavioral;
