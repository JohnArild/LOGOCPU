----------------------------------------------------------------------------------
-- 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 2019-10-13
--
-- Module Name: StepperDriver - Behavioral
-- Project Name: LOGO CPU
-- Target Devices: turtle car
-- Tool Versions: Vivado 2019.1.1
-- Description: School assignment CCW2 for DFDV3100
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StepperDriver is
    Port ( dataBus         : in    STD_LOGIC_VECTOR (7 downto 0) ;
           rightMotorPhase : out   STD_LOGIC_VECTOR (3 downto 0) ;
           leftMotorPhase  : out   STD_LOGIC_VECTOR (3 downto 0) ;
           clk             : in    STD_LOGIC;
                        IR : in STD_LOGIC_VECTOR (7 downto 0);
           stepperFinished : inout boolean);
end StepperDriver;

architecture Behavioral of StepperDriver is
signal PWMclock : STD_LOGIC := '0';
signal Motorphase : STD_LOGIC_VECTOR (3 downto 0) := "0011";
begin

    process(clk) 
    variable counter1 : integer := 0;
    begin
        if rising_edge(clk) then
            if (counter1 = 1000000) then
                PWMclock <= not PWMclock;    
                counter1 := 0;
            else 
                counter1 := counter1 + 1;
            end if;
        end if;
    end process;

    process(PWMclock) 
    variable int_count : integer range 2**8 downto 0 := 0;
    variable int_count2 : integer range 4 downto 0 := 0;
    begin
        if rising_edge(PWMclock) then
            if (stepperFinished = false) AND (IR = X"05") then
                 if int_count = 0 then 
                    Motorphase <= "0011";
                 elsif int_count = 1 then
                    Motorphase <= "1001";
                 elsif int_count = 1 then
                    Motorphase <= "1100";
                 elsif int_count = 1 then
                    Motorphase <= "0110";
                 end if;
                 if int_count = unsigned(dataBus) then
                    stepperFinished <= true;
                    int_count2 := 0;
                 end if;
                 int_count2 := int_count2 + 1;
                 int_count := int_count + 1;
            elsif (IR = X"00") then
                stepperFinished <= false;
                int_count := 0;
            end if;
        end if;
    end process;
    rightMotorPhase <= Motorphase;
    

end Behavioral;
