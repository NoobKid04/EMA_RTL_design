-- ============================================================
-- TOP-LEVEL: MODIFIED BOOTH-WALLACE MULTIPLIER 16x16 -> 32 bits
-- Final adder dùng CLA 32-bit
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul_16_noclip is
    port (
        X      : in  STD_LOGIC_VECTOR(15 downto 0);
        Y      : in  STD_LOGIC_VECTOR(15 downto 0);
        result : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mul_16_noclip;

architecture rtl of mul_16_noclip is

    type pp_raw_array is array(0 to 7) of STD_LOGIC_VECTOR(17 downto 0);
    type pp_array     is array(0 to 7) of SIGNED(31 downto 0);
    type ygroup_array is array(0 to 7) of STD_LOGIC_VECTOR(2 downto 0);

    signal pp_raw : pp_raw_array;
    signal pp     : pp_array;
    signal yg     : ygroup_array;

    signal Y_ext  : STD_LOGIC_VECTOR(17 downto 0);

    signal wsum   : SIGNED(31 downto 0);
    signal wcarry : SIGNED(31 downto 0);

	signal final_sum : STD_LOGIC_VECTOR(31 downto 0);

    component booth_encoder
        port (
            x      : in  STD_LOGIC_VECTOR(15 downto 0);
            y_bits : in  STD_LOGIC_VECTOR(2 downto 0);
            pp     : out STD_LOGIC_VECTOR(17 downto 0)
        );
    end component;

    component wallace_tree
        port (
            pp0, pp1, pp2, pp3,
            pp4, pp5, pp6, pp7 : in  SIGNED(31 downto 0);
            wsum               : out SIGNED(31 downto 0);
            wcarry             : out SIGNED(31 downto 0)
        );
    end component;

begin

    Y_ext <= Y(15) & Y & '0';

    yg(0) <= Y_ext(2)  & Y_ext(1)  & Y_ext(0);
    yg(1) <= Y_ext(4)  & Y_ext(3)  & Y_ext(2);
    yg(2) <= Y_ext(6)  & Y_ext(5)  & Y_ext(4);
    yg(3) <= Y_ext(8)  & Y_ext(7)  & Y_ext(6);
    yg(4) <= Y_ext(10) & Y_ext(9)  & Y_ext(8);
    yg(5) <= Y_ext(12) & Y_ext(11) & Y_ext(10);
    yg(6) <= Y_ext(14) & Y_ext(13) & Y_ext(12);
    yg(7) <= Y_ext(16) & Y_ext(15) & Y_ext(14);

    ENC0: booth_encoder port map (x => X, y_bits => yg(0), pp => pp_raw(0));
    ENC1: booth_encoder port map (x => X, y_bits => yg(1), pp => pp_raw(1));
    ENC2: booth_encoder port map (x => X, y_bits => yg(2), pp => pp_raw(2));
    ENC3: booth_encoder port map (x => X, y_bits => yg(3), pp => pp_raw(3));
    ENC4: booth_encoder port map (x => X, y_bits => yg(4), pp => pp_raw(4));
    ENC5: booth_encoder port map (x => X, y_bits => yg(5), pp => pp_raw(5));
    ENC6: booth_encoder port map (x => X, y_bits => yg(6), pp => pp_raw(6));
    ENC7: booth_encoder port map (x => X, y_bits => yg(7), pp => pp_raw(7));

    pp(0) <= resize(SIGNED(pp_raw(0)), 32);
    pp(1) <= shift_left(resize(SIGNED(pp_raw(1)), 32), 2);
    pp(2) <= shift_left(resize(SIGNED(pp_raw(2)), 32), 4);
    pp(3) <= shift_left(resize(SIGNED(pp_raw(3)), 32), 6);
    pp(4) <= shift_left(resize(SIGNED(pp_raw(4)), 32), 8);
    pp(5) <= shift_left(resize(SIGNED(pp_raw(5)), 32), 10);
    pp(6) <= shift_left(resize(SIGNED(pp_raw(6)), 32), 12);
    pp(7) <= shift_left(resize(SIGNED(pp_raw(7)), 32), 14);

    WT: wallace_tree
        port map (
            pp0    => pp(0),
            pp1    => pp(1),
            pp2    => pp(2),
            pp3    => pp(3),
            pp4    => pp(4),
            pp5    => pp(5),
            pp6    => pp(6),
            pp7    => pp(7),
            wsum   => wsum,
            wcarry => wcarry
        );

    -- -------------------------------------------------------
    -- Final adder: thay wsum + wcarry b?ng CLA 32-bit
    -- Cin = '0' vì không có carry vào t? ngoài
    -- Cout b? qua (open) vì k?t qu? ch? l?y 32-bit th?p
    -- -------------------------------------------------------
    final_sum <= std_logic_vector( signed(wsum) + signed(wcarry) );

	result <= final_sum;
end rtl;

