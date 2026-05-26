library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shift_left is
    Generic (
        DATA_WIDTH  : integer := 16;       -- Width of data input
        SHIFT_WIDTH : integer := 5         -- Width of shift amount
    );
    Port (
        data_in    : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        shift_amt  : in  STD_LOGIC_VECTOR(SHIFT_WIDTH-1 downto 0);
        data_out   : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end barrel_shift_left;

architecture Structural of barrel_shift_left is

    type stage_t is array (0 to SHIFT_WIDTH) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal stage : stage_t;

begin

    stage(0) <= data_in;

    -- Generate SHIFT_WIDTH stages; each stage i shifts left by 2^i bits
    GEN_STAGES: for i in 0 to SHIFT_WIDTH-1 generate
    begin
        process(stage(i), shift_amt)
            constant SH : integer := 2**i;  -- Shift amount of this stage: 1, 2, 4, 8, 16, ...
        begin
            if shift_amt(i) = '0' then
                -- No shift at this stage: pass through
                stage(i+1) <= stage(i);

            elsif SH >= DATA_WIDTH then
                -- Shift more than the data width ? result = 0
                stage(i+1) <= (others => '0');

            else
                -- Shift left by SH bits:
                -- High bits [DATA_WIDTH-1 : SH]   ? taken from [DATA_WIDTH-1-SH : 0]
                -- Low bits  [SH-1 : 0]            ? filled with '0'
                stage(i+1)(DATA_WIDTH-1 downto SH) <= stage(i)(DATA_WIDTH-1-SH downto 0);
                stage(i+1)(SH-1 downto 0)          <= (others => '0');
            end if;
        end process;
    end generate;

    -- If shift_amt >= DATA_WIDTH then output = 0
    data_out <= (others => '0')
                    when to_integer(unsigned(shift_amt)) >= DATA_WIDTH
                    else stage(SHIFT_WIDTH);

end Structural;
