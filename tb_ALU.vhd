library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is

    -- Component declaration (match your ALU entity)
    component ALU
        port(
            data1   : in  std_logic_vector(31 downto 0);
            data2   : in  std_logic_vector(31 downto 0);
            aluop   : in  std_logic_vector(3 downto 0);
            dataout : out std_logic_vector(31 downto 0);
            nflag   : out std_logic;
            zflag   : out std_logic
        );
    end component;

    -- Signals to connect to the ALU
    signal data1_s   : std_logic_vector(31 downto 0) := (others => '0');
    signal data2_s   : std_logic_vector(31 downto 0) := (others => '0');
    signal aluop_s   : std_logic_vector(3 downto 0)  := (others => '0');
    signal dataout_s : std_logic_vector(31 downto 0);
    signal nflag_s   : std_logic;
    signal zflag_s   : std_logic;

begin

    UUT: ALU
        port map (
            data1   => data1_s,
            data2   => data2_s,
            aluop   => aluop_s,
            dataout => dataout_s,
            nflag   => nflag_s,
            zflag   => zflag_s
        );

    -- Test process
    stim_proc: process
        -- local expected value vars
        variable expected   : std_logic_vector(31 downto 0);
        variable expected_n : std_logic;
        variable expected_z : std_logic;
    begin
        -- Helper procedure to check outputs
        procedure check_expectation(op_name : in string) is
        begin
            wait for 20 ns; -- allow outputs to settle
            -- compute expected flags from expected vector
            expected_z := '1' when expected = (others => '0') else '0';
            expected_n := expected(31);

            if dataout_s /= expected then
                report "FAIL: " & op_name & " - DATAOUT mismatch. expected(signed)=" &
                       integer'image(to_integer(signed(expected))) &
                       " actual(signed)=" & integer'image(to_integer(signed(dataout_s)))
                       severity failure;
            end if;

            if nflag_s /= expected_n then
                report "FAIL: " & op_name & " - NFLAG mismatch. expected=" & expected_n &
                       " actual=" & nflag_s severity failure;
            end if;

            if zflag_s /= expected_z then
                report "FAIL: " & op_name & " - ZFLAG mismatch. expected=" & expected_z &
                       " actual=" & zflag_s severity failure;
            end if;

            report "PASS: " & op_name & " -> result=" &
                   integer'image(to_integer(signed(dataout_s))) severity note;
            wait for 30 ns;
        end procedure;

        -----------------------------------------------------------------
        -- Test 1: AND (0000)
        -----------------------------------------------------------------
        data1_s <= x"0000000F";
        data2_s <= x"000000F0";
        aluop_s <= "0000";
        wait for 10 ns;
        expected := data1_s and data2_s;
        check_expectation("AND");

        -----------------------------------------------------------------
        -- Test 2: OR (0001)
        -----------------------------------------------------------------
        data1_s <= x"0000000F";
        data2_s <= x"000000F0";
        aluop_s <= "0001";
        wait for 10 ns;
        expected := data1_s or data2_s;
        check_expectation("OR");

        -----------------------------------------------------------------
        -- Test 3: ADD positive (0010)
        -- 10 + 5 = 15
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(10, 32));
        data2_s <= std_logic_vector(to_signed(5, 32));
        aluop_s <= "0010";
        wait for 10 ns;
        expected := std_logic_vector(to_signed(10 + 5, 32));
        check_expectation("ADD (10 + 5)");

        -----------------------------------------------------------------
        -- Test 4: ADD with negative result -> -1 + 1 = 0
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(-1, 32));
        data2_s <= std_logic_vector(to_signed(1, 32));
        aluop_s <= "0010";
        wait for 10 ns;
        expected := std_logic_vector(to_signed(-1 + 1, 32));
        check_expectation("ADD (-1 + 1)");

        -----------------------------------------------------------------
        -- Test 5: SUB positive result (0110)
        -- 20 - 5 = 15
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(20, 32));
        data2_s <= std_logic_vector(to_signed(5, 32));
        aluop_s <= "0110";
        wait for 10 ns;
        expected := std_logic_vector(to_signed(20 - 5, 32));
        check_expectation("SUB (20 - 5)");

        -----------------------------------------------------------------
        -- Test 6: SUB negative result (0110)
        -- 5 - 20 = -15
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(5, 32));
        data2_s <= std_logic_vector(to_signed(20, 32));
        aluop_s <= "0110";
        wait for 10 ns;
        expected := std_logic_vector(to_signed(5 - 20, 32));
        check_expectation("SUB (5 - 20)");

        -----------------------------------------------------------------
        -- Test 7: NOR (1100)
        -- Use all zeros to get all ones in result of NOR
        -----------------------------------------------------------------
        data1_s <= x"00000000";
        data2_s <= x"00000000";
        aluop_s <= "1100";
        wait for 10 ns;
        expected := not (data1_s or data2_s);
        check_expectation("NOR (0,0)");

        -----------------------------------------------------------------
        -- Test 8: SLT (0111) - A < B true
        -- A = -5, B = 3 -> A < B true -> result = 1
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(-5, 32));
        data2_s <= std_logic_vector(to_signed(3, 32));
        aluop_s <= "0111";
        wait for 10 ns;
        if signed(data1_s) < signed(data2_s) then
            expected := std_logic_vector(to_signed(1, 32));
        else
            expected := std_logic_vector(to_signed(0, 32));
        end if;
        check_expectation("SLT (-5 < 3)");

        -----------------------------------------------------------------
        -- Test 9: SLT (0111) - A < B false
        -- A = 10, B = 3 -> A < B false -> result = 0
        -----------------------------------------------------------------
        data1_s <= std_logic_vector(to_signed(10, 32));
        data2_s <= std_logic_vector(to_signed(3, 32));
        aluop_s <= "0111";
        wait for 10 ns;
        if signed(data1_s) < signed(data2_s) then
            expected := std_logic_vector(to_signed(1, 32));
        else
            expected := std_logic_vector(to_signed(0, 32));
        end if;
        check_expectation("SLT (10 < 3)");

        -----------------------------------------------------------------
        -- Additional tests or corner cases can be added here
        -----------------------------------------------------------------

        report "All tests completed." severity note;
        wait; -- finish simulation
    end process;

end Behavioral;