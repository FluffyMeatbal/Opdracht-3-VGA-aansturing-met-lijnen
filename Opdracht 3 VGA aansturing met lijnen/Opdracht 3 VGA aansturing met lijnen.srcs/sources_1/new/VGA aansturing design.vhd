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
Port (clk: in std_logic);
end VGA_aansturing;

architecture Behavioral of VGA_aansturing is
signal deler : integer := 0;
signal sclk: std_logic;
constant deelFactor : integer := 4;
signal EN : std_logic;

signal xTel : integer range 0 to 1023 := 0;
signal yTel : integer range 0 to 1023 := 0;
signal lineAdvance : std_logic;
signal video_ON : std_logic;
begin

delerBlok: process(clk)
begin
    if rising_edge(clk) then
        if deler = deelFactor/2 then
            sclk <= '1'; deler <= deler + 1;
        else
            if deler = deelFactor then
                sclk <= '0'; deler <= 0;
            else
                deler <= deler + 1;
            end if;
        end if;
    end if;
end process delerBlok;

X_teller: process(clk)
begin
    if rising_edge(clk) then
        if rising_edge(sclk) then
            if xTel < 800 then
                xTel <= xTel + 1; lineAdvance <= '0';
            else
                xTel <= 0; lineAdvance <= '1';
            end if;
        end if;
    end if;
end process X_teller;

Y_Teller: process(clk)
begin
    if rising_edge(clk) then
        if video_ON = '1' then
            if lineAdvance = '0' then
                if yTel < 525 then
                   yTel <= yTel + 1;
                else 
                   yTel <= 0;
                end if;
            end if;
        end if;
    end if;
end process Y_teller;

end Behavioral;

