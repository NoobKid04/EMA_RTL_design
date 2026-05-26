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

entity AvgPoolW_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, X_add_ld, X_div_ld, X_add_mux, Div_start, CHW_comp_ld : in STD_LOGIC;
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	H_comp, CHW_comp, Div_done : out STD_LOGIC
 );
end AvgPoolW_datapath;

architecture Behavioral of AvgPoolW_datapath is
signal Wc_in, Hc_in, Cc_in, W_c, H_c, C_c, W_add, H_add, C_add, mulHW, mulCHW, base, X_add1, X_add_in, X_add, H_real, addra_mul, addra_add, mulCH, addra_in: STD_LOGIC_VECTOR (15 downto 0);
signal W_comp, C_comp, HW_comp, H_compbuf, CHW_comp_in : STD_LOGIC;
begin
 --logic
 HW_comp <= H_compbuf and W_comp;
 CHW_comp_in <= HW_comp and C_comp;
 H_real <= H(7 downto 0) & x"00";
 --Comp
 H_compbuf <= '1' when H_add = H else '0';
 H_comp <= H_compbuf;
 W_comp <= '1' when W_add = W else '0';
 C_comp <= '1' when C_add = C else '0';
 --Mux
 Hc_in <= x"0000" when H_compbuf = '1' else H_add;
 Wc_in <= x"0000" when W_comp = '1' else W_add;
 Cc_in <= x"0000" when C_comp = '1' else C_add;
 X_add_in <= x"0000" when X_add_mux = '0' else X_add1;
 --Add
 W_add  <= std_logic_vector(unsigned(W_c)  + to_unsigned(1, 16));
 H_add  <= std_logic_vector(unsigned(H_c)  + to_unsigned(1, 16));
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 base   <= std_logic_vector(unsigned(mulCHW) + unsigned(mulHW));
 addrb  <= std_logic_vector(unsigned(base) + unsigned(W_c));
 X_add1 <= std_logic_vector(signed(doutb) + signed(X_add));
 addra_add <= std_logic_vector(unsigned(addra_mul) + unsigned(W_c));
 addra_in <= std_logic_vector(unsigned(addra_add) + unsigned(mulCH));
 --Mul
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mul2 : mul_16bit
 port map (H_c, W, mulHW);
 Mul3 : mul_16bit
 port map (C, H, mulCH);
 Div : Div_16bit
 port map (RST, CLK, Div_start, X_add, H_real, dina, Div_done);
 ADDRMUL : mul_16bit
 port map (C_c, W, addra_mul);
 --Reg
 Reg1 : Regn
 port map (RST, CLK, count_ld, Hc_in, H_c);
 Reg2 : Regn
 port map (RST, CLK, H_compbuf, Wc_in, W_c);
 Reg3 : Regn
 port map (RST, CLK, HW_comp, Cc_in, C_c);
 Reg4 : Regn
 port map (RST, CLK, X_add_ld, X_add_in, X_add);
 Reg6 : Reg1bit
 port map (RST, CLK, CHW_comp_ld, CHW_comp_in, CHW_comp);
 Reg7 : Regn
 port map (RST, CLK, H_compbuf, addra_in, addra);
end Behavioral;
