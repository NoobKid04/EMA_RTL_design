library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_conv3x3_bias is
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end entity bram_conv3x3_bias;

architecture rtl of bram_conv3x3_bias is

    type rom_type is array (0 to 15) of std_logic_vector(15 downto 0);

    constant ROM : rom_type := (
        x"0010",  -- bias[0]  =  16/256 =  0.0625
        x"FFFD",  -- bias[1]  =  -3/256 = -0.0117
        x"0003",  -- bias[2]  =   3/256 =  0.0117
        x"000B",  -- bias[3]  =  11/256 =  0.0430
        x"000C",  -- bias[4]  =  12/256 =  0.0469
        x"0005",  -- bias[5]  =   5/256 =  0.0195
        x"0065",  -- bias[6]  = 101/256 =  0.3945
        x"0013",  -- bias[7]  =  19/256 =  0.0742
        x"0004",  -- bias[8]  =   4/256 =  0.0156
        x"FFFE",  -- bias[9]  =  -2/256 = -0.0078
        x"FFFB",  -- bias[10] =  -5/256 = -0.0195
        x"0002",  -- bias[11] =   2/256 =  0.0078
        x"0003",  -- bias[12] =   3/256 =  0.0117
        x"0005",  -- bias[13] =   5/256 =  0.0195
        x"0007",  -- bias[14] =   7/256 =  0.0273
        x"0006"   -- bias[15] =   6/256 =  0.0234
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
