library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_conv1x1_bias is
    port(
        clk   : in  std_logic;                          -- clock
        en    : in  std_logic;                          -- read enable
        addr  : in  std_logic_vector(3 downto 0);       -- dia chi doc (0..15)
        dout  : out std_logic_vector(15 downto 0)       -- gia tri Q8.8
    );
end entity bram_conv1x1_bias;

architecture rtl of bram_conv1x1_bias is

    type rom_type is array (0 to 15) of std_logic_vector(15 downto 0);

    constant ROM : rom_type := (
        x"0002",  -- bias[0]  =  2/256 =  0.0078
        x"0001",  -- bias[1]  =  1/256 =  0.0039
        x"0001",  -- bias[2]  =  1/256 =  0.0039
        x"0000",  -- bias[3]  =  0/256 =  0.0000
        x"0001",  -- bias[4]  =  1/256 =  0.0039
        x"0000",  -- bias[5]  =  0/256 =  0.0000
        x"0001",  -- bias[6]  =  1/256 =  0.0039
        x"0001",  -- bias[7]  =  1/256 =  0.0039
        x"0002",  -- bias[8]  =  2/256 =  0.0078
        x"0000",  -- bias[9]  =  0/256 =  0.0000
        x"0001",  -- bias[10] =  1/256 =  0.0039
        x"0002",  -- bias[11] =  2/256 =  0.0078
        x"0002",  -- bias[12] =  2/256 =  0.0078
        x"0001",  -- bias[13] =  1/256 =  0.0039
        x"0001",  -- bias[14] =  1/256 =  0.0039
        x"0001"   -- bias[15] =  1/256 =  0.0039
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
