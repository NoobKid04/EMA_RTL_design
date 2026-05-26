----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2026 12:36:18 AM
-- Design Name: 
-- Module Name: AvgPoolH_datapath - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SQRT_controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, Div_done : in STD_LOGIC;
	Done_o, X_sel, X_ld, Div_start : out STD_LOGIC
 );
end SQRT_controller;

architecture Behavioral of SQRT_controller is
 Type State_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
 Signal state : State_type;
 begin
  process (RST, CLK)
   begin
	if (RST='1') then
		state <= S0;
	elsif (CLK'event and CLK = '1') then
		case state is
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
			 if (Div_done = '1') then 
				state <= S4;
			 else
				state <= S3;
			 end if;
			when S4 =>
			 state <= S5;
			when S5 =>
			 if (Div_done = '1') then 
				state <= S6;
			 else
				state <= S5;
			 end if;
			when S6 =>
			 state <= S7;
			when S7 =>
			 if (Div_done = '1') then 
				state <= S8;
			 else
				state <= S7;
			 end if;
			when S8 =>
			  state <= S9;
			when S9 =>
			 if (Div_done = '1') then 
				state <= S10;
			 else
				state <= S9;
			 end if;
			 when S10 =>
			  state <= S11;
			 when S11 =>
			  if (Start_i = '0') then 
				state <= S0;
			 else
				state <= S11;
			 end if;
		end case;
    end if;
  end process;
  X_sel <= '0' when state = S2 else '1';
  X_ld <= '1' when (state = S2 or state = S4 or state = S6 or state = S8 or state = S10) else '0';
  Div_start <= '1' when (state = S3 or state = S5 or state = S7 or state = S9) else '0';
  Done_o <= '1' when (state = S10 or state = S11) else '0';
end Behavioral;
