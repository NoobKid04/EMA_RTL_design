----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2026 08:02:05 PM
-- Design Name: 
-- Module Name: SQRT - Behavioral
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

entity SQRT is
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	result : out STD_LOGIC_VECTOR(15 downto 0);
	Done_o : out STD_LOGIC
 );
end SQRT;

architecture Behavioral of SQRT is
signal X_sel, X_ld, Div_start, Div_done : STD_LOGIC;

component SQRT_datapath
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR(15 downto 0);
	result : out STD_LOGIC_VECTOR(15 downto 0);
	X_sel, X_ld: in STD_LOGIC;
	Div_start : in STD_LOGIC;
	Div_done : out STD_LOGIC
 );
end component;

component SQRT_controller
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, Div_done : in STD_LOGIC;
	Done_o, X_sel, X_ld, Div_start : out STD_LOGIC
 );
end component;
begin

 CTRL_UNIT : SQRT_controller
 port map (
    RST, CLK,
	Start_i, Div_done,
	Done_o, X_sel, X_ld, Div_start
 );
 
 Datapath_UNIT : SQRT_datapath
 port map (
	RST, CLK,
	X_in,
	result,
	X_sel, X_ld,
	Div_start,
	Div_done
 );

end Behavioral;
