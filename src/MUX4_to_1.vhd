library ieee;
use ieee.std_logic_1164.all;

entity MUX4to1_Generic is
  generic (
    WIDTH : integer := 32  
  );
  port (
    input0 : in std_logic_vector(WIDTH-1 downto 0); 
    input1 : in std_logic_vector(WIDTH-1 downto 0); 
    input2 : in std_logic_vector(WIDTH-1 downto 0);
    input3 : in std_logic_vector(WIDTH-1 downto 0); 
    sel    : in std_logic_vector(2 downto 0);  
    output : out std_logic_vector(WIDTH-1 downto 0)  
  );
end MUX4to1_Generic;

architecture Behavioral of MUX4to1_Generic is
begin
  process (input0, input1, input2, input3, sel)
  begin
    case sel is
      when "000" =>
        output <= input0;  
      when "001" =>
        output <= input1; 
      when "010" =>
        output <= input2;  
      when "011" =>
        output <= input3;
      when others =>
        output <= (others => '0'); 
    end case;
  end process;
end Behavioral;
