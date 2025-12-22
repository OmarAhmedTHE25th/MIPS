----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:35:23 11/22/2025 
-- Design Name: 
-- Module Name:    mux4to1 - Behavioral 
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

entity mux4to1 is
    port(
        a, b, c, d : in  STD_LOGIC_VECTOR(31 downto 0);
        sel        : in  STD_LOGIC_VECTOR(1 downto 0);
        y          : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux4to1;

architecture Behavioral of mux4to1 is
begin
    with sel select
        y <= a when "00",
             b when "01",
             c when "10",
             d when "11",
             (others => '0') when others;
end Behavioral;


