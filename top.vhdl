library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity top is
    port(
      clk_12M : in std_logic;
      clk_pxl : out std_logic; --use this clock
      clk_locked2 : out std_logic;
      HSYNC1 : out std_logic;
      VSYNC1 : out std_logic;
      nes_data : in std_logic;
      nes_latch : out std_logic;
      nes_clock : out std_logic;

      led : out std_logic := '1';

      left : in std_logic;
      right : in std_logic;
      start : in std_logic;

      rgb : out std_logic_vector(5 downto 0)
      );
end top;



architecture synth of top is

  component pll is
     port (
        clk_in : in std_logic;
        clk_out : out std_logic;
        clk_locked : out std_logic
        );
  end component;

--  component nes is
--     port(
--       clock_in : in std_logic;
--       data : in std_logic;
--       latch : out std_logic;
--       clock : out std_logic;
--       left : out std_logic;
--       right : out std_logic;
--       start : out std_logic
--     );
--  end component;

  component vga is
      port(
        clk_in : in std_logic;
        HSYNC : out std_logic;
        VSYNC : out std_logic;
        valid : out std_logic;
        r : out unsigned(9 downto 0);
        c : out unsigned(9 downto 0)
        );
  end component;

  component paddle is
      port(
        left : in std_logic;
        right : in std_logic;

        clk : in std_logic;
        vga_row : in unsigned(9 downto 0);
        vga_col : in unsigned(9 downto 0);

        display : out std_logic
        );
  end component;

  component ball is
      port(
          start : in std_logic; -- signals start of game
          clk : in std_logic; -- clk to move ball
          --clk : out std_logic;
          vga_row : in unsigned(9 downto 0); -- current row of pixels
          vga_col : in unsigned(9 downto 0); -- current col of pixels
          lives : out unsigned(1 downto 0);
          reset : in std_logic;
          changeX : in std_logic;
          changeY : in std_logic;
          next_velocity : in unsigned(2 downto 0);
          display : out std_logic -- 1 if ball displayed, otherwise 0
      );
  end component;

  component brick is
      port(
        clk : in std_logic;

        row : in unsigned(9 downto 0);
        col : in unsigned(9 downto 0);

      --  lives : inout unsigned(1 downto 0);
        display : out std_logic;
        reset : out std_logic;
        del : in std_logic
      );
  end component;

  component live is
      port (
          clk : in std_logic;
          lives_row : in unsigned(9 downto 0); -- current row of pixels
          lives_col : in unsigned(9 downto 0); -- current col of pixels
          livesCount : in unsigned(1 downto 0);
          display : out std_logic
      );
  end component;

  component startScreen is
      port (
          clk : in std_logic;
          sscreen_row : in unsigned(9 downto 0); -- current screen_row of pixels
          sscreen_col : in unsigned(9 downto 0); -- current screen_col of pixels
          sdisplay : out std_logic_vector(5 downto 0)
      );
  end component;

  signal paddle_display : std_logic;
  signal ball_display : std_logic;
  signal brick_display : std_logic;
  signal lives_display : std_logic;
  signal del : std_logic := '0';
  signal startdisplay : std_logic_vector(5 downto 0);

  signal lives : unsigned (1 downto 0) := "00";
  signal changeX : std_logic := '0';
  signal changeY : std_logic := '0';
  signal vel : unsigned(2 downto 0);

  signal row : unsigned(9 downto 0);
  signal col : unsigned(9 downto 0);

 -- signal left : std_logic;
 -- signal right : std_logic;
 -- signal start : std_logic;

  signal clk_locked : std_logic;

  signal valid1 : std_logic;

  signal frame_update : std_logic := '0';

  signal level : unsigned (2 downto 0) := "001";

  signal reset : std_logic;

begin

  pll1 : pll port map (
    clk_12M,
    clk_pxl,
    clk_locked
  );

  vga1 : vga port map (
    clk_in => clk_pxl,
    HSYNC => HSYNC1,
    VSYNC => VSYNC1,
    valid => valid1,
    r => row,
    c => col
  );

  paddlevga : paddle port map (
    clk => clk_pxl,
    left => left,
    right => right,
    display => paddle_display,
    vga_row => row,
    vga_col => col
  );

  ballvga : ball port map (
    clk => clk_pxl,
    start => start,
    lives => lives,
    changeX => changeX,
    changeY => changeY,
    display => ball_display,
    next_velocity => vel,
    reset => reset,
    vga_row => row,
    vga_col => col
  );

  brickvga : brick port map (
    clk => clk_pxl,
    row => row,
    col => col,
    del => del,
    reset => reset,
  --  lives => lives,
    display => brick_display
  );

  livevga : live port map (
    clk => clk_pxl,
    lives_row => row,
    lives_col => col,
    livesCount => lives,
    display => lives_display
  );

  startvga : startScreen port map (
    clk => clk_pxl,
    sscreen_col => col,
    sscreen_row => row,
    sdisplay => startdisplay
  );

  -- nes_impl : nes port map (
  --     clk_pxl,
  --     nes_data,
  --     nes_latch,
  --     nes_clock,
  --     left,
  --     right,
  --     start
  --);

  process (clk_pxl) begin
    if rising_edge(clk_pxl) then

      --draw paddle and ball
      if (valid1 = '1') then

          if (lives = "00") then
            rgb <= startdisplay;
          else

	        if ((paddle_display = '1')) then
                rgb <= "110000";
            elsif ((ball_display = '1')) then
                rgb <= "111111";
            elsif ((brick_display = '1')) then
                if (col > 159) then
                    rgb <= "110000";
                elsif (col > 127) then
                    rgb <= "001100";
                elsif (col > 95) then
                    rgb <= "000011";
                elsif (col > 63) then
                    rgb <= "110000";
                elsif (col > 31) then
                    rgb <= "001100";
                else
                    rgb <= "000011";
                end if;
            elsif ((lives_display = '1')) then
                rgb <= "111111";
            else
                rgb <= "000000";
            end if;
          end if;

      else
        rgb <= "000000";
      end if;

      ---------collision-----------

      --paddle and ball
      if (paddle_display = '1' and ball_display = '1') then
        changeY <= '1';
        frame_update <= '1';
      --brick and ball
      --change x direction if it hits inbetween the top and bottom of brick
      elsif (brick_display = '1' and ball_display = '1'
      and ((col < 30)
      or (col < 62 and col > 33)
      or (col < 94 and col > 65)
      or (col < 126 and col > 97)
      or (col < 158 and col > 129)
      or (col < 190 and col > 161))) then
         changeX <= '1';
         frame_update <= '1';
      --otherwise change y direction
      elsif (brick_display = '1' and ball_display = '1' and frame_update = '0') then
        changeY <= '1';
        frame_update <= '1';
      elsif frame_update <= '0' then
        changeY <= '0';
        changeX <= '0';
      end if;

      --used to refresh frame update
      --prevents changex/changey from being called multiple times in a single collision
      if (row = 700 and col = 0 and frame_update = '1') then
        frame_update <= '0';
      end if;

      --break bricks
      if (brick_display = '1' and ball_display = '1' and del = '0') then
          del <= '1';
      else
          del <= '0';
      end if;


    end if;
  end process;

end;
