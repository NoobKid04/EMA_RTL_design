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

entity FinalAdd is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, C, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end FinalAdd;

architecture Behavioral of FinalAdd is
signal count_ld, CHW_comp : STD_LOGIC;
component FinalAdd_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component FinalAdd_datapath
 port (
	RST, CLK : in STD_LOGIC;
	C, HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	CHW_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : FinalAdd_controller 
 port map (
	RST, CLK,
	Start_i, CHW_comp,
	Done_o, count_ld, enb, ena,
	wea
 );
 Datapath_UNIT : FinalAdd_datapath
 port map(
	RST, CLK,
	C, HW, doutb1, doutb2,
	count_ld,
    dina, addrb1, addrb2, addra,
	CHW_comp
 );
end Behavioral;
