library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port(
        data1   : in  std_logic_vector(31 downto 0);
        data2   : in  std_logic_vector(31 downto 0);
        aluop   : in  std_logic_vector(3 downto 0);
        dataout : out std_logic_vector(31 downto 0);
        zflag   : out std_logic;
        nflag   : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(data1, data2, aluop)
        variable A, B    : signed(31 downto 0);
        variable result  : signed(31 downto 0);
    begin
        A := signed(data1);
        B := signed(data2);
        result := (others => '0');

        case aluop is
            when "0000" =>  result := A and B;          -- AND
            when "0001" =>  result := A or B;           -- OR
            when "0010" =>  result := A + B;            -- ADD
            when "0110" =>  result := A - B;            -- SUB
            when "1100" =>  result := not (A or B);     -- NOR
            when "0111" =>                              -- SLT
                if A < B then
                    result := (others => '0');
                    result(0) := '1';
                else
                    result := (others => '0');
                end if;
            when others =>
                result := (others => '0');
        end case;

        dataout <= std_logic_vector(result);
        if result = 0 then
    zflag <= '1';
else
    zflag <= '0';
end if;
        nflag   <= result(31);
    end process;
end Behavioral;

