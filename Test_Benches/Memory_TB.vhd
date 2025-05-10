library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_tb is
end entity;

architecture tb of Memory_tb is
    signal clk         : std_logic := '0';
    signal MemRead     : std_logic := '0';
    signal MemWrite    : std_logic := '0';
    signal Address     : std_logic_vector(31 downto 0) := (others => '0');
    signal Write_Data  : std_logic_vector(31 downto 0) := (others => '0');
    signal Read_Data   : std_logic_vector(31 downto 0);

begin
    UUT: entity work.Memory
        port map (
            clk        => clk,
            MemRead    => MemRead,
            MemWrite   => MemWrite,
            Address    => Address,
            Write_Data => Write_Data,
            Read_Data  => Read_Data
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
        wait for 10 ns;
        MemWrite <= '1';
        Address <= x"00000004";
        Write_Data <= x"DEADBEEF";
        wait for 10 ns;

        MemWrite <= '0';
        MemRead <= '1';
        wait for 10 ns;

        MemRead <= '0';
        wait;
    end process;
end architecture;