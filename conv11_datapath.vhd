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

entity conv11_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	IC, OH, OW, OC, idoutb : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld, bias_ld : in STD_LOGIC;
    iaddrb, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	ic_comp, iocn_comp : out STD_LOGIC
 );
end conv11_datapath;
 
architecture Behavioral of conv11_datapath is
 --counter
 signal ic_in, n_in, oc_in, ic_c, n_c, oc_c, ic_add, n_add, oc_add, N : STD_LOGIC_VECTOR (15 downto 0);
 signal ic_comp_buf, n_comp, oc_comp, icn_comp, iocn_comp_in : STD_LOGIC;
 --read Bram_in
 signal iaddrb_mul : STD_LOGIC_VECTOR (15 downto 0);
 --read weight
 signal weightaddr_mul, weightaddr_in, weightaddr, weight : STD_LOGIC_VECTOR (15 downto 0);
 --read bias
 signal biasaddr, bias : STD_LOGIC_VECTOR (15 downto 0);
 --write Bram
 signal oaddra_mul, oaddra_in : STD_LOGIC_VECTOR (15 downto 0);
 --Calculator
 signal acc_mul, acc_add, acc_in, acc : STD_LOGIC_VECTOR (31 downto 0);
 
 --component
 component bram_conv1x1_bias
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
 end component;
 component bram_conv1x1_weight
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(7 downto 0);      -- dia chi doc (0..2303)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end component;

begin
 --Counter
 --Logic
 ic_comp <= ic_comp_buf;
 icn_comp <= ic_comp_buf and n_comp;
 iocn_comp_in <= icn_comp and oc_comp;
 --Comp
 ic_comp_buf <= '1' when ic_add = IC else '0';
 n_comp <= '1' when n_add = N else '0';
 oc_comp <= '1' when oc_add = OC else '0';
 --Mux
 ic_in <= ic_add when ic_comp_buf = '0' else x"0000";
 n_in <= n_add when n_comp = '0' else x"0000";
 oc_in <= oc_add when oc_comp = '0' else x"0000";
 --ALU
 ic_add  <= std_logic_vector(unsigned(ic_c)  + to_unsigned(1, 16));
 n_add  <= std_logic_vector(unsigned(n_c)  + to_unsigned(1, 16));
 N  <= std_logic_vector(unsigned(OH)  + unsigned(OW));
 oc_add  <= std_logic_vector(unsigned(oc_c)  + to_unsigned(1, 16));
 --Reg
 Regic : Regn
 port map (RST, CLK, count_ld, ic_in, ic_c);
 Regon : Regn
 port map (RST, CLK, ic_comp_buf, n_in, n_c);
 Regoc : Regn
 port map (RST, CLK, icn_comp, oc_in, oc_c);
 Regiocwhc : Reg1bit
 port map (RST, CLK, icn_comp, iocn_comp_in, iocn_comp);

 --readBram
 --ALU
 Muliaddr : mul_16bit
 port map (ic_c, N, iaddrb_mul);
 iaddrb <= std_logic_vector(unsigned(iaddrb_mul) + unsigned(n_c));
 
 --readWeight
 --ALU
 Mulweight : mul_16bit
 port map (oc_c, IC, weightaddr_mul);
 weightaddr_in <= std_logic_vector(unsigned(weightaddr_mul) + unsigned(ic_c));
 --Reg
 Regweight : Regn
 port map (RST, CLK, '1', weightaddr_in, weightaddr);
 --Weight
 Weightin0 : bram_conv1x1_weight
 port map(CLK, '1', weightaddr(7 downto 0), weight);
 
 --readBias
 Biasin : bram_conv1x1_bias
 port map(CLK, '1', biasaddr(3 downto 0), bias);
 --Reg
 Regbias : Regn
 port map (RST, CLK, bias_ld, oc_c, biasaddr);
 
 --writeBram
 --ALU
 Mulwrite : mul_16bit
 port map (oc_c, N, oaddra_mul);
 oaddra_in <= std_logic_vector(unsigned(oaddra_mul) + unsigned(n_c));
 --Reg
 Regoaddra : Regn
 port map (RST, CLK, ic_comp_buf, oaddra_in, oaddra);
 
 --Calculator
 --Mux
 acc_in <= x"00000000" when acc_sel = '0' else acc_add;
 --ALU
 Mulfinal0 : mul_16_noclip
 port map (idoutb, weight, acc_mul);
 acc_add <= std_logic_vector(signed(acc_mul) + signed(acc));
 odina <= std_logic_vector(signed(acc(23 downto 8)) + signed(bias));
 --Reg
 Regacc : Regn
 generic map (32)
 port map (RST, CLK, acc_ld, acc_in , acc);
end Behavioral;
