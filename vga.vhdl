library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
    port(
      clk_in1 : in std_logic;
      clk_out1 : out std_logic;
      clk_locked1 : out std_logic;
      HSYNC : out std_logic;
      VSYNC : out std_logic;
      valid : out std_logic;
      r : out unsigned(9 downto 0);
      c : out unsigned(9 downto 0)
      );
end vga;



architecture synth of vga is

    component pll is
        port (
            clk_in : in std_logic;
            clk_out : out std_logic;
            clk_locked : out std_logic
            );
    end component;

    signal row : unsigned(9 downto 0) := "0000000000";
    signal column : unsigned(9 downto 0) := "0000000000";

begin

pll1 : pll port map (
  clk_in => clk_in1,
  clk_out => clk_out1,
  clk_locked => clk_locked1
  );

  r <= row;
  c <= column;

  process (clk_out1) begin
    if rising_edge(clk_out1) then
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
