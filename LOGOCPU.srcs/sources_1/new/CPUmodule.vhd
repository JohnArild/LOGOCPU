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
         LED : out STD_LOGIC_VECTOR (7 downto 0):= X"00";
         --PCR : out STD_LOGIC_VECTOR (7 downto 0):= X"00";
         rst : in STD_LOGIC;
         clk : in STD_LOGIC
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
    signal   enable : boolean := TRUE;
begin    

    memory_unit: entity work.ROMmodule(Behavioral)
        port map(mAddress=>mAddress, mData=>mData, enable=>enable);
    
    process(clk) 
    begin
        if rst = '0' then 
            PC <= (others=>'0');
        elsif rising_edge(clk) then
            if enable then
                PC <= PC_next;  -- Update Program Counter
                DR <= DR_next;  -- Update Data Register
                IR <= IR_next;  -- Update Instruction Register
            end if;
        end if;
    end process;

    PC_next <=  mData  when (IR = JMPZ AND DR = X"00") else
                PC + 1;
    
    DR_next <=  DR + 1 when (IR = INCR) else
                DR - 1 when (IR = DECR) else
                mData  when (IR = LDR ) else
                DR;
    
    IR_next <=  X"00" when (IR = LDR ) else
                mData;
    
    mAddress <= PC;
    
    --LED <= PC;
    --LED <= mAddress;
    --LED <= mData;
    LED <= DR; -- debug
    --PCR <= PC;

end Master;
