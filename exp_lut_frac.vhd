library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity exp_lut_frac is
    Port (
        addr : in  STD_LOGIC_VECTOR(3 downto 0);  -- 3-bit input (0..8)
        data : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit Q8.8 output
    );
end exp_lut_frac;

architecture Behavioral of exp_lut_frac is
begin
    process(addr)
    begin
        case addr is
            when "0000" => data <= x"0100";  -- e^(-0/16)  = 1.00000000
    		when "0001" => data <= x"00F0";  -- e^(-1/16)  ? 0.93941306
    		when "0010" => data <= x"00E2";  -- e^(-2/16)  ? 0.88249690
    		when "0011" => data <= x"00D4";  -- e^(-3/16)  ? 0.82902912
    		when "0100" => data <= x"00C7";  -- e^(-4/16)  ? 0.77880078
    		when "0101" => data <= x"00BB";  -- e^(-5/16)  ? 0.73161563
    		when "0110" => data <= x"00B0";  -- e^(-6/16)  ? 0.68728928
    		when "0111" => data <= x"00A5";  -- e^(-7/16)  ? 0.64564853
    		when "1000" => data <= x"009B";  -- e^(-8/16)  ? 0.60653066
    		when "1001" => data <= x"0092";  -- e^(-9/16)  ? 0.56978282
    		when "1010" => data <= x"0089";  -- e^(-10/16) ? 0.53526143
    		when "1011" => data <= x"0081";  -- e^(-11/16) ? 0.50283158
    		when "1100" => data <= x"0079";  -- e^(-12/16) ? 0.47236655
    		when "1101" => data <= x"0072";  -- e^(-13/16) ? 0.44374731
    		when "1110" => data <= x"006B";  -- e^(-14/16) ? 0.41686202
    		when "1111" => data <= x"0064";  -- e^(-15/16) ? 0.39160563
    		when others  => data <= x"0000";
        end case;
    end process;
end Behavioral;

