library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GroupNorm_controller is
 port (
	RST, CLK : in STD_LOGIC;
	Start_i, HW_comp, C_comp, Div_done1, Div_done2, Div_done3, SQRT_done : in STD_LOGIC;
	Done_o, count_ld, X_add1_ld, X_add2_ld, X_add1_sel, X_add2_sel, u_ld, ro_ld, C_ld, Div_start1, Div_start2, Div_start3, SQRT_start, enb, ena : out STD_LOGIC;
	wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end GroupNorm_controller;

architecture Behavioral of GroupNorm_controller is
 Type State_type is (
    S_reset, S_start,
    S_delay1, S_delay2, S_add1, S_delay3, S_delay4,
    S_div1,
    S_delay5, S_delay6, S_delay6a, S_delay6b, S_delay7,
    S_add2,
    S_delay8, S_delay8a, S_delay8b, S_delay9, S_delay10,
    S_div2, S_sqrt, S_div3,
    S_delay11, S_delay12, S_delay13, S_delay14, S_delay15,
    S_write,
    S_delay16, S_delay17, S_delay18, S_delay19, S_delay20,
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
			when S_delay1  => state <= S_delay2;
			when S_delay2  => state <= S_add1;
			when S_add1 =>
			 if (HW_comp = '1') then state <= S_delay3;
			 else                    state <= S_add1;
			 end if;
			when S_delay3  => state <= S_delay4;
			when S_delay4  => state <= S_div1;
			when S_div1 =>
			 if (Div_done1 = '1') then state <= S_delay5;
			 else                      state <= S_div1;
			 end if;
			when S_delay5  => state <= S_delay6;
			when S_delay6  => state <= S_delay6a;
			when S_delay6a => state <= S_delay6b;
			when S_delay6b => state <= S_delay7;
			when S_delay7  => state <= S_add2;
			when S_add2 =>
			 if (HW_comp = '1') then state <= S_delay8;
			 else                    state <= S_add2;
			 end if;
			when S_delay8  => state <= S_delay8a;
			when S_delay8a => state <= S_delay8b;
			when S_delay8b => state <= S_delay9;
			when S_delay9  => state <= S_delay10;
			when S_delay10 => state <= S_div2;
			when S_div2 =>
			 if (Div_done2 = '1') then state <= S_sqrt;
			 else                      state <= S_div2;
			 end if;
			when S_sqrt =>
			 if (Sqrt_done = '1') then state <= S_div3;
			 else                      state <= S_sqrt;
			 end if;
			when S_div3 =>
			 if (Div_done3 = '1') then state <= S_delay11;
			 else                      state <= S_div3;
			 end if;
			when S_delay11 => state <= S_delay12;
			when S_delay12 => state <= S_delay13;
			when S_delay13 => state <= S_delay14;
			when S_delay14 => state <= S_delay15;
			when S_delay15 => state <= S_write;
			when S_write =>
			 if (HW_comp = '1') then state <= S_delay16;
			 else                    state <= S_write;
			 end if;
			when S_delay16 => state <= S_delay17;
			when S_delay17 => state <= S_delay18;
			when S_delay18 => state <= S_delay19;
			when S_delay19 => state <= S_delay20;
			when S_delay20 =>
			 if (C_comp = '1') then state <= S_done;
			 else                   state <= S_delay1;
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
    state = S_delay1  or state = S_delay2  or state = S_add1   or
    state = S_delay5  or state = S_delay6  or state = S_delay6a or state = S_delay6b or state = S_delay7 or
    state = S_add2    or
    state = S_delay11 or state = S_delay12 or state = S_delay13 or state = S_delay14 or
    state = S_delay15 or state = S_write
  ) else '0';

  enb <= '1' when (
    state = S_delay1  or state = S_delay2  or state = S_add1   or
    state = S_delay3  or state = S_delay4  or
    state = S_delay5  or state = S_delay6  or state = S_delay6a or state = S_delay6b or state = S_delay7 or
    state = S_add2    or state = S_delay8  or state = S_delay8a or state = S_delay8b or
    state = S_delay9  or state = S_delay10 or
    state = S_delay11 or state = S_delay12 or state = S_delay13 or state = S_delay14 or
    state = S_delay15 or state = S_write   or state = S_delay16 or state = S_delay17 or
    state = S_delay18 or state = S_delay19 or state = S_delay20
  ) else '0';

  X_add1_sel <= '0' when state = S_delay2  else '1';
  X_add2_sel <= '0' when state = S_delay7  else '1';

  X_add1_ld <= '1' when (
    state = S_delay2 or state = S_add1 or state = S_delay3 or state = S_delay4
  ) else '0';

  X_add2_ld <= '1' when (
    state = S_delay7  or state = S_add2   or state = S_delay8  or
    state = S_delay8a or state = S_delay8b or state = S_delay9 or state = S_delay10
  ) else '0';

  u_ld  <= '1' when state = S_delay5  else '0';
  ro_ld <= '1' when state = S_delay11 else '0';
  C_ld  <= '1' when state = S_delay20 else '0';

  Div_start1 <= '1' when state = S_div1 else '0';
  Div_start2 <= '1' when state = S_div2 else '0';
  Div_start3 <= '1' when state = S_div3 else '0';
  SQRT_start  <= '1' when state = S_sqrt else '0';

  Done_o <= '1' when (state = S_done or state = S_end) else '0';

  ena <= '1' when (
    state = S_write   or state = S_delay16 or state = S_delay17 or
    state = S_delay18 or state = S_delay19 or state = S_delay20
  ) else '0';

  wea <= "1" when (
    state = S_write   or state = S_delay16 or state = S_delay17 or
    state = S_delay18 or state = S_delay19 or state = S_delay20
  ) else "0";

end Behavioral;