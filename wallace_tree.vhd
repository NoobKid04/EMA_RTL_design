-- ============================================================
-- WALLACE TREE 32-bit: rút g?n 8 partial products xu?ng 2 rows
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wallace_tree is
    port (
        pp0, pp1, pp2, pp3,
        pp4, pp5, pp6, pp7 : in  SIGNED(31 downto 0);
        wsum               : out SIGNED(31 downto 0);
        wcarry             : out SIGNED(31 downto 0)
    );
end wallace_tree;

architecture rtl of wallace_tree is

    signal s1a, c1a : SIGNED(31 downto 0);
    signal s1b, c1b : SIGNED(31 downto 0);
    signal s2a, c2a : SIGNED(31 downto 0);
    signal s2b, c2b : SIGNED(31 downto 0);
    signal s3a, c3a : SIGNED(31 downto 0);
    signal s4a, c4a : SIGNED(31 downto 0);

    function csa_sum(
        a : SIGNED(31 downto 0);
        b : SIGNED(31 downto 0);
        c : SIGNED(31 downto 0)
    ) return SIGNED is
    begin
        return a XOR b XOR c;
    end function;

    function csa_carry(
        a : SIGNED(31 downto 0);
        b : SIGNED(31 downto 0);
        c : SIGNED(31 downto 0)
    ) return SIGNED is
        variable maj : SIGNED(31 downto 0);
    begin
        maj := (a AND b) OR (b AND c) OR (a AND c);
        return shift_left(maj, 1);
    end function;

begin

    s1a <= csa_sum  (pp0, pp1, pp2);
    c1a <= csa_carry(pp0, pp1, pp2);

    s1b <= csa_sum  (pp3, pp4, pp5);
    c1b <= csa_carry(pp3, pp4, pp5);

    s2a <= csa_sum  (s1a, c1a, s1b);
    c2a <= csa_carry(s1a, c1a, s1b);

    s2b <= csa_sum  (c1b, pp6, pp7);
    c2b <= csa_carry(c1b, pp6, pp7);

    s3a <= csa_sum  (s2a, c2a, s2b);
    c3a <= csa_carry(s2a, c2a, s2b);

    s4a <= csa_sum  (s3a, c3a, c2b);
    c4a <= csa_carry(s3a, c3a, c2b);

    wsum   <= s4a;
    wcarry <= c4a;

end rtl;

