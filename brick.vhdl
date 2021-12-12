library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity brick is
    port(
      clk : in std_logic;

      row : in unsigned(9 downto 0);
      col : in unsigned(9 downto 0);

      display : out std_logic
    );
end brick;

architecture synth of brick is
  signal bricks : std_logic_vector(59 downto 0) :=  
                                            "1110101010" &
                                            "1010101010" &
                                            "1010101010" &
                                            "1010101010" &
                                            "1010101010" &
                                            "1010101010"; 
begin

--Only displays last brick due to how for loops work in vhdl
process (clk) begin

	if rising_edge(clk) then
		display <= bricks(59 - (to_integer(row(9 downto 5)) * 10 + to_integer(col(9 downto 6))));
	end if;

end process;

end;
