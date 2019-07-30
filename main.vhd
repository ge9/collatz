library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.types.all;

entity collatz_main is
    port (
        clk       : in std_logic := '0';
		  clk_count : out std_logic_vector(31 downto 0) := (others => '0');
        top4      : out whole_routes_4 := (others => ((others => '0'), (others => '0'), (others => '0')))
    );
end collatz_main;

architecture RTL of collatz_main is

   signal clk_count_reg : std_logic_vector(31 downto 0) := (others => '0'); 
	signal chain_reg : whole_route := ((others => '0'), (others => '0'), (others => '0'));

	
	signal alldone : std_logic := '0';
	signal address:STD_LOGIC_VECTOR (8 DOWNTO 0)  := (others => '0');--write/read address
	signal wren	: STD_LOGIC := '0';--WRite ENable
	
	signal ramdata	: STD_LOGIC_VECTOR (26 DOWNTO 0) := (others => '0');--data to write
	signal q	   : STD_LOGIC_VECTOR (26 DOWNTO 0);--data read from ram
	--26  :flag(is already visited?)
	--25-8:peak
	--7-0 :count(=length)
	signal q_peak	   : STD_LOGIC_VECTOR (17 DOWNTO 0);
	signal q_count	   : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal mode : std_logic := '0';--'0':calculating '1':finish calculation&prepare calculation
	
   signal root : std_logic_vector(8 downto 0) := (others => '0');--0 to 511
	signal num  : std_logic_vector(17 downto 0) := "000000000000000001";--current number(up to 250504)
	signal peak : std_logic_vector(17 downto 0) := "000000000000000001";--peak(up to 250504)
   signal count : std_logic_vector(7 downto 0) := "00000000";--ex. 5(0)->16(1)->8(2)->...
	
begin

   ram_1port : entity work.ram port map(
	     clock => clk,
		  data => ramdata,
		  address => address,
		  wren => wren,
		  q => q
	);
	sorter : entity work.sorter port map(
        clk   => clk,
        chain => chain_reg,
        top4  => top4
    );
	
	clk_count <= clk_count_reg;
	q_peak <= q(25 downto 8);
	q_count <= q(7 downto 0);
	process(clk) begin
      if rising_edge(clk) and alldone = '0' then
   		clk_count_reg <= clk_count_reg + 1;
		end if;
	end process;

   process(clk) begin
      if rising_edge(clk) and alldone = '0' then
		   if (mode='0') then
		      wren <= '0';
			   if (num="000000000000000001") then--goal
					mode <= '1';
				else
				   if (num <= "000000010000000000" and num(0)='1') then--less than 1024 and odd number
					   address <= num(9 downto 1);
					end if;
					if (count >= 4 and q(26)='1') then --already calculated
						mode <= '1';
						if (peak <= q_peak) then--if the peak from ram is larger
							peak <= q_peak;
						end if;
						count <= q_count + count - 3;
					else
						if (num > peak) then
							peak <= num;--update the peak
						end if;
						if (num(0)='0') then
							num <= ('0' & num(17 downto 1));--divide by 2
							count <= count + 1;
						else
							num <= (num(16 downto 0) & '1') + num;--multiply by 3 and add 1
							count <= count + 1;
						end if;
					end if;
			   end if;
			else--mode='1'
			   if (root = "111111111") then
					   alldone <= '1';
				end if;
			   wren <= '1';
				address <= root;
				ramdata <= '1'&peak&count;--to memory
				root <= root + 1;--the next root
				count <= "00000000";--reset the count
				num <= "00000000"&(root + 1)&'1';--the next initial number
				peak <= "000000000000000001";--reset the peak
				chain_reg <= (root & '1', peak, count);--register the result
				mode <= '0';
			end if;
	   end if;
   end process;


end RTL;
