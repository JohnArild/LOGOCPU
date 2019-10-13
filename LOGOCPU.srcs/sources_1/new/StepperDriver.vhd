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
begin
    process(clk) 
    variable int_count : integer range 2**8 downto 0 := 0;
    begin
        if rising_edge(clk) then
            if (stepperFinished = false) AND (IR = X"05") then
                 int_count := int_count + 1;
                 if int_count = unsigned(dataBus) then
                    stepperFinished <= true;
                 end if;
            elsif (IR = X"00") then
                stepperFinished <= false;
            end if;
        end if;
    end process;
    
    

end Behavioral;
