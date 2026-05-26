library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_gn_bias is
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end entity bram_gn_bias;

architecture rtl of bram_gn_bias is

    type rom_type is array (0 to 15) of std_logic_vector(15 downto 0);

    -- module.layer2.0.ema.gn.bias [16]
    -- (trich tu ema_weights_layer2_q8_8.vhd, dong 355-359)
    constant ROM : rom_type := (
        x"0026", x"001F", x"0022", x"0025",
        x"0026", x"0023", x"FEAF", x"002B",
        x"0022", x"001F", x"001F", x"0021",
        x"0021", x"0022", x"0022", x"0024"
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
