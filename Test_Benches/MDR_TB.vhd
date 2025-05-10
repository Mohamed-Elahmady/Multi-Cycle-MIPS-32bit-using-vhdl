library ieee;
use ieee.std_logic_1164.all;

entity MDR_tb is
end entity;

architecture tb of MDR_tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal load     : std_logic := '0';
    signal data_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_out : std_logic_vector(31 downto 0);
begin
    UUT: entity work.MDR
        port map (
            clk      => clk,
            rst      => rst,
            load     => load,
            data_in  => data_in,
            data_out => data_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    stim: process
    begin
        rst <= '1'; wait for 10 ns;
        rst <= '0';
        load <= '1';
        data_in <= x"ABCD1234"; wait for 10 ns;
        load <= '0'; wait for 10 ns;
        wait;
    end process;
end architecture;
