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
           IR              : in    STD_LOGIC_VECTOR (7 downto 0);
           stepperFinished : inout boolean);
end StepperDriver;

architecture Behavioral of StepperDriver is
signal StepperClock : STD_LOGIC := '0';
signal Motorphase : STD_LOGIC_VECTOR (3 downto 0) := "0011";
--signal stepCount : STD_LOGIC_VECTOR (7 downto 0);
signal stepCount : integer := 0;
signal int_count : integer := 0; -- counts total steps
begin

    process(clk) 
    variable counter1 : integer := 0;
    begin
        if rising_edge(clk) then
            -- Generate stepper clock. This determines the speed of the stepper motors
            -- clk is 100MHz, StepperClock is 500Hz. This means new step every 2ms.
            if (counter1 = 100000) then
                StepperClock <= not StepperClock;    
                counter1 := 0;
                int_count <= int_count + 1;
            else 
                counter1 := counter1 + 1;
            end if;
            -- stepperFinished is used to determine if CPU should halt or not
            if (IR = X"00") then
                stepperFinished <= false;
                int_count <= 0;
            elsif int_count > stepCount then
                stepperFinished <= true;
                int_count <= 0;
           end if;
        end if;
    end process;

    process(StepperClock) 
    variable int_Phasecount : integer := 0; -- keeps track of current step
    begin
        if rising_edge(StepperClock) then
            if (stepperFinished = false) AND (IR = X"05") then
                 if    int_Phasecount = 1 then Motorphase <= b"0011";
                 elsif int_Phasecount = 2 then Motorphase <= b"1001";
                 elsif int_Phasecount = 3 then Motorphase <= b"1100";
                 elsif int_Phasecount = 4 then Motorphase <= b"0110";
                 end if;
                 -- Reverse if dataBus 2 MSB are 11
                 if (dataBus OR b"00111111") = b"11111111" then 
                    int_Phasecount := int_Phasecount - 1; -- Move backwards
                    if int_Phasecount = 0 then int_Phasecount := 4;
                    end if;
                 else
                    int_Phasecount := int_Phasecount + 1; -- Move forward
                    if int_Phasecount = 5 then int_Phasecount := 1;
                    end if;
                 end if;
            end if;
        end if;
    end process;
    
    -- stepCount ignores 2 MSB of dataBus since they are used for controlling direction
    -- the remaining 6 MSB is multiplied to give a more reasonable step count.
    stepCount <= to_integer(unsigned(dataBus AND b"00111111")) * 100;
    
    -- Right Motor is deactivated when dataBus 2 MSB are 01
    rightMotorPhase <= b"0000" when (dataBus OR b"00111111") = b"01111111" else
                       Motorphase;
    
    -- Left Motor is deactivated when dataBus 2 MSB are 10
    leftMotorPhase  <= b"0000" when (dataBus OR b"00111111") = b"10111111" else
                       Motorphase;
end Behavioral;
