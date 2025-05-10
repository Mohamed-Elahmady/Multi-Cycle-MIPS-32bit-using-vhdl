library ieee;
use ieee.std_logic_1164.all;

entity mux3_tb is
end mux3_tb;

architecture test of mux3_tb is

  -- Signals
  signal input0  : std_logic_vector(31 downto 0) := x"00000001";
  signal input1  : std_logic_vector(31 downto 0) := x"00000002";
  signal input2  : std_logic_vector(31 downto 0) := x"00000003";
  signal sel     : std_logic_vector(1 downto 0) := "00";
  signal output  : std_logic_vector(31 downto 0);

begin

  -- DUT
  mux3: entity work.MUX3to1_Generic
    generic map(WIDTH => 32)
    port map (
      input0 => input0,
      input1 => input1,
      input2 => input2,
      sel    => sel,
      output => output
    );

  -- Stimulus
  process
  begin
    sel <= "00"; wait for 100 ns;  -- ??????? output = input0
    sel <= "01"; wait for 100 ns;  -- ??????? output = input1
    sel <= "10"; wait for 100 ns;  -- ??????? output = input2
    wait;
  end process;

end architecture;