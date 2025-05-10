library ieee;
use ieee.std_logic_1164.all;

entity Shift_Left_2_tb is
end Shift_Left_2_tb;

architecture behaviour of Shift_Left_2_tb is
    signal input_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal output_data : std_logic_vector(31 downto 0);

begin
    Shift_Left_2_inst : entity work.Shift_Left_2
        port map (
            input_data => input_data,
            output_data => output_data
        );

    process
    begin
        input_data <= x"00000001";
        wait for 10 ns;

        input_data <= x"00000002";
        wait for 10 ns;

        input_data <= x"00000003";
        wait for 10 ns;

        input_data <= x"00000004";
        wait for 10 ns;

        wait;
    end process;

end behaviour;
