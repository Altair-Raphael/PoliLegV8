-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Unidade de Controle 

library ieee;
use ieee.numeric_bit.all;

entity unidadeControle is
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
end entity unidadeControle;

architecture behavioral of unidadeControle is
begin
    process(opcode)
    begin
        -- Resetando sinais para evitar latch (valores default)
        reg2loc <= '0'; uncondBranch <= '0'; branch <= '0';
        memRead <= '0'; memToReg <= '0'; memWrite <= '0';
        aluSrc <= '0'; regWrite <= '0'; aluOp <= "0000"; -- AND default

        case opcode is
            -- R-Format: ADD (10001011000)
            when "10001011000" => 
                regWrite <= '1'; aluOp <= "0010"; -- ADD

            -- R-Format: SUB (11001011000)
            when "11001011000" => 
                regWrite <= '1'; aluOp <= "0110"; -- SUB

            -- R-Format: AND (10001010000)
            when "10001010000" => 
                regWrite <= '1'; aluOp <= "0000"; -- AND

            -- R-Format: ORR (10101010000)
            when "10101010000" => 
                regWrite <= '1'; aluOp <= "0001"; -- OR

            -- D-Format: LDUR (11111000010) - Load
            when "11111000010" => 
                aluSrc <= '1'; memRead <= '1'; memToReg <= '1'; regWrite <= '1'; 
                aluOp <= "0010"; -- Calcula Endereço (ADD)

            -- D-Format: STUR (11111000000) - Store
            when "11111000000" => 
                reg2loc <= '1'; aluSrc <= '1'; memWrite <= '1'; 
                aluOp <= "0010"; -- Calcula Endereço (ADD)

            -- CBZ (10110100...) - Compare and Branch Zero
            -- Nota: CBZ geralmente usa 8 bits de opcode, aqui verificamos 11 para simplificar,
            -- assumindo que os bits 23-21 sao padrao ou que o fluxoDados extrai corretamente.
            -- Para LEGv8 estrito, CBZ é 10110100 (8 bits). Vamos verificar prefixo.
            -- Ajuste: Vamos considerar opcode exato se possivel, ou range.
            when "10110100000" | "10110100001" | "10110100010" | "10110100011" => 
                 reg2loc <= '1'; branch <= '1'; aluOp <= "0111"; -- Pass B (testar valor)

            -- B (000101...) - Unconditional Branch
            when others =>
                -- Check para Branch incondicional (000101)
                if opcode(10 downto 5) = "000101" then
                    uncondBranch <= '1';
                end if;
        end case;
    end process;
end architecture;