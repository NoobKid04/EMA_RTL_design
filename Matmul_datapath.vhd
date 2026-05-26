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

entity Matmul_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	C, HW, doutb1, doutb2 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld : in STD_LOGIC;
    dina, addrb1, addrb2,  addra : out STD_LOGIC_VECTOR (15 downto 0);
	C_comp, CHW_comp : out STD_LOGIC
 );
end Matmul_datapath;

architecture Behavioral of Matmul_datapath is
signal Cc_in, HWc_in,  C_c, HW_c, C_add, HW_add, mulCHW, acc_mul, acc_add, acc_in, acc, acc_mul_in: STD_LOGIC_VECTOR (15 downto 0);
signal C_comp_buf, HW_comp, CHW_comp_in : STD_LOGIC;
begin
 --logic
 C_comp <= C_comp_buf;
 addrb1 <= C_c;
 dina <= acc;
 CHW_comp_in <= HW_comp and C_comp_buf;
 --Comp
 C_comp_buf <= '1' when C_add = C else '0';
 HW_comp <= '1' when HW_add = HW else '0';
 --Mux
 Cc_in <= x"0000" when C_comp_buf = '1' else C_add;
 HWc_in <= x"0000" when HW_comp = '1' else HW_add;
 acc_in <= x"0000" when acc_sel = '0' else acc_add;
 --Add
 C_add  <= std_logic_vector(unsigned(C_c)  + to_unsigned(1, 16));
 HW_add  <= std_logic_vector(unsigned(HW_c)  + to_unsigned(1, 16));
 addrb2  <= std_logic_vector(unsigned(mulCHW) + unsigned(HW_c));
 acc_add <= std_logic_vector(signed(acc_mul) + signed(acc));
 --Mul
 Mul1 : mul_16bit
 port map (C_c, HW, mulCHW);
 Mulacc : booth_wallace_multiplier
 port map (doutb1, doutb2, acc_mul_in);
 --Reg
 Reg1 : Regn
 port map (RST, CLK, count_ld, Cc_in, C_c);
 Reg2 : Regn
 port map (RST, CLK, C_comp_buf, HWc_in, HW_c);
 Reg3 : Regn
 port map (RST, CLK, C_comp_buf, HW_c, addra);
 Reg4 : Regn
 port map (RST, CLK, acc_ld, acc_in, acc);
 Reg5 : Reg1bit
 port map (RST, CLK, C_comp_buf, CHW_comp_in, CHW_comp);
 Reg6 : Regn
 port map (RST, CLK, '1', acc_mul_in, acc_mul);
end Behavioral;
