library ieee;
use ieee.numeric_bit.all;
use work.polilegv8_pkg.all; -- Usa o nosso pacote para entender o tipo 'reg_array'

entity mux32_64 is
    port (
        inputs : in reg_array;            -- As 32 entradas de 64 bits
        sel    : in bit_vector(4 downto 0);
        dOut   : out bit_vector(63 downto 0)
    );
end entity mux32_64;

architecture behavioral of mux32_64 is
begin
    -- Seleciona o vetor dentro do array baseado no indice inteiro
    dOut <= inputs(to_integer(unsigned(sel)));
end architecture behavioral;