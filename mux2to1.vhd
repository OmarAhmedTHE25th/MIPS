----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:18:01 11/21/2025 
-- Design Name: 
-- Module Name:    mux2to1 - Behavioral 
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

entity mux2to1 is
    port(
        a, b : in  STD_LOGIC_VECTOR(31 downto 0);
        sel  : in  STD_LOGIC;
        y    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux2to1;

architecture Behavioral of mux2to1 is
begin
    y <= a when sel = '0' else b;
end Behavioral;


