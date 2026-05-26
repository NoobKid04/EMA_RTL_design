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

entity Sigmoid2D_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, H, W, doutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld : in STD_LOGIC;
    dina, addrb, addra : out STD_LOGIC_VECTOR (15 downto 0);
	cn_comp : out STD_LOGIC
 );
end Sigmoid2D_datapath;

architecture Behavioral of Sigmoid2D_datapath is
signal n_in, c_in, n_c, c_c, n_add, c_add, N, addr_mul, addr, addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, Exp, Add: STD_LOGIC_VECTOR (15 downto 0);
signal n_comp, c_comp : STD_LOGIC;
begin
 --logic
 cn_comp <= n_comp and c_comp;
 addrb <= addr;
 --Comp
 n_comp <= '1' when n_add = N else '0';
 c_comp <= '1' when c_add = C else '0';
 --Mux
 n_in <= x"0000" when n_comp = '1' else n_add;
 c_in <= x"0000" when c_comp = '1' else c_add;
 --Add
 n_add <= std_logic_vector(unsigned(n_c) + to_unsigned(1, 16));
 c_add <= std_logic_vector(unsigned(c_c) + to_unsigned(1, 16));
 addr <= std_logic_vector(unsigned(addr_mul) + unsigned(n_c));
 Add  <= std_logic_vector(signed(Exp)  + to_signed(256, 16));
 
 --Mul
 Mul1 : mul_16bit
 port map (c_c, N, addr_mul);
 Mul_N : mul_16bit
 port map (H, W, N);
 Div : Div_16bit_continuos
 port map (RST, CLK, x"0100", Add, dina);
 Exp1 : exp_continuos
 port map (RST, CLK, doutb, Exp);
 --Reg
 Regn_c : Regn
 port map (RST, CLK, count_ld, n_in, n_c);
 Regc : Regn
 port map (RST, CLK, n_comp, c_in, c_c);
 Reg1 : Regn
 port map (RST, CLK, '1', addr, addr1);
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
