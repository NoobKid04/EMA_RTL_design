library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_gn_weight is
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end entity bram_gn_weight;

architecture rtl of bram_gn_weight is

    type rom_type is array (0 to 15) of std_logic_vector(15 downto 0);

    -- module.layer2.0.ema.gn.weight [16]  (gamma)
    -- (trich tu ema_weights_layer2_q8_8.vhd, dong 361-365)
    constant ROM : rom_type := (
        x"0045", x"0025", x"0031", x"003C",
        x"003D", x"0032", x"0058", x"0045",
        x"0032", x"0028", x"001F", x"0030",
        x"0031", x"0035", x"0038", x"0033"
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                dout <= ROM(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end architecture rtl;
