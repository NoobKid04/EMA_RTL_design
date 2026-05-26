library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;

entity Exp_Datapath is
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld : in STD_LOGIC;
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0)
 );
end Exp_Datapath;

architecture rtl of Exp_Datapath is
 --signal
 signal X, Xneg, X1_in, X2_in, X3_in, X4_in, X1, X2, X3, X4, X12_in, X34_in, X12, X34, Exp_in : STD_LOGIC_VECTOR (15 downto 0);
 signal Xneg_comp0, X_comp0, Xneg_lut_int, X_lut_int, Xneg_lut_frac, X_lut_frac, Xneg_lut_frac2, X_lut_frac2 : STD_LOGIC_VECTOR (15 downto 0);
 --component
 component exp_lut_int
  port (
	addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
    data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
  );
 end component;
 component expneg_lut_int
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
 component expneg_lut_frac
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
 component expneg_lut_frac2
  port (
	addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 3-bit input (0..8)
    data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
  );
 end component;

 begin
	--Xcomp
	X_comp0 <= x"0100" when X(15 downto 12) = "0000" else x"0000";
	Xneg_comp0 <= x"0100" when Xneg(15 downto 12) = "0000" else x"FFFF";
	X1_in <= X_comp0 when X(15) = '0' else Xneg_comp0;
	X2_in <= X_lut_int when X(15) = '0' else Xneg_lut_int;
	X3_in <= X_lut_frac when X(15) = '0' else Xneg_lut_frac;
	X4_in <= X_lut_frac2 when X(15) = '0' else Xneg_lut_frac2;

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
	port map (X(11 downto 8), X_lut_int);
	LUT2 : exp_lut_frac
	port map (X(7 downto 4), X_lut_frac);
	LUT3 : exp_lut_frac2
	port map (X(3 downto 0), X_lut_frac2);
	LUT4 : expneg_lut_int
	port map (Xneg(11 downto 8), Xneg_lut_int);
	LUT5 : expneg_lut_frac
	port map (Xneg(7 downto 4), Xneg_lut_frac);
	LUT6 : expneg_lut_frac2
	port map (Xneg(3 downto 0), Xneg_lut_frac2);

	--Reg
	REGX : Regn
	generic map (16)
  	port map (RST, CLK, X_ld, X_in, X);
	REGX1 : Regn
	generic map (16)
  	port map (RST, CLK, X1_ld, X1_in, X1);
	REGX2 : Regn
	generic map (16)
  	port map (RST, CLK, X2_ld, X2_in, X2);
	REGX3 : Regn
	generic map (16)
  	port map (RST, CLK, X3_ld, X3_in, X3);
	REGX4 : Regn
	generic map (16)
  	port map (RST, CLK, X4_ld, X4_in, X4);
	REGX12 : Regn
	generic map (16)
  	port map (RST, CLK, X12_ld, X12_in, X12);
	REGX34 : Regn
	generic map (16)
  	port map (RST, CLK, X34_ld, X34_in, X34);
	REGEXP : Regn
	generic map (16)
  	port map (RST, CLK, Exp_ld, Exp_in, Exp_o);

end rtl;
