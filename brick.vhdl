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
      del : in std_logic; --when this is high, the brick that encapsulates row and col gets deleted
      display : out std_logic
    );
end brick;

architecture synth of brick is

   
-- ___________________Level Design______________________
-- Each vector represents a row of bricks and each bit in a vector
-- is a column. The top left brick is the left most bit in vec0

-- Start Level
  signal start0 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal start1 : std_logic_vector(9 downto 0) :=
                                            "1111110000";
  signal start2 : std_logic_vector(9 downto 0) :=
    					    "0000000000";
  signal start3 : std_logic_vector(9 downto 0) :=
                                            "0011111111";
  signal start4 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal start5 : std_logic_vector(9 downto 0) :=
                                            "1111111000";

-- Checker Level
  signal check0 : std_logic_vector(9 downto 0) :=
                                            "0101010101";
  signal check1 : std_logic_vector(9 downto 0) :=
                                            "1010101010";
  signal check2 : std_logic_vector(9 downto 0) :=
                                            "0101010101";
  signal check3 : std_logic_vector(9 downto 0) :=
                                            "1010101010";
  signal check4 : std_logic_vector(9 downto 0) :=
                                            "0101010101";
  signal check5 : std_logic_vector(9 downto 0) :=
                                            "1010101010";

  signal end0 : std_logic_vector(9 downto 0) :=
                                            "1101001110";
  signal end1 : std_logic_vector(9 downto 0) :=
                                            "1001001101";
  signal end2 : std_logic_vector(9 downto 0) :=
                                            "1101101101";
  signal end3 : std_logic_vector(9 downto 0) :=
                                            "1001011101";
  signal end4 : std_logic_vector(9 downto 0) :=
                                            "1101001110";
  signal end5 : std_logic_vector(9 downto 0) :=
                                            "0000000000";


-- Brick States. These store the states of the bricks
-- at any given moment. Only modify these in reponse to input from del,  
-- and lvl
  signal curr0 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal curr1 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal curr2 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal curr3 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal curr4 : std_logic_vector(9 downto 0) :=
                                            "0000000000";
  signal curr5 : std_logic_vector(9 downto 0) :=
                                            "0000000000";

-- FF that store the current amount of bits. Must be reset when level resets
  signal brick_count : integer := 30;
  signal brick_count2 : integer := 76;

  signal lvl : std_logic_vector(2 downto 0) := "001";

  signal lvl_store : std_logic_vector(1 downto 0) := "00";

  signal lvl_change : std_logic;


begin

process (clk) begin

	if rising_edge(clk) then
	           case lvl is
			when "001" =>
 			        curr0 <= start0; 
				curr1 <= start1; 
				curr2 <= start2; 
				curr3 <= start3;
				curr4 <= start4;
				curr5 <= start5;
				brick_count <= 30;
				lvl(0) <= '0';
			when "010" =>
	         		curr0 <= check0;
		  		curr1 <= check1;
		  		curr2 <= check2;
	        		curr3 <= check3;
		  		curr4 <= check4;
	        		curr5 <= check5;
				lvl(1) <= '0';
				brick_count2 <= 70;
				lvl_store(0) <= '1';
			when "100" =>
				curr0 <= end0;
				curr1 <= end1;
				curr2 <= end2;
				curr3 <= end3;
				curr4 <= end4;
				curr5 <= end5;
				lvl(2) <= '0';
				lvl_store(1) <= '1';
				
		        when others =>
				
				lvl(1) <= '1' when (brick_count <= 0 and lvl_store(0) = '0') else '0';
				lvl(2) <= '1' when (brick_count2 <= 0 and lvl_store(1) = '0' and lvl_store(0) = '1') else '0';
		end case;


		


		-- Displays pixel at row, col if brick in curr is on. If del is high, delete thr brick that encapsulates
		-- row, col
		case col(9 downto 5) is
			when "00000" =>
				display <= curr0(9 - to_integer(row(9 downto 6)));
				curr0(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr0(9 - to_integer(row(9 downto 6)));
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr0(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
				brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr0(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
			when "00001" =>
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr1(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
				display <= curr1(9 - to_integer(row(9 downto 6)));
        			brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr1(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
	                        curr1(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr1(9 - to_integer(row(9 downto 6)));
                	when "00010" =>
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr2(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
	       			brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr2(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
				display <= curr2(9 - to_integer(row(9 downto 6)));
                                curr2(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr2(9 - to_integer(row(9 downto 6)));
	        	when "00011" =>
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr3(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
				display <= curr3(9 - to_integer(row(9 downto 6)));
               			brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr3(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
	                        curr3(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr3(9 - to_integer(row(9 downto 6)));
                 	when "00100" =>
	        		brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr4(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr4(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
				display <= curr4(9 - to_integer(row(9 downto 6)));
                                curr4(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr4(9 - to_integer(row(9 downto 6)));
	        	when "00101" =>
	        		brick_count2 <= brick_count2 - 1 when (lvl_store(0) = '1' and del = '1' and curr5(9 - to_integer(row(9 downto 6))) = '0') else brick_count2;
				brick_count <= brick_count - 1 when (lvl_store(0) = '0' and del = '1' and curr5(9 - to_integer(row(9 downto 6))) = '1') else brick_count;
				display <= curr5(9 - to_integer(row(9 downto 6)));
                                curr5(9 - to_integer(row(9 downto 6))) <= '0' when (del = '1') else curr5(9 - to_integer(row(9 downto 6)));
			when others =>
				display <= '0';
		end case;


	end if;

end process;

end;
