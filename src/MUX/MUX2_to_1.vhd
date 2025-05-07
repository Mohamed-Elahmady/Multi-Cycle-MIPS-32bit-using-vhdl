library ieee;
use ieee.std_logic_1164.all;

entity MUX2to1_Generic is
  generic (
    WIDTH : integer := 32  
  );
  port (
    input0 : in std_logic_vector(WIDTH-1 downto 0); 
    input1 : in std_logic_vector(WIDTH-1 downto 0); 
    sel    : in std_logic;                         
    output : out std_logic_vector(WIDTH-1 downto 0) 
  );
end MUX2to1_Generic;

architecture Behavioral of MUX2to1_Generic is
begin
  process (input0, input1, sel)
  begin
    if sel = '0' then
      output <= input0;
    else
      output <= input1;
    end if;
  end process;
end Behavioral;
