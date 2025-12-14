library ieee;
use ieee.numeric_bit.all;

package polilegv8_pkg is
    -- definir um array de 32 vetores de 64 bits
    -- facilita a criacao do Mux e do Banco de Registradores
    type reg_array is array (0 to 31) of bit_vector(63 downto 0);
end package polilegv8_pkg;