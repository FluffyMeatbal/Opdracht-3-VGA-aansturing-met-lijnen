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
        Red, Green, Blue: in std_logic_vector(3 downto 0);
        Hsync, Vsync, video_ON: out std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
    end component;

    signal clk: std_logic;
    signal Red, Green, Blue: std_logic_vector(3 downto 0);
    signal Hsync, Vsync, video_ON: std_logic;
    signal vgaRed, vgaGreen, vgaBlue: std_logic_vector(3 downto 0);
    
--    signal verify : boolean:= true; 

begin

uut : VGA_aansturing port map(
    clk => clk,
    Red => Red,
    Green => Green,
    Blue => Blue,
    Hsync => Hsync,
    Vsync => Vsync,
    video_ON => video_ON,
    vgaRed => vgaRed,
    vgaGreen => vgaGreen,
    vgaBlue => vgaBlue
);

tb : process
begin
    Red <= "000"; Green <= "000"; Blue <= "000";    --Zwart
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when
--            (vgaRed = "000" 
--            and vgaGreen = "000" 
--            and vgaBlue = "000")
--            else false;
--        end if;
    end loop;

    Red <= "111"; Green <= "000"; Blue <= "000";    --Rood
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "111") 
--            and (vgaGreen = "000") 
--            and (vgaBlue = "000")
--            else false;
--        end if;
    end loop;
    
    Red <= "111"; Green <= "111"; Blue <= "000";    --Geel
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "111") 
--            and (vgaGreen = "111") 
--            and (vgaBlue = "000") 
--            else false;
--        end if;
    end loop;

    Red <= "000"; Green <= "111"; Blue <= "000";    --Groen
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "000") 
--            and (vgaGreen = "111") 
--            and (vgaBlue = "000") 
--            else false;
--        end if;
    end loop;
    
    Red <= "000"; Green <= "111"; Blue <= "111";    --Cyaan
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "000") 
--            and (vgaGreen = "111") 
--            and (vgaBlue = "111") 
--            else false;
--        end if;
    end loop;
    
    Red <= "000"; Green <= "000"; Blue <= "111";    --Blauw
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "000") 
--            and (vgaGreen = "000") 
--            and (vgaBlue = "111") 
--            else false;
--        end if;
    end loop;
    
    Red <= "111"; Green <= "000"; Blue <= "111";    --Magenta
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "111") 
--            and (vgaGreen = "000") 
--            and (vgaBlue = "111") 
--            else false;
--        end if;
    end loop;
    
    Red <= "111"; Green <= "111"; Blue <= "111";    --Wit
    
    for i in 0 to 418676 loop
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
        
--        if video_ON = '1' then
--            verify <= true when 
--            (vgaRed = "111") 
--            and (vgaGreen = "111") 
--            and (vgaBlue = "111") 
--            else false;
--        end if;
    end loop;
    
    wait;
end process;

end Behavioral;
