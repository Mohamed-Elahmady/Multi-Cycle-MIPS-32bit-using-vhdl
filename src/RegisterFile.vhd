library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity RegisterFile is
	generic(
		W: integer := 5;
		B: integer := 32
	);
	port(
		clk   			 :in  std_logic;
		rst				 :in  std_logic;
		Reg_Write        :in  std_logic;
		Read_Register1   :in  std_logic_vector(W-1 downto 0);
		Read_Register2   :in  std_logic_vector(W-1 downto 0);  
		Write_Register   :in  std_logic_vector(W-1 downto 0);
		write_Data       :in  std_logic_vector(B-1 downto 0);
		Read_Data1       :out std_logic_vector(B-1 downto 0);
		Read_Data2       :out std_logic_vector(B-1 downto 0)
	);
end entity;

architecture behaviour of RegisterFile is
type register_array is array (0 to 2**W -1) of std_logic_vector(B-1 downto 0);
signal registers: register_array := (others => (others => '0'));
begin	   
	Read_Data1 <= registers(to_integer(unsigned(Read_Register1)));
	Read_Data2 <= registers(to_integer(unsigned(Read_Register2)));
	
	process (clk,rst) is
	begin
		if(rising_edge(clk)) then	
			if (rst = '1') then
				registers <= (others => (others => '0'));
			elsif (Reg_Write = '1') then
				if(Write_Register /= "00000") then
					registers(to_integer(unsigned(Write_Register))) <= write_Data;
				end if;
			end if;			
		end if;
	end process;
		
end architecture;