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
use IEEE.NUMERIC_STD.ALL;

entity ROMmodule is

    generic ( 
        LDR  : STD_LOGIC_VECTOR (7 downto 0):= X"01";
        DECR : STD_LOGIC_VECTOR (7 downto 0):= X"02";
        JMPZ : STD_LOGIC_VECTOR (7 downto 0):= X"03";
        INCR : STD_LOGIC_VECTOR (7 downto 0):= X"04";
        MxT  : STD_LOGIC_VECTOR (7 downto 0):= X"05";
        PDN  : STD_LOGIC_VECTOR (7 downto 0):= X"06";
        PUP  : STD_LOGIC_VECTOR (7 downto 0):= X"07"
        );
    
    Port ( mAddress : in STD_LOGIC_VECTOR (7 downto 0);
              mData : out STD_LOGIC_VECTOR (7 downto 0));
             
end ROMmodule;

architecture Behavioral of ROMmodule is
    type rom_type is array (0 to 255) of STD_LOGIC_VECTOR (7 downto 0);
    constant ROM_Content : rom_type :=( 
    LDR  , X"55", LDR  , X"0F", DECR , INCR , INCR , INCR , PDN  , INCR , INCR , DECR , MxT  , X"3F", LDR  , X"01",
    PUP  , MxT  , X"FF", JMPZ , X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00"
    );
begin
    mData <= ROM_Content(to_integer(unsigned(mAddress)));
end Behavioral;
