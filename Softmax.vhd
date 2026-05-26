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

entity Softmax is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, X_max : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end Softmax;

architecture Behavioral of Softmax is
signal C_comp, count_ld, Sum_ld, Sum_sel : STD_LOGIC;
component Softmax_controller 
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, C_comp : in STD_LOGIC;
	Done_o, count_ld, enb, Sum_ld, Sum_sel, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end component;
 component Softmax_datapath 
 port (
	RST, CLK : in STD_LOGIC;
	C, X_max, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, Sum_sel, Sum_ld : in STD_LOGIC;
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	C_comp : out STD_LOGIC
 );
 end component;
begin
 CTRL_UNIT : Softmax_controller 
 port map (
	RST, CLK,
	Start_i, C_comp,
	Done_o, count_ld, enb, Sum_ld, Sum_sel, ena,
	wea
 );
 Datapath_UNIT : Softmax_datapath 
 port map (
	RST, CLK,
	C, X_max, doutb,
	count_ld, Sum_sel, Sum_ld,
	dina, addrb, addra,
	C_comp
 );
end Behavioral;
