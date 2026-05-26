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

entity AvgPool_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, X_add_ld, X_add_mux, Div_start, CHW_comp_ld : in STD_LOGIC;
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	HW_comp, CHW_comp, Div_done : out STD_LOGIC
 );
end AvgPool_datapath;

architecture Behavioral of AvgPool_datapath is
signal Wc_in, Hc_in, Cc_in, W_c, H_c, C_c, W_add, H_add, C_add, mulHW, mulCHW, base : STD_LOGIC_VECTOR (15 downto 0);
signal X_add1, X_add_in, X_add, HW_real, doutb32, dina32 : STD_LOGIC_VECTOR (31 downto 0);
signal H_comp, C_comp, W_comp, HW_compbuf, CHW_comp_in : STD_LOGIC;
begin
 --logic
 HW_compbuf <= W_comp and H_comp;
 CHW_comp_in <= HW_compbuf and C_comp;
 HW_real <= x"00" & HW & x"00";
 doutb32 <= std_logic_vector(resize(signed(doutb), 32));
 dina <= dina32(15 downto 0);
 --Comp
 W_comp <= '1' when W_add = W else '0';
 H_comp <= '1' when H_add = H else '0';
 C_comp <= '1' when C_add = C else '0';
 HW_comp <= HW_compbuf;
 --Mux
 Wc_in <= x"0000" when W_comp = '1' else W_add;
 Hc_in <= x"0000" when H_comp = '1' else H_add;
 Cc_in <= x"0000" when C_comp = '1' else C_add;
 X_add_in <= x"00000000" when X_add_mux = '0' else X_add1;
 --Add
 W_add  <= std_logic_vector( unsigned(W_c)  + to_unsigned(1, 16) );
 H_add  <= std_logic_vector( unsigned(H_c)  + to_unsigned(1, 16) );
 C_add  <= std_logic_vector( unsigned(C_c)  + to_unsigned(1, 16) );
 base   <= std_logic_vector( unsigned(mulCHW) + unsigned(mulHW) );
 addrb  <= std_logic_vector( unsigned(base) + unsigned(W_c) );
 X_add1 <= std_logic_vector( signed(doutb32) + signed(X_add) );
 --Mul
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mul2 : mul_16bit
 port map (H_c, W, mulHW);
 Div : Div_32bit
 port map (RST, CLK, Div_start, X_add, HW_real, dina32, Div_done);
 --Reg
 Reg1 : Regn
 port map (RST, CLK, count_ld, Wc_in, W_c);
 Reg2 : Regn
 port map (RST, CLK, W_comp, Hc_in, H_c);
 Reg3 : Regn
 port map (RST, CLK, HW_compbuf, Cc_in, C_c);
 Reg4 : Regn
 generic map (32)
 port map (RST, CLK, X_add_ld, X_add_in, X_add);
 Reg5 : Regn
 port map (RST, CLK, HW_compbuf, C_c, addra);
 Reg6 : Reg1bit
 port map (RST, CLK, CHW_comp_ld, CHW_comp_in, CHW_comp);
end Behavioral;
