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
		clk   			: in  std_logic;	
		MemRead			: in  std_logic;
		MemWrite		: in  std_logic;
		Address         : in  std_logic_vector(B-1 downto 0);
		Write_Data      : in  std_logic_vector(B-1 downto 0);
		Read_Data       : out std_logic_vector(B-1 downto 0)
	);
end entity;

architecture behaviour of Memory is
	type memory_array is array (0 to S-1) of std_logic_vector(B-1 downto 0);

	-- Initialized Instructions (MIPS-style opcodes for simulation)
	signal RAM: memory_array := (
		0 => x"20080004",  -- addi $t0, $zero, 4   (t0 = 4)
		1 => x"20090008",  -- addi $t1, $zero, 8   (t1 = 8)
		2 => x"01095020",  -- add  $t2, $t0, $t1   (t2 = t0 + t1 = 12)
		3 => x"AC0A0000",  -- sw   $t2, 0($zero)   (store t2 at address 0)
		4 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3) 
		5 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3)
		6 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3) 
		7 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3)
		8 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3)
		9 => x"8C0B0000",  -- lw   $t3, 0($zero)   (load from address 0 into t3) 
		others => (others => '0')  -- rest is zeroed
	);
begin	   
	--Write operation (only on clock edge)
	process (clk)
		variable addr_index: integer range 0 to S-1;
	begin
		if rising_edge(clk) then
			addr_index := to_integer(unsigned(Address(11 downto 2)));
			if MemWrite = '1' then
				RAM(addr_index) <= Write_Data;
			end if;
		end if;
	end process;

	-- Read operation (combinational)
	process (MemRead, Address)
		variable addr_index: integer range 0 to S-1;
	begin  
		if MemRead = '1' then
			addr_index := to_integer(unsigned(Address(11 downto 2)));
			Read_Data <= RAM(addr_index);
		elsif MemWrite = '1' then
			addr_index := to_integer(unsigned(Address(11 downto 2)));
			RAM(addr_index) <= Write_Data;
		end if;
	end process;
end architecture;
