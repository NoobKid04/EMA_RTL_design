library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- ho?c: use IEEE.NUMERIC_STD.ALL; (n?u b?n dùng ki?u unsigned/signed)

entity sub_32bit is
    Port (
        A, B   : in  STD_LOGIC_VECTOR(31 downto 0);
        Diff   : out STD_LOGIC_VECTOR(31 downto 0);
        Cout   : out STD_LOGIC
    );
end sub_32bit;

architecture Behavioral of sub_32bit is
    signal B_inv : STD_LOGIC_VECTOR(31 downto 0);
begin
    -- Invert B to get one's complement
    B_inv <= not B;

    -- Use existing 32-bit CLA adder
    cla32_inst: entity work.cla_32bit
        port map (
            A    => A,
            B    => B_inv,
            Cin  => '1',       -- Add 1 => Two's complement
            Sum  => Diff,
            Cout => Cout
        );
end Behavioral;

