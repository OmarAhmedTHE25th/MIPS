library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    port(
        read_sel1  : in  std_logic_vector(4 downto 0);
        read_sel2  : in  std_logic_vector(4 downto 0);
        write_sel  : in  std_logic_vector(4 downto 0);
        write_ena  : in  std_logic;
        clk,reset  : in  std_logic;
        reg3_out   : out std_logic_vector(31 downto 0);
        reg4_out   : out std_logic_vector(31 downto 0);
reg5_out   : out std_logic_vector(31 downto 0);
reg6_out   : out std_logic_vector(31 downto 0);
reg7_out   : out std_logic_vector(31 downto 0);
reg8_out   : out std_logic_vector(31 downto 0);
reg9_out   : out std_logic_vector(31 downto 0);
        write_data : in  std_logic_vector(31 downto 0);
        data1      : out std_logic_vector(31 downto 0);
        auto_incr : in std_logic;
        data2      : out std_logic_vector(31 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is

    -- decoder output
    signal decoded : std_logic_vector(31 downto 0);
    signal incr_decoded : std_logic_vector(31 downto 0);
    -- load enables for each register
    signal load : std_logic_vector(31 downto 0);
signal next_val : std_logic_vector(31 downto 0);
signal reg_input : std_logic_vector(31 downto 0);
signal data1_i : std_logic_vector(31 downto 0);
signal data2_i : std_logic_vector(31 downto 0);
    --32 registers
    signal r0,  r1,  r2,  r3,
           r4,  r5,  r6,  r7,
           r8,  r9,  r10, r11,
           r12, r13, r14, r15,
           r16, r17, r18, r19,
           r20, r21, r22, r23,
           r24, r25, r26, r27,
           r28, r29, r30, r31 : std_logic_vector(31 downto 0);

begin

reg3_out <= r3;
reg4_out <= r4;
reg5_out <= r5;
reg6_out <= r6;
reg7_out <= r7;
reg8_out <= r8;
reg9_out <= r9;
-- Decoder Instance
    DEC: entity work.Decoder_5to32
        port map(
            sel  => write_sel,
            dout => decoded
        );
    INC_DEC: entity work.Decoder_5to32 
         port map(
            sel => read_sel1, dout => incr_decoded
            );

    load <= (decoded and (31 downto 0 => write_ena)) or (incr_decoded and (31 downto 0 => auto_incr));
-- This signal acts as a switch for the whole file
-- If auto_incr is 1, we use the +4 value. Otherwise, we use normal write_data.
   reg_input <= next_val when auto_incr = '1' else write_data;
-- 32 FlopR register instances
next_val <= std_logic_vector(unsigned(data1_i) + 4);
REG0: entity work.FlopR port map(clk, reset, '0', x"00000000", r0); 
REG1: entity work.FlopR port map(clk, reset, load(1), reg_input, r1);
REG2: entity work.FlopR port map(clk, reset, load(2), reg_input, r2);
REG3: entity work.FlopR port map(clk, reset, load(3), reg_input, r3);
REG4: entity work.FlopR port map(clk, reset, load(4), reg_input, r4);
REG5: entity work.FlopR port map(clk, reset, load(5), reg_input, r5);
REG6: entity work.FlopR port map(clk, reset, load(6), reg_input, r6);
REG7: entity work.FlopR port map(clk, reset, load(7), reg_input, r7);
REG8: entity work.FlopR port map(clk, reset, load(8), reg_input, r8);
REG9: entity work.FlopR port map(clk, reset, load(9), reg_input, r9);
REG10: entity work.FlopR port map(clk, reset, load(10), reg_input, r10);
REG11: entity work.FlopR port map(clk, reset, load(11), reg_input, r11);
REG12: entity work.FlopR port map(clk, reset, load(12), reg_input, r12);
REG13: entity work.FlopR port map(clk, reset, load(13), reg_input, r13);
REG14: entity work.FlopR port map(clk, reset, load(14), reg_input, r14);
REG15: entity work.FlopR port map(clk, reset, load(15), reg_input, r15);
REG16: entity work.FlopR port map(clk, reset, load(16), reg_input, r16);
REG17: entity work.FlopR port map(clk, reset, load(17), reg_input, r17);
REG18: entity work.FlopR port map(clk, reset, load(18), reg_input, r18);
REG19: entity work.FlopR port map(clk, reset, load(19), reg_input, r19);
REG20: entity work.FlopR port map(clk, reset, load(20), reg_input, r20);
REG21: entity work.FlopR port map(clk, reset, load(21), reg_input, r21);
REG22: entity work.FlopR port map(clk, reset, load(22), reg_input, r22);
REG23: entity work.FlopR port map(clk, reset, load(23), reg_input, r23);
REG24: entity work.FlopR port map(clk, reset, load(24), reg_input, r24);
REG25: entity work.FlopR port map(clk, reset, load(25), reg_input, r25);
REG26: entity work.FlopR port map(clk, reset, load(26), reg_input, r26);
REG27: entity work.FlopR port map(clk, reset, load(27), reg_input, r27);
REG28: entity work.FlopR port map(clk, reset, load(28), reg_input, r28);
REG29: entity work.FlopR port map(clk, reset, load(29), reg_input, r29);
REG30: entity work.FlopR port map(clk, reset, load(30), reg_input, r30);
REG31: entity work.FlopR port map(clk, reset, load(31), reg_input, r31);
-- Mux for read port 1

    MUX1: entity work.Mux32to1
        port map(
            sel  => read_sel1,
            din0 => r0,  din1 => r1,  din2 => r2,  din3 => r3,
            din4 => r4,  din5 => r5,  din6 => r6,  din7 => r7,
            din8 => r8,  din9 => r9,  din10 => r10, din11 => r11,
            din12 => r12, din13 => r13, din14 => r14, din15 => r15,
            din16 => r16, din17 => r17, din18 => r18, din19 => r19,
            din20 => r20, din21 => r21, din22 => r22, din23 => r23,
            din24 => r24, din25 => r25, din26 => r26, din27 => r27,
            din28 => r28, din29 => r29, din30 => r30, din31 => r31,
            dout => data1_i
        );

-- Mux for read port 2
    MUX2: entity work.Mux32to1
        port map(
            sel  => read_sel2,
            din0 => r0,  din1 => r1,  din2 => r2,  din3 => r3,
            din4 => r4,  din5 => r5,  din6 => r6,  din7 => r7,
            din8 => r8,  din9 => r9,  din10 => r10, din11 => r11,
            din12 => r12, din13 => r13, din14 => r14, din15 => r15,
            din16 => r16, din17 => r17, din18 => r18, din19 => r19,
            din20 => r20, din21 => r21, din22 => r22, din23 => r23,
            din24 => r24, din25 => r25, din26 => r26, din27 => r27,
            din28 => r28, din29 => r29, din30 => r30, din31 => r31,
            dout => data2_i
        );

end Behavioral;
