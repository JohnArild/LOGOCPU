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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPUmodule is
    Port ( 
                LED : out STD_LOGIC_VECTOR (7 downto 0);
                rst : in STD_LOGIC;
                clk : in STD_LOGIC;
                rstLED : out STD_LOGIC
         );
         
end CPUmodule;

architecture Master of CPUmodule is
    signal mAddress : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal    mData : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       PC : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       IR : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal       DR : STD_LOGIC_VECTOR (7 downto 0) := X"00";
begin    

    memory_unit: entity work.ROMmodule(Behavioral)
        port map(mAddress=>mAddress, mData=>mData);
    
    --mAddress <= "00000001";
    --LED <= mData;

-- Psudo Code
-- Set mAddress to PC
-- Set IR to mData
-- Increment PC
-- Decode/Execute IR

    process(clk) 
        variable int_count : integer range 7 downto 0 := 0;
    begin
        if rst = '0' then 
            int_count := 0;
            PC <= (others=>'0');
            mAddress <= "00000001";
        elsif rising_edge(clk) then
            if int_count = 0 then 
                mAddress <= PC;
            elsif int_count = 1 then 
                IR <= mDATA;
            elsif int_count = 2 then 
                if PC < 8 then 
                    PC <= PC + 1;
                else 
                    PC <= "00000000";
                end if;
                int_count := 0;
            end if;
            int_count := int_count + 1;
        end if; 
        
    end process;

    LED <= mData;
    rstLED <= rst;

end Master;
