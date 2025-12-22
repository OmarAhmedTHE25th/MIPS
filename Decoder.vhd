library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder_5to32 is
    port(
        sel  : in  std_logic_vector(4 downto 0);
        dout : out std_logic_vector(31 downto 0)
    );
end Decoder_5to32;

architecture Behavioral of Decoder_5to32 is
begin
    process(sel)
    begin
        dout <= (others => '0');
        dout(to_integer(unsigned(sel))) <= '1';
    end process;
end Behavioral;
