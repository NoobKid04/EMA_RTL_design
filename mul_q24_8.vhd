library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.My_component_lib.all;

entity mul_q24_8 is
    port (
        RST, CLK : in  STD_LOGIC;
        X, Y     : in  STD_LOGIC_VECTOR(31 downto 0);
        result   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mul_q24_8;

architecture rtl of mul_q24_8 is

    type pp_raw_array is array(0 to 15) of STD_LOGIC_VECTOR(33 downto 0);
    type pp_array     is array(0 to 15) of SIGNED(63 downto 0);
    type ygroup_array is array(0 to 15) of STD_LOGIC_VECTOR(2 downto 0);

    signal pp_raw    : pp_raw_array;
    signal pp_raw_r  : pp_raw_array;
    signal pp        : pp_array;
    signal yg        : ygroup_array;
    signal Y_ext     : STD_LOGIC_VECTOR(33 downto 0);

    signal wsum, wcarry     : SIGNED(63 downto 0);
    signal wsum_slv, wcarry_slv     : STD_LOGIC_VECTOR(63 downto 0);
    signal wsum_r_slv, wcarry_r_slv : STD_LOGIC_VECTOR(63 downto 0);
    signal final_sum        : STD_LOGIC_VECTOR(63 downto 0);

    component booth_encoder_32
        port (
            x      : in  STD_LOGIC_VECTOR(31 downto 0);
            y_bits : in  STD_LOGIC_VECTOR(2 downto 0);
            pp     : out STD_LOGIC_VECTOR(33 downto 0)
        );
    end component;

    component wallace_tree_16
        port (
            pp0,  pp1,  pp2,  pp3  : in SIGNED(63 downto 0);
            pp4,  pp5,  pp6,  pp7  : in SIGNED(63 downto 0);
            pp8,  pp9,  pp10, pp11 : in SIGNED(63 downto 0);
            pp12, pp13, pp14, pp15 : in SIGNED(63 downto 0);
            wsum   : out SIGNED(63 downto 0);
            wcarry : out SIGNED(63 downto 0)
        );
    end component;

begin

    -- ====== STAGE 1: Booth encode ======
    Y_ext <= Y(31) & Y & '0';

    yg(0)  <= Y_ext(2)  & Y_ext(1)  & Y_ext(0);
    yg(1)  <= Y_ext(4)  & Y_ext(3)  & Y_ext(2);
    yg(2)  <= Y_ext(6)  & Y_ext(5)  & Y_ext(4);
    yg(3)  <= Y_ext(8)  & Y_ext(7)  & Y_ext(6);
    yg(4)  <= Y_ext(10) & Y_ext(9)  & Y_ext(8);
    yg(5)  <= Y_ext(12) & Y_ext(11) & Y_ext(10);
    yg(6)  <= Y_ext(14) & Y_ext(13) & Y_ext(12);
    yg(7)  <= Y_ext(16) & Y_ext(15) & Y_ext(14);
    yg(8)  <= Y_ext(18) & Y_ext(17) & Y_ext(16);
    yg(9)  <= Y_ext(20) & Y_ext(19) & Y_ext(18);
    yg(10) <= Y_ext(22) & Y_ext(21) & Y_ext(20);
    yg(11) <= Y_ext(24) & Y_ext(23) & Y_ext(22);
    yg(12) <= Y_ext(26) & Y_ext(25) & Y_ext(24);
    yg(13) <= Y_ext(28) & Y_ext(27) & Y_ext(26);
    yg(14) <= Y_ext(30) & Y_ext(29) & Y_ext(28);
    yg(15) <= Y_ext(32) & Y_ext(31) & Y_ext(30);

    ENC0:  booth_encoder_32 port map (X, yg(0),  pp_raw(0));
    ENC1:  booth_encoder_32 port map (X, yg(1),  pp_raw(1));
    ENC2:  booth_encoder_32 port map (X, yg(2),  pp_raw(2));
    ENC3:  booth_encoder_32 port map (X, yg(3),  pp_raw(3));
    ENC4:  booth_encoder_32 port map (X, yg(4),  pp_raw(4));
    ENC5:  booth_encoder_32 port map (X, yg(5),  pp_raw(5));
    ENC6:  booth_encoder_32 port map (X, yg(6),  pp_raw(6));
    ENC7:  booth_encoder_32 port map (X, yg(7),  pp_raw(7));
    ENC8:  booth_encoder_32 port map (X, yg(8),  pp_raw(8));
    ENC9:  booth_encoder_32 port map (X, yg(9),  pp_raw(9));
    ENC10: booth_encoder_32 port map (X, yg(10), pp_raw(10));
    ENC11: booth_encoder_32 port map (X, yg(11), pp_raw(11));
    ENC12: booth_encoder_32 port map (X, yg(12), pp_raw(12));
    ENC13: booth_encoder_32 port map (X, yg(13), pp_raw(13));
    ENC14: booth_encoder_32 port map (X, yg(14), pp_raw(14));
    ENC15: booth_encoder_32 port map (X, yg(15), pp_raw(15));

    -- ====== PIPELINE REG 1: sau Booth ======
    RegPP0:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(0),  pp_raw_r(0));
    RegPP1:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(1),  pp_raw_r(1));
    RegPP2:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(2),  pp_raw_r(2));
    RegPP3:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(3),  pp_raw_r(3));
    RegPP4:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(4),  pp_raw_r(4));
    RegPP5:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(5),  pp_raw_r(5));
    RegPP6:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(6),  pp_raw_r(6));
    RegPP7:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(7),  pp_raw_r(7));
    RegPP8:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(8),  pp_raw_r(8));
    RegPP9:  Regn generic map (34) port map (RST, CLK, '1', pp_raw(9),  pp_raw_r(9));
    RegPP10: Regn generic map (34) port map (RST, CLK, '1', pp_raw(10), pp_raw_r(10));
    RegPP11: Regn generic map (34) port map (RST, CLK, '1', pp_raw(11), pp_raw_r(11));
    RegPP12: Regn generic map (34) port map (RST, CLK, '1', pp_raw(12), pp_raw_r(12));
    RegPP13: Regn generic map (34) port map (RST, CLK, '1', pp_raw(13), pp_raw_r(13));
    RegPP14: Regn generic map (34) port map (RST, CLK, '1', pp_raw(14), pp_raw_r(14));
    RegPP15: Regn generic map (34) port map (RST, CLK, '1', pp_raw(15), pp_raw_r(15));

    -- ====== STAGE 2: shift + Wallace ======
    pp(0)  <= resize(SIGNED(pp_raw_r(0)), 64);
    pp(1)  <= shift_left(resize(SIGNED(pp_raw_r(1)),  64), 2);
    pp(2)  <= shift_left(resize(SIGNED(pp_raw_r(2)),  64), 4);
    pp(3)  <= shift_left(resize(SIGNED(pp_raw_r(3)),  64), 6);
    pp(4)  <= shift_left(resize(SIGNED(pp_raw_r(4)),  64), 8);
    pp(5)  <= shift_left(resize(SIGNED(pp_raw_r(5)),  64), 10);
    pp(6)  <= shift_left(resize(SIGNED(pp_raw_r(6)),  64), 12);
    pp(7)  <= shift_left(resize(SIGNED(pp_raw_r(7)),  64), 14);
    pp(8)  <= shift_left(resize(SIGNED(pp_raw_r(8)),  64), 16);
    pp(9)  <= shift_left(resize(SIGNED(pp_raw_r(9)),  64), 18);
    pp(10) <= shift_left(resize(SIGNED(pp_raw_r(10)), 64), 20);
    pp(11) <= shift_left(resize(SIGNED(pp_raw_r(11)), 64), 22);
    pp(12) <= shift_left(resize(SIGNED(pp_raw_r(12)), 64), 24);
    pp(13) <= shift_left(resize(SIGNED(pp_raw_r(13)), 64), 26);
    pp(14) <= shift_left(resize(SIGNED(pp_raw_r(14)), 64), 28);
    pp(15) <= shift_left(resize(SIGNED(pp_raw_r(15)), 64), 30);

    WT: wallace_tree_16
        port map (
            pp0  => pp(0),  pp1  => pp(1),  pp2  => pp(2),  pp3  => pp(3),
            pp4  => pp(4),  pp5  => pp(5),  pp6  => pp(6),  pp7  => pp(7),
            pp8  => pp(8),  pp9  => pp(9),  pp10 => pp(10), pp11 => pp(11),
            pp12 => pp(12), pp13 => pp(13), pp14 => pp(14), pp15 => pp(15),
            wsum => wsum, wcarry => wcarry
        );

    wsum_slv   <= std_logic_vector(wsum);
    wcarry_slv <= std_logic_vector(wcarry);

    -- ====== PIPELINE REG 2: sau Wallace ======
    RegWS: Regn generic map (64) port map (RST, CLK, '1', wsum_slv,   wsum_r_slv);
    RegWC: Regn generic map (64) port map (RST, CLK, '1', wcarry_slv, wcarry_r_slv);

    -- ====== STAGE 3: CLA + saturation ======
    final_sum <= std_logic_vector(signed(wsum_r_slv) + signed(wcarry_r_slv));

    -- Saturation cho Q24.8: kiem tra bit [63:39] dong nhat
    result <= final_sum(39 downto 8)
                when (final_sum(63 downto 39) = "0000000000000000000000000"
                   or final_sum(63 downto 39) = "1111111111111111111111111")
              else x"7FFFFFFF" when final_sum(63) = '0'
              else x"80000000";

end rtl;