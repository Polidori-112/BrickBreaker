library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity live is
    port (
        clk : in std_logic;
        lives_row : in unsigned(9 downto 0); -- current row of pixels
        lives_col : in unsigned(9 downto 0); -- current col of pixels
        livesCount : in unsigned(1 downto 0);
        display : out std_logic
    );
end live;

architecture synth of live is


begin
    process(clk) begin
        if rising_edge(clk) then
            if ((lives_col > 460) and (lives_col < 470)) then
                if ((lives_row > 550) and (lives_row < 560) and (livesCount > 0)) then
                    display <= '1';
                elsif ((lives_row > 530) and (lives_row < 540) and (livesCount > 1)) then
                    display <= '1';
                elsif ((lives_row > 510) and (lives_row < 520) and (livesCount > 2)) then
                    display <= '1';
                else
                    display <= '0';
                end if;
            else
                display <= '0';
            end if;
        end if;
    end process;
end;
