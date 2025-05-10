library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
    port (
        CLK, Reset: in std_logic;
        Op, Funct: in std_logic_vector(5 downto 0);
	   	ALUOp: inout std_logic_vector(1 downto 0);
        PCSrc: out std_logic_vector(1 downto 0);
        ALUSrcB: out std_logic_vector(1 downto 0);
        MemtoReg, RegDst, LorD, ALUSrcA: out std_logic;

        IRWrite, MemWrite, PCWrite, PCWriteCond, RegWrite, MemRead: out std_logic
    );
end entity;

architecture rtl of control_unit is	 
		

    type state_type is (
        Fetch, Decode,
        MemAdr, MemReadS1, MemReadS2,
        MemWriteS,
        ExecuteR, WriteR,
        ExecuteI, WriteI,
        Branch, Jump
    );
    signal state, next_state: state_type;
    --signal ALUOp: std_logic_vector(1 downto 0);

begin

    -- FSM state register
    process(CLK, Reset)
    begin
        if Reset = '1' then
            state <= Fetch;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;

    -- Next-state logic
    process(state, Op)
    begin
        case state is
            when Fetch => next_state <= Decode;

            when Decode =>
                case Op is
                    when "100011" => next_state <= MemAdr;      -- lw
                    when "101011" => next_state <= MemAdr;      -- sw
                    when "000000" => next_state <= ExecuteR;    -- R-type
                    when "001000" => next_state <= ExecuteI;    -- addi
                    when "000100" => next_state <= Branch;      -- beq
                    when "000010" => next_state <= Jump;        -- jump
                    when others => next_state <= Fetch;
                end case;

            when MemAdr =>
                if Op = "100011" then
                    next_state <= MemReadS1;
                else
                    next_state <= MemWriteS;
                end if;

            when MemReadS1 => next_state <= MemReadS2;
            when MemReadS2 => next_state <= Fetch;
            when MemWriteS => next_state <= Fetch;
            when ExecuteR => next_state <= WriteR;
            when WriteR    => next_state <= Fetch;
            when ExecuteI  => next_state <= WriteI;
            when WriteI    => next_state <= Fetch;
            when Branch    => next_state <= Fetch;
            when Jump      => next_state <= Fetch;
        end case;
    end process;

    -- Output logic
    process(state, Op, Funct)
    begin
        -- default values
        IRWrite <= '0'; MemRead <= '0'; MemWrite <= '0';
        PCWrite <= '0'; PCWriteCond <= '0'; RegWrite <= '0';
        MemtoReg <= '0'; RegDst <= '0'; LorD <= '0';
        ALUSrcA <= '0'; ALUSrcB <= "00"; PCSrc <= "00";
        ALUOp <= "00"; 

        case state is
            when Fetch =>
                MemRead <= '1';
                IRWrite <= '1';
                ALUSrcB <= "01";
                PCWrite <= '1';
                PCSrc <= "00";
                ALUOp <= "00";

            when Decode =>
                ALUSrcB <= "11";
                ALUOp <= "00";

            when MemAdr =>
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "00";

            when MemReadS1 =>
                MemRead <= '1';
                LorD <= '1';

            when MemReadS2 =>
                RegWrite <= '1';
                MemtoReg <= '1';

            when MemWriteS =>
                MemWrite <= '1';
                LorD <= '1';

            when ExecuteR =>
                ALUSrcA <= '1';
                ALUOp <= "10";

            when WriteR =>
                RegDst <= '1';
                RegWrite <= '1';

            when ExecuteI =>
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "00";

            when WriteI =>
                RegWrite <= '1';

            when Branch =>
                ALUSrcA <= '1';
                ALUOp <= "01";
                PCSrc <= "01";
                PCWriteCond <= '1';

            when Jump =>
                PCSrc <= "10";
                PCWrite <= '1';

        end case;
    end process;

   

end architecture;
