library ieee;
use ieee.std_logic_1164.all;

entity main_tb is
end entity main_tb;

architecture rtl of main_tb is

    function count_ones(vec: in std_logic_vector) return integer is
        variable count : integer := 0;
    begin
        for i in vec'range loop
            if vec(i) = '1' then
                count := count + 1;
            end if;
        end loop;
        return count;
    end function;

    function check(scoresA, scoresB: in std_logic_vector(2 downto 0)) return std_logic_vector is
    begin
	if (count_ones(scoresA) = 0 and count_ones(scoresB) = 0) then
            return "00";
        elsif (count_ones(scoresA) > count_ones(scoresB)) then
            return "10";
        elsif (count_ones(scoresA) < count_ones(scoresB)) then
            return "01";
	else
	    return "11";
        end if;
    end function;

    component counter 
        port (
		clock : in bit;
		reset : in bit;
		enable : in bit;
		load : in bit;
		up_down : in bit;
		data : in std_logic_vector(3 downto 0);
		count : out std_logic_vector(3 downto 0)
	);
    end component;

    for uut : counter use entity work.counter;

    signal clock, reset, enable, load, up_down : bit;
    signal data, count : std_logic_vector(3 downto 0);
begin
    uut: counter
        port map (
            clock,
            reset,
            enable,
            load,
            up_down,
            data,
            count
        );

    process
    begin

        clock <= '1';
        reset <= '1';
	wait for 10 ns;

        assert count = "0000"
            report "unable to reset! " & to_hstring(count) severity error;

        /*
        up_down <= '0';
        for i in 0 to 100 loop

            if i = 50 then
                up_down <= '1';
            end if;

            reset <= '0';
            clock <= '0';
            wait for 10 ns;

            enable <= '1';
            load <= '0';
            
            wait for 10 ns;

            clock <= '1';
            wait for 10 ns;

            assert count = "0001"
                report "cannot count to ! " & to_hstring(count) severity error;

        end loop;
        */

        -- Synchronous reset

        -- Load data
        clock <= '0';
        load <= '1';
        data <= "1010";
        reset <= '0';
        enable <= '1';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        assert count = "1010" report "cannot load!" severity error;
        assert false report "end of test" severity note;
    	wait;
    end process;

end architecture rtl;

