----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2026 12:36:18 AM
-- Design Name: 
-- Module Name: AvgPoolH_datapath - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SQRT_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR(15 downto 0);
	result : out STD_LOGIC_VECTOR(15 downto 0);
	X_sel, X_ld: in STD_LOGIC;
	Div_start : in STD_LOGIC;
	Div_done : out STD_LOGIC
 );
end SQRT_datapath;

architecture Behavioral of SQRT_datapath is
 signal X_mux, X, X_div, X_add, X_shift : STD_LOGIC_VECTOR(15 downto 0);
begin
 --mux
  X_mux <= X_in when X_sel = '0' else X_shift;
  
  --Cal
  Div : Div_16bit
  port map (RST, CLK, Div_start, X_in, X, X_div, Div_done);
  X_add <= std_logic_vector ( unsigned (X_div) + unsigned (X) );
  X_shift <= std_logic_vector (SHIFT_RIGHT( unsigned(X_add), 1));
  
  --Reg
  Reg1 : Regn
  port map (RST, CLK, X_ld, X_mux, X);
  
  --result
  result <= X;
end Behavioral;
