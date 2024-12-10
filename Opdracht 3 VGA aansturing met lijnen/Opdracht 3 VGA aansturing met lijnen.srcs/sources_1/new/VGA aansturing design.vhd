----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Remco Pieper
-- Studentnummer: 1859875
-- Create Date: 20.11.2024 19:32:54
-- Design Name: 
-- Module Name: VGA aansturing design - Behavioral
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
-- Eisen:
-- Lijnkleur is rood
-- Achtergrond is geel
-- Breedte van de lijn is 4 pixels
-- De afstand tussen de lijnen is 16 pixels
-- Horizontale lijnen
-- Er worden 3 lijnen afgebeeld
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_aansturing is
Port (
clk: in std_logic;
btnU, btnD: in std_logic;
Hsync, Vsync, video_ON: out std_logic;
vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
);
end VGA_aansturing;

architecture Behavioral of VGA_aansturing is
signal enable: std_logic;                               --gedeelde klok 
constant prscl : integer := 4;                          --prescaler
constant tweeHzSCL : integer := 50000000;               --prescaler voor 2Hz teller

signal tweeHz : std_logic;                              --2Hz klok signaal
signal btnUreg : std_logic;                             --register voor omhoog knop
signal btnDreg : std_logic;                             --register voor omlaag knop
signal lijnTel: integer range 0 to 511 := 0;            --teller voor de lijn

signal xTel : integer range 0 to 1023 := 0;
signal yTel : integer range 0 to 1023 := 0;

signal H_sync : std_logic;
signal V_sync : std_logic;
signal vid_ON : std_logic;

signal Red, Green, Blue: std_logic_vector(3 downto 0);  --signaal voor kleuren

begin

delerBlok: process(clk)
variable deler : integer range 0 to 511 := 1;           --variabele voor de deler

begin
    if rising_edge(clk) then
        if deler = prscl / 4 then                       --25% van periode voorbij 
            enable <= '1';
        else
            enable <= '0';
        end if;
        
        if deler = prscl then                           --100% van periode voorbij 
            deler := 1;
        else
            deler := deler + 1;
        end if;
    end if;
end process delerBlok;

X_teller: process(clk, enable, xTel)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel < 799 then
                xTel <= xTel + 1;                       --verhoog xTel
            else
                xTel <= 0;                              --xTel gaat terug naar het begin
            end if;
        end if;
    end if;
end process X_teller;

Y_Teller: process(clk, enable, yTel)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel = 799 then                          --xTel is aan het eind
                if yTel < 524 then
                    yTel <= yTel + 1;
                else 
                    yTel <= 0;
                end if;
            end if;
        end if;
    end if;
end process Y_teller;

HORsync: process(xTel)
begin
    if xTel > 655 and xTel < 752 then           --Horizontale puls 96 lijnen breed
        H_sync <= '0';
    elsif xTel < 640 then
        H_sync <= '1';
    else
        H_sync <= '1';
    end if;
end process HORsync;

VERTsync: process(yTel)
begin
    if yTel > 489 and yTel < 492 then           --Verticale puls 2 lijnen breed
        V_sync <= '0';
    elsif yTel < 480 then
        V_sync <= '1';
    else
        V_sync <= '1';
    end if;
end process VERTsync;

video_ON_sync: process(xTel, yTel)
begin
    if xTel < 640 and yTel < 480 then
        vid_ON <= '1';
    else
        vid_ON <= '0';
    end if;
end process video_ON_sync;

RGBsync: process(clk, enable, Red, Green, Blue, vid_ON)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if vid_ON = '1' then
                vgaRed <= Red;
                vgaGreen <= Green;
                vgaBlue <= Blue;
            else
                vgaRed <= "0000";
                vgaGreen <= "0000";
                vgaBlue <= "0000";
            end if;
        end if;
    end if;
end process RGBsync;

Hsync <= H_sync;
Vsync <= V_sync;
video_ON <= vid_ON;

miniCLK: process(clk)
variable deler: integer range 0 to tweeHzSCL-1 := 0;
begin
if rising_edge(clk) then
    if deler < tweeHzSCL then
        deler := deler + 1;
    else
        deler := 0;
    end if;
    
    if deler < tweeHzSCL / 2 then
        tweeHz <= '1';
    else
        tweeHz <= '0';
    end if;
end if;
end process miniCLK;

knopRegistratie: process(clk, btnU, btnD)
begin
if rising_edge(clk) then
    if btnU = '1' xor btnD = '1' then
        btnUreg <= btnU;
        btnDreg <= btnD;
    end if;
end if;
end process knopRegistratie;

lijnTeller: process(tweeHz, btnUreg, btnDreg)
begin
if rising_edge(tweeHz) then
    if btnUreg = '1' then
        if lijnTel < 480 - 44 then
            lijnTel <= lijnTel + 1;
        else
            lijnTel <= 0;
        end if;
    end if;
    if btnDreg = '1' then
        if lijnTel > 0 then
            lijnTel <= lijnTel - 1;
        else
            lijnTel <= 480 - 44;
        end if;
    end if;
end if;
end process lijnTeller;

lijnen: process(clk, enable, lijnTel, yTel)
begin
if rising_edge(clk) then
    if enable = '1' then
        if yTel >= lijnTel and yTel < lijnTel +4 then
            Red <= "1111";
            Green <= "0000";
            Blue <= "0000";
        
        elsif yTel >= lijnTel + 20 and yTel < lijnTel + 24 then
            Red <= "1111";
            Green <= "0000";
            Blue <= "0000";
        
        elsif yTel >= lijnTel + 40 and yTel < lijnTel + 44 then
            Red <= "1111";
            Green <= "0000";
            Blue <= "0000";
        
        else 
            Red <= "1111";
            Green <= "1111";
            Blue <= "0000";
            
        end if;
    end if;
end if;
end process lijnen;

end Behavioral;

