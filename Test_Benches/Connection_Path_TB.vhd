library ieee;
use ieee.std_logic_1164.all;

entity Connection_Path_tb is
end entity;

architecture sim of Connection_Path_tb is

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

begin

    UUT: entity work.Connection_Path
        port map (
            clk => clk,
            rst => rst
        );

    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 180 ns;
        wait;
    end process;

end architecture;
