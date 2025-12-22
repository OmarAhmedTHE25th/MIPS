----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:31:34 11/22/2025 
-- Design Name: 
-- Module Name:    alu32 - Behavioral 
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

entity ALU is
    port(
        data1   : in  std_logic_vector(31 downto 0);
        data2   : in  std_logic_vector(31 downto 0);
        aluop   : in  std_logic_vector(3 downto 0);
        dataout : out std_logic_vector(31 downto 0);
        nflag   : out std_logic;
        zflag   : out std_logic
    );
end ALU;

architecture Behavioral of ALU is

    signal A, B : signed(31 downto 0);
    signal result : signed(31 downto 0);

begin
    A <= signed(data1);
    B <= signed(data2);

    process(A, B, aluop)
    begin
        case aluop is
            when "0000" =>  result <= A and B;                          -- AND
            when "0001" =>  result <= A or B;                           -- OR
            when "0010" =>  result <= A + B;                            -- ADD
            when "0110" =>  result <= A - B;                            -- SUB
            when "1100" =>  result <= not (A or B);                     -- NOR
            when "0111" =>                                              -- SLT
                if A < B then
                    result <= (others => '0'); result(0) <= '1';
                else
                    result <= (others => '0');
                end if;
            when others =>
                result <= (others => '0');
        end case;
    end process;

    dataout <= std_logic_vector(result);

    -- Zero flag
    zflag <= '1' when result = 0 else '0';
    nflag <= '1' when result(31) = '1' else '0';

end Behavioral;

