library ieee;
use ieee.numeric_bit.all;

entity tb_sign_extend is
end entity tb_sign_extend;

architecture behavioral of tb_sign_extend is

    -- Definições de Tamanho para o Teste
    constant C_IN_SIZE  : natural := 32;
    constant C_OUT_SIZE : natural := 64;
    constant C_POS_SIZE : natural := 5; 

    -- Sinais
    signal inData_s      : bit_vector(C_IN_SIZE-1 downto 0) := (others => '0');
    signal inDataStart_s : bit_vector(C_POS_SIZE-1 downto 0) := (others => '0');
    signal inDataEnd_s   : bit_vector(C_POS_SIZE-1 downto 0) := (others => '0');
    signal outData_s     : bit_vector(C_OUT_SIZE-1 downto 0);

begin

    -- Instanciação Direta
    DUT: entity work.sign_extend
    generic map (
        dataISize       => C_IN_SIZE,
        dataOSize       => C_OUT_SIZE,
        dataMaxPosition => C_POS_SIZE
    )
    port map (
        inData      => inData_s,
        inDataStart => inDataStart_s,
        inDataEnd   => inDataEnd_s,
        outData     => outData_s
    );

    -- Processo de Teste
    process
    begin
        report "INICIO SIMULACAO: EXTENSOR DE SINAL" severity note;

        -----------------------------------------------------------------------
        -- CASO 1: Exemplo do Enunciado (Sinal Negativo)
        -----------------------------------------------------------------------
        inData_s <= (4 => '1', 0 => '1', others => '0'); -- ...00010001
        inDataStart_s <= "00100"; -- 4
        inDataEnd_s   <= "00001"; -- 1
        wait for 10 ns;

        -- Verifica se os bits inferiores são "000" e os superiores são todos '1'
        -- (60 downto 0 => '1') cria um vetor de 61 bits "11...11" explicitamente
        assert outData_s(2 downto 0) = "000" and outData_s(63 downto 3) = (60 downto 0 => '1')
            report "ERRO (Caso 1): Falha no exemplo do enunciado."
            severity error;

        -----------------------------------------------------------------------
        -- CASO 2: Extensão de Sinal Positivo
        -----------------------------------------------------------------------
        inData_s <= (1 => '1', 0 => '1', others => '0'); -- ...000011
        inDataStart_s <= "00010"; -- 2
        inDataEnd_s   <= "00000"; -- 0
        wait for 10 ns;

        assert outData_s(2 downto 0) = "011" and outData_s(63) = '0'
            report "ERRO (Caso 2): Falha na extensão de sinal positivo."
            severity error;

        -----------------------------------------------------------------------
        -- CASO 3: Bit Único (CORREÇÃO AQUI)
        -----------------------------------------------------------------------
        inData_s <= (5 => '1', others => '0');
        inDataStart_s <= "00101"; -- 5
        inDataEnd_s   <= "00101"; -- 5
        wait for 10 ns;

        -- CORREÇÃO: Usar intervalo explícito em vez de (others => '1') na comparação
        assert outData_s = (C_OUT_SIZE-1 downto 0 => '1')
            report "ERRO (Caso 3): Falha na extensão de bit único '1'."
            severity error;

        report "SIMULACAO EXTENSOR CONCLUIDA." severity note;
        wait;
    end process;

end architecture behavioral;