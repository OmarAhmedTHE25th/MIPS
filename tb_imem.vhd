library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_imem is
-- Testbench has no ports
end tb_imem;

architecture Behavioral of tb_imem is

    -- Component Declaration
    component imem
        port(
            a  : in  std_logic_vector(5 downto 0);
            rd : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal a_tb  : std_logic_vector(5 downto 0) := (others => '0');
    signal rd_tb : std_logic_vector(31 downto 0);

begin

    -- Instantiate UUT
    uut: imem
        port map (
            a  => a_tb,
            rd => rd_tb
        );

    -- Stimulus Process
    stim_proc: process
    begin		
        -- Wait for file loading logic in imem to settle
        wait for 100 ns;

        -- Test Address 0
        a_tb <= "000000";
        wait for 40 ns;
        -- Removing to_hstring and using report for basic tracking
        report "Checked Address 00";

        -- Test Address 1
        a_tb <= "000001";
        wait for 40 ns;
        report "Checked Address 01";

        -- Test Address 2
        a_tb <= "000010";
        wait for 40 ns;
        report "Checked Address 02";

        -- Test a specific high address
        a_tb <= "001010"; 
        wait for 40 ns;
        report "Checked Address 10";

        wait;
    end process;

end Behavioral;