library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity exp_lut_int is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
        data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
    );
end exp_lut_int;

architecture Behavioral of exp_lut_int is
begin
    process(addr)
    begin
        case addr is
             when "0000" => data <= x"0100";  -- e^(-0)  = 1.00000000
            when "0001" => data <= x"005E";  -- e^(-1)  ? 0.36787944
            when "0010" => data <= x"0023";  -- e^(-2)  ? 0.13533528
            when "0011" => data <= x"000D";  -- e^(-3)  ? 0.04978707
            when "0100" => data <= x"0005";  -- e^(-4)  ? 0.01831564
            when "0101" => data <= x"0002";  -- e^(-5)  ? 0.00673795
            when "0110" => data <= x"0001";  -- e^(-6)  ? 0.00247875
            when others  => data <= x"0000";  -- e^(-7) tr? ?i underflow
        end case;
    end process;
end Behavioral;

