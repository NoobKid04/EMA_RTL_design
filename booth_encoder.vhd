-- ============================================================
-- MODIFIED RADIX-4 BOOTH ENCODER
-- Inputs : x (16-bit multiplicand), y_bits (3-bit group of multiplier)
-- Output : pp (18-bit signed partial product, extended for sign)
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_encoder is
    port (
        x      : in  STD_LOGIC_VECTOR(15 downto 0);  -- multiplicand
        y_bits : in  STD_LOGIC_VECTOR(2 downto 0);   -- (Yi+1, Yi, Yi-1)
        pp     : out STD_LOGIC_VECTOR(17 downto 0)   -- partial product (signed, extended)
    );
end booth_encoder;

architecture rtl of booth_encoder is
    signal x_ext  : SIGNED(17 downto 0);
    signal x2_ext : SIGNED(17 downto 0);
begin
    x_ext  <= resize(SIGNED(x), 18);
    x2_ext <= shift_left(resize(SIGNED(x), 18), 1);  -- 2X

    process(y_bits, x_ext, x2_ext)
    begin
        case y_bits is
            when "000" => pp <= STD_LOGIC_VECTOR(TO_SIGNED(0, 18));    -- 0X
            when "001" => pp <= STD_LOGIC_VECTOR(x_ext);               -- +X
            when "010" => pp <= STD_LOGIC_VECTOR(x_ext);               -- +X
            when "011" => pp <= STD_LOGIC_VECTOR(x2_ext);              -- +2X
            when "100" => pp <= STD_LOGIC_VECTOR(-x2_ext);             -- -2X
            when "101" => pp <= STD_LOGIC_VECTOR(-x_ext);              -- -X
            when "110" => pp <= STD_LOGIC_VECTOR(-x_ext);              -- -X
            when "111" => pp <= STD_LOGIC_VECTOR(TO_SIGNED(0, 18));    -- 0X
            when others => pp <= (others => '0');
        end case;
    end process;
end rtl;

