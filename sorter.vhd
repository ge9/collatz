library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity sorter is
    port (
        clk   : in  std_logic := '0';
        chain : in  whole_route := ((others => '0'), (others => '0'), (others => '0'));
        top4  : out whole_routes_4 := (others => ((others => '0'), (others => '0'), (others => '0')))
    );
end sorter;

architecture RTL of sorter is

    signal top4_reg : whole_routes_4 := (others => ((others => '0'), (others => '0'), (others => '0')));

begin
   top4 <= top4_reg;
	process(clk) begin
	   if rising_edge(clk) then
	      if (chain.peak>top4_reg(0).peak) then--new peak is the largest
		   top4_reg(0) <= chain;
		   top4_reg(1) <= top4_reg(0);
			top4_reg(2) <= top4_reg(1);
			top4_reg(3) <= top4_reg(2);
			elsif(chain.peak=top4_reg(0).peak) then--new peak is one of the largest
			   if(chain.len>top4_reg(0).len) then--compare two lengthes
			      top4_reg(0) <= chain;
			   end if;
			elsif (chain.peak>top4_reg(1).peak) then--new peak is the second largest
		   top4_reg(1) <= chain;
		   top4_reg(2) <= top4_reg(1);
			top4_reg(3) <= top4_reg(2);
			elsif(chain.peak=top4_reg(1).peak) then--new peak is one of the second largest
			   if(chain.len>top4_reg(1).len) then--etc.
			      top4_reg(1) <= chain;
			   end if;
			elsif (chain.peak>top4_reg(2).peak) then
		   top4_reg(2) <= chain;
		   top4_reg(3) <= top4_reg(2);
			elsif(chain.peak=top4_reg(2).peak) then
			   if(chain.len>top4_reg(2).len) then
			      top4_reg(2) <= chain;
			   end if;
			elsif (chain.peak>top4_reg(3).peak) then
		   top4_reg(3) <= chain;
		   elsif(chain.peak=top4_reg(3).peak) then
			   if(chain.len>top4_reg(3).len) then
			      top4_reg(3) <= chain;
			   end if;
			end if;	
		end if;	
	end process;

end RTL;
