library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    Port (
        clk         : in  STD_LOGIC;                     
        rst         : in  STD_LOGIC;
        PCWrite     : in  STD_LOGIC;
        Branch      : in  STD_LOGIC;
        Jump        : in  STD_LOGIC;
        Zero        : in  STD_LOGIC;
        JumpReg     : in  STD_LOGIC;
        ALUResult   : in  STD_LOGIC_VECTOR(31 downto 0);
        Instr       : in  STD_LOGIC_VECTOR(31 downto 0);
        CurrentPC   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture behaviour of PC is
    signal PC_Reg           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal PC_plus_4        : STD_LOGIC_VECTOR(31 downto 0);                  
    signal Branch_Target    : STD_LOGIC_VECTOR(31 downto 0);                  
    signal Jump_Target      : STD_LOGIC_VECTOR(31 downto 0);                
begin
    PC_plus_4 <= STD_LOGIC_VECTOR(unsigned(PC_Reg) + 4);
    Branch_Target <= STD_LOGIC_VECTOR(unsigned(PC_plus_4) + unsigned(ALUResult));
    Jump_Target <= PC_plus_4(31 downto 28) & Instr(25 downto 0) & "00";

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

    CurrentPC <= PC_Reg;

end architecture;