entity pwm04B is
generic(    IDLE  : boolean := false;
            IDLE_I: boolean := false;
            INTERLOCK :integer := 4            
            );
    Port ( clk : in STD_LOGIC;
           duty : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC;
           pwm : out STD_LOGIC;
           pwm_i : out STD_LOGIC
           );
end pwm04B;

architecture Behavioral04B of pwm04B is
    signal counter : std_logic_vector(7 downto 0) := "00000000";
    signal duty_sig : std_logic_vector (7 downto 0) := "00000000";
    signal duty_sig_i : std_logic_vector (7 downto 0) := "00000000";
    
function bool_to_sl(X : boolean)--conversion from boolean to std_logic
              return std_ulogic is
    begin
      if X then
        return '1';
      else
        return '0';
      end if;
end BOOL_TO_SL;
begin
process(clk) 
        begin
        if rising_edge(clk) then
            if enable = '1' then
                counter <= counter + 1; --pwm signal with interlock delay time if counter >= INTERLOCK and counter < duty_sig then
                    pwm <= '1';
                else
                    pwm <= '0'; end if; --inverted pwm signal if counter >= duty_sig_i  then
                   pwm_i <= '1';
                else
                   pwm_i <= '0';
                end if; 
            else --enable = '0'
                counter <= (others => '0');
                pwm   <= bool_to_sl(IDLE); --Set to iddle state
                pwm_i <= bool_to_sl(IDLE_I);  --Set to iddle state   
            end if;
        end if;
--update the dutycycle only at the end of each PWM-cycle
        if counter = 0 then
            duty_sig <= duty ;
            duty_sig_i <= duty+ INTERLOCK;
        end if;
end process;
end Behavioral04B;
