library ieee;		
use ieee.std_logic_1164.all;

entity OR_Gate is
	port (
	A,B: in std_logic;
	C  : out std_logic
		);
end entity;

architecture behaviour of OR_Gate is
begin
	C <= A or B;
end architecture;
