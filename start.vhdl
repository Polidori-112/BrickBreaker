library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity startScreen is
    port (
        clk : in std_logic;
        sscreen_row : in unsigned(9 downto 0); -- current sscreen_sscreen_row of pixels
        sscreen_col : in unsigned(9 downto 0); -- current sscreen_sscreen_col of pixels
        display : out std_logic
    );
end startScreen;

architecture synth of startScreen is

begin
    process(clk) begin
        if rising_edge(clk) then
            if (((sscreen_col > 210) and (sscreen_col < 220)) and ((sscreen_row > 350) and (sscreen_row < 360))) then
                display <= '1';



              --draw blocks
            elsif (((sscreen_row > 245) and (sscreen_row < 285)) and ((sscreen_col > 180) and (sscreen_col < 200))) then
                display <= '1';
            elsif (((sscreen_row > 200) and (sscreen_row < 240)) and ((sscreen_col > 180) and (sscreen_col < 200))) then
                display <= '1';
            elsif (((sscreen_row > 155) and (sscreen_row < 195)) and ((sscreen_col > 180) and (sscreen_col < 200))) then
                display <= '1';
            elsif (((sscreen_row > 245) and (sscreen_row < 285)) and ((sscreen_col > 205) and (sscreen_col < 225))) then
                display <= '1';
            elsif (((sscreen_row > 200) and (sscreen_row < 240)) and ((sscreen_col > 205) and (sscreen_col < 225))) then
                display <= '1';
            elsif (((sscreen_row > 155) and (sscreen_row < 195)) and ((sscreen_col > 205) and (sscreen_col < 225))) then
                display <= '1';
            elsif (((sscreen_row > 245) and (sscreen_row < 285)) and ((sscreen_col > 155) and (sscreen_col < 175))) then
                display <= '1';
            elsif (((sscreen_row > 200) and (sscreen_row < 240)) and ((sscreen_col > 155) and (sscreen_col < 175))) then
                display <= '1';
            elsif (((sscreen_row > 155) and (sscreen_row < 195)) and ((sscreen_col > 155) and (sscreen_col < 175))) then
                display <= '1';
                
            elsif ((sscreen_col > 300) and (sscreen_col < 400)) then
                if (sscreen_row > 545) then
                    display <= '0';
            elsif (sscreen_row > 495) then
                if ((sscreen_row > 515) and (sscreen_col > 320) and (sscreen_col < 340)) then
                    display <= '0';
                elsif ((sscreen_row > 515) and (sscreen_col > 360) and (sscreen_col < 380)) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 445) then
                if (sscreen_col > 320) then
                    if ((sscreen_row > 455) and (sscreen_row < 485)) then
                        if ((sscreen_row > 465) and (sscreen_row < 475)) then
                            display <= '1';
                        else
                            display <= '0';
                        end if;
                    else
                        display <= '1';
                    end if;
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 395) then
                if ((sscreen_col < 1980 - 4*sscreen_row) or (sscreen_col < 4*sscreen_row - 1420)) then
                    display <= '0';
                elsif ((sscreen_col > 370) and (sscreen_col < 385)) then
                    display <= '1';
                elsif ((sscreen_col > 2045 - 4*sscreen_row) and (sscreen_col > 4*sscreen_row - 1355)) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 345) then
                if ((sscreen_row > 365) and (sscreen_col > 320) and (sscreen_col < 380)) then
                    if ((sscreen_row > 380) and (sscreen_col > 350)) then
                        display <= '1';
                    else
                        display <= '0';
                    end if;
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 295) then
                display <= '0';
            elsif (sscreen_row > 245) then
                if (sscreen_col > 910 - 2*sscreen_row) then
                    display <= '0';
                elsif ((sscreen_col < 2*sscreen_row - 175) and (sscreen_col > 2*sscreen_row - 205)) then
                    display <= '1';
                elsif (sscreen_col < 880 - 2*sscreen_row) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 195) then
                if ((sscreen_col < 1160 - 4*sscreen_row) or (sscreen_col < 4*sscreen_row - 600)) then
                    display <= '0';
                elsif ((sscreen_col > 370) and (sscreen_col < 385)) then
                    display <= '1';
                elsif ((sscreen_col > 1225 - 4*sscreen_row) and (sscreen_col > 4*sscreen_row - 535)) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 145) then
                if ((sscreen_row > 165) and (sscreen_col < 380)) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            elsif (sscreen_row > 95) then
                if ((sscreen_row > 115) and (sscreen_col > 345)) then
                    display <= '0';
                elsif (((sscreen_row > 115) and (sscreen_row < 125)) and ((sscreen_col > 317) and (sscreen_col < 327))) then
                    display <= '0';
                else
                    display <= '1';
                end if;
            end if;
          else
            display <= '0';
          end if;
        end if;
    end process;
end;