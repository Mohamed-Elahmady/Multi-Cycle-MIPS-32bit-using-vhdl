library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity PC_tb is
end PC_tb;

architecture Behavioral of PC_tb is
    component PC
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            PCWrite     : in  STD_LOGIC;
            ALUResult   : in  STD_LOGIC_VECTOR(31 downto 0);
            CurrentPC   : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk_tb      : STD_LOGIC := '0';
    signal rst_tb      : STD_LOGIC := '0';
    signal PCWrite_tb  : STD_LOGIC := '0';
    signal ALUResult_tb: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal CurrentPC_tb: STD_LOGIC_VECTOR(31 downto 0);
    
    -- Clock period
    constant clk_period : time := 10 ns;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: PC port map (
        clk => clk_tb,
        rst => rst_tb,
        PCWrite => PCWrite_tb,
        ALUResult => ALUResult_tb,
        CurrentPC => CurrentPC_tb
    );

    -- Clock generation process
    clk_process: process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        variable my_line : line;
    begin
        -- Initialize all inputs
        write(my_line, string'("Starting simulation..."));
        writeline(output, my_line);
        rst_tb <= '1';
        wait for clk_period;
        
        -- Test 1: Reset functionality
        write(my_line, string'("Test 1: Reset"));
        writeline(output, my_line);
        rst_tb <= '1';
        PCWrite_tb <= '1';
        wait for clk_period;
        assert CurrentPC_tb = x"00000000" 
            report "Reset failed" severity error;
        
        -- Test 2: Normal PC increment (PC+4)
        write(my_line, string'("Test 2: PC increment"));
        writeline(output, my_line);
        rst_tb <= '0';
        PCWrite_tb <= '1';
        wait for clk_period;
        assert CurrentPC_tb = x"00000004" 
            report "PC+4 failed" severity error;
        
        -- Test 3: Jump operation
        write(my_line, string'("Test 3: Jump"));
        writeline(output, my_line);
        ALUResult_tb <= x"12345678";
        wait for clk_period;
        assert CurrentPC_tb = x"00000008" 
            report "Jump failed" severity error;
        
        -- Test 4: PCWrite disabled
        write(my_line, string'("Test 4: PCWrite disabled"));
        writeline(output, my_line);
        PCWrite_tb <= '0';
        ALUResult_tb <= x"AAAAAAAA";
        wait for clk_period;
        assert CurrentPC_tb = x"00000008" 
            report "PCWrite disable failed" severity error;
        
        write(my_line, string'("All tests completed successfully"));
        writeline(output, my_line);
        wait;
    end process;

    -- Simple monitor process using integer conversion
    monitor_proc: process(clk_tb)
    begin
        if rising_edge(clk_tb) then
            report "PC Value (decimal) = " & integer'image(to_integer(unsigned(CurrentPC_tb)));
        end if;
    end process;

end Behavioral;