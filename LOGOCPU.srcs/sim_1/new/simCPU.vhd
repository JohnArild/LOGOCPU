----------------------------------------------------------------------------------
-- 
-- Engineer: John Arild Lolland
-- 
-- Create Date: 2019-10-12 11:59:22
--
-- Module Name: simCPU - Behavioral
-- Project Name: LOGO CPU
-- Target Devices: turtle car
-- Tool Versions: Vivado 2019.1.1
-- Description: School assignment CCW2 for DFDV3100
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

entity simCPU is

end simCPU;

architecture tb of simCPU is
    signal             LED : STD_LOGIC_VECTOR (7 downto 0);
    signal rightMotorPhase : STD_LOGIC_VECTOR (3 downto 0);
    signal  leftMotorPhase : STD_LOGIC_VECTOR (3 downto 0);
    signal             rst : STD_LOGIC;
    signal             clk : STD_LOGIC;
    signal        servoPWM : STD_LOGIC;
  --signal      rstLED : STD_LOGIC;
    constant    clk_period : time := 10 ns;
begin

    uut : entity work.CPUmodule
    port map (clk => clk, 
              rst => rst, 
              LED => LED
              --PCR => PCR
              );

clk_process: process 
   begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
   end process;

   stim_proc: process
      begin
        rst <= '0';
        wait for clk_period * 1;
        rst <= '1';  
        wait for clk_period * 100;      
      end process ;

end tb;
