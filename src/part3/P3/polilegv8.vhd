-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: PoliLegV8

library ieee;
use ieee.numeric_bit.all;

entity polilegv8 is
    port (
        clock, reset : in bit;
        pc_out       : out bit_vector(63 downto 0);
        alu_result   : out bit_vector(63 downto 0)
    );
end entity polilegv8;

architecture structural of polilegv8 is

    component fluxoDados is
        port (
            clock, reset : in bit;
            reg2loc, uncondBranch, branch, memRead, memToReg : in bit;
            aluOp : in bit_vector(3 downto 0);
            memWrite, aluSrc, regWrite : in bit;
            pc_out, alu_result : out bit_vector(63 downto 0);
            opcode : out bit_vector(10 downto 0)
        );
    end component;

    component unidadeControle is
        port (
            opcode : in bit_vector(10 downto 0);
            reg2loc, uncondBranch, branch, memRead, memToReg : out bit;
            aluOp : out bit_vector(3 downto 0);
            memWrite, aluSrc, regWrite : out bit
        );
    end component;

    -- Sinais de conexao Controle <-> Datapath
    signal s_reg2loc, s_uncondBranch, s_branch, s_memRead, s_memToReg : bit;
    signal s_memWrite, s_aluSrc, s_regWrite : bit;
    signal s_aluOp : bit_vector(3 downto 0);
    signal s_opcode : bit_vector(10 downto 0);

begin

    -- Instancia do Datapath
    DATAPATH: fluxoDados port map (
        clock        => clock,
        reset        => reset,
        reg2loc      => s_reg2loc,
        uncondBranch => s_uncondBranch,
        branch       => s_branch,
        memRead      => s_memRead,
        memToReg     => s_memToReg,
        aluOp        => s_aluOp,
        memWrite     => s_memWrite,
        aluSrc       => s_aluSrc,
        regWrite     => s_regWrite,
        pc_out       => pc_out,
        alu_result   => alu_result,
        opcode       => s_opcode -- Datapath envia o opcode lido
    );

    -- Instancia do Controle
    CONTROL: unidadeControle port map (
        opcode       => s_opcode, -- Controle recebe e decide
        reg2loc      => s_reg2loc,
        uncondBranch => s_uncondBranch,
        branch       => s_branch,
        memRead      => s_memRead,
        memToReg     => s_memToReg,
        aluOp        => s_aluOp,
        memWrite     => s_memWrite,
        aluSrc       => s_aluSrc,
        regWrite     => s_regWrite
    );

end architecture structural;