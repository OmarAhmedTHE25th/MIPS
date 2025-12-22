library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux32to1 is
    port(
        sel  : in  std_logic_vector(4 downto 0);
        din0 : in  std_logic_vector(31 downto 0);
        din1 : in  std_logic_vector(31 downto 0);
        din2 : in  std_logic_vector(31 downto 0);
        din3 : in  std_logic_vector(31 downto 0);
        din4 : in  std_logic_vector(31 downto 0);
        din5 : in  std_logic_vector(31 downto 0);
        din6 : in  std_logic_vector(31 downto 0);
        din7 : in  std_logic_vector(31 downto 0);
        din8 : in  std_logic_vector(31 downto 0);
        din9 : in  std_logic_vector(31 downto 0);
        din10 : in std_logic_vector(31 downto 0);
        din11 : in std_logic_vector(31 downto 0);
        din12 : in std_logic_vector(31 downto 0);
        din13 : in std_logic_vector(31 downto 0);
        din14 : in std_logic_vector(31 downto 0);
        din15 : in std_logic_vector(31 downto 0);
        din16 : in std_logic_vector(31 downto 0);
        din17 : in std_logic_vector(31 downto 0);
        din18 : in std_logic_vector(31 downto 0);
        din19 : in std_logic_vector(31 downto 0);
        din20 : in std_logic_vector(31 downto 0);
        din21 : in std_logic_vector(31 downto 0);
        din22 : in std_logic_vector(31 downto 0);
        din23 : in std_logic_vector(31 downto 0);
        din24 : in std_logic_vector(31 downto 0);
        din25 : in std_logic_vector(31 downto 0);
        din26 : in std_logic_vector(31 downto 0);
        din27 : in std_logic_vector(31 downto 0);
        din28 : in std_logic_vector(31 downto 0);
        din29 : in std_logic_vector(31 downto 0);
        din30 : in std_logic_vector(31 downto 0);
        din31 : in std_logic_vector(31 downto 0);
        dout : out std_logic_vector(31 downto 0)
    );
end Mux32to1;

architecture Behavioral of Mux32to1 is
begin

    process(sel, din0, din1, din2, din3, din4, din5, din6, din7,
                  din8, din9, din10, din11, din12, din13, din14, din15,
                  din16, din17, din18, din19, din20, din21, din22, din23,
                  din24, din25, din26, din27, din28, din29, din30, din31)
    begin
        case sel is
            when "00000" => dout <= din0;
            when "00001" => dout <= din1;
            when "00010" => dout <= din2;
            when "00011" => dout <= din3;
            when "00100" => dout <= din4;
            when "00101" => dout <= din5;
            when "00110" => dout <= din6;
            when "00111" => dout <= din7;
            when "01000" => dout <= din8;
            when "01001" => dout <= din9;
            when "01010" => dout <= din10;
            when "01011" => dout <= din11;
            when "01100" => dout <= din12;
            when "01101" => dout <= din13;
            when "01110" => dout <= din14;
            when "01111" => dout <= din15;
            when "10000" => dout <= din16;
            when "10001" => dout <= din17;
            when "10010" => dout <= din18;
            when "10011" => dout <= din19;
            when "10100" => dout <= din20;
            when "10101" => dout <= din21;
            when "10110" => dout <= din22;
            when "10111" => dout <= din23;
            when "11000" => dout <= din24;
            when "11001" => dout <= din25;
            when "11010" => dout <= din26;
            when "11011" => dout <= din27;
            when "11100" => dout <= din28;
            when "11101" => dout <= din29;
            when "11110" => dout <= din30;
            when others  => dout <= din31;
        end case;
    end process;

end Behavioral;
