library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Memory is
	generic(
		S: integer := 1024;
		B: integer := 32
	);
	port(
		clk   			 :in  std_logic;	
		MemRead			 :in  std_logic;
		MemWrite		 :in  std_logic;
		Address          :in  std_logic_vector(B-1 downto 0);
		Write_Data       :in std_logic_vector(B-1 downto 0);
		Read_Data        :out std_logic_vector(B-1 downto 0)
	);
end entity;

architecture behaviour of Memory is
type memory_array is array (0 to S-1) of std_logic_vector(B-1 downto 0);
signal RAM: memory_array := (others => (others => '0'));
begin	   
	
	
	process (clk) is
	variable addr_index: integer range 0 to S-1;
	begin
		if(rising_edge(clk)) then	
			addr_index := to_integer(unsigned(Address(11 downto 2)));
			if (MemWrite = '1') then
				RAM(addr_index) <= Write_Data;
			end if;
		end if;
	end process;
	
	process (MemRead, Address) is
	variable addr_index: integer range 0 to S-1;
	begin  
	if ( MemRead = '1' ) then
		addr_index := to_integer(unsigned(Address(11 downto 2)));
		Read_Data <= RAM(addr_index);
	else
		Read_Data <= (others => 'Z');
	end if;		
		
	end process;
	
		
end architecture;