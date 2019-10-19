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
signal PWMclock : STD_LOGIC := '0';
signal Motorphase : STD_LOGIC_VECTOR (3 downto 0) := "0011";
--signal stepCount : STD_LOGIC_VECTOR (7 downto 0);
signal stepCount : integer := 0;
signal int_count : integer := 0; -- counts total steps
begin

    process(clk) 
    variable counter1 : integer := 0;
    begin
        if rising_edge(clk) then
            if (counter1 = 100000) then
                PWMclock <= not PWMclock;    
                counter1 := 0;
                int_count <= int_count + 1;
            else 
                counter1 := counter1 + 1;
            end if;
            if (IR = X"00") then
                stepperFinished <= false;
            elsif int_count > stepCount then
                stepperFinished <= true;
                int_count <= 0;
           end if;
        end if;
    end process;

    process(PWMclock) 
    --variable int_count : integer := 0; -- counts total steps
    variable int_Phasecount : integer := 0; -- keeps track of current step
    begin
        if rising_edge(PWMclock) then
            if (stepperFinished = false) AND (IR = X"05") then
                 if    int_Phasecount = 1 then Motorphase <= b"0011";
                 elsif int_Phasecount = 2 then Motorphase <= b"1001";
                 elsif int_Phasecount = 3 then Motorphase <= b"1100";
                 elsif int_Phasecount = 4 then Motorphase <= b"0110";
                 end if;
                 --if int_count = unsigned(dataBus AND b"00111111") then -- bitmask to ignorte two most significant bits
                 --int_Phasecount := int_Phasecount + 1;
                 --if int_count >= stepCount then
                 --   int_count <= 0;
                 --end if;
                 --int_count <= int_count + 1;
                 if (dataBus OR b"01111111") = b"11111111" then -- check if reverse bit is set
                    int_Phasecount := int_Phasecount - 1; -- Move backwards
                    if int_Phasecount = 0 then int_Phasecount := 4;
                    end if;
                 else
                    int_Phasecount := int_Phasecount + 1; -- Move forward
                    if int_Phasecount = 5 then int_Phasecount := 1;
                    end if;
                 end if;
 --           else
 --               stepperFinished <= false;
 --               int_count := 0;
            end if;
        end if;
    end process;
    rightMotorPhase <= Motorphase;
    stepCount <= to_integer(unsigned(dataBus AND b"00111111")) * 100;
    
end Behavioral;
