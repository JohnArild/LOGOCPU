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

entity ServoDriver is
    Port ( servoPos : in  STD_LOGIC;
           servoPWM : out STD_LOGIC;
           clk      : in STD_LOGIC);
end ServoDriver;

architecture Behavioral of ServoDriver is

begin


end Behavioral;
