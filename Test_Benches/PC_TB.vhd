library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end PC_tb;

architecture behaviour of PC_tb is
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal PCWrite     : std_logic := '0';
    signal Branch      : std_logic := '0';
    signal Jump        : std_logic := '0';
    signal Zero        : std_logic := '0';
    signal JumpReg     : std_logic := '0';
    signal ALUResult   : std_logic_vector(31 downto 0) := (others => '0');
    signal Instr       : std_logic_vector(31 downto 0) := (others => '0');
    signal CurrentPC   : std_logic_vector(31 downto 0);

begin
    PC_inst : entity work.PC
        port map (
            clk => clk,
            rst => rst,
            PCWrite => PCWrite,
            Branch => Branch,
            Jump => Jump,
            Zero => Zero,
            JumpReg => JumpReg,
            ALUResult => ALUResult,
            Instr => Instr,
            CurrentPC => CurrentPC
        );

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        PCWrite <= '1';
        wait for 10 ns;

        Jump <= '1';
        Instr <= x"08000000";
        wait for 10 ns;

        Branch <= '1';
        Zero <= '1';
        ALUResult <= x"00000004";
        wait for 10 ns;

        JumpReg <= '1';
        ALUResult <= x"00000010";
        wait for 10 ns;

        PCWrite <= '0';
        wait for 10 ns;

        wait;
    end process;

end behaviour;
