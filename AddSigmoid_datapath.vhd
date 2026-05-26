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

entity AddSigmoid_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	HW_comp : out STD_LOGIC
 );
end AddSigmoid_datapath;

architecture Behavioral of AddSigmoid_datapath is
signal HWc_in, HW_c, HW_add, addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, Exp, Add, doutb_add: STD_LOGIC_VECTOR (15 downto 0);
signal HW_comp_buf : STD_LOGIC;
begin
 --logic
 HW_comp <= HW_comp_buf;
 addrb <= HW_c;
 --Comp
 HW_comp_buf <= '1' when HW_add = HW else '0';
 --Mux
 HWc_in <= x"0000" when HW_comp_buf = '1' else HW_add;
 --Add
 HW_add <= std_logic_vector(unsigned(HW_c) + to_unsigned(1, 16));
 doutb_add <= std_logic_vector(signed(doutb1) + signed(doutb2));
 Add  <= std_logic_vector(signed(Exp)  + to_signed(256, 16));
 
 --Mul
 Div : Div_16bit_continuos
 port map (RST, CLK, x"0100", Add, dina);
 Exp1 : exp_continuos
 port map (RST, CLK, doutb_add, Exp);
 --Reg
 RegHWc : Regn
 port map (RST, CLK, count_ld, HWc_in, HW_c);
 Reg1 : Regn
 port map (RST, CLK, '1', HW_c, addr1);
 Reg2 : Regn
 port map (RST, CLK, '1', addr1, addr2);
 Reg3 : Regn
 port map (RST, CLK, '1', addr2, addr3);
 Reg4 : Regn
 port map (RST, CLK, '1', addr3, addr4);
 Reg5 : Regn
 port map (RST, CLK, '1', addr4, addr5);
 Reg6 : Regn
 port map (RST, CLK, '1', addr5, addr6);
 Reg7 : Regn
 port map (RST, CLK, '1', addr6, addr7);
 Reg8 : Regn
 port map (RST, CLK, '1', addr7, addr8);
 Reg9 : Regn
 port map (RST, CLK, '1', addr8, addr9);
 Reg10 : Regn
 port map (RST, CLK, '1', addr9, addr10);
 Reg11 : Regn
 port map (RST, CLK, '1', addr10, addr11);
 Reg12 : Regn
 port map (RST, CLK, '1', addr11, addr12);
 Reg13 : Regn
 port map (RST, CLK, '1', addr12, addr13);
 Reg14 : Regn
 port map (RST, CLK, '1', addr13, addra);
end Behavioral;
