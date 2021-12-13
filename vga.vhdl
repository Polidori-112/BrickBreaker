library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
    port(
      clk_in : in std_logic;
      HSYNC : out std_logic;
      VSYNC : out std_logic;
      valid : out std_logic;
      r : out unsigned(9 downto 0);
      c : out unsigned(9 downto 0)
      );
end vga;



architecture synth of vga is


    signal row : unsigned(9 downto 0) := "0000000000";
    signal column : unsigned(9 downto 0) := "0000000000";

begin


  r <= row;
  c <= column;

  process (clk_in) begin
    if rising_edge(clk_in) then
      if (row < 640 and column < 480) then
        valid <= '1';
      else
        valid <= '0';
      end if;

      if (row <= 799) then
        row <= row + 1;

        if (row > 659 and row < 756) then
          HSYNC <= '0';
        else
          HSYNC <= '1';
        end if;

        if (row = 799) then
          row <= "0000000000";

          if (column <= 524) then
            column <= column + 1;

            if (column >= 491 and column < 493) then
              VSYNC <= '0';
            else
              VSYNC <= '1';
            end if;

            if (column = 524) then
                column <= "0000000000";
            end if;

          end if;

        end if;

      end if;

    end if;

  end process;

end;
