----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:28:52 11/22/2025 
-- Design Name: 
-- Module Name:    pc - Behavioral 
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

entity PC is
    Port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        pc_in  : in  std_logic_vector(5 downto 0);
        pc_out : out std_logic_vector(5 downto 0)
    );
end PC;

architecture Behavioral of PC is
signal reg_out: std_logic_vector(31 downto 0);

begin
	FlopR: entity work.FlopR
		port map(
			clk => clk,
			reset => reset,
			load => '1',
			d => X"000000" & "00" & pc_in,
			q => reg_out
		);
			pc_out <= reg_out(5 downto 0);
end Behavioral;

