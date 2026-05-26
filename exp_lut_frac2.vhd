library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity exp_lut_frac2 is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 3-bit input (0..8)
        data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
    );
end exp_lut_frac2;

architecture Behavioral of exp_lut_frac2 is
begin
    process(addr)
    begin
        case addr is
            when "0000" => data <= x"0100";  -- e^(-0/256)  = 1.00000000
			when "0001" => data <= x"00FF";  -- e^(-1/256)  ? 0.99610137
			when "0010" => data <= x"00FE";  -- e^(-2/256)  ? 0.99221794
			when "0011" => data <= x"00FD";  -- e^(-3/256)  ? 0.98834965
			when "0100" => data <= x"00FC";  -- e^(-4/256)  ? 0.98449644
			when "0101" => data <= x"00FB";  -- e^(-5/256)  ? 0.98065825
			when "0110" => data <= x"00FA";  -- e^(-6/256)  ? 0.97683502
			when "0111" => data <= x"00F9";  -- e^(-7/256)  ? 0.97302671
			when "1000" => data <= x"00F8";  -- e^(-8/256)  ? 0.96923323
			when "1001" => data <= x"00F7";  -- e^(-9/256)  ? 0.96545455
			when "1010" => data <= x"00F6";  -- e^(-10/256) ? 0.96169060
			when "1011" => data <= x"00F5";  -- e^(-11/256) ? 0.95794133
			when "1100" => data <= x"00F4";  -- e^(-12/256) ? 0.95420667
			when "1101" => data <= x"00F3";  -- e^(-13/256) ? 0.95048657
			when "1110" => data <= x"00F2";  -- e^(-14/256) ? 0.94678097
			when "1111" => data <= x"00F1";  -- e^(-15/256) ? 0.94308982
			when others  => data <= x"0000";
        end case;
    end process;
end Behavioral;

