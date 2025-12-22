----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:35 11/21/2025 
-- Design Name: 
-- Module Name:    test - Behavioral 
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

entity MUX2to1 is
    Port (
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Sel  : in  STD_LOGIC;
        Y    : out STD_LOGIC
    );
end MUX2to1;

architecture Behavioral of MUX2to1 is
begin
    process(A, B, Sel)
    begin
        if Sel = '0' then
            Y <= A;
        else
            Y <= B;
        end if;
    end process;
end Behavioral;


