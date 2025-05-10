library ieee;
use ieee.std_logic_1164.all;

entity Shift_Left_2 is	 
	
  port (
    input_data  : in  std_logic_vector(31 downto 0);
    output_data : out std_logic_vector(31 downto 0)
  );
end Shift_Left_2;

architecture Behavioral of Shift_Left_2 is
begin
  output_data <= input_data(29 downto 0) & "00";	  
end Behavioral;												
