library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Control_Unit is
  port (
    ALU_Operation     : in  std_logic_vector(1 downto 0); 
    Function_Code     : in  std_logic_vector(5 downto 0); 
    ALU_Control_Signal: out std_logic_vector(3 downto 0) 
  );
end ALU_Control_Unit;

architecture Behavioral of ALU_Control_Unit is
begin
  process(ALU_Operation, Function_Code)
  begin
    case ALU_Operation is
      when "00" =>
        -- LW, SW => ADD
        ALU_Control_Signal <= "0010";
      when "01" =>
        -- BEQ => SUB
        ALU_Control_Signal <= "0110";
      when "10" =>
        -- R-type => decode from funct
           case Function_Code is
             when "100000" => 
			    ALU_Control_Signal <= "0010"; -- ADD
             when "100010" => 
			    ALU_Control_Signal <= "0110"; -- SUB
             when "100100" => 
			    ALU_Control_Signal <= "0000"; -- AND
             when "100101" => 
			    ALU_Control_Signal <= "0001"; -- OR
             when "100111" => 
			    ALU_Control_Signal <= "1100"; -- NOR
             when "100110" => 
			    ALU_Control_Signal <= "0011"; -- XOR
             when others   => 
			    ALU_Control_Signal <= "1111"; -- undefined
           end case;
      when others =>
        ALU_Control_Signal <= "1111";
    end case;
  end process;
end Behavioral;
