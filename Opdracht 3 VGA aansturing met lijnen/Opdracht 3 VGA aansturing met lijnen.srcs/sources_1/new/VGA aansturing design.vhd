----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Remco Pieper
-- 
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
Red, Green, Blue: in std_logic_vector(3 downto 0);
Hsync, Vsync, video_ON: out std_logic;
vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
);
end VGA_aansturing;

architecture Behavioral of VGA_aansturing is
signal sclk: std_logic;                             --gedeelde klok 
constant prscl : integer := 4;                      --prescaler

signal xTel : integer range 0 to 1023 := 0;
signal yTel : integer range 0 to 1023 := 0;
signal lineAdvance : std_logic;

signal H_sync : std_logic;
signal V_sync : std_logic;
signal vid_ON : std_logic;

begin

delerBlok: process(clk)
variable deler : integer range 0 to 1023 := 0;      --variabele voor de deler

begin
    if rising_edge(clk) then
        if deler = prscl/2 then                     --50% van periode voorbij
            sclk <= '1'; 
            deler := deler + 1;
        else
            if deler = prscl then                   --100% van periode voorbij
                sclk <= '0'; 
                deler := 0;
            else
                deler := deler + 1;
            end if;
        end if;
    end if;
end process delerBlok;

X_teller: process(sclk, xTel, lineAdvance)
begin
    if rising_edge(sclk) then
        if xTel < 799 then
            xTel <= xTel + 1;                       --verhoog xTel
            lineAdvance <= '0';
        else
            xTel <= 0;                              --xTel gaat terug naar het begin en yTel moet 1 omhoog
            lineAdvance <= '1';
        end if;
    end if;
end process X_teller;

Y_Teller: process(sclk, yTel, lineAdvance)
begin
    if rising_edge(sclk) then
        if lineAdvance = '1' then
            if yTel < 524 then
                yTel <= yTel + 1;
            else 
                yTel <= 0;
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
        H_sync <= '0';
    end if;
end process HORsync;

VERTsync: process(yTel)
begin
    if yTel > 489 and yTel < 492 then           --Verticale puls 2 lijnen breed
        V_sync <= '0';
    elsif yTel < 480 then
        V_sync <= '1';
    else
        V_sync <= '0';
    end if;
end process VERTsync;

vid_ON <= V_sync and H_sync;

RGBsync: process(sclk, Red, Green, Blue, vid_ON)
begin
    if rising_edge(sclk) then
        if vid_ON = '1' then
            vgaRed <= Red;
            vgaGreen <= Green;
            vgaBlue <= Blue;
        end if;
    end if;
end process RGBsync;

Hsync <= H_sync;
Vsync <= V_sync;
video_ON <= vid_ON;

end Behavioral;

