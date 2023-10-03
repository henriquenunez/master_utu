library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity counter is
	port (
		clock : in bit;
		reset : in bit;
		enable : in bit;
		load : in bit;
		up_down : in bit;
		data : in std_logic_vector(3 downto 0);
		count : out std_logic_vector(3 downto 0)
	);
end counter;

architecture rtl_1 of counter is
begin

process (all)
variable curr_count : integer;
begin

if rising_edge(clock) then

    if reset = '1' then
        curr_count := 0;
    else

        if enable = '1' then
            if up_down = '0' then -- up is 0, down is 1
                curr_count := curr_count + 1;
            else
                curr_count := curr_count - 1;
            end if;

            if curr_count < 0 then
                curr_count := 15;
            elsif curr_count > 15 then
                curr_count := 0;
            end if;

            if load = '1' then
                curr_count := to_integer(unsigned(data));
            end if;
        end if;
    end if;

    count <= std_logic_vector(to_unsigned(curr_count, count'length));
end if;

end process;
end rtl_1;
/*
architecture rtl_2 of counter is
begin
    process (all)
    variable curr_count : integer;
    begin
    end process;
end rtl_2;
*/

