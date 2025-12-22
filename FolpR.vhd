library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlopR is
    generic(N : integer := 32);
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        load  : in  std_logic;
        d     : in  std_logic_vector(N-1 downto 0);
        q     : out std_logic_vector(N-1 downto 0)
    );
end FlopR;

architecture Behavioral of FlopR is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;

    q <= q_reg;
end Behavioral;
