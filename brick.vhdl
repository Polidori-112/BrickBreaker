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
  signal bricks : unsigned(59 downto 0) := "0000111010" &
                                            "0000000001" &
                                            "0000000001" &
                                            "0000000001" &
                                            "0000000011" &
                                            "0001111001";
begin

--Only displays last brick due to how for loops work in vhdl
process (clk) begin
  if rising_edge(clk) then
  --for j in 0 to 5 loop
    for i in 0 to 9 loop
        if (bricks(i) = '1') then
          if (row > (5 + (i * 45)) and row < (45 + (i * 45))
          and col > (5) and col < (25)) then
            display <= '1';
          else
            display <= '0';
          end if;
        end if;
    end loop;
  --end loop;
end if;
end process;

end;
