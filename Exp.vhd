library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Exp is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
end Exp;

architecture rtl of Exp is
 --component
 component Exp_Controller
  port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	Done_o : out STD_LOGIC;
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld : out STD_LOGIC
  );
 end component;
 component Exp_Datapath
  port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld : in STD_LOGIC;
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0)
  );
 end component;

 --signal
 signal X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld : STD_LOGIC;

 begin
  CTRL_UNIT : Exp_Controller
   port map (
	RST, CLK,
	Start_i,
	Done_o,
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld
   );

  Datapath_UNIT : Exp_Datapath
   port map (
	RST, CLK,
	X_in,
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld,
	Exp_o
   );
end rtl;
