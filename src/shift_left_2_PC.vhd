library ieee;
use ieee.std_logic_1164.all;

entity shift_left_2_PC is	 
	
  port (
    input_data  : in  std_logic_vector(25 downto 0);
    output_data : out std_logic_vector(27 downto 0)
  );
end entity;

architecture Behavioral of shift_left_2_PC is
begin
  output_data <= input_data(25 downto 0) & "00";
end Behavioral;
