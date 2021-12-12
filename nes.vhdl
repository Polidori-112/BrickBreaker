library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nes is
port(
data : in std_logic;
latch : out std_logic := '0';
clock : out std_logic;
left : out std_logic;
right : out std_logic;
start : out std_logic
);
end nes;

architecture synth of nes is

component SB_HFOSC is
generic (
CLKHF_DIV : String := "0b00"
);
port(
CLKHFPU : in std_logic := 'X';
CLKHFEN : in std_logic := 'X';
CLKHF : out std_logic := 'X'
);
end component;

signal my_out : std_logic;
signal ccount : unsigned (20 downto 0) := "000000000000000000000";
signal NESClk : std_logic;
signal NESCount : unsigned(11 downto 0);
signal shift : std_logic_vector(7 downto 0) := "00000000";
signal store : std_logic_vector(7 downto 0) := "00000000";

begin

osc : SB_HFOSC port map('1', '1', my_out);

process (my_out) begin
if rising_edge(my_out) then
ccount <= ccount + 1;
end if;
end process;

NESClk <= ccount(8);
NESCount <= ccount(20 downto 9);


latch <= '1' when (NESCount = "11111111111") else '0';
clock <= NESClk when (NESCount  < 8d"8") else '0';

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



end;

