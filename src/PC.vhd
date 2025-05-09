library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
       	PCWrite     : in  STD_LOGIC;
        ALUResult   : in  STD_LOGIC_VECTOR(31 downto 0);
        CurrentPC   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;
architecture behaviour of PC is
-- Local PC register	
	signal Instr 		    : STD_LOGIC_VECTOR(31 downto 0); 
    signal PC_Reg           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal PC_plus_4        : STD_LOGIC_VECTOR(31 downto 0);
    signal Branch_Target    : STD_LOGIC_VECTOR(31 downto 0);
    signal Jump_Target      : STD_LOGIC_VECTOR(31 downto 0);
    signal Offset           : STD_LOGIC_VECTOR(31 downto 0);

    -- Control-like internal signals (moved from ports)
    signal Branch   : STD_LOGIC := '0';
    signal Jump     : STD_LOGIC := '0';
    signal Zero     : STD_LOGIC := '0';
    signal JumpReg  : STD_LOGIC := '0';
begin

    -- PC + 4 calculation
    PC_plus_4 <= std_logic_vector(unsigned(PC_Reg) + 4);

    -- Branch offset calculation
    Offset <= std_logic_vector(shift_left(resize(signed(Instr(15 downto 0)), 32), 2));

    -- Branch target address
    Branch_Target <= std_logic_vector(unsigned(PC_plus_4) + unsigned(Offset));

    -- Jump target address
    Jump_Target <= PC_Reg(31 downto 28) & Instr(25 downto 0) & "00";

    -- PC Update process
    process(clk, rst)
    begin
        if rst = '1' then
            PC_Reg <= (others => '0');
        elsif rising_edge(clk) then
            if PCWrite = '1' then
                if JumpReg = '1' then
                    PC_Reg <= ALUResult;
                elsif Jump = '1' then
                    PC_Reg <= Jump_Target;
                elsif Branch = '1' and Zero = '1' then
                    PC_Reg <= Branch_Target;
                else
                    PC_Reg <= PC_plus_4;
                end if;
            end if;
        end if;
    end process;

    -- Output assignment
    CurrentPC <= PC_Reg;

end architecture;