library ieee;
use ieee.numeric_bit.all; 

entity tb_reg is
end entity tb_reg;

architecture test of tb_reg is

    -- 1. Declaração do Componente (Deve ser idêntica à Entity)
    component reg is
        generic (dataSize: natural := 64);
        port (
            clock  : in bit;
            reset  : in bit;
            enable : in bit;
            d      : in bit_vector(dataSize-1 downto 0);
            q      : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    -- 2. Sinais de Teste
    constant DATA_WIDTH : natural := 64;
    constant CLK_PERIOD : time := 10 ns;

    signal s_clock  : bit := '0';
    signal s_reset  : bit := '0';
    signal s_enable : bit := '0';
    signal s_d      : bit_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal s_q      : bit_vector(DATA_WIDTH-1 downto 0);

begin

    -- 3. Instanciação do DUT (Device Under Test)
    DUT: reg
        generic map (dataSize => DATA_WIDTH)
        port map (
            clock  => s_clock,
            reset  => s_reset,
            enable => s_enable,
            d      => s_d,
            q      => s_q
        );

    -- 4. Gerador de Clock
    p_clock: process
    begin
        s_clock <= '0';
        wait for CLK_PERIOD/2;
        s_clock <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Processo de Estímulos
    p_stimulus: process
    begin
        -- Caso 1: Teste do Reset Inicial
        report "Inicio do Teste: Verificando Reset..." severity note;
        s_reset <= '1';
        wait for CLK_PERIOD;
        assert (unsigned(s_q) = 0) report "Erro: Reset falhou!" severity error;
        s_reset <= '0';
        wait for CLK_PERIOD;

        -- Caso 2: Escrita Habilitada (Enable = 1)
        report "Teste: Escrita com Enable = 1..." severity note;
        s_enable <= '1';
        -- Escreve o valor 10 (decimal)
        s_d <= bit_vector(to_unsigned(10, DATA_WIDTH)); 
        wait for CLK_PERIOD;
        
        -- Verifica se gravou
        assert (unsigned(s_q) = 10) report "Erro: Falha na escrita (10)" severity error;

        -- Escreve o valor Maior (ex: 0xFF...FF)
        s_d <= (others => '1');
        wait for CLK_PERIOD;
        assert (s_q = (DATA_WIDTH-1 downto 0 => '1')) report "Erro: Falha na escrita (All 1s)" severity error;

        -- Caso 3: Retenção de Dado (Enable = 0)
        report "Teste: Retencao com Enable = 0..." severity note;
        s_enable <= '0';
        s_d <= (others => '0'); -- Mudamos a entrada para 0
        wait for CLK_PERIOD;
        
        -- A saída deve continuar sendo '111...1' (valor anterior), ignorando o '0' da entrada
        assert (s_q = (DATA_WIDTH-1 downto 0 => '1')) report "Erro: Registrador nao reteve o valor!" severity error;

        -- Caso 4: Reset durante operação
        report "Teste: Reset Assincrono..." severity note;
        s_enable <= '1';
        wait for 2 ns; -- Avança um pouco no tempo (fora da borda do clock)
        s_reset <= '1';
        wait for 1 ns; 
        
        -- Deve zerar imediatamente, sem esperar a próxima borda de subida
        assert (unsigned(s_q) = 0) report "Erro: Reset Assincrono falhou!" severity error;

        report "Fim dos testes do REG." severity note;
        wait; -- Para a simulação
    end process;

end architecture test;