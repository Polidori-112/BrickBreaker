library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ball is
    port(
        start : in std_logic; -- signals start of game
        clk : in std_logic;
        -- vga_row : in unsigned(9 downto 0); -- current row of pixels
        -- vga_col : in unsigned(9 downto 0); -- current col of pixels
        lives : out unsigned(1 downto 0) := "11";
        changeX : in std_logic;
        changeY : in std_logic;
        next_velocity : in unsigned(2 downto 0);
        vga_row : in unsigned(9 downto 0); -- current row of pixels
        vga_col : in unsigned(9 downto 0); -- current col of pixels
        display : out std_logic -- 1 if ball displayed, otherwise 0
    );
end ball;

architecture synth of ball is

  signal dirx : std_logic := '1';
  signal diry : std_logic := '1';
  signal ballx : unsigned(9 downto 0) := "0101000000"; -- current x pos of ball
  signal bally : unsigned(9 downto 0) := "0011110000";-- current y pos of ball

  signal velocity : unsigned(2 downto 0) := "010";

  signal invertx : std_logic := '0';
  signal inverty : std_logic := '0';
  
  signal nextLife : unsigned(1 downto 0) := "10";

begin

    process (clk) begin
        if rising_edge(clk) then
        
            --this means the start/end screen is displaying
            --when the start or end screen is displaying, if it gets start
            --set all these things
            if ((lives = "00") and (start = '0')) then
                lives <= "11";
                ballx <= "0101000000";
                bally <= "0011110000";
            --if we have lives play the game
            elsif ((lives /= "00")) then
              --draws ball
                if (vga_row > (ballx - 5) and vga_row < (ballx + 5)
                and vga_col > (bally - 5) and vga_col < (bally + 5)) then
                    display <= '1';
                else
                    display <= '0';
                end if;
                if (vga_row = 481 and vga_col = 0) then

                --inverts ball direction
                if ((ballx <= 5) or (ballx >= 634) or changeX = '1') then
                    invertx <= '1';
                else
                    invertx <= '0';
                end if;

                if ((bally <= 10) or changeY = '1') then
                    inverty <= '1';
                else
                    inverty <= '0';
                end if;
                
                if (bally >= 475) then
                    lives <= nextLife;
                    inverty <=  '1';
                else
                    nextLife <= lives - 1;
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

             else

               velocity <= "010";
               ballx <= "0101000000";
               bally <= "0011110000";
               if (not start) then
                 velocity <= "010";
               end if;

         end if;
        end if;
    end process;

    --inverts x and y direction
    --must use rising edge function here
    process(changeX, invertx, changeY, inverty) begin
      if (rising_edge(invertx)) then
        dirx <= not dirx;
        --changeX <= '0';
      end if;

      if (rising_edge(inverty)) then
        diry <= not diry;
        --changeY <= '0';
      end if;
    end process;
end;
