library ieee;
use ieee.std_logic_1164.all;

entity shift_left_2_PC_tb is
end entity;

architecture sim of shift_left_2_PC_tb is

    signal input_data  : std_logic_vector(25 downto 0) := (others => '0');
    signal output_data : std_logic_vector(27 downto 0);

begin

    DUT : entity work.shift_left_2_PC
        port map (
            input_data => input_data,
            output_data => output_data
        );

    stim_proc : process
    begin
        input_data <= "00000000000000000000000001";
        wait for 10 ns;

        input_data <= "00000000000000000000000010";
        wait for 10 ns;

        input_data <= "00000000000000000000001111";
        wait for 10 ns;

        input_data <= "11111111111111111111111111";
        wait for 10 ns;

        wait;
    end process;

end architecture;
