
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: deslocador

library ieee;
use ieee.numeric_bit.all; 

entity two_left_shifts is
    generic (
        dataSize: natural := 64
    );
    port(
        input  : in bit_vector(dataSize-1 downto 0);
        output : out bit_vector(dataSize-1 downto 0)
    );
end entity two_left_shifts;

architecture rtl of two_left_shifts is
begin
    -- Lógica de deslocamento assíncrono:
    -- Pega os bits da entrada (do tamanho total - 3 até 0) e concatena com "00" no final.
    -- Os bits mais significativos (MSB) originais são descartados.
    output <= input(dataSize-3 downto 0) & "00";
    
end architecture rtl;