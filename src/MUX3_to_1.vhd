library ieee;
use ieee.std_logic_1164.all;

entity MUX3to1_Generic is
  generic (
    WIDTH : integer := 32 
  );
  port (
    input0 : in std_logic_vector(WIDTH-1 downto 0); 
    input1 : in std_logic_vector(WIDTH-1 downto 0); 
    input2 : in std_logic_vector(WIDTH-1 downto 0); 
    sel    : in std_logic_vector(1 downto 0);  
    output : out std_logic_vector(WIDTH-1 downto 0)  
  );
end MUX3to1_Generic;

architecture Behavioral of MUX3to1_Generic is
begin
  process (input0, input1, input2, sel)
  begin
    case sel is
      when "00" =>
        output <= input0;  
      when "01" =>
        output <= input1; 
      when "10" =>
        output <= input2;  
      when others =>
        output <= (others => '0'); 
    end case;
  end process;
end Behavioral;
