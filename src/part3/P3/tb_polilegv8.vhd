-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench PoliLegV8

library ieee;
use ieee.numeric_bit.all;

entity tb_polilegv8 is
end entity tb_polilegv8;

architecture test of tb_polilegv8 is
    component polilegv8 is
        port (
            clock, reset : in bit;
            pc_out       : out bit_vector(63 downto 0);
            alu_result   : out bit_vector(63 downto 0)
        );
    end component;

    signal s_clock, s_reset : bit := '0';
    signal s_pc_out, s_alu_result : bit_vector(63 downto 0);
    
    constant CLK_PERIOD : time := 20 ns; -- Clock mais lento para garantir estabilidade

begin
    DUT: polilegv8 port map (s_clock, s_reset, s_pc_out, s_alu_result);

    -- Gerador de Clock
    process
    begin
        s_clock <= '0'; wait for CLK_PERIOD/2;
        s_clock <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- Processo de Estimulo
    process
    begin
        report "Inicio Simulacao PoliLEGv8";
        
        -- Reset Inicial
        s_reset <= '1'; 
        wait for CLK_PERIOD * 2; 
        s_reset <= '0';

        -- Deixa o processador rodar por alguns ciclos
        -- Ciclo 1: Busca instrucao 0 (LDUR ou ADD conforme seu .dat)
        wait for CLK_PERIOD;
        report "Ciclo 1 Concluido. PC=" & integer'image(to_integer(unsigned(s_pc_out)));

        -- Ciclo 2
        wait for CLK_PERIOD;
        report "Ciclo 2 Concluido. PC=" & integer'image(to_integer(unsigned(s_pc_out)));
        
        -- Ciclo 3
        wait for CLK_PERIOD;
        report "Ciclo 3 Concluido. PC=" & integer'image(to_integer(unsigned(s_pc_out)));

        -- Ciclo 4
        wait for CLK_PERIOD;
        report "Ciclo 4 Concluido. PC=" & integer'image(to_integer(unsigned(s_pc_out)));

        report "Fim Simulacao PoliLEGv8";
        wait; -- Para a simulacao
    end process;

end architecture;