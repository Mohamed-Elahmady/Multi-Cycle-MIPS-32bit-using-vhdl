library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

  signal A           : std_logic_vector(31 downto 0);
  signal B           : std_logic_vector(31 downto 0);
  signal ALU_Control : std_logic_vector(3 downto 0);
  signal ALU_Result  : std_logic_vector(31 downto 0);
  signal Zero        : std_logic;

begin

  uut: entity work.ALU
    port map (
      A           => A,
      B           => B,
      ALU_Control => ALU_Control,
      ALU_Result  => ALU_Result,
      Zero        => Zero
    );

  stimulus: process
  begin
    -- Test 1: ADD 
    A <= x"00000005"; 
    B <= x"00000005"; 
    ALU_Control <= "0010"; 
    wait for 10 ns; -- Expected output: 10 (A + B = 5 + 5)

    -- Test 2: SUB 
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Control <= "0110";
    wait for 10 ns; -- Expected output: 7 

    -- Test 3: AND 
    A <= x"0000FFFF"; 
    B <= x"FFFF0000"; 
    ALU_Control <= "0000";
    wait for 10 ns; -- Expected output: 00000001

    -- Test 4: OR 
    A <= x"00000006"; 
    B <= x"00000003"; 
    ALU_Control <= "0001"; 
    wait for 10 ns; -- Expected output: 00000007 

    -- Test 5: NOR 
    A <= x"0000000A"; 
    B <= x"00000003"; 
    ALU_Control <= "1100"; 
    wait for 10 ns; -- Expected output: FFFFFFF4 

    -- Test 6: XOR 
    A <= x"00000005"; 
    B <= x"00000005"; 
    ALU_Control <= "0011"; 
    wait for 10 ns; -- Expected output: 00000000 

    -- End of test cases
    wait;
  end process;

end Behavioral;
