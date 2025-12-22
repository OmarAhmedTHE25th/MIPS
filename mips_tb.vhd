library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench entity has no ports
entity tb_MIPS_Processor is
end tb_MIPS_Processor;

architecture Behavioral of tb_MIPS_Processor is

    -- 1. Component Declaration for the Unit Under Test (UUT)
    component MIPS_Processor
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            alu_output : out std_logic_vector(31 downto 0);
            write_data : out std_logic_vector(31 downto 0)
        );
    end component;

    -- 2. Signal Declarations to connect to UUT
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal alu_output : std_logic_vector(31 downto 0);
    signal write_data : std_logic_vector(31 downto 0);

    -- 3. Clock Period Definition
    constant clk_period : time := 10 ns;

begin

    -- 4. Instantiate the Unit Under Test (UUT)
    uut: MIPS_Processor 
        port map (
            clk        => clk,
            reset      => reset,
            alu_output => alu_output,
            write_data => write_data
        );

    -- 5. Clock Generation Process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 6. Stimulus Process
    stim_proc: process
    begin		
        -- Hold reset state for 20 ns
        reset <= '1';
        wait for 20 ns;	
        
        -- Release reset
        reset <= '0';

        -- The CPU will now start fetching instructions from 'imem'.
        -- Since this is a CPU, the "stimulus" is actually the 
        -- machine code stored inside your 'imem' component.
        
        -- Let the simulation run for a set amount of time
        wait for 10000 ns;

        -- End simulation
        assert false report "Simulation Finished" severity failure;
        wait;
    end process;

end Behavioral;