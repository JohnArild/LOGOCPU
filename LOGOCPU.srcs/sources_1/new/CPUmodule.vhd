----------------------------------------------------------------------------------
-- 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 2019-10-12 09:49:33
--
-- Module Name: CPUmodule - Master
-- Project Name: LOGO CPU
-- Target Devices: turtle car
-- Tool Versions: Vivado 2019.1.1
-- Description: School assignment CCW2 for DFDV3100
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPUmodule is

    generic ( 
        LDR  : STD_LOGIC_VECTOR (7 downto 0):= X"01";
        DECR : STD_LOGIC_VECTOR (7 downto 0):= X"02";
        JMPZ : STD_LOGIC_VECTOR (7 downto 0):= X"03";
        INCR : STD_LOGIC_VECTOR (7 downto 0):= X"04";
        MxT  : STD_LOGIC_VECTOR (7 downto 0):= X"05";
        PDN  : STD_LOGIC_VECTOR (7 downto 0):= X"06";
        PUP  : STD_LOGIC_VECTOR (7 downto 0):= X"07"
        );
        
    Port ( 
                LED : out STD_LOGIC_VECTOR (7 downto 0):= X"00"; -- debug
    rightMotorPhase : out STD_LOGIC_VECTOR (3 downto 0);
     leftMotorPhase : out STD_LOGIC_VECTOR (3 downto 0);
           servoPWM : out STD_LOGIC;
                rst : in  STD_LOGIC;
                clk : in  STD_LOGIC
         );
         
end CPUmodule;

architecture Master of CPUmodule is
    signal mAddress : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal    mData : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       PC : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal  PC_next : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       IR : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal  IR_next : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       DR : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal  DR_next : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal    CPUen : boolean := TRUE;
    signal stepperFinished : boolean := FALSE;
begin    
------------------------------------
--Define modules

    memory_unit: entity work.ROMmodule(Behavioral)
        port map(mAddress=>mAddress, mData=>mData);
        
    stepper_unit: entity work.StepperDriver(Behavioral)
        port map(       dataBus => mData,
                rightMotorPhase => rightMotorPhase,
                 leftMotorPhase => leftMotorPhase,
                            clk => clk,
                stepperFinished => stepperFinished,
                             IR => IR);
                
    servo_unit: entity work.ServoDriver(Behavioral)
        port map(IR => IR, servoPWM => servoPWM, clk  => clk);
 
 --------------------------------------   
 --CPU Code:
 
    process(clk) 
    begin
        if rst = '0' then 
            PC <= (others=>'0'); -- Reset Program Counter
            DR <= (others=>'0'); -- Reset Data Register
            IR <= (others=>'0'); -- Reset Instruction Register
        elsif rising_edge(clk) then
            if CPUen then
                PC <= PC_next;  -- Update Program Counter
                DR <= DR_next;  -- Update Data Register
                IR <= IR_next;  -- Update Instruction Register
            end if;
        end if;
    end process;

    -- PC_next is PC+1 unless there is a jump instruction
    PC_next <=  mData  when (IR = JMPZ AND NOT DR = X"00") else
                PC + 1;
    
    -- DR_next is DR unless there is a INCR, DECR, LDR or MxT instruction
    DR_next <=  DR + 1 when (IR = INCR) else
                DR - 1 when (IR = DECR) else
                mData  when (IR = LDR ) OR (IR = MxT) else
                DR;
    
    -- IR_next is whatever is in the memory unless there is a LDR or MxT instruction.
    IR_next <=  X"00" when (IR = LDR ) else
                IR when (IR = MxT) AND (stepperFinished = FALSE)  else
                X"00" when (IR = MxT) AND (stepperFinished = TRUE) else 
                mData;
                
    --CPUen is used by the stepper-driver to halt the CPU
    CPUen   <=  FALSE when (IR = MxT) AND (stepperFinished = FALSE) else
                TRUE;
    
    -- the address buss (to the ROM) is always same as current PC (Program Counter)
    mAddress <= PC;
    
    -- LEDs shows the Data Register. Useful for debugging
    LED <= DR; -- debug

end Master;
