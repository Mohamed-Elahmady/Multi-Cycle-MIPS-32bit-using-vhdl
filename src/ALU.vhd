library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port 
  (
    A           : in  std_logic_vector(31 downto 0);
    B           : in  std_logic_vector(31 downto 0);
    ALU_Control : in  std_logic_vector(3 downto 0);
    ALU_Result  : out std_logic_vector(31 downto 0);
    Zero        : out std_logic
  );
end ALU;

architecture Behavioral of ALU is

signal Result : std_logic_vector(31 downto 0);	

begin
  process (A, B, ALU_Control)
  begin
    case ALU_Control is
      when "0010" => 
	       Result <= std_logic_vector(unsigned(A) + unsigned(B)); -- ADD
      when "0110" => 
	       Result <= std_logic_vector(unsigned(A) - unsigned(B)); -- SUB
      when "0000" => 
	       Result <= A and B;                                     -- AND
      when "0001" => 
	       Result <= A or B;                                      -- OR
      when "1100" => 
	       Result <= not (A or B);                                -- NOR
      when "0011" =>
	       Result <= A xor B;                                     -- XOR
      when others => 
	       Result <= (others => '0');
    end case;
  end process;

  ALU_Result <= Result;
  
  Zero <= '1' 
  when Result = x"00000000" else '0';
	
end Behavioral;
