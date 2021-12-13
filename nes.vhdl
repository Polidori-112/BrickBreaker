library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nes is
port(
clock_in : in std_logic;
data : in std_logic;
latch : out std_logic := 'X';
clock : out std_logic;
left : out std_logic;
right : out std_logic;
start : out std_logic
);
end nes;

architecture synth of nes is


signal ccount : unsigned (20 downto 0) := "000000000000000000000";
signal NESClk : std_logic;
signal NESCount : unsigned(15 downto 0);
signal shift : std_logic_vector(7 downto 0) := "00000000";
signal store : std_logic_vector(7 downto 0) := "00000000";

begin

process (clock_in) begin
if rising_edge(clock_in) then
ccount <= ccount + 1;
end if;
end process;

NESClk <= ccount(4);
NESCount <= ccount(20 downto 5);


latch <= '1' when (NESCount = 16d"65535") else '0';
clock <= NESClk when (NESCount < 8d"8") else '0';

process (clock) begin
if rising_edge(clock) then
shift(0) <= shift(1);
shift(1) <= shift(2);
shift(2) <= shift(3);
shift(3) <= shift(4);
shift(4) <= shift(5);
shift(5) <= shift(6);
shift(6) <= shift(7);
shift(7) <= data;
end if;
end process;

process (latch) begin 
	if rising_edge(latch) then
		start <= not shift(3);
		left <= not shift(7);
		right <= not shift(6);
	end if;

end process;

end;

