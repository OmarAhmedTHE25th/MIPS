library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPS_Processor is 
    port(
        clk, reset  : in  std_logic;
        alu_output  : out std_logic_vector(31 downto 0);
        write_data  : out std_logic_vector(31 downto 0)
    );
end MIPS_Processor;

architecture Behavioral of MIPS_Processor is
    -- Control Signals
    signal RegDst_s, ALUSrc_s, MemtoReg_s, RegWrite_s : std_logic;
    signal zero_flag, PCSrc, MemRead_s, MemWrite_s     : std_logic;
    signal Branch_s, Jump_s                            : std_logic;
    signal ALUOp_s : std_logic_vector(3 downto 0);
    signal branchtype_s : STD_LOGIC_VECTOR(1 downto 0);

    -- Data Signals
    signal instruction, alu_out, mem_read_data, reg_write_data : std_logic_vector(31 downto 0);
    signal PC : std_logic_vector(7 downto 2);

begin

    -- Branch decision logic: Result is '1' if we are on a branch instruction AND zero is detected
    PCSrc <= Branch_s AND zero_flag;

    -- 1. Datapath Instance
 
    Datapath_Inst: entity work.Datapath
        port map(
            clk           => clk,
            reset         => reset,
            instr         => instruction,
            aluoperation  => ALUOp_s,
            zero          => zero_flag,
            regwrite      => RegWrite_s,
            RegDst        => RegDst_s,
            MemtoReg      => MemtoReg_s,
            AluSrc        => ALUSrc_s,
            read_data     => mem_read_data,
            branch        => Branch_s,
            jump          => Jump_s,
            aluout        => alu_out,
            pc_out        => PC,
            write_data    => reg_write_data,
            branch_type => branchtype_s
        );

    -- 2. Control Unit Instance
    Control_Unit_Inst: entity work.Control_Unit
        port map(
            opcode   => instruction(31 downto 26),
            RegDst   => RegDst_s,
            ALUSrc   => ALUSrc_s,
            MemtoReg => MemtoReg_s,
            RegWrite => RegWrite_s,
            MemRead  => MemRead_s,
            MemWrite => MemWrite_s,
            Branch   => Branch_s,
            Jump     => Jump_s,
        BranchType => branchtype_s,
            ALUOp    => ALUOp_s
        );

    -- 3. Data Memory Instance (dmem)
    Data_Memory_Inst: entity work.DataMemory
        port map(
            clk => clk,
            memWrite  => MemWrite_s,
            memRead => MemRead_s,
            writeData  => reg_write_data,
            ReadData  => mem_read_data,
            address   => alu_out
        );

    -- 4. Instruction Memory Instance (imem)
    Instruction_Memory_Inst: entity work.inst_mem
        port map(
            a  => PC,
            rd => instruction
        );

    -- Output Port Assignments
    alu_output <= alu_out;
    write_data <= reg_write_data;

end Behavioral;