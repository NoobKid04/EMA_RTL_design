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

entity conv33_datapath is
 port (
	RST, CLK : in STD_LOGIC;
	IC, OH, OW, OC, HW, idoutb0, idoutb1, idoutb2, idoutb3, idoutb4, idoutb5, idoutb6, idoutb7, idoutb8 : in STD_LOGIC_VECTOR (15 downto 0);
	count_ld, acc_sel, acc_ld, bias_ld : in STD_LOGIC;
    iaddrb0, iaddrb1, iaddrb2, iaddrb3, iaddrb4, iaddrb5, iaddrb6, iaddrb7, iaddrb8, oaddra, odina : out STD_LOGIC_VECTOR (15 downto 0);
	ic_comp, icowhc_comp : out STD_LOGIC
 );
end conv33_datapath;
 
architecture Behavioral of conv33_datapath is
 --counter
 signal ic_in, ow_in, oh_in, oc_in, ic_c, ow_c, oh_c, oc_c, ic_add, ow_add, oh_add, oc_add : STD_LOGIC_VECTOR (15 downto 0);
 signal ic_comp_buf, ow_comp, oh_comp, oc_comp, icow_comp, icowh_comp, icowhc_comp_in : STD_LOGIC;
 --read Bram_in
 signal imulCHW, iaddrb_in, iaddrb, ibase, iaddrb_sub, iaddrb_add : STD_LOGIC_VECTOR (15 downto 0);
 --read weight
 signal ic9_c, IC9, OIC9, weightaddr_in, weightaddr1, weightaddr, weight_addr1, weight_addr2, weight_addr3, weight_addr4, weight_addr5, weight_addr6, weight_addr7, weight_addr8 : STD_LOGIC_VECTOR (15 downto 0);
 signal weight0, weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8 : STD_LOGIC_VECTOR (15 downto 0);
 --read bias
 signal biasaddr, bias : STD_LOGIC_VECTOR (15 downto 0);
 --write Bram
 signal mulHW, omulCHW, obase, oaddra_in : STD_LOGIC_VECTOR (15 downto 0);
 --Calculator
 signal idoutbmul0, idoutbmul1, idoutbmul2, idoutbmul3, idoutbmul5, idoutbmul6, idoutbmul7, idoutbmul8 : STD_LOGIC_VECTOR (15 downto 0);
 signal W0H0, W0H1, W1H0, W1H1, ow_comp1, oh_comp1 : STD_LOGIC;
 signal Mul0_in, Mul0, Mul1_in, Mul1, Mul2_in,  Mul2, Mul3_in, Mul3, Mul4_in, Mul4, Mul5_in, Mul5, Mul6_in, Mul6, Mul7_in, Mul7, Mul8_in, Mul8, Add0, Add1, Add2, Add3, Add4, Add5, Add6, Add7, acc_add, acc_in, acc : STD_LOGIC_VECTOR (31 downto 0);
 signal pad_mask2, pad_mask1, pad_mask, pad_mask_in : std_logic_vector(8 downto 0);
 
 --component
 component bram_conv3x3_bias
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
 end component;
 component bram_conv3x3_weight
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(11 downto 0);      -- dia chi doc (0..2303)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end component;

begin
 --Counter
 --Logic
 ic_comp <= ic_comp_buf;
 icow_comp <= ic_comp_buf and ow_comp;
 icowh_comp <= icow_comp and oh_comp;
 icowhc_comp_in <= icowh_comp and oc_comp;
 --Comp
 ic_comp_buf <= '1' when ic_add = IC else '0';
 ow_comp <= '1' when ow_add = OW else '0';
 oh_comp <= '1' when oh_add = OH else '0';
 oc_comp <= '1' when oc_add = OC else '0';
 ow_comp1 <= '1' when ow_add = x"0001" else '0';
 oh_comp1 <= '1' when oh_add = x"0001" else '0';
 --Mux
 ic_in <= ic_add when ic_comp_buf = '0' else x"0000";
 ow_in <= ow_add when ow_comp = '0' else x"0000";
 oh_in <= oh_add when oh_comp = '0' else x"0000";
 oc_in <= oc_add when oc_comp = '0' else x"0000";
 --ALU
 ic_add  <= std_logic_vector(unsigned(ic_c)  + to_unsigned(1, 16));
 ow_add  <= std_logic_vector(unsigned(ow_c)  + to_unsigned(1, 16));
 oh_add  <= std_logic_vector(unsigned(oh_c)  + to_unsigned(1, 16));
 oc_add  <= std_logic_vector(unsigned(oc_c)  + to_unsigned(1, 16));
 --Reg
 Regic : Regn
 port map (RST, CLK, count_ld, ic_in, ic_c);
 Regow : Regn
 port map (RST, CLK, ic_comp_buf, ow_in, ow_c);
 Regoh : Regn
 port map (RST, CLK, icow_comp, oh_in, oh_c);
 Regoc : Regn
 port map (RST, CLK, icowh_comp, oc_in, oc_c);
 Regiocwhc : Reg1bit
 port map (RST, CLK, icowh_comp, icowhc_comp_in, icowhc_comp);

 --readBram
 --ALU
 Muliaddr : mul_16bit
 port map (ic_c, HW, imulCHW);
 ibase <= std_logic_vector(unsigned(imulCHW) + unsigned(mulHW));
 iaddrb_in <= std_logic_vector(unsigned(ibase) + unsigned(ow_c));
 iaddrb_sub <= std_logic_vector(unsigned(iaddrb) - unsigned(OW));
 iaddrb_add <= std_logic_vector(unsigned(iaddrb) + unsigned(OW));
 --Reg
 Regiaddrb : Regn
 port map (RST, CLK, '1', iaddrb_in, iaddrb);
 --InputAddr
 iaddrb0 <= std_logic_vector(unsigned(iaddrb_sub) - to_unsigned(1, 16));
 iaddrb1 <= iaddrb_sub;
 iaddrb2 <= std_logic_vector(unsigned(iaddrb_sub) + to_unsigned(1, 16));
 iaddrb3 <= std_logic_vector(unsigned(iaddrb) - to_unsigned(1, 16));
 iaddrb4 <= iaddrb;
 iaddrb5 <= std_logic_vector(unsigned(iaddrb) + to_unsigned(1, 16));
 iaddrb6 <= std_logic_vector(unsigned(iaddrb_add) - to_unsigned(1, 16));
 iaddrb7 <= iaddrb_add;
 iaddrb8 <= std_logic_vector(unsigned(iaddrb_add) + to_unsigned(1, 16));
 
 --readWeight
 --ALU
 Mulweight1 : mul_16bit
 port map (ic_c, x"0009", ic9_c);
 Mulweight2 : mul_16bit
 port map (IC, x"0009", IC9);
 Mulweight3 : mul_16bit
 port map (IC9, oc_c, OIC9);
 weightaddr_in <= std_logic_vector(unsigned(ic9_c) + unsigned(OIC9));
 --Reg
 Regweight1 : Regn
 port map (RST, CLK, '1', weightaddr_in, weightaddr1);
 Regweight2 : Regn
 port map (RST, CLK, '1', weightaddr1, weightaddr);
 --WeightAddress
 weight_addr1 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(1, 16));
 weight_addr2 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(2, 16));
 weight_addr3 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(3, 16));
 weight_addr4 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(4, 16));
 weight_addr5 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(5, 16));
 weight_addr6 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(6, 16));
 weight_addr7 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(7, 16));
 weight_addr8 <= std_logic_vector(unsigned(weightaddr) + to_unsigned(8, 16));
 --Weight
 Weightin0 : bram_conv3x3_weight
 port map(CLK, '1', weightaddr(11 downto 0), weight0);
 Weightin1 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr1(11 downto 0), weight1);
 Weightin2 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr2(11 downto 0), weight2);
 Weightin3 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr3(11 downto 0), weight3);
 Weightin4 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr4(11 downto 0), weight4);
 Weightin5 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr5(11 downto 0), weight5);
 Weightin6 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr6(11 downto 0), weight6);
 Weightin7 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr7(11 downto 0), weight7);
 Weightin8 : bram_conv3x3_weight
 port map(CLK, '1', weight_addr8(11 downto 0), weight8);
 
 
 --readBias
 Biasin : bram_conv3x3_bias
 port map(CLK, '1', biasaddr(3 downto 0), bias);
 --Reg
 Regbias : Regn
 port map (RST, CLK, bias_ld, oc_c, biasaddr);
 
 --writeBram
 --ALU
 Mulwrite1 : mul_16bit
 port map (oc_c, HW, omulCHW);
 Mulwrite2 : mul_16bit
 port map (oh_c, OW, mulHW);
 obase <= std_logic_vector(unsigned(mulHW) + unsigned(omulCHW));
 oaddra_in <= std_logic_vector(unsigned(obase) + unsigned(ow_c));
 --Reg
 Regoaddra : Regn
 port map (RST, CLK, ic_comp_buf, oaddra_in, oaddra);
 
 --Calculator
 --Logicc
 W0H0 <= '1' when (ow_comp1 = '1' or oh_comp1 = '1') else '0';
 W1H0 <= '1' when (ow_comp = '1' or oh_comp1 = '1') else '0';
 W0H1 <= '1' when (ow_comp1 = '1' or oh_comp = '1') else '0';
 W1H1 <= '1' when (ow_comp = '1' or oh_comp = '1') else '0';
 pad_mask_in(0) <= W0H0;
 pad_mask_in(1) <= oh_comp1;
 pad_mask_in(2) <= W1H0;
 pad_mask_in(3) <= ow_comp1;
 pad_mask_in(4) <= '0';
 pad_mask_in(5) <= ow_comp;
 pad_mask_in(6) <= W0H1;
 pad_mask_in(7) <= oh_comp;
 pad_mask_in(8) <= W1H1;
 --Mux
 idoutbmul0 <= idoutb0 when pad_mask(0) = '0' else x"0000";
 idoutbmul1 <= idoutb1 when pad_mask(1) = '0' else x"0000";
 idoutbmul2 <= idoutb2 when pad_mask(2) = '0' else x"0000";
 idoutbmul3 <= idoutb3 when pad_mask(3) = '0' else x"0000";
 idoutbmul5 <= idoutb5 when pad_mask(5) = '0' else x"0000";
 idoutbmul6 <= idoutb6 when pad_mask(6) = '0' else x"0000";
 idoutbmul7 <= idoutb7 when pad_mask(7) = '0' else x"0000";
 idoutbmul8 <= idoutb8 when pad_mask(8) = '0' else x"0000";
 acc_in <= x"00000000" when acc_sel = '0' else acc_add;
 --ALU
 Mulfinal0 : mul_16_noclip
 port map (idoutbmul0, weight0, Mul0_in);
 Mulfinal1 : mul_16_noclip
 port map (idoutbmul1, weight1, Mul1_in);
 Mulfinal2 : mul_16_noclip
 port map (idoutbmul2, weight2, Mul2_in);
 Mulfinal3 : mul_16_noclip
 port map (idoutbmul3, weight3, Mul3_in);
 Mulfinal4 : mul_16_noclip
 port map (idoutb4, weight4, Mul4_in);
 Mulfinal5 : mul_16_noclip
 port map (idoutbmul5, weight5, Mul5_in);
 Mulfinal6 : mul_16_noclip
 port map (idoutbmul6, weight6, Mul6_in);
 Mulfinal7 : mul_16_noclip
 port map (idoutbmul7, weight7, Mul7_in);
 Mulfinal8 : mul_16_noclip
 port map (idoutbmul8, weight8, Mul8_in);
 Add0 <= std_logic_vector(signed(Mul0) + signed(Mul1));
 Add1 <= std_logic_vector(signed(Mul2) + signed(Mul3));
 Add2 <= std_logic_vector(signed(Mul4) + signed(Mul5));
 Add3 <= std_logic_vector(signed(Mul6) + signed(Mul7));
 Add4 <= std_logic_vector(signed(Add0) + signed(Add1));
 Add5 <= std_logic_vector(signed(Add2) + signed(Add3));
 Add6 <= std_logic_vector(signed(Add4) + signed(Add5));
 Add7 <= std_logic_vector(signed(Mul8) + signed(acc));
 acc_add <= std_logic_vector(signed(Add6) + signed(Add7));
 odina <= std_logic_vector(signed(acc(23 downto 8)) + signed(bias));
 --Reg
 RegMul0 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul0_in , Mul0);
 RegMul1 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul1_in , Mul1);
 RegMul2 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul2_in , Mul2);
 RegMul3 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul3_in , Mul3);
 RegMul4 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul4_in , Mul4);
 RegMul5 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul5_in , Mul5);
 RegMul6 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul6_in , Mul6);
 RegMul7 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul7_in , Mul7);
 RegMul8 : Regn
 generic map (32)
 port map (RST, CLK, '1', Mul8_in , Mul8);
 Regacc : Regn
 generic map (32)
 port map (RST, CLK, acc_ld, acc_in , acc);
 Regpasmask2 : Regn
 generic map (9)
 port map (RST, CLK, '1', pad_mask_in , pad_mask2);
 Regpasmask1 : Regn
 generic map (9)
 port map (RST, CLK, '1', pad_mask2 , pad_mask1);
 Regpasmask : Regn
 generic map (9)
 port map (RST, CLK, '1', pad_mask1 , pad_mask);
end Behavioral;
