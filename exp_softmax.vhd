library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;

entity exp_softmax is
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0)
 );
end exp_softmax;

architecture rtl of exp_softmax is
 --signal
 signal X, Xneg, X1, X2, X3, X4, X12_in, X34_in, X12, X34, Exp_in : STD_LOGIC_VECTOR (15 downto 0);
 signal X_comp0, X_lut_int, X_lut_frac, X_lut_frac2 : STD_LOGIC_VECTOR (15 downto 0);
 --component
 component exp_lut_int
  port (
	addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
    data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
  );
 end component;
 component exp_lut_frac
  port (
	addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 3-bit input (0..8)
    data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
  );
 end component;
 component exp_lut_frac2
  port (
	addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 3-bit input (0..8)
    data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
  );
 end component;

 begin
	--Xcomp
	X_comp0 <= x"0100" when Xneg(15 downto 12) = "0000" else x"0000";

	--Calculate
	MUL1 : booth_wallace_multiplier
	port map (X1, X2, X12_in);
	MUL2 : booth_wallace_multiplier
	port map (X3, X4, X34_in);
	MUL3 : booth_wallace_multiplier
	port map (X12, X34, Exp_in);
	Xneg <= STD_LOGIC_VECTOR( - SIGNED(X) ); 
	
	--LUT
	LUT1 : exp_lut_int
	port map (Xneg(11 downto 8), X_lut_int);
	LUT2 : exp_lut_frac
	port map (Xneg(7 downto 4), X_lut_frac);
	LUT3 : exp_lut_frac2
	port map (Xneg(3 downto 0), X_lut_frac2);

	--Reg
	REGX : Regn
	generic map (16)
  	port map (RST, CLK, '1', X_in, X);
	REGX1 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X_comp0, X1);
	REGX2 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X_lut_int, X2);
	REGX3 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X_lut_frac, X3);
	REGX4 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X_lut_frac2, X4);
	REGX12 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X12_in, X12);
	REGX34 : Regn
	generic map (16)
  	port map (RST, CLK, '1', X34_in, X34);
	REGEXP : Regn
	generic map (16)
  	port map (RST, CLK, '1', Exp_in, Exp_o);

end rtl;
