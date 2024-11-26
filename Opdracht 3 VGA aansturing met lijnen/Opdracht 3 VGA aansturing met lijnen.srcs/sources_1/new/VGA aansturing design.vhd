----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
signal deler : integer := 0;                --signaal voor de deler
signal sclk: std_logic;                     --gedeelde klok 
constant prscl : integer := 4;              --prescaler
signal EN : std_logic;                      --Enable

signal xTel : integer range 0 to 1023 := 0;
signal yTel : integer range 0 to 1023 := 0;
signal lineAdvance : std_logic;

signal H_sync : std_logic;
signal V_sync : std_logic;
signal vid_ON : std_logic;

begin

delerBlok: process(clk)
begin
    if rising_edge(clk) then
        if deler = prscl/2 then        --50% van periode voorbij
            sclk <= '1'; deler <= deler + 1;
        else
            if deler = prscl then      --100% van periode voorbij
                sclk <= '0'; deler <= 0;
            else
                deler <= deler + 1;
            end if;
        end if;
    end if;
end process delerBlok;

X_teller: process(clk, xTel, lineAdvance)
begin
    if rising_edge(sclk) then
        if xTel < 800 then
            xTel <= xTel + 1; lineAdvance <= '0';
        else
            xTel <= 0; lineAdvance <= '1';
        end if;
    end if;
end process X_teller;

Y_Teller: process(clk, yTel, lineAdvance)
begin
    if rising_edge(sclk) then
        if vid_ON = '1' then
            if lineAdvance = '1' then
                if yTel < 525 then
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
    if xTel > 655 and xTel < 752 then
        Hsync <= '0'; H_sync <= '0';
    elsif xTel < 640 then
        Hsync <= '1'; H_sync <= '0';
    end if;
end process HORsync;

VERTsync: process(yTel)
begin
    if yTel > 489 and yTel < 492 then
        Vsync <= '0'; V_sync <= '0';
    elsif yTel < 480 then
        Vsync <= '1'; V_sync <= '0';
    end if;
end process VERTsync;

video_ON <= V_sync and H_sync;
vid_ON <= V_sync and H_sync;

RGBsync: process(Red, Green, Blue, vid_ON)
begin
    if rising_edge(sclk) then
        if vid_ON = '1' then
            vgaRed <= Red;
            vgaGreen <= Green;
            vgaBlue <= Blue;
        end if;
    end if;
end process RGBsync;

end Behavioral;

