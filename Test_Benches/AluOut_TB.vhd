 library ieee;
use ieee.std_logic_1164.all;

entity AluOut_tb is
end AluOut_tb;

architecture behaviour of AluOut_tb is
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal en      : std_logic := '0';
    signal ALU_IN  : std_logic_vector(31 downto 0) := (others => '0');
    signal ALU_OUT : std_logic_vector(31 downto 0);

begin
    AluOut_inst : entity work.AluOut
        port map (
            clk => clk,
            rst => rst,
            en => en,
            ALU_IN => ALU_IN,
            ALU_OUT => ALU_OUT
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

        en <= '1';
        ALU_IN <= x"00000001";
        wait for 10 ns;

        ALU_IN <= x"00000002";
        wait for 10 ns;

        en <= '0';
        ALU_IN <= x"FFFFFFFF";
        wait for 10 ns;

        en <= '1';
        ALU_IN <= x"12345678";
        wait for 10 ns;

        wait;
    end process;

end behaviour;
