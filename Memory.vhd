----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:08:05 11/22/2025 
-- Design Name: 
-- Module Name:    DataMemory - Behavioral 
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

entity DataMemory is
    Port(
        clk      : in  std_logic;                         -- system clock
        memRead  : in  std_logic;                         -- read enable
        memWrite : in  std_logic;                         -- write enable
        address  : in  std_logic_vector(31 downto 0);     -- address
        writeData: in  std_logic_vector(31 downto 0);     -- data to write (SW)
        readData : out std_logic_vector(31 downto 0)      -- data read  (LW)
    );
end DataMemory;

architecture Behavioral of DataMemory is

    -- Memory array: 256 words x 32 bits (1 KB)
    type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal RAM: ram_type := (others => (others => '0'));

begin

    -- Synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if (memWrite = '1') then
                RAM(to_integer(unsigned(address(9 downto 2)))) <= writeData;
            end if;
        end if;
    end process;

    -- Asynchronous read
    readData <= RAM(to_integer(unsigned(address(9 downto 2)))) when memRead='1'
                else (others => '0');

end Behavioral;
