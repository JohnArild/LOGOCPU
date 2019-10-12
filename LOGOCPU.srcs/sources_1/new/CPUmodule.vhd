----------------------------------------------------------------------------------
-- Company: 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 10/12/2019 09:49:33 AM
-- Design Name: 
-- Module Name: CPUmodule - Master
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

entity CPUmodule is
    Port ( 
                LED : out STD_LOGIC_VECTOR (7 downto 0));
end CPUmodule;

architecture Master of CPUmodule is
    signal mAddress, mData : STD_LOGIC_VECTOR (7 downto 0);
begin    
    memory_unit: entity work.ROMmodule(Behavioral)
        port map(mAddress=>mAddress, mData=>mData);
    
    mAddress <= "00000001";
    LED <= mData;

-- Psudo Code
-- Set mAddress to PC
-- Set IR to mData
-- Increment PC
-- Decode/Execute IR


end Master;
