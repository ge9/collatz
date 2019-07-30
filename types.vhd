library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

package types is

    type whole_route is record
        start : std_logic_vector(9 downto 0);
        peak : std_logic_vector(17 downto 0);
        len  : std_logic_vector(7 downto 0);
    end record;
    type whole_routes_4 is array(0 to 3) of whole_route;
    

 end package types;
