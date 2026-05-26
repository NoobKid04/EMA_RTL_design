----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2026 11:25:43 PM
-- Design Name: 
-- Module Name: EMA - Behavioral
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

entity EMA_datapath is
 Port (
    RST, CLK : in STD_LOGIC;
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld : in STD_LOGIC;
    BramStart_old : in STD_LOGIC_VECTOR(1 downto 0);
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul : in STD_LOGIC;
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul : out STD_LOGIC;
    enb, ena : in STD_LOGIC;
	wea : in STD_LOGIC_VECTOR (0 downto 0);
	addra, dina, addrb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	doutb : out STD_LOGIC_VECTOR (15 downto 0)
 );
end EMA_datapath;

architecture Behavioral of EMA_datapath is
 --Signal
 signal HW_in, CH_in, HW, CH : STD_LOGIC_VECTOR(15 downto 0);
 --Bram_Start
 signal BramStart_enb, AvgH_enb, AvgW_enb, ele_enb, Fimul_enb : STD_LOGIC;
 signal BramStart_addrb, AvgH_addrb, AvgW_addrb, ele_addrb, Fimul_addrb, BramStart_doutb : STD_LOGIC_VECTOR(15 downto 0);
 signal Conv33_enb : STD_LOGIC;
 signal BramStart_addrb1, BramStart_addrb2, BramStart_addrb3, BramStart_addrb4, BramStart_addrb5, BramStart_addrb6, BramStart_addrb7, BramStart_addrb8, BramStart_addrb9 : STD_LOGIC_VECTOR(15 downto 0);
 signal BramStart_doutb1, BramStart_doutb2, BramStart_doutb3, BramStart_doutb4, BramStart_doutb5, BramStart_doutb6, BramStart_doutb7, BramStart_doutb8, BramStart_doutb9 : STD_LOGIC_VECTOR(15 downto 0);
 --Bram_Avg
 signal BramAvgHW_ena, BramAvgHW_enb, AvgH_ena, AvgW_ena : STD_LOGIC;
 signal BramAvgHW_wea, AvgH_wea, AvgW_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal BramAvgHW_addra, AvgH_addra, AvgW_addra, BramAvgHW_dina, AvgH_dina, AvgW_dina, BramAvgHW_addrb, BramAvgHW_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --Bram_Conv11
 signal BramConv11_ena, BramConv11_enb : STD_LOGIC;
 signal BramConv11_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal BramConv11_addra, BramConv11_dina, BramConv11_addrb, BramConv11_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --Sigmoid
 signal SigmoidH_ena, SigmoidW_ena, Sigmoid_ena : STD_LOGIC;
 signal Sigmoid_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal SigmoidH_addra, Sigmoid_dina, SigmoidH_addrb, SigmoidH_doutb, SigmoidW_addra, SigmoidW_addrb, SigmoidW_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --elemul
 signal elemul_ena, elemul_enb : STD_LOGIC;
 signal elemul_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal elemul_addra, elemul_dina, elemul_addrb, elemul_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --GroupNorm
 signal GroupNorm_ena, GroupNorm_enb : STD_LOGIC;
 signal GroupNorm_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal GroupNorm_addra, GroupNorm_dina, GroupNorm_addrb, GroupNorm_doutb : STD_LOGIC_VECTOR(15 downto 0);
 signal Matm2_enb, AvgP1_enb : STD_LOGIC;
 signal Matm2_addrb, AvgP1_addrb : STD_LOGIC_VECTOR(15 downto 0);
 --Bram_Conv33
 signal BramConv33_ena, BramConv33_enb : STD_LOGIC;
 signal BramConv33_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal BramConv33_addra, BramConv33_dina, BramConv33_addrb, BramConv33_doutb : STD_LOGIC_VECTOR(15 downto 0);
 signal Matm1_enb, AvgP2_enb : STD_LOGIC;
 signal Matm1_addrb, AvgP2_addrb : STD_LOGIC_VECTOR(15 downto 0);
 --Bram_Avg1
 signal BramAvg1_ena, BramAvg1_enb, Done_Avg1 : STD_LOGIC;
 signal BramAvg1_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal BramAvg1_addra, BramAvg1_dina, BramAvg1_addrb, BramAvg1_doutb : STD_LOGIC_VECTOR(15 downto 0);
 signal SubAvg1_max, Avg1_max_mux, Avg1_max_in, Avg1_max : STD_LOGIC_VECTOR(15 downto 0);
 signal Avg1_max_ld : STD_LOGIC;
 --Bram_Avg2
 signal BramAvg2_ena, BramAvg2_enb, Done_Avg2 : STD_LOGIC;
 signal BramAvg2_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal BramAvg2_addra, BramAvg2_dina, BramAvg2_addrb, BramAvg2_doutb : STD_LOGIC_VECTOR(15 downto 0);
 signal SubAvg2_max, Avg2_max_mux, Avg2_max_in, Avg2_max : STD_LOGIC_VECTOR(15 downto 0);
 signal Avg2_max_ld : STD_LOGIC;
 --Softmax1
 signal Softmax1_ena, Done_Softmax1 : STD_LOGIC;
 signal Softmax1_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal Softmax1_addra, Softmax1_dina, Softmax1_addrb, Softmax1_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --Softmax2
 signal Softmax2_ena, Done_Softmax2 : STD_LOGIC;
 signal Softmax2_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal Softmax2_addra, Softmax2_dina, Softmax2_addrb, Softmax2_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --Matmul1
 signal Matmul1_ena, Done_Matmul1 : STD_LOGIC;
 signal Matmul1_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal Matmul1_addra, Matmul1_dina, Matmul1_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --Matmul2
 signal Matmul2_ena, Done_Matmul2 : STD_LOGIC;
 signal Matmul2_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal Matmul2_addra, Matmul2_dina, Matmul2_doutb : STD_LOGIC_VECTOR(15 downto 0);
 --AddSigmoid
 signal AddSigmoid_ena, AddSig_enb : STD_LOGIC;
 signal AddSigmoid_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal AddSigmoid_addra, AddSigmoid_dina, AddSigmoid_addrb, AddSigmoid_doutb, AddSig_addrb : STD_LOGIC_VECTOR(15 downto 0);
 --Final
 signal Final_ena : STD_LOGIC;
 signal Final_wea : STD_LOGIC_VECTOR(0 downto 0);
 signal Final_addra, Final_dina : STD_LOGIC_VECTOR(15 downto 0);
 --Component Bram
 component BramStart 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
 end component;
 component Bram16 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
 end component;
 component Bram256 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
 end component;
 component Bram512 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
 end component;
 component Bram4096 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
 end component;
 --Component Cal
 component conv33 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb0, idoutb1, idoutb2, idoutb3, idoutb4, idoutb5, idoutb6, idoutb7, idoutb8, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	iaddrb0, iaddrb1, iaddrb2, iaddrb3, iaddrb4, iaddrb5, iaddrb6, iaddrb7, iaddrb8, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component AvgPoolH 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	write_en : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component AvgPoolW 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component conv11 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	iaddrb, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component Sigmoid2D 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component elemul 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb1, idoutb2, idoutb3, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	iaddrb1, iaddrb2, iaddrb3, odina, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component GroupNorm
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	idoutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	odina, iaddrb, oaddra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component AvgPool 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, H, W, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component Softmax 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb, C, X_max : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component Matmul 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, C, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component AddSigmoid 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
 component FinalAdd 
 Port (
    RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR (0 downto 0);
	doutb1, doutb2, C, HW : in STD_LOGIC_VECTOR (15 downto 0);
	dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	Done_o : out STD_LOGIC
 );
 end component;
begin
 RegHW : Regn
 port map (RST, CLK, '1', HW_in, HW);
 RegCH : Regn
 port map (RST, CLK, '1', CH_in, CH);
 --HW
 HWmul : mul_16bit
 port map (H, W, HW_in);
 CHmul : mul_16bit
 port map (C, H, CH_in);
 --Sigmoid logic
 SigmoidW_addra <= std_logic_vector(signed(SigmoidH_addra)  - signed(CH));
 SigmoidH_ena <= Sigmoid_ena when SigmoidW_addra(15) = '1' else '0';
 SigmoidW_ena <= Sigmoid_ena when SigmoidW_addra(15) = '0' else '0';
 --AvgPool1 logic
 SubAvg1_max <= std_logic_vector(signed(BramAvg1_dina)  - signed(Avg1_max));
 Avg1_max_mux <= Avg1_max when SubAvg1_max(15)='1' else BramAvg1_dina;
 Avg1_max_in <= Avg1_max_mux when Avg_max_sel = '1' else x"0000";
 Avg1_max_ld <= BramAvg1_ena or Avg_max_ld;
 RegAvg1_max : Regn
 port map (RST, CLK, Avg1_max_ld, Avg1_max_in, Avg1_max);
 --AvgPool2 logic
 SubAvg2_max <= std_logic_vector(signed(BramAvg2_dina)  - signed(Avg2_max));
 Avg2_max_mux <= Avg2_max when SubAvg2_max(15)='1' else BramAvg2_dina;
 Avg2_max_in <= Avg2_max_mux when Avg_max_sel = '1' else x"0000";
 Avg2_max_ld <= BramAvg2_ena or Avg_max_ld;
 RegAvg2_max : Regn
 port map (RST, CLK, Avg2_max_ld, Avg2_max_in, Avg2_max);
 --BramStart_logic
 BramStart_enb <= AvgH_enb when BramStart_old = "00" else AvgW_enb when BramStart_old = "01" else ele_enb when BramStart_old = "10" else Fimul_enb;
 BramStart_addrb <= AvgH_addrb when BramStart_old = "00" else AvgW_addrb when BramStart_old = "01" else ele_addrb when BramStart_old = "10" else Fimul_addrb;
 --BramAvgHW
 BramAvgHW_ena <= AvgH_ena when BramAvg1_ild = '0' else AvgW_ena;
 BramAvgHW_wea <= AvgH_wea when BramAvg1_ild = '0' else AvgW_wea;
 BramAvgHW_addra <= AvgH_addra when BramAvg1_ild = '0' else AvgW_addra;
 BramAvgHW_dina <= AvgH_dina when BramAvg1_ild = '0' else AvgW_dina;
 --GroupNorm
 GroupNorm_enb <= AvgP1_enb when Avg_old = '0' else Matm2_enb;
 GroupNorm_addrb <= AvgP1_addrb when Avg_old = '0' else Matm2_addrb;
 BramConv33_enb <= AvgP2_enb when Avg_old = '0' else Matm1_enb;
 BramConv33_addrb <= AvgP2_addrb when Avg_old = '0' else Matm1_addrb;
 --LogicDone
 Done_Avg <= Done_Avg1 and Done_Avg2;
 Done_Softmax <= Done_Softmax1 and Done_Softmax2;
 Done_Matmul <= Done_Matmul1 and Done_Matmul2;
 
 --BramStart
 BramStartno0 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    BramStart_enb,
    BramStart_addrb(11 DOWNTO 0),
    BramStart_doutb
 );
 BramStartno1 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb1(11 DOWNTO 0),
    BramStart_doutb1
 );
 BramStartno2 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb2(11 DOWNTO 0),
    BramStart_doutb2
 );
 BramStartno3 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb3(11 DOWNTO 0),
    BramStart_doutb3
 );
 BramStartno4 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb4(11 DOWNTO 0),
    BramStart_doutb4
 );
 BramStartno5 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb5(11 DOWNTO 0),
    BramStart_doutb5
 );
 BramStartno6 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb6(11 DOWNTO 0),
    BramStart_doutb6
 );
 BramStartno7 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb7(11 DOWNTO 0),
    BramStart_doutb7
 );
 BramStartno8 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb8(11 DOWNTO 0),
    BramStart_doutb8
 );
 BramStartno9 : BramStart
 port map(
    CLK,
    ena,
    wea,
    addra(11 downto 0),
    dina,
    CLK,
    Conv33_enb,
    BramStart_addrb9(11 DOWNTO 0),
    BramStart_doutb9
 );
 
 --Conv33
 Conv33UUT : conv33
 port map(
    RST, CLK,
	Start_Conv33,
	Conv33_enb, BramConv33_ena,
	BramConv33_wea,
	BramStart_doutb1, BramStart_doutb2, BramStart_doutb3, BramStart_doutb4, BramStart_doutb5, BramStart_doutb6, BramStart_doutb7, BramStart_doutb8, BramStart_doutb9, C, H, W, HW,
	BramStart_addrb1, BramStart_addrb2, BramStart_addrb3, BramStart_addrb4, BramStart_addrb5, BramStart_addrb6, BramStart_addrb7, BramStart_addrb8, BramStart_addrb9, BramConv33_addra, BramConv33_dina,
	Done_Conv33
 );
 
 --Bram_Conv33
 BramConv33UUT : Bram4096 
  PORT map (
    CLK,
    BramConv33_ena,
    BramConv33_wea,
    BramConv33_addra(11 downto 0),
    BramConv33_dina,
    CLK,
    BramConv33_enb,
    BramConv33_addrb(11 downto 0),
    BramConv33_doutb
  );
  
  --AvgH
 AvgHUUT : AvgPoolH 
 Port map (
    RST, CLK,
	Start_AvgH,
	AvgH_enb, AvgH_ena,
	AvgH_wea,
	BramStart_doutb, C, H, W, HW,
	AvgH_dina, AvgH_addrb, AvgH_addra,
	Done_AvgH
 );
 
 --AvgW
 AvgWUUT : AvgPoolW 
 Port map (
    RST, CLK,
	Start_AvgW,
	AvgW_enb, AvgW_ena,
	AvgW_wea,
	BramStart_doutb, C, H, W, HW,
	AvgW_dina, AvgW_addrb, AvgW_addra,
	Done_AvgW
 );
 
 --BramAvgHW
 BramAvgHWUUT : Bram512 
  PORT map(
    CLK,
    BramAvgHW_ena,
    BramAvgHW_wea,
    BramAvgHW_addra(8 downto 0),
    BramAvgHW_dina,
    CLK,
    BramAvgHW_enb,
    BramAvgHW_addrb(8 downto 0),
    BramAvgHW_doutb
 );
 
 --Conv11
 Conv11UUT : conv11
 Port map(
    RST, CLK,
	Start_Conv11,
	BramAvgHW_enb, BramConv11_ena,
	BramConv11_wea,
	BramAvgHW_doutb, C, H, W,
	BramAvgHW_addrb, BramConv11_addra, BramConv11_dina,
	Done_Conv11
 );
 
 --Conv11Bram
 BramConv11UUT : Bram512 
  PORT map(
    CLK,
    BramConv11_ena,
    BramConv11_wea,
    BramConv11_addra(8 downto 0),
    BramConv11_dina,
    CLK,
    BramConv11_enb,
    BramConv11_addrb(8 downto 0),
    BramConv11_doutb
 );
 
 --Sigmoid
 SigmoidUUT : Sigmoid2D
 Port map(
    RST, CLK,
	Start_Sigmoid,
	BramConv11_enb, Sigmoid_ena,
	Sigmoid_wea,
	BramConv11_doutb, C, H, W,
	Sigmoid_dina, BramConv11_addrb, SigmoidH_addra,
	Done_Sigmoid
 );
 
 --SigmoidH
 SigmoidHUUT : Bram256 
  PORT map(
    CLK,
    SigmoidH_ena,
    Sigmoid_wea,
    SigmoidH_addra(7 downto 0),
    Sigmoid_dina,
    CLK,
    ele_enb,
    SigmoidH_addrb(7 downto 0),
    SigmoidH_doutb
 );
  
 --SigmoidW
 SigmoidWUUT : Bram256 
  PORT map(
    CLK,
    SigmoidW_ena,
    Sigmoid_wea,
    SigmoidW_addra(7 downto 0),
    Sigmoid_dina,
    CLK,
    ele_enb,
    SigmoidW_addrb(7 downto 0),
    SigmoidW_doutb
 );
  
 --elemul
 elemulUUT : elemul
 Port map(
    RST, CLK,
	Start_elemul,
	ele_enb, elemul_ena,
	elemul_wea,
	SigmoidH_doutb, SigmoidW_doutb, BramStart_doutb, C, H, W, HW,
	SigmoidH_addrb, SigmoidW_addrb, ele_addrb, elemul_dina, elemul_addra,
	Done_elemul
 );
 
 --elemul_bram
 elemulBramUUT : Bram4096 
  PORT map(
    CLK,
    elemul_ena,
    elemul_wea,
    elemul_addra(11 DOWNTO 0),
    elemul_dina,
    CLK,
    elemul_enb,
    elemul_addrb(11 DOWNTO 0),
    elemul_doutb
 );
 
 --GroupNorm
 GroupNormUUT : GroupNorm
 Port map(
    RST, CLK,
	Start_GroupNorm,
	elemul_enb, GroupNorm_ena,
	GroupNorm_wea,
	elemul_doutb, C, H, W, HW,
	GroupNorm_dina, elemul_addrb, GroupNorm_addra,
	Done_GroupNorm
 );
 
 --GroupNormBram
 GroupNormBramUUT : Bram4096 
  PORT map(
    CLK,
    GroupNorm_ena,
    GroupNorm_wea,
    GroupNorm_addra(11 DOWNTO 0),
    GroupNorm_dina,
    CLK,
    GroupNorm_enb,
    GroupNorm_addrb(11 DOWNTO 0),
    GroupNorm_doutb
 );
 
 --AvgPool1
 AvgPool1UUT : AvgPool
 Port map(
    RST, CLK,
	Start_Avg,
	AvgP1_enb, BramAvg1_ena,
	BramAvg1_wea,
	GroupNorm_doutb, C, H, W, HW,
	BramAvg1_dina, AvgP1_addrb, BramAvg1_addra,
	Done_Avg1
 );
 --AvgPool1
 AvgPool2UUT : AvgPool
 Port map(
    RST, CLK,
	Start_Avg,
	AvgP2_enb, BramAvg2_ena,
	BramAvg2_wea,
	BramConv33_doutb, C, H, W, HW,
	BramAvg2_dina, AvgP2_addrb, BramAvg2_addra,
	Done_Avg2
 );
 
 --BramAvg1
 BramAvg1UUT : Bram16 
  PORT map(
    CLK,
    BramAvg1_ena,
    BramAvg1_wea,
    BramAvg1_addra(3 DOWNTO 0),
    BramAvg1_dina,
    CLK,
    BramAvg1_enb,
    BramAvg1_addrb(3 DOWNTO 0),
    BramAvg1_doutb
  );
 --BramAvg2
 BramAvg2UUT : Bram16 
  PORT map(
    CLK,
    BramAvg2_ena,
    BramAvg2_wea,
    BramAvg2_addra(3 DOWNTO 0),
    BramAvg2_dina,
    CLK,
    BramAvg2_enb,
    BramAvg2_addrb(3 DOWNTO 0),
    BramAvg2_doutb
  );
  
 --Softmax1
 Softmax1UUT : Softmax 
 Port map(
    RST, CLK,
	Start_Softmax,
	BramAvg1_enb, Softmax1_ena,
	Softmax1_wea,
	BramAvg1_doutb, C, Avg1_max,
	Softmax1_dina, BramAvg1_addrb, Softmax1_addra,
	Done_Softmax1
 );
 --Softmax2
 Softmax2UUT : Softmax 
 Port map(
    RST, CLK,
	Start_Softmax,
	BramAvg2_enb, Softmax2_ena,
	Softmax2_wea,
	BramAvg2_doutb, C, Avg2_max,
	Softmax2_dina, BramAvg2_addrb, Softmax2_addra,
	Done_Softmax2
 );
 
 --SoftmaxBram1
 SoftmaxBram1UUT : Bram16 
  PORT map(
    CLK,
    Softmax1_ena,
    Softmax1_wea,
    Softmax1_addra(3 DOWNTO 0),
    Softmax1_dina,
    CLK,
    Matm1_enb,
    Softmax1_addrb(3 DOWNTO 0),
    Softmax1_doutb
 );
 --SoftmaxBram1
 SoftmaxBram2UUT : Bram16 
  PORT map(
    CLK,
    Softmax2_ena,
    Softmax2_wea,
    Softmax2_addra(3 DOWNTO 0),
    Softmax2_dina,
    CLK,
    Matm2_enb,
    Softmax2_addrb(3 DOWNTO 0),
    Softmax2_doutb
 );
 
 --Matmul1
 Matmul1UUT : Matmul
 Port map(
    RST, CLK,
	Start_Matmul,
	Matm1_enb, Matmul1_ena,
	Matmul1_wea,
	Softmax1_doutb, BramConv33_doutb, C, HW,
	Matmul1_dina, Softmax1_addrb, Matm1_addrb, Matmul1_addra,
	Done_Matmul1
 );
 --Matmul2
 Matmul2UUT : Matmul
 Port map(
    RST, CLK,
	Start_Matmul,
	Matm2_enb, Matmul2_ena,
	Matmul2_wea,
	Softmax2_doutb, GroupNorm_doutb, C, HW,
	Matmul2_dina, Softmax2_addrb, Matm2_addrb, Matmul2_addra,
	Done_Matmul2
 );
 
 --MatmulBram1
 MatmulBram1 : Bram256 
  PORT map(
    CLK,
    Matmul1_ena,
    Matmul1_wea,
    Matmul1_addra(7 downto 0),
    Matmul1_dina,
    CLK,
    AddSig_enb,
    AddSig_addrb(7 downto 0),
    Matmul1_doutb
 );
 --MatmulBram2
 MatmulBram2 : Bram256 
  PORT map(
    CLK,
    Matmul2_ena,
    Matmul2_wea,
    Matmul2_addra(7 downto 0),
    Matmul2_dina,
    CLK,
    AddSig_enb,
    AddSig_addrb(7 downto 0),
    Matmul2_doutb
 );
 
 --AddSigmoid
 AddSigmoidUUT : AddSigmoid 
 Port map(
    RST, CLK,
	Start_AddSigmoid,
	AddSig_enb, AddSigmoid_ena,
	AddSigmoid_wea,
	Matmul1_doutb, Matmul2_doutb, HW,
	AddSigmoid_dina, AddSig_addrb, AddSigmoid_addra,
	Done_AddSigmoid
 );
 --AddSigmoidBram
 AddSigmoidBramUUT : Bram256 
  PORT map(
    CLK,
    AddSigmoid_ena,
    AddSigmoid_wea,
    AddSigmoid_addra(7 downto 0),
    AddSigmoid_dina,
    CLK,
    Fimul_enb,
    AddSigmoid_addrb(7 downto 0),
    AddSigmoid_doutb
 );
 
 --FinalMul
 FinalMul : FinalAdd 
 Port map(
    RST, CLK,
	Start_Finalmul,
	Fimul_enb, Final_ena,
	Final_wea,
	AddSigmoid_doutb, BramStart_doutb, C, HW,
	Final_dina, AddSigmoid_addrb, Fimul_addrb, Final_addra,
	Done_Finalmul
 );
 --FinalBram
 FinalBram : Bram4096 
  PORT map (
    CLK,
    Final_ena,
    Final_wea,
    Final_addra(11 downto 0),
    Final_dina,
    CLK,
    enb,
    addrb(11 downto 0),
    doutb
  );
end Behavioral;
 
