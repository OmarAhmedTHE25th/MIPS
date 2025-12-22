library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inst_mem is
    port(
        a  : in  std_logic_vector(5 downto 0); -- 6-bit address from PC
        rd : out std_logic_vector(31 downto 0) -- 32-bit instruction output
    );
end inst_mem;

architecture Behavioral of inst_mem is
    -- Define a memory type (64 words of 32 bits each)
    type ram_type is array (0 to 63) of std_logic_vector(31 downto 24); -- Byte array or
    -- Simpler approach: define it as 32-bit words
    type mem_array is array (0 to 63) of std_logic_vector(31 downto 0);
    
    -- Initialize memory with machine code (Example program)
    constant mem : mem_array := (
        0 => x"2008000A", -- ADDI $t0, $zero, 10  (R[8] = 0 + 10)
        1 => x"20090014", -- ADDI $t1, $zero, 20  (R[9] = 0 + 20)
        2 => x"01095020", -- ADD  $t2, $t0, $t1   (R[10] = 10 + 20)
        3 => x"AC0A0004", -- SW   $t2, 4($zero)   (Mem[4] = 30)
        4 => x"91090001", -- LWR  $t1, 1($zero) (Load Right from address 1 into $t1)
        5 => x"9D0A0000", -- LW_INC $t2, 0($t0) (Load from Mem[$t0], then $t0 = $t0 + 4)
        others => x"00000000" -- NOP (No Operation)
    );

begin
    -- Asynchronous read: instruction is output immediately based on address
    -- Note: Since MIPS addresses are usually byte-aligned, but this memory 
    -- is word-aligned, we use the address directly as the index.
    process(a)
    begin
        rd <= mem(to_integer(unsigned(a)));
    end process;

end Behavioral;