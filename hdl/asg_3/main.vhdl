library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity counter is
    generic (
        MAX_COUNT_g : integer;
        w : integer 
    );

    port (
	clock : in std_logic;
	reset : in std_logic;
	enable : in std_logic;
	load : in std_logic;
	up_down : in std_logic;
	data : in std_logic_vector(w-1 downto 0);
	count : out std_logic_vector(w-1 downto 0);
        over: out std_logic
    );
end counter;

architecture rtl_1 of counter is
signal curr_count : unsigned(w-1 downto 0);
begin

process (clock)
-- variable curr_count : integer;
begin

if rising_edge(clock) then

    if reset = '1' then
        curr_count <= (others => '0');
        over <= '0';
    else
        if enable = '1' then
            if up_down = '0' then -- up is 0, down is 1
                curr_count <= curr_count + 1;
            else
                curr_count <= curr_count - 1;
            end if;

            if curr_count < 0 then
                over <= '1';
                curr_count <= to_unsigned(MAX_COUNT_g, w);
            elsif curr_count > to_unsigned(MAX_COUNT_g, w) then
                over <= '1';
                curr_count <= (others => '0');
            end if;

            if load = '1' then
                curr_count <= unsigned(data);
            end if;
        end if;
    end if;

    
end if;

count <= std_logic_vector(curr_count);

end process;
end rtl_1;

