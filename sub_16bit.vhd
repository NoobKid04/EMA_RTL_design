library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 16-bit Subtractor using CLA_16bit (A - B = A + NOT(B) + 1)
entity sub_16bit is
    Port (
        A, B    : in  STD_LOGIC_VECTOR(15 downto 0);
        Diff    : out STD_LOGIC_VECTOR(15 downto 0);
        Bout    : out STD_LOGIC   -- borrow out (1 n?u A < B)
    );
end sub_16bit;

architecture Structural of sub_16bit is

    component cla_16bit
        Port (
            A, B  : in  STD_LOGIC_VECTOR(15 downto 0);
            Cin   : in  STD_LOGIC;
            Sum   : out STD_LOGIC_VECTOR(15 downto 0);
            Cout  : out STD_LOGIC
        );
    end component;

    signal B_inv  : STD_LOGIC_VECTOR(15 downto 0);
    signal Cout   : STD_LOGIC;

begin
    -- ??o bit B ?? th?c hi?n bù 2
    B_inv <= not B;

    -- A + NOT(B) + 1  =>  A - B
    adder: cla_16bit
        port map (
            A    => A,
            B    => B_inv,
            Cin  => '1',       -- +1 ?? hoàn ch?nh bù 2
            Sum  => Diff,
            Cout => Cout
        );

    -- Bout = 1 khi A < B (không có carry ra => có borrow)
    Bout <= not Cout;

end Structural;

