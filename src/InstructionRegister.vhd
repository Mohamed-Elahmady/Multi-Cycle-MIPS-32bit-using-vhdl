library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity InstructionRegister is
	generic(
		W: integer := 5;
		X: integer := 16;
		Y: integer := 26;
		B: integer := 32
	);
	port(
		clk   					 :in  std_logic;
		IRWrite     		     :in  std_logic;
		MemData     		     :in std_logic_vector(B-1 downto 0);
		OpCode      		     :out std_logic_vector(W downto 0);
		Register1   		     :out std_logic_vector(W-1 downto 0);  -- RS
		Register2  		         :out std_logic_vector(W-1 downto 0);  -- RT
		Destination_Register	 :out std_logic_vector(W-1 downto 0);  -- RD
		Shift_Amount			 :out std_logic_vector(W-1 downto 0);  -- shamt
		Function_Code			 :out std_logic_vector(W downto 0);	   -- funct
		Immediate				 :out std_logic_vector(X-1 downto 0);  -- immediate
		Jump_Address			 :out std_logic_vector(Y-1 downto 0)   -- jump rate
		
	);
end entity;

architecture behaviour of InstructionRegister is
signal instruction: std_logic_vector(B-1 downto 0);
begin	   
	
	process (clk) is
	begin
		if(rising_edge(clk)) then	
			if (IRWrite = '1') then
				instruction <= 	MemData;
			end if;			
		end if;
	end process;
	
	 -- Split the instruction into its fields (combinational logic)
	OpCode 					<= instruction(B-1 downto Y);    -- Bits 31-26: Opcode
	Register1   			<= instruction(Y-1 downto Y-5);	 -- Bits 25-21: RS
	Register2   			<= instruction(Y-6 downto Y-10); -- Bits 20-16: RT
	Destination_Register	<= instruction(X-1 downto X-5);	 -- Bits 15-11: RD
	Shift_Amount			<= instruction(X-6 downto X-10); -- Bits 10-06: shamt
	Function_Code 			<= instruction(W downto 0);		 -- Bits 05-00: funct
	Immediate 				<= instruction(X-1 downto 0);	 -- Bits 15-00: immediate
	Jump_Address 			<= instruction(Y-1 downto 0);	 -- Bits 25-00: jump rate
	
		
end architecture;