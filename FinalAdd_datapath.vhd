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

entity FinalAdd_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb1, addrb2, addra : out STD_LOGIC_VECTOR (15 downto 0);
	CHW_comp : out STD_LOGIC
 );
end FinalAdd_datapath;

architecture Behavioral of FinalAdd_datapath is
signal HWc_in, Cc_in, HW_c, C_c, HW_add, C_add, mulCHW, base, dina_in, addra2, addra1 : STD_LOGIC_VECTOR (15 downto 0);
signal HW_comp, C_comp : STD_LOGIC;
begin
 --logic
 CHW_comp <= HW_comp and C_comp;
 addrb1 <= HW_c;
 addrb2 <= base;
 --Comp
 HW_comp <= '1' when HW_add = HW else '0';
 C_comp <= '1' when C_add = C else '0';
 --Mux
 HWc_in <= x"0000" when HW_comp = '1' else HW_add;
 Cc_in <= x"0000" when C_comp = '1' else C_add;
 --Add
 HW_add  <= std_logic_vector(unsigned(HW_c)  + to_unsigned(1, 16));
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 base   <= std_logic_vector(unsigned(mulCHW) + unsigned(HW_c));
 --Mul
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mul : booth_wallace_multiplier
 port map (doutb1, doutb2, dina_in);
 --Reg
 Reg1 : Regn
 port map (RST, CLK, count_ld, HWc_in, HW_c);
 Reg2 : Regn
 port map (RST, CLK, HW_comp, Cc_in, C_c);
 Regdina : Regn
 port map (RST, CLK, '1', dina_in, dina);
 Regaddra : Regn
 port map (RST, CLK, '1', base, addra2);
 Reg3 : Regn
 port map (RST, CLK, '1', addra2, addra1);
 Reg4 : Regn
 port map (RST, CLK, '1', addra1, addra);
end Behavioral;
