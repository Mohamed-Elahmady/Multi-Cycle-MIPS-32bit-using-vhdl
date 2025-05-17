library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Connection_Path is 
	port (	
		clk ,rst :in  std_logic
	);
end entity;

architecture connection of Connection_Path is 	 

 	signal Op, Funct:  std_logic_vector(5 downto 0);	 
  	signal ALUOp, ALUSrcB:  std_logic_vector(1 downto 0);
    signal MemtoReg, RegDst, LorD, ALUSrcA:  std_logic;
    signal IRWrite, MemWrite, PCWrite,MemRead,PCWriteCond, RegWrite: std_logic;   
	
	signal MemAddress : std_logic_vector(31 downto 0);	  
	signal MemReaddata:  std_logic_vector(31 downto 0);  --memory 
	signal Read_Data1,Read_Data2,A_Out,B_Out : std_logic_vector(31 downto 0);	
	signal data_out : std_logic_vector(31 downto 0);	 --MDR
	signal ALU_Result  : std_logic_vector(31 downto 0);
    signal Zero : std_logic;   	
	signal CurrentPC ,mux3_1topc  :  STD_LOGIC_VECTOR(31 downto 0);	
	signal ALU_OUT  :  STD_LOGIC_VECTOR(31 downto 0);	--ALU OUT	
	
	
	signal  or_to_pc, and_to_or_to_pc: std_logic;	
	signal  input_data ,output_data : std_logic_vector (31 downto 0);  --shifht left IR
	signal  output_data_Mux : std_logic_vector (27 downto 0);  --shifht left PC  
	signal  input_mux_2 : std_logic_vector (31 downto 0);  
	
	signal Mux_A_out , Mux_B_out :std_logic_vector(31 downto 0);
	
	
	------------------check pcsrc from control unit
   	signal PCSrc:  std_logic_vector(1 downto 0);

	--register
	signal write_Data:  std_logic_vector(31 downto 0);	 
     signal Write_Register: std_logic_vector(4 downto 0);	
	--Ir signals 
	signal 	RS   		             : std_logic_vector(4 downto 0);  -- RS
	signal 	RT  		         : std_logic_vector(4 downto 0);  -- RT
	signal	RD	 : std_logic_vector(4 downto 0);  -- RD
	signal	shamt			 : std_logic_vector(4 downto 0);  -- shamt
	signal	immediate				 : std_logic_vector(15 downto 0);  -- immediate
	signal	Jump_Address			 : std_logic_vector(25 downto 0);   -- jump rate	 
	
	signal Alu_control_out : std_logic_vector(3 downto 0);
	
	constant FOUR : std_logic_vector(31 downto 0) := x"00000004";
	
begin  		 
	
	------------------------------------------------
	--1	  contol_unit
	contol_unit_instance: entity  control_unit 
		port map (		   
		CLK          => clk,
		Reset         => rst,
		Op           => Op,
		Funct        =>	Funct,
		ALUOp	     => ALUOp,
   		ALUSrcB	     => ALUSrcB,
		MemtoReg   	 => MemtoReg,
  		RegDst		 => RegDst,
   		LorD		 => LorD,
   		PCSrc 		 => PCSrc,
		ALUSrcA		 =>	ALUSrcA,
   		IRWrite 	 =>	IRWrite,
		MemWrite	 =>	MemWrite,
		PCWrite	     =>	PCWrite,
		RegWrite	 => RegWrite,  
		PCWriteCond  => PCWriteCond,
		MemRead      =>	MemRead
		);	 
		


	----------------------------------------------------------
	--2   Shift left MUX
	
	shift_left_PC_inst :    entity shift_left_2_PC   
		  port map(
            input_data => Jump_Address ,
            output_data =>output_data_Mux (27 downto 0)
           
  			);	
    ----------------------------------------------------------
		input_mux_2  <=  CurrentPC(31 downto 28) & output_data_Mux;	  
	-----------------------------------------------------------	
	--3	Input_Mux3_1_Pc
	   Input_Mux3_1_Pc : entity MUX3to1_Generic
		  generic map (
		  			   WIDTH => 32 
		  )
		  
          port map(
   					input0 => ALU_Result,
    				input1 => ALU_OUT, 
					input2 => input_mux_2 ,
    				sel    => PCSrc,                         
    				output => mux3_1topc
  			); 

	--------------------------------------------------------------	
		--4  and_to_pc
		and_topc : entity AND_Gate 
			port map(

			A => Zero, 
			B => PCWriteCond,
			C => and_to_or_to_pc
			
		);	
	------------------------------------------------------------	
		--5 or_to_pc
		or_topc : entity OR_Gate 
			port map(
			A => and_to_or_to_pc, 
			B => PCWrite,
			C => or_to_pc
		);		
	----------------------------------------------------------------	
	
	  	--6	  pc_instance
	   	pc_instance	: entity PC 
		port map (
		clk         => clk,
        rst         => rst,
       	PCWrite     => or_to_pc,
        ALUResult   => mux3_1topc,	
        CurrentPC   => CurrentPC
		
		);
		
	  ---------------------------------------------------------------
	  ---7 Alu out instance 
	  AL_out_instance : entity AluOut
		  		generic map(
							B => 32
						)
				port map(
							clk         => clk,
       						rst         => rst,
							en          => '1',
							ALU_IN      => ALU_Result,
							ALU_OUT     => ALU_OUT
					);
		
	---------------------------------------------------------------	
	--8  Memmory_address_Mux_instance
	  Memmory_address_Mux_instance: entity MUX2to1_Generic 
		  generic map (
		  			   WIDTH => 32 
		  )
		  
		  port map(
   					input0 => CurrentPC,
    				input1 => ALU_OUT, 
    				sel    => LorD,                         
    				output => MemAddress
  			);
		  
		-------------------------------------------------------------
		--9 Memory instance
		
		Memory_instance : entity Memory
				generic map(
						S => 1024,
						B => 32
						)
						
					port map (
						clk   	     =>	clk,
						MemRead		 =>	MemRead,
						MemWrite	 => MemWrite,
						Address      => MemAddress,
						Write_Data   => B_Out,
						Read_Data    => MemReaddata
						);
	
		 -------------------------------------------------------------
		--10  instruction register instance 
		--------------------------------------------------------------
		IR_instance : entity InstructionRegister	   
						generic map (
								W => 5,
								X => 16,
								Y => 26,
								B => 32
								)	
								
						port map(
								clk   			         => clk,
								IRWrite     		     =>	IRWrite,
								MemData     		     => MemReaddata,
								OpCode      		     => Op,	          --Bits 31-26: Opcode
								Register1   		     => RS,            -- RS 	Bits 25-21:
								Register2  		         => RT,           -- RT 	 Bits 20-16
								Destination_Register	 => RD,           -- RD	 Bits 15-11
								Function_Code			 => funct,	      -- funct	 Bits 05-00:
								Immediate				 => immediate,    -- immediate	15-00:
								Jump_Address			 => Jump_Address  -- jump rate	25-00:
		
								);	 
							
	  -------------------------------------------------------------
		--11  MDR 
		MDR_instance : entity MDR
			 		 generic map(
							B => 32
					)	
   					 Port map(
       					 clk     =>clk,
      				     rst     =>rst,
        				 load    =>'1',
       				     data_in =>MemReaddata,
        				 data_out=>data_out
   					 );
						
		-----------------------------------------------------------
		--12 Muxes between IR and Register
		
		IR_MUX_to_reg :	entity MUX2to1_Generic 	
			   generic map (
		  			   WIDTH => 5
		  )
		  
		  port map(
   					input0 => RT,
    				input1 => RD, 
    				sel    => RegDst,                         
    				output => Write_Register 
  			);
			  
			  ------------------------------------
		  			
		MDR_MUX_to_reg: entity MUX2to1_Generic 
		
		  generic map (
		  			   WIDTH => 32
		  )
		  
		  port map(
   					input0 => ALU_OUT,
    				input1 => data_out, 
    				sel    => MemtoReg,                         
    				output => write_Data 
  			);
		--------------------------------------------------------------
		--13 Register instance
		Register_instance :	entity RegisterFile 
		  generic map (
					W => 5,
					B => 32
		  )
		  
		  port map(
            clk => clk,
            rst => rst,
            Reg_Write => RegWrite,
            Read_Register1 => RS,
            Read_Register2 => RT,
            Write_Register => Write_Register,
            write_Data => write_Data,
            Read_Data1 => Read_Data1,
            Read_Data2 => Read_Data2
  			);	
			  
		--------------------------------------------------------------
		--14 Sign extend and Shifht left 
		sign_extend_inst :	entity Sign_Extend   
		  port map(
            input_16 => immediate,
            output_32 => input_data(31 downto 0)
           
  			);	
			  ----------------------------------
		shift_left_IR_inst :	entity Shift_Left_2   
		  port map(
            input_data => input_data (31 downto 0),
            output_data => output_data(31 downto 0)
           
  			);	
		----------------------------------------------------------------
		--15 A and B registers 
		
		Reg_A : entity Register_Generic	
				generic map (
       				  WIDTH => 32
   						 )
    			port map (
       					 clk    => clk,
        				 rst    => rst,
                         load   => '1',  
                         input  => Read_Data1,
                         output => A_Out
                           );
	
	
			Reg_B :	entity Register_Generic	 
				  generic map (
       				   WIDTH => 32
   						  )
   				  port map (
    				    clk    => clk,
         			    rst    => rst,
                        load   => '1',  
                        input  => Read_Data2,
                        output => B_Out
                          );
		
		----------------------------------------------------------------
		--16 Alu_ Muxes	  
		
			PC_Register_MUX_2_1_ALU: entity MUX2to1_Generic 
		  generic map (
		  			   WIDTH => 32 
		  )
		  
		  port map(
   					input0 => CurrentPC,
    				input1 => A_Out, 
    				sel    => ALUSrcA,                         
    				output => Mux_A_out 
  			);
		   ----------------------------------------------------
		   	IR_Register_MUX_4_1_ALU: entity MUX4to1_Generic 
		  generic map (
		  			   WIDTH => 32 
		  )
		  
		  port map(
   					input0 => B_Out,
    				input1 => FOUR ,
					input2 => input_data,
					input3 => output_data,
    				sel    => ALUSrcB,                         
    				output => Mux_B_out 
  			);
		
		----------------------------------------------------------------
		--17 Alu_ Control instance	
		
		Alu_control_instance : entity ALU_Control_Unit
			port map(
  				  ALU_Operation      => ALUOp , 
   				  Function_Code      => funct ,
   				  ALU_Control_Signal => Alu_control_out
  				);
		
		----------------------------------------------------------------
		--18 Alu instance
		
		Alu_instane : entity ALU
			  port map(
  				  A           => Mux_A_out,
    			  B           => Mux_B_out,
   				  ALU_Control => Alu_control_out,
    			  ALU_Result  => ALU_Result,
    			  Zero        => Zero
 				 );
		
	end architecture;