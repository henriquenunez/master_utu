library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end entity main_tb;

architecture rtl of main_tb is
    component counter
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
    end component;

    for uut : counter use entity work.counter;

    signal clock, reset, enable, load, up_down, over : std_logic;
    signal data, count : std_logic_vector(7 downto 0);
begin
    uut: counter
        generic map (
            MAX_COUNT_g => 255,
            w => 8
        )
        port map (
            clock,
            reset,
            enable,
            load,
            up_down,
            data,
            count,
            over
        );

    process
    begin

        load <= '0';
        enable <= '1';
        data <= (others => '0');

        -- Resetting on rising edge
        clock <= '0';
        reset <= '1';

	wait for 10 ns;

        clock <= '1';

        wait for 5 ns;
        reset <= '0';
        wait for 5 ns;

        assert count = "00000000" and over = '0'
            report "unable to reset! " & to_hstring(count) severity error;

        -- Counting up
        up_down <= '0';
        for i in 0 to 20 loop

            if i < 16 then
                assert to_integer(unsigned(count)) = i
                    report "cannot count to ! " & to_string(i) & " -> " & to_hstring(count) severity error;
            else
                assert to_integer(unsigned(count)) = i - 16 and over = '1'
                        report "OVER PROBLEM!!!! cannot count to ! " & to_string(i) & " -> " & to_hstring(count) severity error;
            end if;
    
            clock <= '0';
            wait for 10 ns;

            clock <= '1';
            wait for 10 ns;
        end loop;

        -- Synchronous reset
        clock <= '0';
        reset <= '1';
	    wait for 10 ns;

        clock <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Load data
        clock <= '0';
        load <= '1';
        data <= "00001010";
        wait for 10 ns;

        clock <= '1';
        wait for 10 ns;
        assert count = "00001010" and over = '0' report "cannot load!" severity error;
        assert false report "end of test" severity note;

        up_down  <= '1';
        -- Counting down with loaded data
        for i in 0 to 10 loop

            assert to_integer(unsigned(count)) = 10 - i
                    report "cannot count to ! " & to_string(i) & " -> " & to_hstring(count) severity error;

            -- Run clock cycle
            reset <= '0';
            clock <= '0';
            enable <= '1';
            load <= '0';
            wait for 10 ns;

            clock <= '1';
            wait for 10 ns;
        end loop;

        assert over = '1'
                report "OVER PROBLEM!!!!" severity error;

        -- Testing enable=0
        clock <= '0';
        reset <= '0';
	    enable <= '0';
	    wait for 10 ns;

        clock <= '1';
        wait for 10 ns;
        
        
        wait for 50 ns;
        
        enable <= '1';
        clock <= '0';
       
	    wait for 10 ns;

        clock <= '1';
        wait for 10 ns;
        reset <= '0';
        
        wait for 50 ns;

        -- Synchronous reset
        clock <= '0';
        reset <= '1';
	    wait for 10 ns;

        clock <= '1';
        wait for 10 ns;
        reset <= '0';

    	wait;
    end process;

end architecture rtl;

