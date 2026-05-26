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

entity AddSigmoid is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end AddSigmoid;

architecture Behavioral of AddSigmoid is
signal count_ld, HW_comp : STD_LOGIC;
component AddSigmoid_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, HW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component AddSigmoid_datapath
 port (
	RST, CLK : in STD_LOGIC;
	HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	HW_comp : out STD_LOGIC
 );
end component;
begin
 CTRL_UNIT : AddSigmoid_controller
 port map(
	RST, CLK,
	Start_i, HW_comp,
	Done_o, count_ld, enb, ena,
	wea
 );
 Datapath_UNIT : AddSigmoid_datapath
 port map(
	RST, CLK,
	HW, doutb1, doutb2,
	count_ld,
    dina, addrb, addra,
	HW_comp
 );
end Behavioral;
