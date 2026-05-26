----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2026 11:32:48 PM
-- Design Name: 
-- Module Name: EMA_controller - Behavioral
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

entity EMA_controller is
 Port(
    RST, CLK : in STD_LOGIC;
    Start_i : in STD_LOGIC;
    BramAvg1_ild, Avg_old, Avg_max_sel, Avg_max_ld : out STD_LOGIC;
    BramStart_old : out STD_LOGIC_VECTOR(1 downto 0);
    Start_Conv33, Start_AvgH, Start_AvgW, Start_Conv11, Start_Sigmoid, Start_elemul, Start_GroupNorm, Start_Avg, Start_Softmax, Start_Matmul, Start_AddSigmoid, Start_Finalmul : out STD_LOGIC;
    Done_Conv33, Done_AvgH, Done_AvgW, Done_Conv11, Done_Sigmoid, Done_elemul, Done_GroupNorm, Done_Avg, Done_Softmax, Done_Matmul, Done_AddSigmoid, Done_Finalmul : in STD_LOGIC;
    Done_o : out STD_LOGIC
 );
end EMA_controller;

architecture Behavioral of EMA_controller is
 Type State_type is (S_reset, S_start, S_AvgH, S_AvgW, S_Conv11, S_Sigmoid, S_elemul, S_GroupNorm, S_Avg, S_Softmax, S_Matmul, S_AddSigmoid, S_Finalmul, S_end);
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
				state <= S_AvgH;
			 else
				state <= S_start;
			end if;
			when S_AvgH =>
			 if(Done_AvgH = '1') then
			     state <= S_AvgW;
			 else
			     state <= S_AvgH;
			end if;
			when S_AvgW =>
			 if(Done_AvgW = '1') then
			     state <= S_Conv11;
			 else
			     state <= S_AvgW;
			end if;
			when S_Conv11 =>
			 if(Done_Conv11 = '1') then
			     state <= S_Sigmoid;
			 else
			     state <= S_Conv11;
			end if;
			when S_Sigmoid =>
			 if(Done_Sigmoid = '1') then
			     state <= S_elemul;
			 else
			     state <= S_Sigmoid;
			end if;
			when S_elemul =>
			 if(Done_elemul = '1') then
			     state <= S_GroupNorm;
			 else
			     state <= S_elemul;
			end if;
			when S_GroupNorm =>
			 if(Done_GroupNorm = '1' and Done_Conv33 = '1') then
			     state <= S_Avg;
			 else
			     state <= S_GroupNorm;
			end if;
			when S_Avg =>
			 if(Done_Avg = '1') then
			     state <= S_Softmax;
			 else
			     state <= S_Avg;
			end if;
			when S_Softmax =>
			 if(Done_Softmax = '1') then
			     state <= S_Matmul;
			 else
			     state <= S_Softmax;
			end if;
			when S_Matmul =>
			 if(Done_Matmul = '1') then
			     state <= S_AddSigmoid;
			 else
			     state <= S_Matmul;
			end if;
			when S_AddSigmoid =>
			 if(Done_AddSigmoid = '1') then
			     state <= S_Finalmul;
			 else
			     state <= S_AddSigmoid;
			end if;
			when S_Finalmul =>
			 if(Done_Finalmul = '1') then
			     state <= S_end;
			 else
			     state <= S_Finalmul;
			end if;
			when S_end =>
			  if (Start_i = '0') then 
				state <= S_reset;
			 else
				state <= S_end;
			end if;
		end case;
	end if;
   end process;
   BramStart_old <= "01" when state = S_AvgW else "10" when state = S_elemul else "11" when state = S_Finalmul else "00";
   BramAvg1_ild <= '1' when state = S_AvgW else '0';
   Avg_old <= '1' when state = S_Matmul else '0';
   Avg_max_sel <= '1' when state = S_Avg else '0';
   Avg_max_ld <=  '1' when state = S_GroupNorm else '0';
   Start_Conv33 <= '1' when (state = S_AvgH or state = S_AvgW or state = S_Conv11 or state = S_Sigmoid or state = S_elemul or state = S_GroupNorm) else '0';
   Start_AvgH <= '1' when state = S_AvgH else '0';
   Start_AvgW <= '1' when state = S_AvgW else '0';
   Start_Conv11 <= '1' when state = S_Conv11 else '0';
   Start_Sigmoid <= '1' when state = S_Sigmoid else '0';
   Start_elemul <= '1' when state = S_elemul else '0';
   Start_GroupNorm <= '1' when state = S_GroupNorm else '0';
   Start_Avg <= '1' when state = S_Avg else '0';
   Start_Softmax <= '1' when state = S_Softmax else '0';
   Start_Matmul <= '1' when state = S_Matmul else '0';
   Start_AddSigmoid <= '1' when state = S_AddSigmoid else '0';
   Start_Finalmul <= '1' when state = S_Finalmul else '0';
   Done_o <= '1' when state = S_end else '0';
end Behavioral;
