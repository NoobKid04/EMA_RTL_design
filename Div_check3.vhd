library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================
-- Div_check3: tim vi tri bit 1 cao nhat trong 24-bit input
-- Output 5-bit: gia tri 1..24 la vi tri, 0x1F = khong co bit 1
-- ============================================================
entity Div_check3 is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input
        position : out STD_LOGIC_VECTOR(4 downto 0)    -- vi tri bit 1 cao nhat
    );
end Div_check3;

architecture Behavioral of Div_check3 is
begin
    process(data_in)
    begin
        if    data_in(23) = '1' then position <= "11000";  -- 24 = 0x18
        elsif data_in(22) = '1' then position <= "10111";  -- 23 = 0x17
        elsif data_in(21) = '1' then position <= "10110";  -- 22 = 0x16
        elsif data_in(20) = '1' then position <= "10101";  -- 21 = 0x15
        elsif data_in(19) = '1' then position <= "10100";  -- 20 = 0x14
        elsif data_in(18) = '1' then position <= "10011";  -- 19 = 0x13
        elsif data_in(17) = '1' then position <= "10010";  -- 18 = 0x12
        elsif data_in(16) = '1' then position <= "10001";  -- 17 = 0x11
        elsif data_in(15) = '1' then position <= "10000";  -- 16 = 0x10
        elsif data_in(14) = '1' then position <= "01111";  -- 15 = 0x0F
        elsif data_in(13) = '1' then position <= "01110";  -- 14 = 0x0E
        elsif data_in(12) = '1' then position <= "01101";  -- 13 = 0x0D
        elsif data_in(11) = '1' then position <= "01100";  -- 12 = 0x0C
        elsif data_in(10) = '1' then position <= "01011";  -- 11 = 0x0B
        elsif data_in(9)  = '1' then position <= "01010";  -- 10 = 0x0A
        elsif data_in(8)  = '1' then position <= "01001";  --  9 = 0x09
        elsif data_in(7)  = '1' then position <= "01000";  --  8 = 0x08
        elsif data_in(6)  = '1' then position <= "00111";  --  7 = 0x07
        elsif data_in(5)  = '1' then position <= "00110";  --  6 = 0x06
        elsif data_in(4)  = '1' then position <= "00101";  --  5 = 0x05
        elsif data_in(3)  = '1' then position <= "00100";  --  4 = 0x04
        elsif data_in(2)  = '1' then position <= "00011";  --  3 = 0x03
        elsif data_in(1)  = '1' then position <= "00010";  --  2 = 0x02
        elsif data_in(0)  = '1' then position <= "00001";  --  1 = 0x01
        else                         position <= "11111";  -- 0x1F: khong co bit 1
        end if;
    end process;
end Behavioral;