library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expneg_lut_int is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
        data : out STD_LOGIC_VECTOR(15 downto 0)   -- 16-bit Q8.8 output
    );
end expneg_lut_int;

architecture Behavioral of expneg_lut_int is
begin
    process(addr)
    begin
        case addr is
            when "0000" => data <= x"0100";  -- e^0  = 1.00000   ? 256
            when "0001" => data <= x"02B8";  -- e^1  ? 2.71828   ? 696
            when "0010" => data <= x"0764";  -- e^2  ? 7.38906   ? 1892
            when "0011" => data <= x"1416";  -- e^3  ? 20.0855   ? 5142
            when "0100" => data <= x"3699";  -- e^4  ? 54.5982   ? 13977
            when "0101" => data <= x"946A";  -- e^5  ? 148.413   ? 37994
            when others  => data <= x"7FFF";  -- e^6..e^15 ? OVERFLOW (saturated)
        end case;
    end process;
end Behavioral;