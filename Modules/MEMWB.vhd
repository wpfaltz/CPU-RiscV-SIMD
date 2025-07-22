LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MEMWB IS
    PORT (
        CLK             : IN std_logic;                             -- Sinal de entrada de clock            
        Reg_Write_in     : IN std_logic;                             -- Sinal de entrada de controle que define quando o registrador será escrito
        Mem_To_Reg_in     : IN std_logic;                             -- Sinal de entrada de controle que define quando um dado será passado da memória para o registrador
        Mem_data_in     : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do valor lido na memória
        ALU_result_in    : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do resultado da operação da ALU
        Rd_in           : IN std_logic_vector(4 DOWNTO 0);          -- Entrada da instrução atual buscada na memória de instruções
        
        Reg_Write_out    : out std_logic;                            -- Sinal de saída de controle que define quando o registrador será escrito
        Mem_To_Reg_out    : out std_logic;                            -- Sinal de saída de controle que define quando um dado será passado da memória para o registrador
        Mem_data_out    : out std_logic_vector(31 DOWNTO 0);        -- Saída do valor lido na memória
        ALU_result_out   : out std_logic_vector(31 DOWNTO 0);        -- Saída do resultado da operação da ALU
        Rd_out          : out std_logic_vector(4 DOWNTO 0)          -- Saída da instrução atual buscada na memória de instruções
    );
END MEMWB;


ARCHITECTURE Behavioral OF MEMWB IS

SIGNAL memwb_sig : std_logic_vector(70 DOWNTO 0);  -- Registrador de 70 bits para armazenar os valores do memwb

BEGIN

    PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN                   -- Detecta a borda de subida do sinal de clock     
            memwb_sig(0)   <= Reg_Write_in;
            memwb_sig(1)   <= Mem_To_Reg_in;  
            memwb_sig(33 downto 2)  <= Mem_data_in ;       
            memwb_sig(65 downto 34)  <= ALU_result_in;   
            memwb_sig(70 downto 66)  <= Rd_in;   
        END IF;
        IF (falling_edge(CLK)) THEN                 -- Detecta a borda de descida do sinal de clock
            Reg_Write_out <= memwb_sig(0);    
            Mem_To_Reg_out <= memwb_sig(1);
            Mem_data_out <= memwb_sig(33 downto 2);
            ALU_result_out <= memwb_sig(65 downto 34);
            Rd_out <= memwb_sig(70 downto 66);
        END IF;
    END PROCESS;

    
END Behavioral;
