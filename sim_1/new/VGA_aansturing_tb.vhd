----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2024 16:13:33
-- Design Name: 
-- Module Name: VGA_aansturing_tb - Behavioral
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

entity VGA_aansturing_tb is
--  Port ( );
end VGA_aansturing_tb;

architecture Behavioral of VGA_aansturing_tb is

    component VGA_aansturing is
    Port (
        clk: in std_logic;
        btnU, btnD: in std_logic;
        Hsync, Vsync, video_ON: out std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
    end component;

    signal clk: std_logic;
    signal Up, Down: std_logic;
    signal Hsync, Vsync, video_ON: std_logic;
    signal vgaRed, vgaGreen, vgaBlue: std_logic_vector(3 downto 0);
    
--    signal verify : boolean:= true; 

begin

uut: VGA_aansturing port map(
    clk => clk,
    btnU => Up,
    btnD => down,
    Hsync => Hsync,
    Vsync => Vsync,
    video_ON => video_ON,
    vgaRed => vgaRed,
    vgaGreen => vgaGreen,
    vgaBlue => vgaBlue
    
);

clk_gen: process
begin
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
end process;

tb: process
begin
    Up <= '1';
    wait for 10 ns;
    Up <= '0';
    wait for 5 ms;
    Down <= '1';
    wait for 10 ns;
    Down <= '0';
    wait for 5 ms;
    
    wait;                                               --Einde van de simulatie
end process;

--validation: process
--begin
--wait until rising_edge(clk);
--if video_ON = '1' then
--    verify <= true when 
--        (vgaRed = Red) 
--        and (vgaGreen = Green) 
--        and (vgaBlue = Blue) 
--    else false;
--end if;

--end process;

end Behavioral;
