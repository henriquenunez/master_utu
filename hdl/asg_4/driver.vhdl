
entity led_driver is
    port(
        LED_0 : out std_logic_vector(1 downto 0);
        LED_1 : out std_logic_vector(1 downto 0);
        LED_2 : out std_logic_vector(1 downto 0);
        )

end led_driver;

architecture rtl of led_driver is

type state_t is (S0, S1, S2, S3, S4, S5, S6, S7);
signal state, next_state : state_t;

begin

-- Sync reset (?)

process (clk)
begin
    if forward then
        case (state) is
            when S1 =>
                next_state <= S6;
            when S6 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S7;
            when S7 =>
                next_state <= S1;
        end case;
    else
        case (state) is
            when S1 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S2 =>
                next_state <= S6;
            when S3 =>
                next_state <= S2;
            when S7 =>
                next_state <= S3;
        end case;
    end if;
end

-- Decoder logic
process (state)
begin
    case (state) is
        when (S1) =>
            LED_0 <= "10";
            LED_1 <= "00";
            LED_2 <= "00";
        when (S2) =>
            LED_0 <= "00";
            LED_1 <= "10";
            LED_2 <= "00";
        when (S3) =>
            LED_0 <= "00";
            LED_1 <= "00";
            LED_2 <= "10";
        when (S4) =>
            LED_0 <= "10";
            LED_1 <= "10";
            LED_2 <= "10";
        when (S5) =>
            LED_0 <= "00";
            LED_1 <= "00";
            LED_2 <= "00";
        when (S6) =>
            LED_0 <= "10";
            LED_1 <= "10";
            LED_2 <= "00";
        when (S7) =>
            LED_0 <= "01";
            LED_1 <= "00";
            LED_2 <= "01";
        when (S0) =>
            LED_0 <= "00";
            LED_1 <= "00";
            LED_2 <= "00";

end

end architecture rtl;

