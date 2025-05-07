library ieee;
use ieee.std_logic_1164.all;

entity Sign_Extend is
  port (
    input_16  : in  std_logic_vector(15 downto 0);
    output_32 : out std_logic_vector(31 downto 0)
  );
end Sign_Extend;

architecture Behavioral of Sign_Extend is
begin
  process(input_16)
  begin
    if input_16(15) = '1' then
      output_32 <= (15 downto 0 => '1') & input_16;  
    else
      output_32 <= (15 downto 0 => '0') & input_16;  
    end if;
  end process;
end Behavioral;
