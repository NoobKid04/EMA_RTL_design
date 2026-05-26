library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Matmul_controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, C_comp, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, acc_sel, acc_ld, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end Matmul_controller;

architecture Behavioral of Matmul_controller is
 Type State_type is (
    S_reset, S_start,
    S_delay1, S_delay2, S_delay2b,
    S_add,
    S_delay3b, S_delay3, S_delay4,
    S_write, S_done, S_end
 );
 Signal state : State_type;
 begin
  process (RST, CLK)
   begin
	if (RST='1') then
		state <= S_reset;
	elsif (CLK'event and CLK = '1') then
		case state is
			when S_reset  => state <= S_start;
			when S_start  =>
			 if (Start_i = '1') then state <= S_delay1;
			 else                    state <= S_start;
			 end if;
			when S_delay1  => state <= S_delay2;
			when S_delay2  => state <= S_delay2b;
			when S_delay2b => state <= S_add;
			when S_add =>
			 if (C_comp = '1') then state <= S_delay3b;
			 else                   state <= S_add;
			 end if;
			when S_delay3b => state <= S_delay3;
			when S_delay3  => state <= S_delay4;
			when S_delay4  => state <= S_write;
			when S_write =>
			 if (CHW_comp = '1') then state <= S_done;
			 else                    state <= S_delay1;
			 end if;
			when S_done   => state <= S_end;
			when S_end    =>
			 if (Start_i = '0') then state <= S_reset;
			 else                    state <= S_end;
			 end if;
		end case;
    end if;
  end process;

  count_ld <= '1' when (
    state = S_delay1 or state = S_delay2 or state = S_delay2b or state = S_add
  ) else '0';

  enb <= '1' when (
    state = S_delay1  or state = S_delay2  or state = S_delay2b or
    state = S_add     or state = S_delay3b or state = S_delay3  or state = S_delay4
  ) else '0';

  acc_sel <= '0' when state = S_delay2b else '1';

  acc_ld <= '1' when (
    state = S_delay2b or state = S_add    or
    state = S_delay3b or state = S_delay3 or state = S_delay4
  ) else '0';

  Done_o <= '1' when (state = S_done or state = S_end) else '0';

  ena <= '1' when state = S_write else '0';
  wea <= "1" when state = S_write else "0";

end Behavioral;