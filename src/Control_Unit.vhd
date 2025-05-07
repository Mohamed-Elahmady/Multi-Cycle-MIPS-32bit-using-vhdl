library ieee;
use ieee.std_logic_1164.all;

entity control_unit is 
   port (
   Op, Funct: in std_logic_vector(5 downto 0);	 
   ALUOp: inout std_logic_vector(1 downto 0);
   -- mux selects
   ALUSrcB: out std_logic_vector(1 downto 0);
   MemtoReg, RegDst, LorD, PCSrc, ALUSrcA: out std_logic;
   -- Register Enables
   IRWrite, MemWrite, PCWrite, Branch, RegWrite: out std_logic
   );	
end entity;	

architecture rtl of control_unit is
-- control_word returns the out of given op and funct in vector then i can assign each out with its index in the vector
    signal control_word: std_logic_vector(13 downto 0);	 
	signal alu_control_signal:std_logic_vector(2 downto 0);
begin  
	
	alu_controller :entity  alu_controller 
		port map(ALUOp => ALUOp , funct => funct , ALUControl => alu_control_signal);

    -- Control word generation based on Op and Funct
    with Op select
        control_word <= 
            "00101011000011" when "100011", -- lw
            "0010XX10100000" when "101011", -- sw
            "10000101000011" when "000000", -- R-type (default for add)
            "0100XX01110000" when "000100", -- beq
            "XXXXXXXX001000" when "000010", -- jump
            (others => '0') when others;

    -- If the Op is R-type, we need to check the Funct field for specific operations
    process(Op, Funct)
    begin
        if Op = "000000" then -- R-type
            case Funct is
                when "100000" =>  -- add
                    control_word <= "10000101000011"; -- R-type add control word
                when "100010" =>  -- sub
                    control_word <= "10000101000010"; -- R-type sub control word
                -- Add more cases for other R-type instructions
                when others =>
                    control_word <= "10000101000011"; -- Default: R-type add
            end case;
        end if;
    end process;

    -- Map bits from control_word to output ports
    ALUOp     <= control_word(13 downto 12);
    ALUSrcB   <= control_word(11 downto 10);
    MemtoReg  <= control_word(9);
    RegDst    <= control_word(8);
    LorD      <= control_word(7);
    PCSrc     <= control_word(6);
    ALUSrcA   <= control_word(5);
    IRWrite   <= control_word(4);
    MemWrite  <= control_word(3);
    PCWrite   <= control_word(2);
    Branch    <= control_word(1);
    RegWrite  <= control_word(0);

end architecture;
