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

entity GroupNorm_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, HW, idoutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start : in STD_LOGIC;
    odina, iaddrb, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done : out STD_LOGIC
 );
end GroupNorm_datapath;

architecture Behavioral of GroupNorm_datapath is
--Counter
signal Wc_in, Hc_in, Cc_in, W_c, H_c, C_c, W_add, H_add, C_add : STD_LOGIC_VECTOR (15 downto 0);
signal W_comp, H_comp, C_compbuf : STD_LOGIC;

--In/Out
signal mulCHW, mulHW, base, addr, oaddra4, oaddra3, oaddra2, oaddra1, odina_in : STD_LOGIC_VECTOR (15 downto 0);

--Mean
signal X_add1_mux, X_add1_in, X_add1, u_in, u :  STD_LOGIC_VECTOR (31 downto 0);

--Var
signal X_sub_in, X_sub, X_mul, X_add2_mux, X_add2_in, X_add2, o2_in : STD_LOGIC_VECTOR (31 downto 0);
signal o2 : STD_LOGIC_VECTOR (15 downto 0);

--Calculate
signal o1, o, ro_in, ro, Xf_in, Xf, X_mul2, gamma, beta : STD_LOGIC_VECTOR (15 downto 0);
signal HW_real, idoutb32 : STD_LOGIC_VECTOR (31 downto 0);

--Component
component SQRT 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	result : out STD_LOGIC_VECTOR(15 downto 0);
	Done_o : out STD_LOGIC
 );
end component;
component bram_gn_bias
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end component;

component bram_gn_weight
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end component;

begin
 --Counter
 --logic
 HW_comp <= W_comp and H_comp;
 HW_real <= X"00" & HW(15 downto 0) & x"00";
 idoutb32 <= std_logic_vector(resize(signed(idoutb), 32));
 --Comp
 W_comp <= '1' when W_add = W else '0';
 C_comp <= C_compbuf;
 H_comp <= '1' when H_add = H else '0';
 C_compbuf <= '1' when C_add = C else '0';
 --Mux
 Wc_in <= x"0000" when W_comp = '1' else W_add;
 Hc_in <= x"0000" when H_comp = '1' else H_add;
 Cc_in <= x"0000" when C_compbuf = '1' else C_add;
 --Add
 W_add  <= std_logic_vector(unsigned(W_c)  + to_unsigned(1, 16));
 H_add  <= std_logic_vector(unsigned(H_c)  + to_unsigned(1, 16));
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 --Reg
 RegW : Regn
 port map (RST, CLK, count_ld, Wc_in, W_c);
 RegH : Regn
 port map (RST, CLK, W_comp, Hc_in, H_c);
 RegC : Regn
 port map (RST, CLK, C_ld, Cc_in, C_c);
 
 --In/Out
 --Logic
 iaddrb <= addr;
 --Cal
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mul2 : mul_16bit
 port map (H_c, W, mulHW);
 base <= std_logic_vector(unsigned(mulCHW) + unsigned(mulHW));
 addr <= std_logic_vector(unsigned(base) + unsigned(W_c));
 --Reg
 Regoaddra4 : Regn
 port map (RST, CLK, '1', addr, oaddra4);
 Regoaddra3 : Regn
 port map (RST, CLK, '1', oaddra4, oaddra3);
 Regoaddra2 : Regn
 port map (RST, CLK, '1', oaddra3, oaddra2);
 Regoaddra1 : Regn
 port map (RST, CLK, '1', oaddra2, oaddra1);
 Regoaddra : Regn
 port map (RST, CLK, '1', oaddra1, oaddra);
 Regodina : Regn
 port map (RST, CLK, '1', odina_in, odina);
 --Weight, Bias
 Weight : bram_gn_weight
 port map (CLK, '1', C_c(3 downto 0), gamma);
 Bias : bram_gn_bias
 port map (CLK, '1', C_c(3 downto 0), beta);
 
 --Mean
 --Mux
 X_add1_in <= x"00000000" when x_add1_sel = '0' else X_add1_mux; 
 --Cal
 X_add1_mux <= std_logic_vector(signed(idoutb32) + signed(X_add1));
 Div1 : Div_32bit
 port map (RST, CLK, Div_start1, X_add1, HW_real, u_in, Div_done1);
 --Reg
 RegXadd1 : Regn
 generic map (32)
 port map (RST, CLK, X_add1_ld, X_add1_in, X_add1);
 RegXu : Regn
 generic map (32)
 port map (RST, CLK, u_ld, u_in, u);
 
 --Var
 --Logic
 o2 <= o2_in(15 downto 0);
 --Mux
 X_add2_in <= x"00000000" when x_add2_sel = '0' else X_add2_mux; 
 --Cal
 X_sub_in <= std_logic_vector(signed(idoutb32) - signed(u));
 Mul : mul_q24_8
 port map (RST, CLK, X_sub, X_sub, X_mul);
 X_add2_mux <= std_logic_vector(signed(X_mul) + signed(X_add2));
 Div2 : Div_32bit
 port map (RST, CLK, Div_start2, X_add2, HW_real, o2_in, Div_done2);
 --Reg
 RegXadd2 : Regn                         
 generic map (32)                        
 port map (RST, CLK, X_add2_ld, X_add2_in, X_add2);
 RegXsub : Regn                         
 generic map (32)                        
 port map (RST, CLK, '1', X_sub_in, X_sub);
 
 --Calculate
 --Cal
 o1 <= std_logic_vector(signed(o2) + to_signed(1, 16));
 SQRT1 : SQRT
 port map (RST, CLK, SQRT_start, o1, o, SQRT_done);
 Div3 : Div_16bit
 port map (RST, CLK, Div_start3, x"0100", o, ro_in, Div_done3);
 Mulbooth1 : booth_wallace_multiplier
 port map (X_sub(15 downto 0), ro, Xf_in);
 Mulbooth2 : booth_wallace_multiplier
 port map (Xf, gamma, X_mul2);
 odina_in <= std_logic_vector(signed(X_mul2) + signed(beta));
 --Reg
 Reg1o : Regn
 port map (RST, CLK, ro_ld, ro_in, ro);
 RegXf : Regn
 port map (RST, CLK, '1', Xf_in, Xf);
end Behavioral;
