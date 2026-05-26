library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expneg_lut_frac is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input (0..15)
        data : out STD_LOGIC_VECTOR(15 downto 0)   -- 16-bit Q8.8 output
    );
end expneg_lut_frac;

architecture Behavioral of expneg_lut_frac is
begin
    process(addr)
    begin
        case addr is
            when "0000" => data <= x"0100";  -- e^(0/16)  = 1.00000 ? 256
            when "0001" => data <= x"0111";  -- e^(1/16)  ? 1.06449 ? 273
            when "0010" => data <= x"0122";  -- e^(2/16)  ? 1.13315 ? 290
            when "0011" => data <= x"0135";  -- e^(3/16)  ? 1.20623 ? 309
            when "0100" => data <= x"0149";  -- e^(4/16)  ? 1.28403 ? 329
            when "0101" => data <= x"015E";  -- e^(5/16)  ? 1.36687 ? 350
            when "0110" => data <= x"0174";  -- e^(6/16)  ? 1.45499 ? 372
            when "0111" => data <= x"018D";  -- e^(7/16)  ? 1.54883 ? 397
            when "1000" => data <= x"01A6";  -- e^(8/16)  ? 1.64872 ? 422
            when "1001" => data <= x"01C1";  -- e^(9/16)  ? 1.75505 ? 449
            when "1010" => data <= x"01DE";  -- e^(10/16) ? 1.86825 ? 478
            when "1011" => data <= x"01FD";  -- e^(11/16) ? 1.98874 ? 509
            when "1100" => data <= x"021E";  -- e^(12/16) ? 2.11700 ? 542
            when "1101" => data <= x"0241";  -- e^(13/16) ? 2.25353 ? 577
            when "1110" => data <= x"0266";  -- e^(14/16) ? 2.39888 ? 614
            when "1111" => data <= x"028E";  -- e^(15/16) ? 2.55360 ? 654
            when others  => data <= x"0000";
        end case;
    end process;
end Behavioral;