library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Generic is
    generic (
        WIDTH : integer := 32  
    );
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        load   : in  std_logic;  
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity Register_Generic;

architecture Behavioral of Register_Generic is
    signal reg : std_logic_vector(WIDTH-1 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '0');  
        elsif rising_edge(clk) then
            if load = '1' then       
                reg <= input;
            end if;
        end if;
    end process;

    output <= reg;  
end architecture Behavioral;