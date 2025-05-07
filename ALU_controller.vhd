library ieee;
use ieee.std_logic_1164.all;

entity alu_controller is 
   port (
   ALUOp:in std_logic_vector(1 downto 0);
   Funct:in std_logic_vector(5 downto 0);
   ALUControl:out std_logic_vector(2 downto 0)
   );	
end entity;	

architecture rtl of alu_controller is
begin	
	 
  ALUControl <= "010" when ALUOp = "00" else  -- lw/sw: ADD
                "110" when ALUOp = "01" else  -- beq: SUB
                "010" when ALUOp = "10" and Funct = "100000" else -- R-type ADD
                "110" when ALUOp = "10" and Funct = "100010" else -- R-type SUB
                "000" when ALUOp = "10" and Funct = "100100" else -- R-type AND
                "001" when ALUOp = "10" and Funct = "100101" else -- R-type OR
                "111" when ALUOp = "10" and Funct = "101010" else -- R-type SLT
                "XXX";  -- unknown / unsupported   (when 11 it is not applicable)

				    
end architecture;

