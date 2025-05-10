library ieee;
use ieee.std_logic_1164.all;

entity InstructionRegister_tb is
end entity;

architecture tb of InstructionRegister_tb is
    signal clk                : std_logic := '0';
    signal IRWrite            : std_logic := '0';
    signal MemData            : std_logic_vector(31 downto 0) := (others => '0');
    signal OpCode             : std_logic_vector(5 downto 0);
    signal Register1          : std_logic_vector(4 downto 0);
    signal Register2          : std_logic_vector(4 downto 0);
    signal Destination_Register : std_logic_vector(4 downto 0);
    signal Shift_Amount       : std_logic_vector(4 downto 0);
    signal Function_Code      : std_logic_vector(5 downto 0);
    signal Immediate          : std_logic_vector(15 downto 0);
    signal Jump_Address       : std_logic_vector(25 downto 0);

    component InstructionRegister
        generic (
            W : integer := 5;
            X : integer := 16;
            Y : integer := 26;
            B : integer := 32
        );
        port (
            clk                  : in std_logic;
            IRWrite              : in std_logic;
            MemData              : in std_logic_vector(B-1 downto 0);
            OpCode               : out std_logic_vector(W downto 0);
            Register1            : out std_logic_vector(W-1 downto 0);
            Register2            : out std_logic_vector(W-1 downto 0);
            Destination_Register : out std_logic_vector(W-1 downto 0);
            Shift_Amount         : out std_logic_vector(W-1 downto 0);
            Function_Code        : out std_logic_vector(W downto 0);
            Immediate            : out std_logic_vector(X-1 downto 0);
            Jump_Address         : out std_logic_vector(Y-1 downto 0)
        );
    end component;

begin

    UUT: InstructionRegister
        port map (
            clk, IRWrite, MemData,
            OpCode, Register1, Register2,
            Destination_Register, Shift_Amount,
            Function_Code, Immediate, Jump_Address
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim: process
    begin
        IRWrite <= '1';
        MemData <= x"8C130004";  -- ?? ???? ???????
        wait for 10 ns;
        IRWrite <= '0';
        wait;
    end process;

end architecture;
