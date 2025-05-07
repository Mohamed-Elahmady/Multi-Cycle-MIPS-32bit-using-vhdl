library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDR is	
	generic (
		B : integer := 32
		);	
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        load    : in  std_logic;
        data_in : in  std_logic_vector(B-1 downto 0);
        data_out: out std_logic_vector(B-1 downto 0)
    );
end entity;

architecture Behavioral of MDR is
    signal reg : std_logic_vector(B-1 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
	
end architecture;