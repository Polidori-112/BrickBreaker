library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity top is
    port(
      left : in std_logic;
      right : in std_logic;
      start : in std_logic;

      clk_12M : in std_logic;
      clk_pxl : out std_logic; --use this clock
      clk_locked2 : out std_logic;
      HSYNC1 : out std_logic;
      VSYNC1 : out std_logic;
      led : out std_logic;
      led1 : out std_logic;

      rgb : out std_logic_vector(5 downto 0)
      );
end top;



architecture synth of top is

  component vga is
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

        display : out std_logic;
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
          sscreen_row : in unsigned(9 downto 0); -- current sscreen_row of pixels
          sscreen_col : in unsigned(9 downto 0); -- current sscreen_col of pixels
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

  signal valid1 : std_logic;

  signal frame_update : std_logic := '0';

  signal level : unsigned (2 downto 0) := "001";
begin

  vga1 : vga port map (
    clk_in1 => clk_12M,
    clk_out1 => clk_pxl,
    clk_locked1 => clk_locked2,
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
    vga_row => row,
    vga_col => col
  );

  brickvga : brick port map (
    clk => clk_pxl,
    row => row,
    col => col,
    del => del,
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
                rgb <= "000011";
            elsif ((lives_display = '1')) then
                rgb <= "111111";
            else
                rgb <= "000000";
            end if;
 

        end if;
      else
        rgb <= "000000";
      end if;

      --collision with paddle
      --keep in top file
      if (paddle_display = '1' and ball_display = '1') then
        changeY <= '1';
        frame_update <= '1';
      elsif frame_update <= '0' then
        changeY <= '0';
      end if;

      if (row = 700 and col = 0 and frame_update = '1') then
        frame_update <= '0';
      end if;
      
    end if;
  end process;

end;
