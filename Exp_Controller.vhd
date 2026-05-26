library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Exp_Controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	Done_o : out STD_LOGIC;
	X_ld, X1_ld, X2_ld, X3_ld, X4_ld, X12_ld, X34_ld, Exp_ld : out STD_LOGIC
 );
end Exp_Controller;

architecture rtl of Exp_Controller is
 Type State_type is (S0, S1, S2, S3, S4, S5, S6);
 Signal state : State_type;
 begin
  process (RST, CLK)
   begin
	if (RST='1') then
		state <= S0;
	elsif (CLK'event and CLK = '1') then
		case State is
			when S0 =>
			 state <= S1;
			when S1 =>
			 if (Start_i = '1') then 
				state <= S2;
			 else
				state <= S1;
			 end if;
			when S2 =>
			 state <= S3;
			when S3 =>
			 state <= S4;
			when S4 =>
			 state <= S5;
			when S5 =>
			 state <= S6;
			when S6 =>
			 if (Start_i = '0') then 
				state <= S0;
			 else
				state <= S6;
			 end if;
		end case;
    end if;
  end process;
	
 X_ld <= '1' when state = S2 else '0';
 X1_ld <= '1' when state = S3 else '0';
 X2_ld <= '1' when state = S3 else '0';
 X3_ld <= '1' when state = S3 else '0';
 X4_ld <= '1' when state = S3 else '0';
 X12_ld <= '1' when state = S4 else '0';
 X34_ld <= '1' when state = S4 else '0';
 Exp_ld <= '1' when state = S5 else '0';
 Done_o <= '1' when (state = S5 or state = S6) else '0'; 
end rtl;
