entity reg is
    generic (dataSize: natural := 64);
    port (
        clock  : in bit;
        reset  : in bit;
        enable : in bit;
        d      : in bit_vector(dataSize-1 downto 0);
        q      : out bit_vector(dataSize-1 downto 0)
    );
end entity reg;

architecture behavior of reg is
    -- Sinal interno para armazenar o estado
    signal storage : bit_vector(dataSize-1 downto 0);
begin

    process(clock, reset)
    begin
        -- Reset Assíncrono (Prioridade sobre o Clock)
        if reset = '1' then
            storage <= (others => '0');
        
        -- Escrita Síncrona na Borda de Subida
        elsif (clock'event and clock = '1') then
            if enable = '1' then
                storage <= d;
            end if;
        end if;
    end process;

    -- Saída Assíncrona (Sempre reflete o estado interno)
    q <= storage;

end architecture behavior;