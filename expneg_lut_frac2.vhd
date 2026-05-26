library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expneg_lut_frac2 is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
        data : out STD_LOGIC_VECTOR(15 downto 0)   -- 16-bit Q8.8 output
    );
end expneg_lut_frac2;

architecture Behavioral of expneg_lut_frac2 is
begin
    process(addr)
    begin
        case addr is
            when "0000" => data <= x"0100";  -- e^(0/256)  = 1.00000 ? 256
            when "0001" => data <= x"0101";  -- e^(1/256)  ? 1.00391 ? 257
            when "0010" => data <= x"0102";  -- e^(2/256)  ? 1.00784 ? 258
            when "0011" => data <= x"0103";  -- e^(3/256)  ? 1.01179 ? 259
            when "0100" => data <= x"0104";  -- e^(4/256)  ? 1.01574 ? 260
            when "0101" => data <= x"0105";  -- e^(5/256)  ? 1.01972 ? 261
            when "0110" => data <= x"0106";  -- e^(6/256)  ? 1.02370 ? 262
            when "0111" => data <= x"0107";  -- e^(7/256)  ? 1.02771 ? 263
            when "1000" => data <= x"0108";  -- e^(8/256)  ? 1.03172 ? 264
            when "1001" => data <= x"0109";  -- e^(9/256)  ? 1.03575 ? 265
            when "1010" => data <= x"010A";  -- e^(10/256) ? 1.03980 ? 266
            when "1011" => data <= x"010B";  -- e^(11/256) ? 1.04386 ? 267
            when "1100" => data <= x"010C";  -- e^(12/256) ? 1.04806 ? 268
            when "1101" => data <= x"010D";  -- e^(13/256) ? 1.05218 ? 269
            when "1110" => data <= x"010E";  -- e^(14/256) ? 1.05631 ? 270
            when "1111" => data <= x"010F";  -- e^(15/256) ? 1.06046 ? 271
            when others  => data <= x"0000";
        end case;
    end process;
end Behavioral;