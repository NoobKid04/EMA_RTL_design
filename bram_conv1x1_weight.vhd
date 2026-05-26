library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_conv1x1_weight is
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(7 downto 0);       -- dia chi doc (0..255)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end entity bram_conv1x1_weight;

architecture rtl of bram_conv1x1_weight is

    type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);

    -- weight[oc][ic] flatten: addr = oc * 16 + ic
    constant ROM : rom_type := (
        -- oc=0
        x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"FFFF", x"0000",
        -- oc=1
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        -- oc=2
        x"0000", x"0000", x"FFFF", x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000",
        -- oc=3
        x"0000", x"0000", x"FFFF", x"FFFE", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"FFFF", x"FFFE", x"0000",
        -- oc=4
        x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0001", x"0000", x"0000", x"FFFF", x"0000", x"FFFF", x"0000",
        -- oc=5
        x"0000", x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"FFFF", x"0000",
        -- oc=6
        x"FFFC", x"FFFE", x"FFFD", x"FFFD", x"FFF9", x"FFF7", x"FFFB", x"FFF4",
        x"FFFF", x"FFFC", x"FFFF", x"FFFE", x"FFFC", x"FFFE", x"FFF8", x"FFFF",
        -- oc=7
        x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFE",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"FFFF", x"FFFE", x"0000",
        -- oc=8
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        -- oc=9
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000",
        -- oc=10
        x"0000", x"0000", x"0000", x"0001", x"0001", x"0001", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        -- oc=11
        x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
        -- oc=12
        x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000",
        -- oc=13
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000",
        -- oc=14
        x"0000", x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"FFFF", x"0000",
        -- oc=15
        x"0000", x"0000", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
        x"0000", x"0000", x"0000", x"0000", x"FFFF", x"0000", x"FFFF", x"0000"
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
