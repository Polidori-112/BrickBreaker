
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity paddle is
    port(
      left : in std_logic;
      right : in std_logic;
      clk : in std_logic;
      vga_row : in unsigned(9 downto 0);
      vga_col : in unsigned(9 downto 0);


      display : out std_logic
      );
end paddle;



architecture synth of paddle is

  signal paddlex : unsigned(9 downto 0) := "0101000000";


begin

  process (clk) begin
    if (rising_edge(clk)) then
      --display paddle
      if (vga_row > (paddlex - 50) and (vga_row < paddlex + 50)
      and (vga_col > 440) and (vga_col < 455)) then
        display <= '1';
      else
        display <= '0';
      end if;

      if (vga_row = 524 and vga_col = 0) then
        --move paddle
        if (left = '0' and right = '0') then
          paddlex <= paddlex;
        elsif (left = '0' and paddlex > 50) then
          paddlex <= paddlex - 2;
        elsif (right = '0' and paddlex < 590) then
          paddlex <= paddlex + 2;
        else
          paddlex <= paddlex;
        end if;

      end if;

    end if;
  end process;

end;
