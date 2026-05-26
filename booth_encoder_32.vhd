-- ============================================================
-- MODIFIED RADIX-4 BOOTH ENCODER (32-bit version)
-- x: 32-bit; pp: 34-bit signed (du cho ±2X)
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_encoder_32 is
    port (
        x      : in  STD_LOGIC_VECTOR(31 downto 0);
        y_bits : in  STD_LOGIC_VECTOR(2 downto 0);
        pp     : out STD_LOGIC_VECTOR(33 downto 0)
    );
end booth_encoder_32;

architecture rtl of booth_encoder_32 is
    signal x_ext  : SIGNED(33 downto 0);
    signal x2_ext : SIGNED(33 downto 0);
begin
    -- Mo rong 32-bit len 34-bit de chua ca 2X ma khong tran so
    x_ext  <= resize(SIGNED(x), 34);
    x2_ext <= shift_left(resize(SIGNED(x), 34), 1);  -- 2X

    process(y_bits, x_ext, x2_ext)
    begin
        case y_bits is
            when "000" => pp <= STD_LOGIC_VECTOR(TO_SIGNED(0, 34));  --  0
            when "001" => pp <= STD_LOGIC_VECTOR(x_ext);             -- +X
            when "010" => pp <= STD_LOGIC_VECTOR(x_ext);             -- +X
            when "011" => pp <= STD_LOGIC_VECTOR(x2_ext);            -- +2X
            when "100" => pp <= STD_LOGIC_VECTOR(-x2_ext);           -- -2X
            when "101" => pp <= STD_LOGIC_VECTOR(-x_ext);            -- -X
            when "110" => pp <= STD_LOGIC_VECTOR(-x_ext);            -- -X
            when "111" => pp <= STD_LOGIC_VECTOR(TO_SIGNED(0, 34));  --  0
            when others => pp <= (others => '0');
        end case;
    end process;
end rtl;