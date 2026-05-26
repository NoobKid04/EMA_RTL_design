library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;

entity Div_16bit_continuos is
 port (
	RST, CLK : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (15 downto 0);
	result : out STD_LOGIC_VECTOR (15 downto 0)
 );
end Div_16bit_continuos;

architecture rtl of Div_16bit_continuos is
 --signal
 signal X_shift1, X_shift2, Y_shift1, Y_shift2, X, Y, X_norm_in, Y_norm_in, X_norm, X_normK, Y_norm, Y_normK, X1_in, Y1_in, Y1, Y1K, X1, X1K, F1_in, F1, X2_in, Y2_in, Y2, Y2k, X2, X2K, F2_in, F2, X3_in, X3, F3_in, F3, X_mux: STD_LOGIC_VECTOR (15 downto 0);
 signal Y_check1, Y_check2 : STD_LOGIC_VECTOR (3 downto 0);
 signal Y_comp0, X_comp1, X_comp2, X_comp3, X_comp4, X_comp5, X_comp6, X_comp7, X_comp8 : STD_LOGIC;
 --component
 component Div_check1
  port (
	data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
    position : out STD_LOGIC_VECTOR(3 downto 0)
  );
 end component;
 component Div_check2
  port (
	data_in  : in  STD_LOGIC_VECTOR(7 downto 0); 
    position : out STD_LOGIC_VECTOR(3 downto 0)   
  );
 end component;
 component barrel_shift_left
  generic (
	DATA_WIDTH  : integer := 16;
    SHIFT_WIDTH : integer := 4
  );
  port (
	data_in   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    shift_amt : in  STD_LOGIC_VECTOR(SHIFT_WIDTH-1 downto 0);
    data_out  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
  );
 end component;
 component barrel_shift_right
  generic (
	DATA_WIDTH  : integer := 16;
    SHIFT_WIDTH : integer := 4
  );
  port (
	data_in   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    shift_amt : in  STD_LOGIC_VECTOR(SHIFT_WIDTH-1 downto 0);
    data_out  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
  );
 end component;

 begin
	--Xcomp
	Y_comp0 <= '1' when Y(15 downto 8) = "00000000" else '0';
	X_comp1 <= '1' when X(15) = '1' else '0';

	--MUX
	X_norm_in <= X_shift1 when Y_comp0 = '0' else X_shift2;
	Y_norm_in <= Y_shift1 when Y_comp0 = '0' else Y_shift2;
	X_mux <= X when X_comp1 = '0' else STD_LOGIC_VECTOR( - SIGNED(X) );
	result <= X3 when X_comp8 = '0' else STD_LOGIC_VECTOR( - SIGNED(X3) );
	
	--Shift
	Shiftright1 : barrel_shift_right
	port map (X_mux, Y_check1, X_shift1);
	Shiftright2 : barrel_shift_right
	port map (Y, Y_check1, Y_shift1);
	Shiftleft1 : barrel_shift_left
	port map (X_mux, Y_check2, X_shift2);
	Shiftleft2 : barrel_shift_left
	port map (Y, Y_check2, Y_shift2);

	--Calculate
	F1_in <= std_logic_vector( to_unsigned(512, 16) - unsigned(Y_normK) );
	F2_in <= std_logic_vector( to_unsigned(512, 16) - unsigned(Y1K) );
	F3_in <= std_logic_vector( to_unsigned(512, 16) - unsigned(Y2K) );
	
	Mul1 : booth_wallace_multiplier port map (X_norm, F1, X1_in);   -- X1_in = X_norm * F1
    Mul2 : booth_wallace_multiplier port map (Y_norm, F1, Y1_in);   -- Y1_in = Y_norm * F1
    Mul3 : booth_wallace_multiplier port map (X1,     F2, X2_in);   -- X2_in = X1 * F2
    Mul4 : booth_wallace_multiplier port map (Y1,     F2, Y2_in);   -- Y2_in = Y1 * F2
    Mul5 : booth_wallace_multiplier port map (X2,     F3, X3_in);   -- X3_in = X2 * F3
	
	--LUT
	Check1 : Div_check1
	port map (Y(15 downto 8), Y_check1);
	Check2 : Div_check2
	port map (Y(7 downto 0), Y_check2);
	--Reg
	RegX : Regn
	port map (RST, CLK, '1', X_in, X);
	RegY : Regn
	port map (RST, CLK, '1', Y_in, Y);
	RegXnoK : Regn
	port map (RST, CLK, '1', X_norm_in, X_normK);
	RegYnoK : Regn
	port map (RST, CLK, '1', Y_norm_in, Y_normK);
	RegXno : Regn
	port map (RST, CLK, '1', X_normK, X_norm);
	RegYno : Regn
	port map (RST, CLK, '1', Y_normK, Y_norm);
	RegX1K : Regn
	port map (RST, CLK, '1', X1_in, X1K);
	RegY1K : Regn
	port map (RST, CLK, '1', Y1K, Y1);
	RegX1 : Regn
	port map (RST, CLK, '1', X1K, X1);
	RegY1 : Regn
	port map (RST, CLK, '1', Y1_in, Y1K);
	RegF1 : Regn
	port map (RST, CLK, '1', F1_in, F1);
	RegX2K : Regn
	port map (RST, CLK, '1', X2_in, X2K);
	RegY2K : Regn
	port map (RST, CLK, '1', Y2_in, Y2K);
	RegX2 : Regn
	port map (RST, CLK, '1', X2K, X2);
	RegY2 : Regn
	port map (RST, CLK, '1', Y2K, Y2);
	RegF2 : Regn
	port map (RST, CLK, '1', F2_in, F2);
	RegX3 : Regn
	port map (RST, CLK, '1', X3_in, X3);
	RegF3 : Regn
	port map (RST, CLK, '1', F3_in, F3);
	RegXcomp2 : Reg1bit
	port map (RST, CLK, '1', X_comp1, X_comp2);
	RegXcomp3 : Reg1bit
	port map (RST, CLK, '1', X_comp2, X_comp3);
	RegXcomp4 : Reg1bit
	port map (RST, CLK, '1', X_comp3, X_comp4);
	RegXcomp5 : Reg1bit
	port map (RST, CLK, '1', X_comp4, X_comp5);
	RegXcomp6 : Reg1bit
	port map (RST, CLK, '1', X_comp5, X_comp6);
	RegXcomp7 : Reg1bit
	port map (RST, CLK, '1', X_comp6, X_comp7);
	RegXcomp8 : Reg1bit
	port map (RST, CLK, '1', X_comp7, X_comp8);
end rtl;