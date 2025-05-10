library ieee;
use ieee.std_logic_1164.all;

entity MUX4to1_TB is
end MUX4to1_TB;

architecture test of MUX4to1_TB is

  -- Signals
  signal input0, input1, input2, input3 : std_logic_vector(31 downto 0);
  signal sel : std_logic_vector(2 downto 0);
  signal output : std_logic_vector(31 downto 0);

begin

  -- Direct instantiation without component declaration
  mux_inst : entity work.MUX4to1_Generic
    generic map (WIDTH => 32)
    port map (
      input0 => input0,
      input1 => input1,
      input2 => input2,
      input3 => input3,
      sel    => sel,
      output => output
    );

  -- Stimulus process
  stim_proc : process
  begin
    input0 <= x"00000001";
    input1 <= x"00000002";
    input2 <= x"00000003";
    input3 <= x"00000004";

    sel <= "000";
    wait for 10 ns;

    sel <= "001";
    wait for 10 ns;

    sel <= "010";
    wait for 10 ns;

    sel <= "011";
    wait for 10 ns;

    sel <= "100";  -- invalid
    wait for 10 ns;

    wait;
  end process;

end architecture;
