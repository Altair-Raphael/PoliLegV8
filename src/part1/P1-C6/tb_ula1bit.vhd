
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: ULA 1 bit

library ieee;
use ieee.numeric_bit.all;

entity tb_ula1bit is
end entity tb_ula1bit;

architecture behavioral of tb_ula1bit is

    -- Sinais de teste
    signal a_s, b_s         : bit := '0';
    signal ainvert_s        : bit := '0';
    signal binvert_s        : bit := '0';
    signal cin_s            : bit := '0';
    signal operation_s      : bit_vector(1 downto 0) := "00";
    signal result_s         : bit;
    signal cout_s           : bit;
    signal overflow_s       : bit;

begin

    -- Instanciação Direta
    DUT: entity work.ula1bit
    port map (
        a         => a_s,
        b         => b_s,
        ainvert   => ainvert_s,
        binvert   => binvert_s,
        cin       => cin_s,
        operation => operation_s,
        result    => result_s,
        cout      => cout_s,
        overflow  => overflow_s
    );

    -- Processo de Teste
    p_test: process
    begin
        report "INICIO SIMULACAO ULA 1 BIT" severity note;

        -- =========================================================
        -- TESTE 1: Operação AND (00)
        -- =========================================================
        operation_s <= "00"; 
        ainvert_s <= '0'; binvert_s <= '0'; cin_s <= '0';
        
        -- 1 AND 0 = 0
        a_s <= '1'; b_s <= '0'; wait for 10 ns;
        assert result_s = '0' report "ERRO: 1 AND 0 falhou" severity error;
        
        -- 1 AND 1 = 1
        a_s <= '1'; b_s <= '1'; wait for 10 ns;
        assert result_s = '1' report "ERRO: 1 AND 1 falhou" severity error;

        -- =========================================================
        -- TESTE 2: Operação OR (01)
        -- =========================================================
        operation_s <= "01";
        
        -- 0 OR 0 = 0
        a_s <= '0'; b_s <= '0'; wait for 10 ns;
        assert result_s = '0' report "ERRO: 0 OR 0 falhou" severity error;

        -- 1 OR 0 = 1
        a_s <= '1'; b_s <= '0'; wait for 10 ns;
        assert result_s = '1' report "ERRO: 1 OR 0 falhou" severity error;

        -- =========================================================
        -- TESTE 3: Operação ADD (10) e Carry
        -- =========================================================
        operation_s <= "10";
        
        -- 0 + 1 (Cin=0) = 1, Cout=0
        a_s <= '0'; b_s <= '1'; cin_s <= '0'; wait for 10 ns;
        assert result_s = '1' and cout_s = '0' 
            report "ERRO: Soma 0+1 falhou" severity error;

        -- 1 + 1 (Cin=0) = 0, Cout=1
        a_s <= '1'; b_s <= '1'; cin_s <= '0'; wait for 10 ns;
        assert result_s = '0' and cout_s = '1' 
            report "ERRO: Soma 1+1 falhou (CarryOut esperado)" severity error;

        -- 1 + 1 (Cin=1) = 1, Cout=1
        a_s <= '1'; b_s <= '1'; cin_s <= '1'; wait for 10 ns;
        assert result_s = '1' and cout_s = '1' 
            report "ERRO: Soma 1+1+1 falhou" severity error;

        -- =========================================================
        -- TESTE 4: Inversores (Ainvert / Binvert) com AND
        -- =========================================================
        operation_s <= "00"; -- AND
        
        -- NOT(0) AND 1 => 1 AND 1 = 1
        a_s <= '0'; b_s <= '1';
        ainvert_s <= '1'; -- Inverte A
        binvert_s <= '0';
        wait for 10 ns;
        assert result_s = '1' report "ERRO: Ainvert falhou" severity error;

        -- =========================================================
        -- TESTE 5: Subtração (Simulada: A + NOT(B) + 1)
        -- =========================================================
        operation_s <= "10"; -- ADD (na ULA a subtração é feita pelo somador)
        a_s <= '1'; b_s <= '0'; -- 1 - 0
        ainvert_s <= '0'; 
        binvert_s <= '1'; -- Inverte B (Complemento de 1)
        cin_s <= '1';     -- Soma 1 (Complemento de 2)
        
        -- CORREÇÃO AQUI:
        -- Lógica: 1 + NOT(0) + 1 = 1 + 1 + 1 = 3 (Binário 11).
        -- Result (LSB) = 1. CarryOut (MSB) = 1.
        wait for 10 ns;
        assert result_s = '1' and cout_s = '1'
            report "ERRO: Subtracao (A - B) falhou" severity error;

        -- =========================================================
        -- TESTE 6: Pass B (11)
        -- =========================================================
        operation_s <= "11";
        ainvert_s <= '0'; binvert_s <= '0'; cin_s <= '0'; -- Reseta controles não usados
        a_s <= '1'; b_s <= '0'; wait for 10 ns;
        
        assert result_s = '0' report "ERRO: Pass B falhou (esperado 0)" severity error;
        
        b_s <= '1'; wait for 10 ns;
        assert result_s = '1' report "ERRO: Pass B falhou (esperado 1)" severity error;

        report "FIM DA SIMULACAO ULA. Se nao houver erros acima, sucesso." severity note;
        wait;
    end process;

end architecture behavioral;