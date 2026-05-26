library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;

entity Div_16bit_Datapath is
 port (
	RST, CLK : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (15 downto 0);
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, mul_sel, X_o_ld, Y_o_ld, F_ld : in STD_LOGIC;
	result : out STD_LOGIC_VECTOR (15 downto 0)
 );
end Div_16bit_Datapath;

architecture rtl of Div_16bit_Datapath is
 --signal
 signal X_shift1, X_shift2, Y_shift1, Y_shift2, X, Y, X_norm_in, Y_norm_in, X_norm, Y_norm, X_mul_in, X_mul, Y_mul_in, Y_mul, X_o_in, Y_o_in, Y_o, X_o, F_in, F, X_mux: STD_LOGIC_VECTOR (15 downto 0);
 signal Y_check1, Y_check2 : STD_LOGIC_VECTOR (3 downto 0);
 signal Y_comp0, X_comp1 : STD_LOGIC;
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
	X_mul_in <= X_norm when mul_sel = '0' else X_o;
	Y_mul_in <= Y_norm when mul_sel = '0' else Y_o;
	X_mux <= X when X_comp1 = '0' else STD_LOGIC_VECTOR( - SIGNED(X) );
	result <= X_o when X_comp1 = '0' else STD_LOGIC_VECTOR( - SIGNED(X_o) );
	
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
	F_in <= std_logic_vector( to_unsigned(512, 16) - unsigned(Y_mul_in) );
	Mul1 : booth_wallace_multiplier
	port map (X_mul, F, X_o_in);
	Mul2 : booth_wallace_multiplier
	port map (Y_mul, F, Y_o_in);
	
	--LUT
	Check1 : Div_check1
	port map (Y(15 downto 8), Y_check1);
	Check2 : Div_check2
	port map (Y(7 downto 0), Y_check2);
	--Reg
	RegX : Regn
	port map (RST, CLK, X_ld, X_in, X);
	RegY : Regn
	port map (RST, CLK, Y_ld, Y_in, Y);
	RegXno : Regn
	port map (RST, CLK, X_norm_ld, X_norm_in, X_norm);
	RegYno : Regn
	port map (RST, CLK, Y_norm_ld, Y_norm_in, Y_norm);
	RegF : Regn
	port map (RST, CLK, F_ld, F_in, F);
	RegXmul : Regn
	port map (RST, CLK, F_ld, X_mul_in, X_mul);
	RegYmul : Regn
	port map (RST, CLK, F_ld, Y_mul_in, Y_mul);
	RegXo : Regn
	port map (RST, CLK, X_o_ld, X_o_in, X_o);
	RegYo : Regn
	port map (RST, CLK, Y_o_ld, Y_o_in, Y_o);
end rtl;