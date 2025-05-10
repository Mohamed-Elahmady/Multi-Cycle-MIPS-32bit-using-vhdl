library ieee;
use ieee.std_logic_1164.all;

entity mux2_tb is
end;

architecture tb of mux2_tb is
  signal input0 : std_logic_vector(31 downto 0) := (others => '0');
  signal input1 : std_logic_vector(31 downto 0) := (others => '0');
  signal sel    : std_logic := '0';
  signal output : std_logic_vector(31 downto 0);
begin

  DUT: entity work.MUX2to1_Generic
    port map (
      input0 => input0,
      input1 => input1,
      sel    => sel,
      output => output
    );

  process
  begin
    input0 <= x"AAAAAAAA";
    input1 <= x"55555555";

    sel <= '0';
    wait for 10 ns;

    sel <= '1';
    wait for 10 ns;

    sel <= '0';
    wait for 10 ns;

    wait;
  end process;

end architecture;