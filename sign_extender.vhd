----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:32:46 11/22/2025 
-- Design Name: 
-- Module Name:    sign_extender - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity SignExtender is
    Port (
        imm_in  : in  std_logic_vector(15 downto 0);
        imm_out : out std_logic_vector(31 downto 0)
    );
end SignExtender;

architecture Behavioral of SignExtender is
begin
    imm_out <= std_logic_vector(resize(signed(imm_in), 32));
end Behavioral;


