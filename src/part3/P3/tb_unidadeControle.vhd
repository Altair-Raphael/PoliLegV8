-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench Unidade de Controle 

library ieee;
use ieee.numeric_bit.all;

entity tb_unidadeControle is
end entity tb_unidadeControle;

architecture test of tb_unidadeControle is
    component unidadeControle is
        port (
            opcode       : in bit_vector(10 downto 0);
            reg2loc      : out bit;
            uncondBranch : out bit;
            branch       : out bit;
            memRead      : out bit;
            memToReg     : out bit;
            aluOp        : out bit_vector(3 downto 0);
            memWrite     : out bit;
            aluSrc       : out bit;
            regWrite     : out bit
        );
    end component;

    signal s_opcode : bit_vector(10 downto 0);
    -- Sinais de saida para verificacao
    signal s_reg2loc, s_uncondBranch, s_branch, s_memRead, s_memToReg : bit;
    signal s_memWrite, s_aluSrc, s_regWrite : bit;
    signal s_aluOp : bit_vector(3 downto 0);

begin
    DUT: unidadeControle port map (
        s_opcode, s_reg2loc, s_uncondBranch, s_branch, s_memRead, s_memToReg,
        s_aluOp, s_memWrite, s_aluSrc, s_regWrite
    );

    process
    begin
        report "Inicio Teste Unidade de Controle";

        -- 1. Teste ADD (R-Format) -> Opcode: 10001011000
        -- Esperado: RegWrite=1, ALUOp=0010 (Add), ALUSrc=0 (Reg), MemWrite=0
        s_opcode <= "10001011000"; 
        wait for 10 ns;
        assert (s_regWrite = '1' and s_aluOp = "0010" and s_memWrite = '0')
        report "Erro no ADD" severity error;

        -- 2. Teste LDUR (D-Format) -> Opcode: 11111000010
        -- Esperado: RegWrite=1, MemRead=1, MemToReg=1, ALUSrc=1
        s_opcode <= "11111000010";
        wait for 10 ns;
        assert (s_regWrite = '1' and s_memRead = '1' and s_memToReg = '1' and s_aluSrc = '1')
        report "Erro no LDUR" severity error;

        -- 3. Teste STUR (D-Format) -> Opcode: 11111000000
        -- Esperado: MemWrite=1, Reg2Loc=1, ALUSrc=1, RegWrite=0
        s_opcode <= "11111000000";
        wait for 10 ns;
        assert (s_memWrite = '1' and s_reg2loc = '1' and s_regWrite = '0')
        report "Erro no STUR" severity error;

        -- 4. Teste CBZ (Branch) -> Opcode: 10110100000
        -- Esperado: Branch=1, Reg2Loc=1, ALUOp=0111 (Pass B)
        s_opcode <= "10110100000";
        wait for 10 ns;
        assert (s_branch = '1' and s_reg2loc = '1' and s_aluOp = "0111")
        report "Erro no CBZ" severity error;

        report "Fim Teste Unidade de Controle";
        wait;
    end process;
end architecture;