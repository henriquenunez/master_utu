----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2023 01:28:43 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (  
            SW0 : in std_logic; -- Enable
            SW1 : in std_logic; -- Up/Down
            
            SW2 : in std_logic; -- Data
            SW3 : in std_logic;
            SW4 : in std_logic;
            SW5 : in std_logic;
            
            GCLK : in std_logic; -- Clock
            BTNU : in std_logic; -- Load
            BTNR : in std_logic; -- Reset
            BTNL : in std_logic; -- Clock Reset
            
            LD0 : out std_logic; -- Ouput
            LD1 : out std_logic;
            LD2 : out std_logic;
            LD3 : out std_logic;
            
            LD7 : out std_logic -- Ovver
        );
end top;

architecture Behavioral of top is
    component counter 
        port (
		clock : in std_logic;
		reset : in std_logic;
		enable : in std_logic;
		load : in std_logic;
		up_down : in std_logic;
		data : in std_logic_vector(3 downto 0);
		count : out std_logic_vector(3 downto 0);
        over :  out std_logic
	);
    end component;
    
    component clock_div is
    Port ( clk_in : in STD_LOGIC;
           reset  : in  STD_LOGIC;
           clk_out : out STD_LOGIC);
    end component;
    
    --signal scoresA_top, scoresB_top : std_logic_vector(2 downto 0);
    --signal winner_top : std_logic_vector(1 downto 0);

    signal clk_comm : std_logic;
begin
    
    -- Clock divider
    conn_clock_div : clock_div port map(
        clk_in => GCLK,
        reset => BTNL,
        clk_out => clk_comm
    );
    
    -- Counter module
    conn_counter : counter port map (
        enable => SW0,
        up_down => SW1,
        
        clock => clk_comm,
        reset => BTNR,
        load => BTNU,
        
        data(0) => SW2,
        data(1) => SW3,
        data(2) => SW4,
        data(3) => SW5, 
    
        count(0) => LD0,
        count(1) => LD1,
        count(2) => LD2,
        count(3) => LD3,
        
        over => LD7
        );
        
    -- PWM mapped to LED
    -- TODO

end Behavioral;
