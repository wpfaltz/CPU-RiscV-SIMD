library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forward is 
    port( 
         clk                        : IN std_logic;                         -- Entrada do sinal de clock
         reg_Write_WB, reg_Write_MEM  : IN std_logic;                         -- Sinais de controle de escrita no registrador do WB e do Mem, respectivamente
         Rs1, Rs2                   : IN std_logic_vector(4 downto 0);      -- Endereçoes dos registradores Rs1 e Rs2 vindos do estágio ID/EX do pipeline
         Rd_WB, Rd_Mem              : IN std_logic_vector(4 downto 0);      -- Endereços dos registradores de armazenamento Rd, vindos dos estágios de MEM/WB e EX/MEM do pipeline
         forwardA, forwardB         : OUT std_logic_vector(1 downto 0)      -- Saídas indicando os forwards para as fontes A e B
     );
end Forward;

ARCHITECTURE Behavioral OF MEMWB IS
    signal forwardA_interno, forwardB_interno : std_logic_vector(1 downto 0) := "00";   -- Sinais internos que armazenam o encaminhamento

begin
    process(clk)
    begin
        if ((reg_Write_MEM = '1') and (not(Rd_Mem = "00000")) and (Rd_Mem = Rs1)) then
            forwardA_interno <= "10";   
        end if;

        if ((reg_Write_MEM = '1') and (not(Rd_Mem = "00000")) and (Rd_Mem = Rs2)) then
            forwardB_interno <= "10";  
        end if;

        if ((reg_Write_WB = '1') and (not(Rd_WB = "00000")) and (Rd_WB = Rs1)) then
            forwardA_interno <= "01";   
        end if;

        if ((reg_Write_WB = '1') and (not(Rd_WB = "00000")) and (Rd_WB = Rs2)) then
            forwardB_interno <= "01";   
        end if;

    end process;

    forwardA <= forwardA_interno;  
    forwardB <= forwardB_interno;
       
END Behavioral;
