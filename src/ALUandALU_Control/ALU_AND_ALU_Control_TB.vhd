library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_AND_ALU_Control_TB is
end ALU_AND_ALU_Control_TB;

architecture Behavioral of ALU_AND_ALU_Control_TB is

  
  signal A           : std_logic_vector(31 downto 0);
  signal B           : std_logic_vector(31 downto 0);
  signal ALU_Op      : std_logic_vector(1 downto 0); -- ALUOp signal from Control Unit
  signal Funct_Code  : std_logic_vector(5 downto 0); -- Function code for R-type instructions
  signal ALU_Control : std_logic_vector(3 downto 0); -- Output control signal for ALU
  signal ALU_Result  : std_logic_vector(31 downto 0); -- Result from ALU
  signal Zero        : std_logic; -- Zero flag output
  
begin

 
  uut_control: entity work.ALU_Control_Unit
    port map (
      ALU_Operation  => ALU_Op,
      Function_Code  => Funct_Code,
      ALU_Control_Signal => ALU_Control
    );

  
  uut_alu: entity work.ALU
    port map (
      A           => A,
      B           => B,
      ALU_Control => ALU_Control,
      ALU_Result  => ALU_Result,
      Zero        => Zero
    );

  stimulus: process
  begin
    -- Test 1: ADD (ALU_Op = "10")
    A <= x"00000005"; 
    B <= x"00000005"; 
    ALU_Op <= "10"; -- ALUOp for ADD
    Funct_Code <= "100000"; -- ADD funct
    wait for 10 ns; -- Expected output: 10 (A + B = 5 + 5)

    -- Test 2: SUB (ALU_Op = "10")
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Op <= "10";
    Funct_Code <= "100010"; -- SUB funct
    wait for 10 ns; -- Expected output: 7 (A - B = 10 - 3)

    -- Test 3: AND (ALU_Op = "10")
    A <= x"0000FFFF"; 
    B <= x"FFFF0000"; 
    ALU_Op <= "10";
    Funct_Code <= "100100"; -- AND funct
    wait for 10 ns; -- Expected output: 00000001 (Bitwise AND)

    -- Test 4: OR (ALU_Op = "10")
    A <= x"00000006"; 
    B <= x"00000003"; 
    ALU_Op <= "10";
    Funct_Code <= "100101"; -- OR funct
    wait for 10 ns; -- Expected output: 00000007 (Bitwise OR)

    -- Test 5: NOR (ALU_Op = "10")
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Op <= "10";
    Funct_Code <= "100111"; -- NOR funct
    wait for 10 ns; -- Expected output: FFFFFFF4 (Bitwise NOR)

    -- Test 6: XOR (ALU_Op = "10")
    A <= x"00000005"; 
    B <= x"00000005"; 
    ALU_Op <= "10";
    Funct_Code <= "100110"; -- XOR funct
    wait for 10 ns; -- Expected output: 00000000 (Bitwise XOR)

    -- Test 7: ADD (ALU_Op = "00")
    A <= x"00000005"; 
    B <= x"00000005"; 
    ALU_Op <= "00"; -- ALUOp for ADD
    Funct_Code <= "000000"; -- ADD funct
    wait for 10 ns; -- Expected output: 10 (A + B = 5 + 5)

    -- Test 8: ADD (ALU_Op = "00")
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Op <= "00";
    Funct_Code <= "000000"; -- ADD funct
    wait for 10 ns; -- Expected output: 13 (A + B = 10 + 3)

    -- Test 9: SUB (ALU_Op = "01")
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Op <= "01"; -- ALUOp for SUB
    Funct_Code <= "000000"; -- SUB funct
    wait for 10 ns; -- Expected output: 7 (A - B = 10 - 3)

    -- Test 10: SUB (ALU_Op = "01")
    A <= x"00000015"; 
    B <= x"00000005"; 
    ALU_Op <= "01"; -- ALUOp for SUB
    Funct_Code <= "000000"; -- SUB funct
    wait for 10 ns; -- Expected output: 16 (A - B = 21 - 5)

    -- Test 11: No Operation (ALU_Op = "11")
    A <= x"00000001"; 
    B <= x"00000001"; 
    ALU_Op <= "11"; -- NOP operation (No ALU operation)
    Funct_Code <= "000000"; -- No funct code
    wait for 10 ns; -- Expected output: 00000000 (No Operation)

    -- End of test cases
    wait;
  end process;

end Behavioral;
