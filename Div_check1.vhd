library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Div_check1 is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);  -- S? hexa 8-bit vào
        position : out STD_LOGIC_VECTOR(3 downto 0)   -- V? trí bit 1 cao nh?t
    );
end Div_check1;

architecture Behavioral of Div_check1 is
begin
    process(data_in)
    begin
        if    data_in(7) = '1' then position <= x"8";
        elsif data_in(6) = '1' then position <= x"7";
        elsif data_in(5) = '1' then position <= x"6";
        elsif data_in(4) = '1' then position <= x"5";
        elsif data_in(3) = '1' then position <= x"4";
        elsif data_in(2) = '1' then position <= x"3";
        elsif data_in(1) = '1' then position <= x"2";
        elsif data_in(0) = '1' then position <= x"1";
        else                        position <= x"F"; -- Không có bit 1
        end if;
    end process;
end Behavioral;

