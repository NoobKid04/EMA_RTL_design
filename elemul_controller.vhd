library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity elemul_controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, CHW_comp : in STD_LOGIC;
	Done_o, count_ld, enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end elemul_controller;

architecture Behavioral of elemul_controller is
 Type State_type is (
    S_reset, S_start,
    S_delay1, S_delay2, S_delay3, S_delay4,
    S_write,
    S_delay5, S_delay6, S_delay7,
    S_done, S_end
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
			when S_delay1 => state <= S_delay2;
			when S_delay2 => state <= S_delay3;
			when S_delay3 => state <= S_delay4;
			when S_delay4 => state <= S_write;
			when S_write  =>
			 if (CHW_comp = '1') then state <= S_delay5;
			 else                    state <= S_write;
			 end if;
			when S_delay5 => state <= S_delay6;
			when S_delay6 => state <= S_delay7;
			when S_delay7 => state <= S_done;
			when S_done   => state <= S_end;
			when S_end    =>
			 if (Start_i = '0') then state <= S_reset;
			 else                    state <= S_end;
			 end if;
		end case;
    end if;
  end process;

  count_ld <= '1' when (
    state = S_delay1 or state = S_delay2 or state = S_delay3 or state = S_delay4 or
    state = S_write
  ) else '0';

  enb <= '1' when (
    state = S_delay1 or state = S_delay2 or state = S_delay3 or state = S_delay4 or
    state = S_write  or state = S_delay5 or state = S_delay6
  ) else '0';

  Done_o <= '1' when (state = S_done or state = S_end) else '0';

  ena <= '1' when (
    state = S_write  or state = S_delay5 or state = S_delay6 or
    state = S_delay7 or state = S_done
  ) else '0';

  wea <= "1" when (
    state = S_write  or state = S_delay5 or state = S_delay6 or
    state = S_delay7 or state = S_done
  ) else "0";

end Behavioral;