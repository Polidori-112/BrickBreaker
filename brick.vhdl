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
      del : in std_logic;
      display : out std_logic
    );
end brick;

architecture synth of brick is
  signal brick0 : std_logic_vector(9 downto 0) :=  
                                            "1010101010"; 
  signal brick1 : std_logic_vector(9 downto 0) :=  
                                            "0101010101"; 
  signal brick2 : std_logic_vector(9 downto 0) :=  
                                            "1010101010";
  signal brick3 : std_logic_vector(9 downto 0) :=  
                                            "0101010101";
  signal brick4 : std_logic_vector(9 downto 0) :=  
                                            "1010101010";
  signal brick5 : std_logic_vector(9 downto 0) :=  
                                            "0101010101";



begin

--Only displays last brick due to how for loops work in vhdl
process (clk) begin

	if rising_edge(clk) then
		case col(9 downto 5) is
			when "00000" =>
				display <= brick0(9 - to_integer(row(9 downto 6)));
				brick0(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick0(9 - to_integer(row(9 downto 6)));
			when "00001" =>
				display <= brick1(9 - to_integer(row(9 downto 6)));
                                brick1(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick1(9 - to_integer(row(9 downto 6)));
                	when "00010" =>
				display <= brick2(9 - to_integer(row(9 downto 6)));
                                brick2(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick2(9 - to_integer(row(9 downto 6)));
	        	when "00011" =>
				display <= brick3(9 - to_integer(row(9 downto 6)));
                                brick3(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick3(9 - to_integer(row(9 downto 6)));
                 	when "00100" =>
				display <= brick4(9 - to_integer(row(9 downto 6)));
                                brick4(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick4(9 - to_integer(row(9 downto 6)));
	        	when "00101" =>
				display <= brick5(9 - to_integer(row(9 downto 6)));
                                brick5(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else brick5(9 - to_integer(row(9 downto 6)));
			when others =>
				display <= '0';
		end case;

	end if;

end process;

end;
