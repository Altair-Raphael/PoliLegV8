
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: testbench do deslocador

library ieee;
use ieee.numeric_bit.all; 

entity tb_two_left_shifts is
end entity tb_two_left_shifts;

architecture behavioral of tb_two_left_shifts is
    -- Usaremos 8 bits para o teste para facilitar a leitura visual, 
    -- mas o componente é genérico e funciona para 64 bits.
    constant C_DATA_SIZE : natural := 8;
    
    signal input_s  : bit_vector(C_DATA_SIZE-1 downto 0);
    signal output_s : bit_vector(C_DATA_SIZE-1 downto 0);

begin

    -- Instanciação Direta para evitar erros de "binding"
    DUT: entity work.two_left_shifts
    generic map (
        dataSize => C_DATA_SIZE
    )
    port map (
        input  => input_s,
        output => output_s
    );

    -- Processo de Teste (Sem clock, pois o componente é assíncrono)
    p_test: process
    begin
        report "Iniciando testes do Deslocador..." severity note;

        -- CASO 1: Deslocamento de valor simples (1 virando 4)
        -- Entrada: ...000001
        -- Saída esperada: ...000100
        input_s <= "00000001";
        wait for 10 ns;
        assert output_s = "00000100"
            report "ERRO: Falha no deslocamento do valor 1." severity error;

        -- CASO 2: Deslocamento com perda de bits (Overflow)
        -- Os dois bits mais significativos '11' devem sumir.
        -- Entrada: 11000000
        -- Saída esperada: 00000000
        input_s <= "11000000";
        wait for 10 ns;
        assert output_s = "00000000"
            report "ERRO: Falha ao descartar os bits mais significativos." severity error;

        -- CASO 3: Padrão misto
        -- Entrada: 00001111
        -- Saída esperada: 00111100
        input_s <= "00001111";
        wait for 10 ns;
        assert output_s = "00111100"
            report "ERRO: Falha no padrão misto." severity error;

        -- CASO 4: Teste de Zero
        input_s <= "00000000";
        wait for 10 ns;
        assert output_s = "00000000"
            report "ERRO: Falha na entrada zero." severity error;

        -- Finalização
        report "Simulacao do Deslocador concluida com sucesso (se nenhum erro apareceu acima)." severity note;
        wait;
    end process;

end architecture behavioral;