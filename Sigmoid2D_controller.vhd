library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sigmoid2D_controller is
 port (
    RST, CLK : in STD_LOGIC;
    Start_i, cn_comp : in STD_LOGIC;
    Done_o, count_ld, enb, ena : out STD_LOGIC;
    wea : out STD_LOGIC_VECTOR(0 downto 0)
 );
end Sigmoid2D_controller;

architecture Behavioral of Sigmoid2D_controller is
 Type State_type is (
    S_reset, S_start,
    S_delay1,  S_delay2,  S_delay3,  S_delay4,  S_delay5,  S_delay6,  S_delay7,
    S_delay8,  S_delay9,  S_delay10, S_delay11, S_delay12, S_delay13, S_delay14,
    S_write,
    S_delay15, S_delay16, S_delay17, S_delay18, S_delay19, S_delay20, S_delay21,
    S_delay22, S_delay23, S_delay24, S_delay25, S_delay26, S_delay27, S_delay28,
    S_end
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
            -- 14 delay states tr??c S_write
            when S_delay1  => state <= S_delay2;
            when S_delay2  => state <= S_delay3;
            when S_delay3  => state <= S_delay4;
            when S_delay4  => state <= S_delay5;
            when S_delay5  => state <= S_delay6;
            when S_delay6  => state <= S_delay7;
            when S_delay7  => state <= S_delay8;
            when S_delay8  => state <= S_delay9;
            when S_delay9  => state <= S_delay10;
            when S_delay10 => state <= S_delay11;
            when S_delay11 => state <= S_delay12;
            when S_delay12 => state <= S_delay13;
            when S_delay13 => state <= S_delay14;
            when S_delay14 => state <= S_write;
            -- Write
            when S_write =>
             if (cn_comp = '1') then state <= S_delay15;
             else                    state <= S_write;
             end if;
            -- 14 delay states sau S_write
            when S_delay15 => state <= S_delay16;
            when S_delay16 => state <= S_delay17;
            when S_delay17 => state <= S_delay18;
            when S_delay18 => state <= S_delay19;
            when S_delay19 => state <= S_delay20;
            when S_delay20 => state <= S_delay21;
            when S_delay21 => state <= S_delay22;
            when S_delay22 => state <= S_delay23;
            when S_delay23 => state <= S_delay24;
            when S_delay24 => state <= S_delay25;
            when S_delay25 => state <= S_delay26;
            when S_delay26 => state <= S_delay27;
            when S_delay27 => state <= S_delay28;
            when S_delay28 => state <= S_end;
            -- End
            when S_end =>
             if (Start_i = '0') then state <= S_reset;
             else                    state <= S_end;
             end if;
        end case;
    end if;
  end process;

  -- count_ld: active S_delay1..S_delay14 + S_write (t?ng thêm 3 state)
  count_ld <= '1' when (
    state = S_delay1  or state = S_delay2  or state = S_delay3  or state = S_delay4  or
    state = S_delay5  or state = S_delay6  or state = S_delay7  or state = S_delay8  or
    state = S_delay9  or state = S_delay10 or state = S_delay11 or state = S_delay12 or
    state = S_delay13 or state = S_delay14 or state = S_write
  ) else '0';

  -- enb: active S_delay1..S_delay14 + S_write + S_delay15 + S_delay16 (gi? nguyên pattern: 2 state sau write)
  enb <= '1' when (
    state = S_delay1  or state = S_delay2  or state = S_delay3  or state = S_delay4  or
    state = S_delay5  or state = S_delay6  or state = S_delay7  or state = S_delay8  or
    state = S_delay9  or state = S_delay10 or state = S_delay11 or state = S_delay12 or
    state = S_delay13 or state = S_delay14 or state = S_write   or
    state = S_delay15 or state = S_delay16
  ) else '0';

  -- ena: active S_write..S_delay28 (t?ng thêm 6 state)
  ena <= '1' when (
    state = S_write   or
    state = S_delay15 or state = S_delay16 or state = S_delay17 or state = S_delay18 or
    state = S_delay19 or state = S_delay20 or state = S_delay21 or state = S_delay22 or
    state = S_delay23 or state = S_delay24 or state = S_delay25 or state = S_delay26 or
    state = S_delay27 or state = S_delay28
  ) else '0';

  -- wea: active S_write..S_delay28 (gi?ng ena)
  wea <= "1" when (
    state = S_write   or
    state = S_delay15 or state = S_delay16 or state = S_delay17 or state = S_delay18 or
    state = S_delay19 or state = S_delay20 or state = S_delay21 or state = S_delay22 or
    state = S_delay23 or state = S_delay24 or state = S_delay25 or state = S_delay26 or
    state = S_delay27 or state = S_delay28
  ) else "0";

  -- Done_o: S_delay28 thay th? S_delay22 c?
  Done_o <= '1' when (state = S_delay28 or state = S_end) else '0';

end Behavioral;