----------------------------------------------------------------------------------
-- 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 2019-10-13
--
-- Module Name: ServoDriver - Behavioral
-- Project Name: LOGO CPU
-- Target Devices: turtle car
-- Tool Versions: Vivado 2019.1.1
-- Description: School assignment CCW2 for DFDV3100
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ServoDriver is
    generic ( 
        PDN  : STD_LOGIC_VECTOR (7 downto 0):= X"06";
        PUP  : STD_LOGIC_VECTOR (7 downto 0):= X"07"
        );
        
    Port ( IR       : in  STD_LOGIC_VECTOR (7 downto 0);
           servoPWM : out STD_LOGIC;
           clk      : in STD_LOGIC);
end ServoDriver;

architecture Behavioral of ServoDriver is
signal servopos : STD_LOGIC := '0';
signal PWMclock : STD_LOGIC := '0';
signal counter1 : STD_LOGIC_VECTOR(17 downto 0);
begin
    --First generate 1kHz clock that can be used to drive PWM signal
    process(clk) 
    variable counter1 : integer := 0;
    begin
        if rising_edge(clk) then
            if (counter1 = 50000) then
                PWMclock <= not PWMclock;    
                counter1 := 0;
            else 
                counter1 := counter1 + 1;
            end if;
            -- Update servoPOS if IR= PDN or PUP
            if IR = PDN then 
                servoPOS <= '0';
            elsif IR = PUP then 
                servoPOS <= '1';
            end if;
        end if;
    end process;
    
    --Use 1kHz clock to generate pulse length of 1 or 2 ms every 20ms
    process(PWMclock) 
    variable counter2 : integer := 0;
    begin
        if rising_edge(PWMclock) then
            counter2 := counter2 + 1;
            if (counter2 = 1) then
                servoPWM <= '1';
            elsif (counter2 = 2) AND (servoPOS = '1') then
                servoPWM <= '1';
            elsif counter2 > 19 then -- reset counter after 20ms
                counter2 := 0;
            else
                servoPWM <= '0';
            end if;
        end if;
    end process;

end Behavioral;
