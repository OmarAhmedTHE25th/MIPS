library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Control_Unit is
end tb_Control_Unit;

architecture Behavioral of tb_Control_Unit is

    -- DUT signals
    signal opcode      : std_logic_vector(5 downto 0) := (others => '0');
    signal RegDst      : std_logic;
    signal ALUSrc      : std_logic;
    signal MemtoReg    : std_logic;
    signal RegWrite    : std_logic;
    signal MemRead     : std_logic;
    signal MemWrite    : std_logic;
    signal Branch      : std_logic;
    signal Jump        : std_logic;
    signal BranchType  : std_logic_vector(1 downto 0);
    signal ALUOp       : std_logic_vector(3 downto 0);

    -- helper variable to track any failures
    -- small procedure to compare expected vs actual and report
procedure check_signals(
        testname      : in string;
        exp_RegDst    : in std_logic;
        exp_ALUSrc    : in std_logic;
        exp_MemtoReg  : in std_logic;
        exp_RegWrite  : in std_logic;
        exp_MemRead   : in std_logic;
        exp_MemWrite  : in std_logic;
        exp_Branch    : in std_logic;
        exp_Jump      : in std_logic;
        exp_BranchType: in std_logic_vector(1 downto 0);
        exp_ALUOp     : in std_logic_vector(3 downto 0)
    ) is
variable any_fail : boolean := false;
begin
    wait for 10 ns;
            if RegDst /= exp_RegDst then
            report "FAIL: " & testname  severity failure;
            any_fail:=true;
        end if;

        if not any_fail then
            report "PASS: " & testname severity note;
        else
            any_fail := false;
        end if;
        if ALUSrc /= exp_ALUSrc then
            report "FAIL: " & testname  severity failure;
           any_fail := true;
        end if;
        if MemtoReg /= exp_MemtoReg then
            report "FAIL: " & testname severity failure;
            any_fail:= true;
        end if;
        if RegWrite /= exp_RegWrite then
            report "FAIL: " & testname severity failure;
            any_fail:=true;
        end if;
        if MemRead /= exp_MemRead then
            report "FAIL: " & testname severity failure;
            any_fail:=true;
        end if;
        if MemWrite /= exp_MemWrite then
            report "FAIL: " & testname  severity failure;
            any_fail:=true;
        end if;
        if Branch /= exp_Branch then
            report "FAIL: " & testname & " - Branch expected " severity failure;
            any_fail:=true;
        end if;
        if Jump /= exp_Jump then
            report "FAIL: " & testname & " - Jump expected "  severity failure;
            any_fail:=true;
        end if;
        if BranchType /= exp_BranchType then
            report "FAIL: " & testname & " - BranchType expected " severity failure;
            any_fail:=true;
        end if;
        if ALUOp /= exp_ALUOp then
            report "FAIL: " & testname & " - ALUOp expected " severity failure;
            any_fail:=true;
        end if;

        if not any_fail then
            report "PASS: " & testname severity note;
        else
            any_fail:=false; -- reset for next test
        end if;

 end procedure;
  begin
    -- instantiate the Control Unit under test
    DUT: entity work.Control_Unit
        port map(
            opcode     => opcode,
            RegDst     => RegDst,
            ALUSrc     => ALUSrc,
            MemtoReg   => MemtoReg,
            RegWrite   => RegWrite,
            MemRead    => MemRead,
            MemWrite   => MemWrite,
            Branch     => Branch,
            Jump       => Jump,
            BranchType => BranchType,
            ALUOp      => ALUOp
        );

    
   
      
        
   

    -- stimulus process: exercises each opcode implemented in the Control Unit
    stim_proc: process
    begin
        -- R-type ("000000")
        opcode <= "000000";
        check_signals("R-type (000000)",
                      '1',  -- RegDst
                      '0',  -- ALUSrc
                      '0',  -- MemtoReg
                      '1',  -- RegWrite
                      '0',  -- MemRead
                      '0',  -- MemWrite
                      '0',  -- Branch
                      '0',  -- Jump
                      "00", -- BranchType
                      "0010" -- ALUOp
        );

        -- LW ("100011")
        opcode <= "100011";
        check_signals("LW (100011)",
                      '0', '1', '1', '1', '1', '0', '0', '0', "00", "0010");

        -- SW ("101011")
        opcode <= "101011";
        check_signals("SW (101011)",
                      '0', '1', '0', '0', '0', '1', '0', '0', "00", "0010");

        -- BEQ ("000100")
        opcode <= "000100";
        check_signals("BEQ (000100)",
                      '0', '0', '0', '0', '0', '0', '1', '0', "01", "0110");

        -- BLE ("000110")
        opcode <= "000110";
        check_signals("BLE (000110)",
                      '0', '0', '0', '0', '0', '0', '1', '0', "10", "0110");

        -- ADDI ("001000")
        opcode <= "001000";
        check_signals("ADDI (001000)",
                      '0', '1', '0', '1', '0', '0', '0', '0', "00", "0010");

        -- J ("000010")
        opcode <= "000010";
        check_signals("J (000010)",
                      '0', '0', '0', '0', '0', '0', '0', '1', "00", "0000");

        -- LWR ("100110")
        opcode <= "100110";
        check_signals("LWR (100110)",
                      '0', '1', '1', '1', '1', '0', '0', '1', "00", "0010");

        -- LW_INCR ("100111")
        opcode <= "100111";
        check_signals("LW_INCR (100111)",
                      '0', '1', '1', '1', '1', '0', '0', '1', "00", "0010");

        report "Control Unit tests completed." severity note;
        wait;
    end process;

end Behavioral;