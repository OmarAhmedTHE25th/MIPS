library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    port(
        opcode      : in  STD_LOGIC_VECTOR(5 downto 0);
        RegDst      : out STD_LOGIC;
        ALUSrc      : out STD_LOGIC;
        MemtoReg    : out STD_LOGIC;
        RegWrite    : out STD_LOGIC;
        MemRead     : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        Branch      : out STD_LOGIC;
        Jump        : out STD_LOGIC;
        BranchType  : out STD_LOGIC_VECTOR(1 downto 0);
        ALUOp       : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
begin
    process(opcode)
    begin
        -- defaults
        RegDst      <= '0';
        ALUSrc      <= '0';
        MemtoReg    <= '0';
        RegWrite    <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        Branch      <= '0';
        Jump        <= '0';
        BranchType  <= "00";
        ALUOp       <= "0000";

        case opcode is
            when "000000" =>  -- R-type
                RegDst      <= '1';
                RegWrite    <= '1';
                ALUSrc      <= '0';
                MemtoReg    <= '0';
                ALUOp       <= "0010";
            when "100011" =>  -- LW
                RegDst      <= '0';
                ALUSrc      <= '1';
                MemtoReg    <= '1';
                RegWrite    <= '1';
                MemRead     <= '1';
                ALUOp       <= "0010";
            when "101011" =>  -- SW
                ALUSrc      <= '1';
                MemWrite    <= '1';
                ALUOp       <= "0010";
            when "000100" =>  -- BEQ
                Branch      <= '1';
                ALUSrc      <= '0';
                ALUOp       <= "0110";
                BranchType  <= "01";
            when "000110" =>  -- BLE
                Branch      <= '1';
                ALUSrc      <= '0';
                ALUOp       <= "0110";
                BranchType  <= "10";
            when "001000" =>  -- ADDI
                ALUSrc      <= '1';
                RegWrite    <= '1';
                MemtoReg    <= '0';
                ALUOp       <= "0010";
            when "000010" =>  -- J
                Jump        <= '1';
            when "100110" => -- LWR
                RegDst      <= '0';
                ALUSrc      <= '1';
                MemtoReg    <= '1';
                RegWrite    <= '1';
                MemRead     <= '1';
                ALUOp       <= "0010";
                Jump        <= '1';
            when "100111" => -- LW_INCR
                RegDst      <= '0';
                ALUSrc      <= '1';
                MemtoReg    <= '1';
                RegWrite    <= '1';
                MemRead     <= '1';
                ALUOp       <= "0010";
                Branch      <= '0';
                Jump        <= '1';
            when others =>
                null;  -- all defaults already set
        end case;
    end process;
end Behavioral;
