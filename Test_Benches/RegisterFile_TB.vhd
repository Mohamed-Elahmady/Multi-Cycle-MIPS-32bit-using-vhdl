library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile_tb is
end RegisterFile_tb;

architecture behaviour of RegisterFile_tb is
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '0';
    signal Reg_Write      : std_logic := '0';
    signal Read_Register1 : std_logic_vector(4 downto 0) := (others => '0');
    signal Read_Register2 : std_logic_vector(4 downto 0) := (others => '0');
    signal Write_Register : std_logic_vector(4 downto 0) := (others => '0');
    signal write_Data     : std_logic_vector(31 downto 0) := (others => '0');
    signal Read_Data1     : std_logic_vector(31 downto 0);
    signal Read_Data2     : std_logic_vector(31 downto 0);

begin
    RegisterFile_inst : entity work.RegisterFile
        port map (
            clk => clk,
            rst => rst,
            Reg_Write => Reg_Write,
            Read_Register1 => Read_Register1,
            Read_Register2 => Read_Register2,
            Write_Register => Write_Register,
            write_Data => write_Data,
            Read_Data1 => Read_Data1,
            Read_Data2 => Read_Data2
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

        Reg_Write <= '1';
        Write_Register <= "00001";
        write_Data <= x"00000001";
        wait for 10 ns;

        Read_Register1 <= "00001";
        wait for 10 ns;

        Write_Register <= "00010";
        write_Data <= x"00000002";
        wait for 10 ns;

        Read_Register2 <= "00010";
        wait for 10 ns;

        Reg_Write <= '0';
        Write_Register <= "00001";
        write_Data <= x"00000003";
        wait for 10 ns;

        Read_Register1 <= "00001";
        wait for 10 ns;

        wait;
    end process;

end behaviour;
