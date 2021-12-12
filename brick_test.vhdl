library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brick_test is
end brick_test;

architecture test of brick_test is

component brick is
    port(
      clk : in std_logic;

      row : in unsigned(9 downto 0);
      col : in unsigned(9 downto 0);

      display : out std_logic
    );
end component;

signal clk : std_logic;

signal row : unsigned(9 downto 0);
signal col : unsigned(9 downto 0);

signal display : std_logic;

begin

    dut : brick port map (clk, row, col, display);
process begin
clk <= '0';
row <= 10d"1";
col <= 10d"1";
wait for 1 ns;
clk <= '1';
wait for 1 ns;
assert display = '1' report "failed test 1";
clk <= '0';
row <= 10d"1";
col <= 10d"65";
wait for 1 ns;
clk <= '1';
wait for 1 ns;
assert display = '1' report "failed test 2";
clk <= '0';
row <= 10d"1";
col <= 10d"129";
wait for 1 ns;
clk <= '1';
wait for 1 ns;
assert display = '1' report "failed test 3";
wait;
end process;
end;

