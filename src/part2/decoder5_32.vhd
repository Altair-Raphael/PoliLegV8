library ieee;
use ieee.numeric_bit.all;

entity decoder5_32 is
    port (
        sel : in bit_vector(4 downto 0);
        res : out bit_vector(31 downto 0)
    );
end entity decoder5_32;

architecture behavioral of decoder5_32 is
begin
    process(sel)
        variable index : integer;
        variable temp  : bit_vector(31 downto 0);
    begin
        index := to_integer(unsigned(sel));
        temp := (others => '0');
        
        -- Acende apenas o bit correspondente ao indice selecionado
        temp(index) := '1';
        
        res <= temp;
    end process;
end architecture behavioral;