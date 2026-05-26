-- ============================================================
-- WALLACE TREE 64-bit: giam 16 partial products xuong 2 rows
-- Lich trinh: 16->11->8->6->4->3->2 (6 tang, 14 CSA)
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wallace_tree_16 is
    port (
        pp0,  pp1,  pp2,  pp3  : in SIGNED(63 downto 0);
        pp4,  pp5,  pp6,  pp7  : in SIGNED(63 downto 0);
        pp8,  pp9,  pp10, pp11 : in SIGNED(63 downto 0);
        pp12, pp13, pp14, pp15 : in SIGNED(63 downto 0);
        wsum   : out SIGNED(63 downto 0);
        wcarry : out SIGNED(63 downto 0)
    );
end wallace_tree_16;

architecture rtl of wallace_tree_16 is

    -- Tang 1: CSA(pp0..2), CSA(pp3..5), CSA(pp6..8), CSA(pp9..11), CSA(pp12..14)
    signal s1a, c1a : SIGNED(63 downto 0);
    signal s1b, c1b : SIGNED(63 downto 0);
    signal s1c, c1c : SIGNED(63 downto 0);
    signal s1d, c1d : SIGNED(63 downto 0);
    signal s1e, c1e : SIGNED(63 downto 0);
    -- con: pp15

    -- Tang 2: CSA(s1a,c1a,s1b), CSA(c1b,s1c,c1c), CSA(s1d,c1d,s1e)
    signal s2a, c2a : SIGNED(63 downto 0);
    signal s2b, c2b : SIGNED(63 downto 0);
    signal s2c, c2c : SIGNED(63 downto 0);
    -- con: c1e, pp15

    -- Tang 3: CSA(s2a,c2a,s2b), CSA(c2b,s2c,c2c)
    signal s3a, c3a : SIGNED(63 downto 0);
    signal s3b, c3b : SIGNED(63 downto 0);
    -- con: c1e, pp15

    -- Tang 4: CSA(s3a,c3a,s3b), CSA(c3b,c1e,pp15)
    signal s4a, c4a : SIGNED(63 downto 0);
    signal s4b, c4b : SIGNED(63 downto 0);

    -- Tang 5: CSA(s4a,c4a,s4b)
    signal s5a, c5a : SIGNED(63 downto 0);
    -- con: c4b

    -- Tang 6: CSA(s5a,c5a,c4b)
    signal s6a, c6a : SIGNED(63 downto 0);

    function csa_sum(
        a, b, c : SIGNED(63 downto 0)
    ) return SIGNED is
    begin
        return a XOR b XOR c;
    end function;

    function csa_carry(
        a, b, c : SIGNED(63 downto 0)
    ) return SIGNED is
    begin
        return shift_left((a AND b) OR (b AND c) OR (a AND c), 1);
    end function;

begin

    -- Tang 1: 16 -> 11
    s1a <= csa_sum  (pp0,  pp1,  pp2);   c1a <= csa_carry(pp0,  pp1,  pp2);
    s1b <= csa_sum  (pp3,  pp4,  pp5);   c1b <= csa_carry(pp3,  pp4,  pp5);
    s1c <= csa_sum  (pp6,  pp7,  pp8);   c1c <= csa_carry(pp6,  pp7,  pp8);
    s1d <= csa_sum  (pp9,  pp10, pp11);  c1d <= csa_carry(pp9,  pp10, pp11);
    s1e <= csa_sum  (pp12, pp13, pp14);  c1e <= csa_carry(pp12, pp13, pp14);

    -- Tang 2: 11 -> 8
    s2a <= csa_sum  (s1a, c1a, s1b);     c2a <= csa_carry(s1a, c1a, s1b);
    s2b <= csa_sum  (c1b, s1c, c1c);     c2b <= csa_carry(c1b, s1c, c1c);
    s2c <= csa_sum  (s1d, c1d, s1e);     c2c <= csa_carry(s1d, c1d, s1e);

    -- Tang 3: 8 -> 6
    s3a <= csa_sum  (s2a, c2a, s2b);     c3a <= csa_carry(s2a, c2a, s2b);
    s3b <= csa_sum  (c2b, s2c, c2c);     c3b <= csa_carry(c2b, s2c, c2c);

    -- Tang 4: 6 -> 4
    s4a <= csa_sum  (s3a, c3a, s3b);     c4a <= csa_carry(s3a, c3a, s3b);
    s4b <= csa_sum  (c3b, c1e, pp15);    c4b <= csa_carry(c3b, c1e, pp15);

    -- Tang 5: 4 -> 3
    s5a <= csa_sum  (s4a, c4a, s4b);     c5a <= csa_carry(s4a, c4a, s4b);

    -- Tang 6: 3 -> 2
    s6a <= csa_sum  (s5a, c5a, c4b);     c6a <= csa_carry(s5a, c5a, c4b);

    wsum   <= s6a;
    wcarry <= c6a;

end rtl;