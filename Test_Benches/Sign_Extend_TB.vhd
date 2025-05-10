library ieee;
use ieee.std_logic_1164.all;

entity Sign_Extend_tb is
end Sign_Extend_tb;

architecture behaviour of Sign_Extend_tb is
    signal input_16  : std_logic_vector(15 downto 0) := (others => '0');
    signal output_32 : std_logic_vector(31 downto 0);

begin
    Sign_Extend_inst : entity work.Sign_Extend
        port map (
            input_16 => input_16,
            output_32 => output_32
        );

    process
    begin
        input_16 <= x"0001";
        wait for 10 ns;

        input_16 <= x"8001";
        wait for 10 ns;

        input_16 <= x"FFFF";
        wait for 10 ns;

        input_16 <= x"1234";
        wait for 10 ns;

        wait;
    end process;

end behaviour;
