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

entity AvgPoolH_controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, W_comp, Div_done, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, X_add_mux, X_add_ld, X_div_ld, Div_start, CHW_comp_ld, ena : out STD_LOGIC;
	write_en : out STD_LOGIC_VECTOR(0 downto 0)
 );
end AvgPoolH_controller;

architecture Behavioral of AvgPoolH_controller is
 Type State_type is (S_reset, S_start, S_delay1, S_delay2, S_add, S_delay3, S_delay4, S_div, S_write, S_done, S_end);
 Signal state : State_type;
 begin
  process (RST, CLK)
   begin
	if (RST='1') then
		state <= S_reset;
	elsif (CLK'event and CLK = '1') then
		case State is
			when S_reset =>
			 state <= S_start;
			when S_start =>
			 if (Start_i = '1') then 
				state <= S_delay1;
			 else
				state <= S_start;
			 end if;
			when S_delay1 =>
			 state <= S_delay2;
			when S_delay2 =>
			 state <= S_add;
			when S_add =>
			 if (W_comp = '1') then 
				state <= S_delay3;
			 else
				state <= S_add;
			 end if;
			when S_delay3 =>
			 state <= S_delay4;
			when S_delay4 =>
			 state <= S_div;
			when S_div =>
			 if (Div_done = '1') then 
				state <= S_write;
			 else
				state <= S_div;
			 end if;
			 when S_write =>
			  if (CHW_comp = '1') then 
				state <= S_done;
			 else
				state <= S_delay1;
			 end if;
			 when S_done =>
			  state <= S_end;
			 when S_end =>
			  if (Start_i = '0') then 
				state <= S_reset;
			 else
				state <= S_end;
			 end if;
		end case;
    end if;
  end process;
  count_ld <= '1' when (state = S_delay1 or state = S_delay2 or state = S_add) else '0';
  enb <= '1' when (state = S_delay1 or state = S_delay2 or state = S_add or state = S_delay3 or state = S_delay4) else '0';
  X_add_mux <= '0' when state = S_delay2 else '1';
  X_add_ld <= '1' when (state = S_delay2 or state = S_add or state = S_delay3 or state = S_delay4) else '0';
  Div_start <= '0' when (state = S_delay3 or state = S_delay4) else '1';
  X_div_ld <= '1' when state = S_write else '0';
  Done_o <= '1' when (state = S_done or state = S_end) else '0';
  CHW_comp_ld <= '1'  when state = S_add else '0';
  ena <= '1' when state = S_write else '0';
  write_en <= "1" when state = S_write else "0";
end Behavioral;
