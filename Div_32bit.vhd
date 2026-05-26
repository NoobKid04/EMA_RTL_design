library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Div_32bit is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (31 downto 0);
	result : out STD_LOGIC_VECTOR (31 downto 0);
	Done_o : out STD_LOGIC
 );
end Div_32bit;

architecture rtl of Div_32bit is
 --component
 component Div_32bit_controller
  port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	Done_o : out STD_LOGIC;
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, X_o_ld, Y_o_ld, mul_sel, F_ld : out STD_LOGIC
  );
 end component;
 component Div_32bit_datapath
  port (
	RST, CLK : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (31 downto 0);
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, mul_sel, X_o_ld, Y_o_ld, F_ld : in STD_LOGIC;
	result : out STD_LOGIC_VECTOR (31 downto 0)
  );
 end component;

 --signal
 signal X_ld, Y_ld, X_norm_ld, Y_norm_ld, mul_sel, X_o_ld, Y_o_ld, F_ld : STD_LOGIC;

 begin
  CTRL_UNIT : Div_32bit_controller
   port map (
	RST, CLK,
	Start_i,
	Done_o,
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, X_o_ld, Y_o_ld, mul_sel, F_ld
   );

  Datapath_UNIT : Div_32bit_datapath
   port map (
	RST, CLK,
	X_in, Y_in,
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, mul_sel, X_o_ld, Y_o_ld, F_ld,
	result
   );
end rtl;
