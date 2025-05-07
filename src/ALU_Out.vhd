library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity AluOut is
	generic(
		B: integer := 32
	);
	port(
		clk   			 :in  std_logic;
		rst				 :in  std_logic;
		en               :in  std_logic;
		ALU_IN           :in  std_logic_vector(B-1 downto 0);
		ALU_OUT          :out std_logic_vector(B-1 downto 0)
	);
end entity;

architecture behaviour of AluOut is
signal reg: std_logic_vector(B-1 downto 0);
begin	   
	
	process (clk,rst) is
	begin
		if(rising_edge(clk)) then	
			if (rst = '1') then
				reg <= (others => '0');
			elsif (en = '1') then
				reg <= ALU_IN;
			end if;			
		end if;
	end process;
	ALU_OUT <= reg;
		
end architecture;