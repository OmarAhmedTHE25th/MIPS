library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Testbench for Datapath (uses simple behavioral stubs for submodules)
entity tb_Datapath is
end tb_Datapath;

architecture Behavioral of tb_Datapath is

    -- UUT signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal instr        : std_logic_vector(31 downto 0) := (others => '0');
    signal aluoperation : std_logic_vector(3 downto 0) := (others => '0');
    signal zero_buf     : std_logic := '0'; -- buffer port
    signal nflag        : std_logic;
    signal regwrite     : std_logic := '0';
    signal RegDst       : std_logic := '0';
    signal MemtoReg     : std_logic := '0';
    signal AluSrc       : std_logic := '0';
    signal read_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal branch       : std_logic := '0';
    signal branch_type  : std_logic_vector(1 downto 0) := (others => '0');
    signal aluout       : std_logic_vector(31 downto 0);
    signal pc_out       : std_logic_vector(5 downto 0);
    signal write_data   : std_logic_vector(31 downto 0) := (others => '0');
signal debug_reg3 : std_logic_vector(31 downto 0);
signal debug_reg4 : std_logic_vector(31 downto 0);
signal debug_reg5 : std_logic_vector(31 downto 0);
signal debug_reg6 : std_logic_vector(31 downto 0);
signal debug_reg7 : std_logic_vector(31 downto 0);
signal debug_reg8 : std_logic_vector(31 downto 0);
signal debug_reg9 : std_logic_vector(31 downto 0);

    -- Internal helpers
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the (fixed) Datapath
    UUT: entity work.Datapath
        port map(
            clk         => clk,
            reset       => reset,
            instr       => instr,
            aluoperation=> aluoperation,
            zero        => zero_buf,
            nflag       => nflag,
            regwrite    => regwrite,
            RegDst      => RegDst,
            MemtoReg    => MemtoReg,
            AluSrc      => AluSrc,
            read_data   => read_data,
            branch      => branch,
            branch_type => branch_type,
            aluout      => aluout,
            pc_out      => pc_out,
            write_data  => write_data,
            debug_reg3 => debug_reg3,
            debug_reg8 => debug_reg8
        );

    -- Clock
    clk_proc : process
    begin
        while now < 1000 ns loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus
    stim_proc: process
        -- helper to build instruction: rs(25:21), rt(20:16), rd(15:11)
        function make_rtype(rs_i, rt_i, rd_i: integer) return std_logic_vector is
            variable inst: std_logic_vector(31 downto 0) := (others => '0');
        begin
            inst(25 downto 21) := std_logic_vector(to_unsigned(rs_i,5));
            inst(20 downto 16) := std_logic_vector(to_unsigned(rt_i,5));
            inst(15 downto 11) := std_logic_vector(to_unsigned(rd_i,5));
            return inst;
        end function;

        variable expected_reg3 : signed(31 downto 0);
    begin
        -- Reset pulse
        reset <= '1';
        wait for 25 ns;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Initialize register file inside stub to known values via signal after reset (stub has initial content).
        -- Test 1: ADD registers r1 (10) + r2 (5) -> r3
        instr <= make_rtype(1,2,3);       -- rs=1, rt=2, rd=3
        RegDst <= '1';                    -- select rd
        AluSrc <= '0';                    -- alu from rd2
        MemtoReg <= '0';                  -- write back ALU result
        regwrite <= '1';
        aluoperation <= "0010";           -- ADD
        wait for CLK_PERIOD;              -- let inputs settle

        -- Wait a rising edge so RF writes happen inside component's clocked write
        wait for CLK_PERIOD;

        -- Check register 3 (read back via read through RegisterFile stub)
        wait for 5 ns;
        expected_reg3 := to_signed(10 + 5, 32);
        if signed(UUT.RF_inst.mem(3)) /= expected_reg3 then
            report "FAIL: ADD write-back: reg3 expected " & integer'image(to_integer(expected_reg3)) &
                   " got " & integer'image(to_integer(signed(UUT.RF_inst.mem(3)))) severity failure;
        else
            report "PASS: ADD write-back: reg3 = " & integer'image(to_integer(signed(UUT.RF_inst.mem(3)))) severity note;
        end if;

        -- Test 2: MemtoReg = 1 should write read_data (simulate LW)
        regwrite <= '1';
        MemtoReg <= '1';
        read_data <= std_logic_vector(to_signed(1234,32));
        -- write to same destination rd=3
        instr <= make_rtype(1,2,3);
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;
        wait for 5 ns;
        if signed(UUT.RF_inst.mem(3)) /= to_signed(1234,32) then
            report "FAIL: MemtoReg write-back expected 1234, got " &
                   integer'image(to_integer(signed(UUT.RF_inst.mem(3)))) severity failure;
        else
            report "PASS: MemtoReg write-back = 1234" severity note;
        end if;

        -- Test 3: BEQ branch (branch_type "01"): set registers equal so zero='1', expect PC to branch
        -- Use an instruction where imm lower bits will give a branch offset of +2 (imm_ext(5 downto 0) = "000010")
        -- Prepare registers such that ALU subtract yields zero
        -- Set instruction fields so rs=4 rt=5
        instr <= (others => '0');
        instr(25 downto 21) <= std_logic_vector(to_unsigned(4,5));
        instr(20 downto 16) <= std_logic_vector(to_unsigned(5,5));
        RegDst <= '0';
        MemtoReg <= '0';
        AluSrc <= '0';
        regwrite <= '0';
        aluoperation <= "0110"; -- SUB
        -- Make registers 4 and 5 equal (both 7)
        UUT.RF_inst.mem(4) <= std_logic_vector(to_signed(7,32));
        UUT.RF_inst.mem(5) <= std_logic_vector(to_signed(7,32));

        -- set branch control
        branch <= '1';
        branch_type <= "01"; -- BEQ
        -- set imm_ext lower 6 bits via instruction immediate so that pc_branch = pc_current + 1 + 2
        -- put immediate value 2 in instr[5:0] -> immediate field is bits [5:0] of instr(15 downto 0)
        instr(5 downto 0) <= "000010";
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;
        wait for 5 ns;
        -- pc should have taken branch (pc_next = pc_branch). We can't predict absolute value easily, but check that pc_out changed by at least >0
        report "INFO: pc_out after BEQ = " & integer'image(to_integer(unsigned(pc_out))) severity note;

        -- Test 4: BLE branch (branch_type "10"), branch when zero='1' or nflag='1'
        -- Make A < B (negative result) to assert nflag; set branch_type to BLE.
        instr <= (others => '0');
        instr(25 downto 21) <= std_logic_vector(to_unsigned(6,5)); -- rs
        instr(20 downto 16) <= std_logic_vector(to_unsigned(7,5)); -- rt
        UUT.RF_inst.mem(6) <= std_logic_vector(to_signed(-5,32));
        UUT.RF_inst.mem(7) <= std_logic_vector(to_signed(3,32));
        aluoperation <= "0110"; -- SUB (6 - 7 = -8 => negative)
        branch <= '1';
        branch_type <= "10"; -- BLE
        instr(5 downto 0) <= "000001"; -- branch offset 1
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;
        wait for 5 ns;
        report "INFO: pc_out after BLE = " & integer'image(to_integer(unsigned(pc_out))) severity note;
        --Test 5: LWR rt=9, offset=1, base=0 (address 1)
instr <= x"91090001"; 
RegDst <= '0';
AluSrc <= '1';
MemtoReg <= '1';
regwrite <= '1';
Jump <= '1'; -- Secret code for LWR merge
read_data <= x"AABBCCDD"; -- Data from memory
-- Assume Register $t1 (r9) currently holds x"00000000"
wait for CLK_PERIOD * 2;
-- At address 1, LWR should keep the top 8 bits of the reg and take 24 bits from mem
report "LWR Result in r9: " & integer'image(to_integer(unsigned(UUT.RF_inst.mem(9))));

-- Test 6: Simulate LW_INC: rt=10, rs=8 ($t0), offset=0
instr <= x"9D0A0000"; 
RegDst <= '0';
AluSrc <= '1';
MemtoReg <= '1';
regwrite <= '1';
Jump <= '1'; -- Secret code for Increment
UUT.RF_inst.mem(8) <= x"00000004"; -- $t0 starts at 4
wait for CLK_PERIOD * 2;
-- Check if $t0 (r8) is now 8
if UUT.RF_inst.mem(8) = x"00000008" then
    report "PASS: LW_INC updated base register $t0 to 8" severity note;
else
    report "FAIL: LW_INC base register is " & integer'image(to_integer(unsigned(UUT.RF_inst.mem(8)))) severity failure;
end if;
        report "All tests finished." severity note;
        wait;
    end process;

    ---------------------------------------------------------
    -- Behavioral stubs for components used by Datapath
    -- These are included in the testbench to make the test self-contained.
    ---------------------------------------------------------

    -- Simple 32x32 RegisterFile (entity name RegisterFile)
    -- Expose instance as RF_inst so testbench can poke/check mem contents.
    component RegisterFile
        port(
            read_sel1  : in  std_logic_vector(4 downto 0);
            read_sel2  : in  std_logic_vector(4 downto 0);
            write_sel  : in  std_logic_vector(4 downto 0);
            write_ena  : in  std_logic;
            clk        : in  std_logic;
            reset      : in  std_logic;
            write_data : in  std_logic_vector(31 downto 0);
            data1      : out std_logic_vector(31 downto 0);
            data2      : out std_logic_vector(31 downto 0);
            auto_incr  : in  std_logic
        );
    end component;

    -- Instantiate a named register-file instance (definition below)
    RF_inst: entity work.RegisterFile
        port map(
            read_sel1 => open, -- we will refer to RF_inst.mem directly in testbench checks
            read_sel2 => open,
            write_sel => open,
            write_ena => open,
            clk => open,
            reset => open,
            write_data => open,
            data1 => open,
            data2 => open
        );

    -- Provide the register file entity/architecture below
end Behavioral;

-- Separate concurrent region: define the RegisterFile and other stubs after the testbench architecture
-- RegisterFile implementation
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    port(
        read_sel1  : in  std_logic_vector(4 downto 0);
        read_sel2  : in  std_logic_vector(4 downto 0);
        write_sel  : in  std_logic_vector(4 downto 0);
        write_ena  : in  std_logic;
        clk        : in  std_logic;
        reset      : in  std_logic;
        write_data : in  std_logic_vector(31 downto 0);
        data1      : out std_logic_vector(31 downto 0);
        data2      : out std_logic_vector(31 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type reg_file_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal mem : reg_file_t := (others => (others => '0'));
begin
    -- initial known values used by testbench: r1=10, r2=5
    -- initialize after elaboration (for simulators that support this)
    init_proc: process
    begin
        mem(1) <= std_logic_vector(to_signed(10,32));
        mem(2) <= std_logic_vector(to_signed(5,32));
        wait;
    end process;

    -- read ports are combinational
    data1 <= mem(to_integer(unsigned(read_sel1)));
    data2 <= mem(to_integer(unsigned(read_sel2)));

    -- synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                mem <= (others => (others => '0'));
            else
                if write_ena = '1' then
                    mem(to_integer(unsigned(write_sel))) <= write_data;
                end if;
            end if;
        end if;
    end process;
end Behavioral;

-- SignExtender: 16->32 sign extension
entity SignExtender is
    port(
        imm_in  : in std_logic_vector(15 downto 0);
        imm_out : out std_logic_vector(31 downto 0)
    );
end SignExtender;

architecture Behavioral of SignExtender is
begin
    -- safer explicit:
    imm_out <= std_logic_vector(resize(signed(imm_in), 32));
end Behavioral;

-- 2-to-1 32-bit mux
entity mux2to1_32bit is
    port(
        a   : in  std_logic_vector(31 downto 0);
        b   : in  std_logic_vector(31 downto 0);
        sel : in  std_logic;
        y   : out std_logic_vector(31 downto 0)
    );
end mux2to1_32bit;

architecture Behavioral of mux2to1_32bit is
begin
    y <= a when sel = '0' else b;
end Behavioral;

-- Simple PC register (6-bit)
entity PC is
    port(
        clk   : in std_logic;
        reset : in std_logic;
        pc_in : in std_logic_vector(5 downto 0);
        pc_out: out std_logic_vector(5 downto 0)
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : std_logic_vector(5 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_reg <= (others => '0');
            else
                pc_reg <= pc_in;
            end if;
        end if;
    end process;
    pc_out <= pc_reg;
end Behavioral;

-- ALU: include the ALU you provided earlier (signed arithmetic)
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