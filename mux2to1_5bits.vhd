----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:17:15 11/24/2025 
-- Design Name: 
-- Module Name:    mux2to1_5bits - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

entity mux2to1_5bit is
    port(
        a, b : in  STD_LOGIC_VECTOR(4 downto 0);
        sel  : in  STD_LOGIC;
        y    : out STD_LOGIC_VECTOR(4 downto 0)
    );
end mux2to1_5bit;

architecture Behavioral of mux2to1_5bit is
begin
    y <= a when sel = '0' else b;
end Behavioral;
