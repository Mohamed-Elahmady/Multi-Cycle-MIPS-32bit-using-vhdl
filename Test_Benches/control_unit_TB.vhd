library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit_tb is
end entity;

architecture sim of control_unit_tb is

    signal CLK, Reset: std_logic := '0';
    signal Op, Funct: std_logic_vector(5 downto 0) := (others => '0');
    signal ALUOp: std_logic_vector(1 downto 0);
    signal PCSrc, ALUSrcB: std_logic_vector(1 downto 0);
    signal MemtoReg, RegDst, LorD, ALUSrcA: std_logic;
    signal IRWrite, MemWrite, PCWrite, PCWriteCond, RegWrite, MemRead: std_logic;

begin

    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';

        Op <= "100011"; -- lw
        wait for 100 ns;

        Op <= "101011"; -- sw
        wait for 100 ns;

        Op <= "000000"; -- R-type
        Funct <= "100000"; -- add
        wait for 100 ns;

        Op <= "001000"; -- addi
        wait for 100 ns;

        Op <= "000100"; -- beq
        wait for 100 ns;

        Op <= "000010"; -- jump
        wait for 100 ns;

        wait;
    end process;

    DUT : entity work.control_unit
        port map (
            CLK => CLK,
            Reset => Reset,
            Op => Op,
            Funct => Funct,
            ALUOp => ALUOp,
            PCSrc => PCSrc,
            ALUSrcB => ALUSrcB,
            MemtoReg => MemtoReg,
            RegDst => RegDst,
            LorD => LorD,
            ALUSrcA => ALUSrcA,
            IRWrite => IRWrite,
            MemWrite => MemWrite,
            PCWrite => PCWrite,
            PCWriteCond => PCWriteCond,
            RegWrite => RegWrite,
            MemRead => MemRead
        );

end architecture;
