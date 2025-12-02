library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity deslocador_n is
    generic (
        n : integer := 15 -- Tamanho configurável (Padrão 15 bits conforme PDF)
    );
    port (
        clock   : in  std_logic;
        limpa   : in  std_logic; -- Reset Síncrono (Zera tudo)
        carrega : in  std_logic; -- Carrega dados paralelos
        desloca : in  std_logic; -- Realiza o shift para direita
        entrada : in  std_logic; -- O bit serial que entra no MSB
        dados   : in  std_logic_vector(n-1 downto 0); -- Entrada Paralela
        saida   : out std_logic_vector(n-1 downto 0)  -- Saída Paralela
    );
end entity deslocador_n;

architecture Behavioral of deslocador_n is
    -- Registrador interno para guardar o estado
    signal reg_interno : std_logic_vector(n-1 downto 0) := (others => '0');
begin

    process(clock)
    begin
        if rising_edge(clock) then
            -- 1. Prioridade Máxima: LIMPA
            if limpa = '1' then
                reg_interno <= (others => '0');
            
            -- 2. Segunda Prioridade: CARREGA
            elsif carrega = '1' then
                reg_interno <= dados;
                
            -- 3. Terceira Prioridade: DESLOCA
            elsif desloca = '1' then
                -- Lógica do Deslocamento à Direita (Shift Right)
                -- Concatenamos o bit 'entrada' com os bits superiores do registrador.
                -- Exemplo (4 bits): entrada='1', reg="0011"
                -- Resultado: '1' & "001" = "1001" (O último '1' foi descartado)
                reg_interno <= entrada & reg_interno(n-1 downto 1);
            end if;
            
            -- Se nenhum sinal estiver ativo, o registrador mantém o valor (implícito no VHDL)
        end if;
    end process;

    -- Conecta o registrador interno à saída do componente
    saida <= reg_interno;

end Behavioral;