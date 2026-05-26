library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package My_component_lib is

 component cla_16bit
  port (
    A, B  : in  STD_LOGIC_VECTOR(15 downto 0);
    Cin   : in  STD_LOGIC;
    Sum   : out STD_LOGIC_VECTOR(15 downto 0);
    Cout  : out STD_LOGIC
  );
 end component;

 component sub_16bit
  port (
    A, B    : in  STD_LOGIC_VECTOR(15 downto 0);
    Diff    : out STD_LOGIC_VECTOR(15 downto 0);
    Bout    : out STD_LOGIC
  );
 end component;

 component booth_wallace_multiplier
  port (
    X      : in  STD_LOGIC_VECTOR(15 downto 0);
    Y      : in  STD_LOGIC_VECTOR(15 downto 0);
    result : out STD_LOGIC_VECTOR(15 downto 0)
  );
 end component;
 
 component Regn is
  generic (DATA_WIDTH : Integer := 16);
  port (
	RST, CLK : in STD_LOGIC;
	En : in STD_LOGIC;
	D : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	Q : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
  );
 end component;
 
 component Reg1bit is
  port (
	RST, CLK : in STD_LOGIC;
	En : in STD_LOGIC;
	D : in STD_LOGIC;
	Q : out STD_LOGIC
  );
 end component;
 
 component mul_16bit
  port (
    X      : in  STD_LOGIC_VECTOR(15 downto 0);
    Y      : in  STD_LOGIC_VECTOR(15 downto 0);
    result : out STD_LOGIC_VECTOR(15 downto 0)
  );
 end component;
 
 component mul_q24_8
  port (
    RST, CLK : in  STD_LOGIC;
    X, Y     : in  STD_LOGIC_VECTOR(31 downto 0);
    result   : out STD_LOGIC_VECTOR(31 downto 0)
  );
 end component;
 
 component mul_16_noclip
  port (
    X      : in  STD_LOGIC_VECTOR(15 downto 0);
    Y      : in  STD_LOGIC_VECTOR(15 downto 0);
    result : out STD_LOGIC_VECTOR(31 downto 0)
  );
 end component;
 
 component Div_16bit is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (15 downto 0);
	result : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;

 component Div_32bit is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (31 downto 0);
	result : out STD_LOGIC_VECTOR (31 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 
 component exp_continuos
 port (
	RST, CLK : in STD_LOGIC;
	X_in : in STD_LOGIC_VECTOR (15 downto 0);
	Exp_o : out STD_LOGIC_VECTOR (15 downto 0)
 );
 end component;
 
 component Div_16bit_continuos
 port (
	RST, CLK : in STD_LOGIC;
	X_in, Y_in : in STD_LOGIC_VECTOR (15 downto 0);
	result : out STD_LOGIC_VECTOR (15 downto 0)
 );
 end component;
end My_component_lib;
