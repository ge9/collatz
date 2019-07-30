library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.types.all;

entity collatz_testbench is
end collatz_testbench;

architecture behaviour of collatz_testbench is

    signal sysclk  : std_logic := '0';
    signal clk_count : std_logic_vector(31 downto 0) := (others => '0');
    signal top4 : whole_routes_4 := (others => ((others => '0'), (others => '0'), (others => '0')));

begin
    main : entity work.collatz_main port map(
		clk => sysclk,
		clk_count => clk_count,
      top4 => top4
	);

	clockgen : process
	begin--generate clock here
		sysclk <= '0';
		wait for 5 ns;
		sysclk <= '1';
		wait for 5 ns;
	end process;

end behaviour;
