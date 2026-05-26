library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Regn is
 generic ( DATA_WIDTH : Integer := 16 );
 port (
	RST, CLK : in STD_LOGIC;
	En : in STD_LOGIC;
	D : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	Q : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
 );
end Regn;

architecture rtl of Regn is
 begin
	process (RST, CLK)
	 begin
		if (RST = '1') then
			Q <= (others => '0');
		elsif (CLK'event and CLK = '1') then
			if (En = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end rtl;
