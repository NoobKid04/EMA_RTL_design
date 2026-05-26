library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Div_16bit_Controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i : in STD_LOGIC;
	Done_o : out STD_LOGIC;
	X_ld, Y_ld, X_norm_ld, Y_norm_ld, X_o_ld, Y_o_ld, mul_sel, F_ld : out STD_LOGIC
 );
end Div_16bit_Controller;

architecture rtl of Div_16bit_Controller is
 Type State_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10);
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
			 state <= S7;
			when S7 =>
			 state <= S8;
			when S8 =>
			 state <= S9;
			when S9 =>
			 state <= S10;
			when S10 =>
			 if (Start_i = '0') then 
				state <= S0;
			 else
				state <= S10;
			 end if;
		end case;
    end if;
  end process;
	
 X_ld <= '1' when state = S2 else '0';
 Y_ld <= '1' when state = S2 else '0';
 X_norm_ld <= '1' when state = S3 else '0'; 
 Y_norm_ld <= '1' when state = S3 else '0'; 
 F_ld <= '1' when (state = S4 or state = S6 or state = S8) else '0';
 X_o_ld <= '1' when (state = S5 or state = S7 or state = S9) else '0';
 Y_o_ld <= '1' when (state = S5 or state = S7 or state = S9) else '0';
 mul_sel <= '0' when (state = S4 or state = S5) else '1';
 Done_o <= '1' when (state = S9 or state = S10) else '0'; 
end rtl;
