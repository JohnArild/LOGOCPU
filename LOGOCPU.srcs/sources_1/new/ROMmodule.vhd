----------------------------------------------------------------------------------
-- 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 2019-10-12
--
-- Module Name: ROMmodule - Behavioral
-- Project Name: LOGO CPU
-- Target Devices: turtle car
-- Tool Versions: Vivado 2019.1.1
-- Description: School assignment CCW2 for DFDV3100
-- 
----------------------------------------------------------------------------------

-- ROM used for Logo-CPU.
-- shall contain list of instructions

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROMmodule is
    Port ( mAddress : inout STD_LOGIC_VECTOR (7 downto 0);
              mData : inout STD_LOGIC_VECTOR (7 downto 0));
end ROMmodule;

architecture Behavioral of ROMmodule is

begin

process (mAddress) begin
    case mAddress is
        when "00000000" => mData <= "00000000"; 
        when "00000001" => mData <= "01010101"; -- for testing.
        when OTHERS => mData <= "00000000";
    end case;
end process;

end Behavioral;
