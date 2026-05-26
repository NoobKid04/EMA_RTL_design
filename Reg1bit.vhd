library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg1bit is
 port (
	RST, CLK : in STD_LOGIC;
	En : in STD_LOGIC;
	D : in STD_LOGIC;
	Q : out STD_LOGIC
 );
end Reg1bit;

architecture rtl of Reg1bit is
 begin
	process (RST, CLK)
	 begin
		if (RST = '1') then
			Q <= '0';
		elsif (CLK'event and CLK = '1') then
			if (En = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end rtl;
