library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        instr       : in  std_logic_vector(31 downto 0);
        aluoperation: in  std_logic_vector(3 downto 0);
        zero        : out std_logic;
        nflag       : out std_logic;  -- Negative flag for BLE
        regwrite    : in  std_logic;
        RegDst      : in  std_logic;
        MemtoReg    : in  std_logic;
        AluSrc      : in  std_logic;
        read_data   : in  std_logic_vector(31 downto 0);
        Jump        : in  std_logic;
        branch      : in  std_logic;
        branch_type : in  std_logic_vector(1 downto 0); -- from Control Unit
        aluout      : out std_logic_vector(31 downto 0);
        pc_out      : out std_logic_vector(5 downto 0);
        write_data  : inout std_logic_vector(31 downto 0);
        debug_reg3   : out std_logic_vector(31 downto 0);
debug_reg4   : out std_logic_vector(31 downto 0);
debug_reg5   : out std_logic_vector(31 downto 0);
debug_reg6   : out std_logic_vector(31 downto 0);
debug_reg7   : out std_logic_vector(31 downto 0);
debug_reg8   : out std_logic_vector(31 downto 0);
debug_reg9   : out std_logic_vector(31 downto 0)
    );
end Datapath;

architecture Behavioral of Datapath is

    -- Instruction fields
    signal rs, rt, rd_sig       : std_logic_vector(4 downto 0);
    signal write_reg_dest       : std_logic_vector(4 downto 0);
    signal rd1, rd2             : std_logic_vector(31 downto 0);

    -- ALU signals
    signal imm_in               : std_logic_vector(15 downto 0);
    signal imm_ext              : std_logic_vector(31 downto 0); -- fixed to 32 bits
    signal alu_src_b, alu_result: std_logic_vector(31 downto 0);
	 signal nflag_i : std_logic;
	 signal zero_i : std_logic;



    -- Branch / PC signals
    signal branch_taken         : std_logic;
    signal pc_current, pc_next, pc_plus4, pc_branch : std_logic_vector(5 downto 0);

    -- LWR signals
    signal lwr_merged_data, data_to_mux : std_logic_vector(31 downto 0);
--lw inc signals
signal rf_incr_control : std_logic;
begin

    -- 1. Instruction fields
    rs <= instr(25 downto 21);
    rt <= instr(20 downto 16);
    rd_sig <= instr(15 downto 11);
    imm_in <= instr(15 downto 0);

    -- 2. RegDst MUX
    write_reg_dest <= rt when RegDst = '0' else rd_sig;
    rf_incr_control <= Jump;

    -- 3. Register File
    RF: entity work.RegisterFile
        port map(
            read_sel1  => rs,
            read_sel2  => rt,
            write_sel  => write_reg_dest,
            write_ena  => regwrite,
            clk        => clk,
            reset      => reset,
            auto_incr => rf_incr_control,
            reg3_out     => debug_reg3,
            reg4_out     => debug_reg4,
            reg5_out     => debug_reg5,
            reg6_out     => debug_reg6,
            reg7_out     => debug_reg7,
            reg8_out     => debug_reg8,
            reg9_out     => debug_reg9,
            write_data => write_data,
            data1      => rd1,
            data2      => rd2
        );

    -- 4. Sign Extender
    SIGN_EXTEND: entity work.SignExtender
        port map(
            imm_in  => imm_in,
            imm_out => imm_ext
        );

    -- 5. ALUSrc MUX
    ALUsrc_Mux: entity work.mux2to1_32bit
        port map(
            a   => rd2,
            b   => imm_ext,
            sel => AluSrc,
            y   => alu_src_b
        );

    -- 6. ALU
    ALU_UNIT: entity work.ALU
        port map(
            data1   => rd1,
            data2   => alu_src_b,
            aluop   => aluoperation,
            dataout => alu_result,
            nflag   => nflag_i,
            zflag   => zero
        );
    aluout <= alu_result;
    nflag <= nflag_i;


-- 7. LWR merge logic (little-endian):
-- alu_result(1 downto 0) selects how many rightmost bytes come from memory.
-- read_data: 32-bit word from memory containing the addressed byte
-- write_data: current value of rt (before write-back)

    process(read_data, write_data, alu_result)
    begin
        case alu_result(1 downto 0) is
            when "00" => lwr_merged_data <= read_data;-- aligned: take full word from memory
            when "01" => lwr_merged_data <= write_data(31 downto 24) & read_data(23 downto 0); -- replace 3 LSB bytes from memory, keep MSB from rt
            when "10" => lwr_merged_data <= write_data(31 downto 16) & read_data(15 downto 0);-- replace 2 LSB bytes from memory, keep top 2 from rt
            when "11" => lwr_merged_data <= write_data(31 downto 8) & read_data(7 downto 0);-- replace 1 LSB byte from memory, keep top 3 from rt
            when others => lwr_merged_data <= read_data;
        end case;
    end process;
-- Feed write-back mux when MemtoReg='1'
    data_to_mux <= lwr_merged_data;  
zero_i <= '1' when alu_result = x"00000000" else '0';
    -- 8. Write-back MUX
    Write_Back_Mux: entity work.mux2to1_32bit
        port map(
            a   => alu_result,
            b   => data_to_mux,
            sel => MemtoReg,
            y   => write_data
        );

    -- 9. Branch logic
    branch_taken <= '1' when
    (branch = '1' and branch_type = "01" and zero_i = '1') or
    (branch = '1' and branch_type = "10" and (zero_i = '1' or nflag_i = '1'))
else
    '0';


    -- 10. PC logic
    pc_plus4 <= std_logic_vector(unsigned(pc_current) + 1);
    pc_branch <= std_logic_vector(unsigned(pc_current) + 1 + unsigned(imm_ext(5 downto 0))); -- adjust width if needed
    pc_next <= pc_branch when branch_taken = '1' else pc_plus4;

    -- PC Register
    PC_REG: entity work.PC
        port map(
            clk    => clk,
            reset  => reset,
            pc_in  => pc_next,
            pc_out => pc_current
        );

    pc_out <= pc_current;

end Behavioral;