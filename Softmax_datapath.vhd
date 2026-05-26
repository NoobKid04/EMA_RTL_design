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

entity Softmax_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, X_max, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, Sum_sel, Sum_ld : in STD_LOGIC;
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	C_comp : out STD_LOGIC
 );
end Softmax_datapath;

architecture Behavioral of Softmax_datapath is
signal Cc_in, C_c, C_add, Sum_add, Sum, Sum_in, X_sub, e_negX, addra13, addra12, addra11, addra10, addra9, addra8, addra7, addra6, addra5, addra4, addra3, addra2, addra1 : STD_LOGIC_VECTOR (15 downto 0);
signal C_comp_buf : STD_LOGIC;
--Component
component exp_softmax
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0)
 );
 end component;
begin
 --logic
 C_comp <= C_comp_buf;
 addrb <= C_c;
 --Comp
 C_comp_buf <= '1' when C_add = C else '0';
 --Mux
 Cc_in <= x"0000" when C_comp_buf = '1' else C_add;
 Sum_in <= Sum_add when Sum_sel = '1' else x"0000";
 --Add
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 Sum_add <= std_logic_vector(signed(e_negX)  + signed(Sum));
 --Sub
 X_sub <= std_logic_vector(signed(doutb) - signed(X_max));
 --Exp
 Exp : exp_softmax
 port map (RST, CLK, X_sub, e_negX);
 --Div
 Div : Div_16bit_continuos
 port map (RST, CLK, e_negX, Sum, dina);
 --Reg
 RegC : Regn
 port map (RST, CLK, count_ld, Cc_in, C_c);
 RegSum : Regn
 port map (RST, CLK, Sum_ld, Sum_in, Sum);
 Regaddra10 : Regn
 port map (RST, CLK, '1', C_c, addra13);
 Regaddra13 : Regn
 port map (RST, CLK, '1', addra13, addra12);
 Regaddra12 : Regn
 port map (RST, CLK, '1', addra12, addra11);
 Regaddra11 : Regn
 port map (RST, CLK, '1', addra11, addra10);
 Regaddra9 : Regn
 port map (RST, CLK, '1', addra10, addra9);
 Regaddra8 : Regn
 port map (RST, CLK, '1', addra9, addra8);
 Regaddra7 : Regn
 port map (RST, CLK, '1', addra8, addra7);
 Regaddra6 : Regn
 port map (RST, CLK, '1', addra7, addra6);
 Regaddra5 : Regn
 port map (RST, CLK, '1', addra6, addra5);
 Regaddra4 : Regn
 port map (RST, CLK, '1', addra5, addra4);
 Regaddra3 : Regn
 port map (RST, CLK, '1', addra4, addra3);
 Regaddra2 : Regn
 port map (RST, CLK, '1', addra3, addra2);
 Regaddra1 : Regn
 port map (RST, CLK, '1', addra2, addra1);
 Regaddra : Regn
 port map (RST, CLK, '1', addra1, addra);
end Behavioral;
