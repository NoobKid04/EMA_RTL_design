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

entity elemul_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, idoutb1, idoutb2, idoutb3 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    iaddrb1, iaddrb2, iaddrb3, odina, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	CHW_comp : out STD_LOGIC
 );
end elemul_datapath;

architecture Behavioral of elemul_datapath is
signal Wc_in, Hc_in, Cc_in, W_c, H_c, C_c, W_add, H_add, C_add, mulHW, mulCHW, mulCH, mulCW, oaddra_base, oaddra_in, oaddra3, oaddra2, oaddra1, odina1, odina_mul_in, odina_mul, idoutb3_d: STD_LOGIC_VECTOR (15 downto 0);
signal W_comp, H_comp, C_comp, HW_comp : STD_LOGIC;
begin
 --logic
 HW_comp <= W_comp and H_comp;
 CHW_comp <= HW_comp and C_comp;
 iaddrb3 <= oaddra_in;
 --Comp
 W_comp <= '1' when W_add = W else '0';
 H_comp <= '1' when H_add = H else '0';
 C_comp <= '1' when C_add = C else '0';
 --Mux
 Wc_in <= x"0000" when W_comp = '1' else W_add;
 Hc_in <= x"0000" when H_comp = '1' else H_add;
 Cc_in <= x"0000" when C_comp = '1' else C_add;
 --Add
 W_add  <= std_logic_vector(unsigned(W_c)  + to_unsigned(1, 16));
 H_add  <= std_logic_vector(unsigned(H_c)  + to_unsigned(1, 16));
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 oaddra_base   <= std_logic_vector(unsigned(mulCHW) + unsigned(mulHW));
 oaddra_in  <= std_logic_vector(unsigned(oaddra_base) + unsigned(W_c));
 iaddrb1  <= std_logic_vector(unsigned(mulCH) + unsigned(H_c));
 iaddrb2  <= std_logic_vector(unsigned(mulCW) + unsigned(W_c));
 --Mul
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mul2 : mul_16bit
 port map (H_c, W, mulHW);
 Mul3 : mul_16bit
 port map (C_c, H, mulCH);
 Mul4 : mul_16bit
 port map (C_c, W, mulCW);
 Mul5 : booth_wallace_multiplier
 port map (idoutb1, idoutb2, odina_mul_in);
 Mul6 : booth_wallace_multiplier
 port map (odina_mul, idoutb3_d, odina1);
 --Reg
 Reg1 : Regn
 port map (RST, CLK, count_ld, Wc_in, W_c);
 Reg2 : Regn
 port map (RST, CLK, W_comp, Hc_in, H_c);
 Reg3 : Regn
 port map (RST, CLK, HW_comp, Cc_in, C_c);
 Reg4 : Regn
 port map (RST, CLK, '1', odina_mul_in, odina_mul);
 Reg_odina : Regn
 port map (RST, CLK, '1', odina1, odina);
 Reg_oaddra3 : Regn
 port map (RST, CLK, '1', oaddra_in, oaddra3);
 Reg5 : Regn
 port map (RST, CLK, '1', oaddra3, oaddra2);
 Reg6 : Regn
 port map (RST, CLK, '1', oaddra2, oaddra1);
 Reg7 : Regn
 port map (RST, CLK, '1', oaddra1, oaddra);
 Reg_delay : Regn
port map (RST, CLK, '1', idoutb3, idoutb3_d);
end Behavioral;
