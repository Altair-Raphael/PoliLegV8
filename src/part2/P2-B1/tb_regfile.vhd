-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench Registradores

-- compilar na seguinte ordem:
-- src/part1/reg.vhd
-- src/part2/polilegv8_pkg.vhd
-- src/part2/decoder5_32.vhd
-- src/part2/mux32_64.vhd
-- src/part2/P2-B1/regfile.vhd
-- src/part2/tb_regfile.vhd

library ieee;
use ieee.numeric_bit.all;

entity tb_regfile is
end entity tb_regfile;

architecture test of tb_regfile is

    component regfile is
        port (
            clock    : in bit;
            reset    : in bit;
            regWrite : in bit;
            rr1, rr2, wr : in bit_vector(4 downto 0);
            d        : in bit_vector(63 downto 0);
            q1, q2   : out bit_vector(63 downto 0)
        );
    end component;

    signal s_clock    : bit := '0';
    signal s_reset    : bit := '0';
    signal s_regWrite : bit := '0';
    signal s_rr1, s_rr2, s_wr : bit_vector(4 downto 0) := (others => '0');
    signal s_d        : bit_vector(63 downto 0) := (others => '0');
    signal s_q1, s_q2 : bit_vector(63 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    signal sim_active : boolean := true;

begin

    DUT: regfile port map (s_clock, s_reset, s_regWrite, s_rr1, s_rr2, s_wr, s_d, s_q1, s_q2);

    -- Clock Process
    p_clock: process
    begin
        while sim_active loop
            s_clock <= '0'; wait for CLK_PERIOD/2;
            s_clock <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus Process
    process
    begin
        report "Inicio Teste RegFile";
        s_reset <= '1'; wait for CLK_PERIOD; s_reset <= '0';

        -- 1. Escrever valor 10 no registrador X1
        s_wr <= "00001";       -- Endereco X1
        s_d  <= bit_vector(to_unsigned(10, 64));
        s_regWrite <= '1';     -- Habilita escrita
        wait for CLK_PERIOD;
        
        -- 2. Escrever valor 20 no registrador X2
        s_wr <= "00010";       -- Endereco X2
        s_d  <= bit_vector(to_unsigned(20, 64));
        wait for CLK_PERIOD;
        
        s_regWrite <= '0';     -- Desabilita escrita para leitura segura

        -- 3. Ler X1 na porta 1 e X2 na porta 2 simultaneamente
        s_rr1 <= "00001"; -- Lê X1
        s_rr2 <= "00010"; -- Lê X2
        wait for CLK_PERIOD;
        
        assert (unsigned(s_q1) = 10) report "Erro ao ler X1" severity error;
        assert (unsigned(s_q2) = 20) report "Erro ao ler X2" severity error;

        -- 4. Teste do XZR (X31)
        -- Tenta escrever valor 999 no X31
        s_regWrite <= '1';
        s_wr <= "11111"; -- X31
        s_d  <= bit_vector(to_unsigned(999, 64));
        wait for CLK_PERIOD;
        s_regWrite <= '0';

        -- Tenta ler X31
        s_rr1 <= "11111";
        wait for CLK_PERIOD;
        -- Deve ser ZERO, ignorando a escrita
        assert (unsigned(s_q1) = 0) report "Erro: XZR (X31) foi sobrescrito!" severity error;

        report "Fim Teste RegFile com Sucesso";
        sim_active <= false;
        wait;
    end process;

end architecture;