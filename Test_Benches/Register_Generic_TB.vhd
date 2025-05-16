library ieee;
use ieee.std_logic_1164.all;

entity Register_Generic_tb is
end Register_Generic_tb;

architecture behaviour of Register_Generic_tb is
    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal load   : std_logic := '0';
    signal input  : std_logic_vector(31 downto 0) := (others => '0');
    signal output : std_logic_vector(31 downto 0);

begin
    Register_inst : entity work.Register_Generic
        port map (
            clk => clk,
            rst => rst,
            load => load,
            input => input,
            output => output
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        load <= '1';
        input <= x"AAAAAAAA";
        wait for 10 ns;

        input <= x"55555555";
        wait for 10 ns;

        load <= '0';
        input <= x"FFFFFFFF";
        wait for 10 ns;

        load <= '1';
        input <= x"12345678";
        wait for 10 ns;

        wait;
    end process;

end behaviour;
