----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:15:03 12/05/2025 
-- Design Name: 
-- Module Name:    mux2to1_6bits - Behavioral 
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

entity mux2to1_6bit is
    Port(
        a   : in  STD_LOGIC_VECTOR(5 downto 0);
        b   : in  STD_LOGIC_VECTOR(5 downto 0);
        sel : in  STD_LOGIC;
        y   : out STD_LOGIC_VECTOR(5 downto 0)
    );
end mux2to1_6bit;

architecture Behavioral of mux2to1_6bit is
begin
    y <= a when sel = '0' else b;
end Behavioral;
