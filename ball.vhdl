library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ball is
    port(
        start : in std_logic; -- signals start of game
        clk : in std_logic;
        -- vga_row : in unsigned(9 downto 0); -- current row of pixels
        -- vga_col : in unsigned(9 downto 0); -- current col of pixels
        lives : out unsigned(1 downto 0) := "00";
        changeX : in std_logic;
        changeY : in std_logic;
        next_velocity : in unsigned(2 downto 0);
        reset : in std_logic;
        vga_row : in unsigned(9 downto 0); -- current row of pixels
        vga_col : in unsigned(9 downto 0); -- current col of pixels
        display : out std_logic -- 1 if ball displayed, otherwise 0
    );
end ball;

architecture synth of ball is

  signal dirx : std_logic := '1';
  signal diry : std_logic := '1';
  signal ballx : unsigned(9 downto 0) := "0100100000"; -- current x pos of ball "0101000000" was og
  signal bally : unsigned(9 downto 0) := "0110010000";-- current y pos of ball

  signal velocity : unsigned(2 downto 0) := "010";

  signal invertx : std_logic := '0';
  signal inverty : std_logic := '0';

  signal nextLife : unsigned(1 downto 0) := "10";

  signal play : std_logic := '0';
  signal temp : std_logic := '0';
  signal temp2 : std_logic := '0';
  signal die : std_logic := '0';


begin

    process (clk) begin
        if rising_edge(clk) then

            --this means the start/end screen is displaying
            --when the start or end screen is displaying, if it gets start
            --set all these things
            if ((lives = "00") and (start = '0')) then
                lives <= "11";
                ballx <= "0100010000";
                bally <= "0110010000";
                play <= '0';
            --if we have lives play the game
          elsif ((lives /= "00") and play = '1') then
              --draws ball
                if (vga_row > (ballx - 5) and vga_row < (ballx + 5)
                and vga_col > (bally - 5) and vga_col < (bally + 5)) then
                    display <= '1';
                else
                    display <= '0';
                end if;
                if (vga_row = 481 and vga_col = 0) then

                --inverts ball direction
                if ((ballx <= 5) or (ballx >= 634) or (changeX = '1') or ((dirx = '0') and (start = '0'))) then
                    invertx <= '1';
                else
                    invertx <= '0';
                end if;

                if ((bally <= 5) or (changeY = '1') or ((diry = '0') and (start = '0'))) then
                    inverty <= '1';
                else
                    inverty <= '0';
                end if;

                if (bally >= 475) then
                    -- lives <= nextLife;
                    play <= '0';
                    lives <= lives - '1';
                    die <= '1';
                else
                    die <= '0';
                end if;


                --moves ball
                if (dirx = '1') then
                    ballx <= ballx + velocity;
                else
                    ballx <= ballx - velocity;
                end if;

                if (diry = '1' and velocity /= "000") then
                    bally <= bally + 2;
                elsif (diry = '0' and velocity /= "000") then
                    bally <= bally - 2;
                else
                    bally <= bally;
                end if;
              end if;

              if temp2 = '1' and bally /= "0110010000" then
                -- play <= '0';
                -- if lives /= "11" then
                --   lives <= lives + 1;
                -- end if;
              end if;

            elsif (play = '0') then

               velocity <= "000";
               ballx <= "0100010000";
               bally <= "0110010000";
               die <= '0';

               if (start = '0' and temp = '1') then
                 velocity <= "010";
                 play <= '1';
               end if;

               if (vga_row > (ballx - 5) and vga_row < (ballx + 5)
               and vga_col > (bally - 5) and vga_col < (bally + 5)) then
                   display <= '1';
               else
                   display <= '0';
               end if;

         end if;
        end if;
    end process;

    --inverts x and y direction
    --must use rising edge function here
    process(invertx, inverty, start, play, die, reset, bally) begin
      if (rising_edge(invertx)) then
        dirx <= not dirx;
      end if;

      if (rising_edge(inverty)) then
        diry <= not diry;
      end if;

      if (rising_edge(start)) then
        temp <= '1';
      end if;

      if rising_edge(reset) then
        temp2 <= '1';
      end if;

      if die then
        temp <= '0';
        dirx <= '1';
      end if;

      -- if bally /= "0110010000" then
      --   temp2 <= '1';
      -- end if;

    end process;

end;
