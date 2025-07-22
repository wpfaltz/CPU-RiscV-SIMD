library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazard is 
    port( 
        clk         : IN std_logic;                     -- Entrada do sinal de clock
        Mem_Read_in : IN std_logic;                     -- Sinal de controle que define quando a Memória será lida
        Rd_EX       : IN std_logic_vector(4 downto 0);  -- Rd é o endereço de destino da operação feita pelo CPU após o estágio de EX
        Rs1, Rs2    : IN std_logic_vector(4 downto 0);  -- Rs1 e Rs2 são os endereços dos registradores contidos na instrução
        stall       : OUT std_logic                     -- Saída que indica se um "stall" (atraso) deve ser aplicado no pipeline
    );
end Hazard;

architecture Behavioral of Hazard is

    signal stall_interno : std_logic := '0';  -- Signal temporário que armazena o nível lógico do stall

begin
    process(clk)
    begin
        if ((Mem_Read_in = '1') and ((Rd_EX = Rs1) or (Rd_EX = Rs2))) then
            stall_interno <= '1';                                                -- Se o sinal de controle de Mem_Read_in for igual a 1 e o resultado  
        end if;                                                                  -- do estágio de Execution estiver em Rs1 ou Rs2, realiza um stall
    end process;

    stall <= stall_interno;                                                     -- Atribui o valor do signal temporário stall_interno à saída stall

end Behavioral;
