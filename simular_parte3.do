# ============================================================================
# Script de Compilação e Simulação - Parte 3 (Completo PoliLEGv8)
# ============================================================================

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

echo ">>> Compilando Parte 1 (Componentes Básicos)..."
# Utilitários e Componentes Simples
vcom -2008 -work work src/part1/utils/fulladder.vhd
vcom -2008 -work work src/part1/P1-C6/ula1bit.vhd
vcom -2008 -work work src/part1/P1-C1/reg.vhd
vcom -2008 -work work src/part1/P1-C5/adder_n.vhd
vcom -2008 -work work src/part1/P1-C2/mux_n.vhd
vcom -2008 -work work src/part1/P1-C7/sign_extend.vhd
vcom -2008 -work work src/part1/P1-C8/two_left_shifts.vhd

# Memórias (Atenção: Elas leem o arquivo .dat da pasta onde o vsim roda)
vcom -2008 -work work src/part1/P1-C3/memoriaInstrucoes.vhd
vcom -2008 -work work src/part1/P1-C4/memoriaDados.vhd

echo ">>> Compilando Parte 2 (Banco de Registradores e ULA)..."
# Pacotes e Auxiliares
vcom -2008 -work work src/part2/polilegv8_pkg.vhd
vcom -2008 -work work src/part2/decoder5_32.vhd
vcom -2008 -work work src/part2/mux32_64.vhd

# Blocos Principais
vcom -2008 -work work src/part2/P2-B1/regfile.vhd
vcom -2008 -work work src/part2/P2-B2/ula.vhd

echo ">>> Compilando Parte 3 (Processador Monociclo)..."
# Fluxo de Dados e Controle
vcom -2008 -work work src/part3/P3/fluxoDados.vhd
vcom -2008 -work work src/part3/P3/unidadeControle.vhd

# Top Level (Processador Completo)
vcom -2008 -work work src/part3/P3/polilegv8.vhd

echo ">>> Preparando Arquivos de Dados..."
# Copia os arquivos .dat da pasta P3 para a raiz (onde o ModelSim enxerga)
file copy -force src/part3/P3/memInstrPolilegv8.dat .
file copy -force src/part3/P3/memDadosInicialPolilegv8.dat .

echo ">>> Compilando Testbenches..."
vcom -2008 -work work src/part3/P3/tb_fluxoDados.vhd
vcom -2008 -work work src/part3/P3/tb_unidadeControle.vhd
vcom -2008 -work work src/part3/P3/tb_polilegv8.vhd

echo ""
echo "----------------------------------------------------------------"
echo "COMPILAÇÃO CONCLUÍDA!"
echo "1. Testar Controle:    vsim work.tb_unidadeControle"
echo "2. Testar Processador: vsim work.tb_polilegv8"
echo "----------------------------------------------------------------"