LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY EXMEM IS
    PORT (
        clk             : IN std_logic;                         -- Entrada do sinal de clock            
        Branch_in       : IN std_logic;                         -- Entrada do sinal de controle que define quando ocorre Branch
        Mem_Write_in     : IN std_logic;                         -- Entrada do sinal de controle que define quando a Memória será escrita
        Mem_Read_in      : IN std_logic;                         -- Entrada do sinal de controle que define quando a Memória será lida
        Reg_Write_in     : IN std_logic;                         -- Entrada do sinal de controle que define quando o registrador será escrito
        Mem_To_Reg_in     : IN std_logic;                         -- Entrada do sinal de controle que define quando um dado será passado da memória para o registrador
        New_PC_in       : IN std_logic_vector(31 downto 0);     -- Soma do PC com imediato (jal) ou reg com imediato substituindo PC (jalr)
        Zero_in         : IN std_logic;                         -- Quando o resultado da ALU foi zero (serve para Branch)
        ALU_result_in    : IN std_logic_vector(31 downto 0);     -- Entrada do resultado da operação da ALU
        read2_in        : IN std_logic_vector(31 downto 0);     -- Entrada do valor lido do read data 2
        Rd_in           : IN std_logic_vector(4 downto 0);      -- Entrada da instrução atual buscada na memória de instruções
        Jalr_ou_Jal_in	: IN std_logic;					        -- Entrada que indica se é Jalr ou Jal	
    
        Branch_out      : out std_logic;                        -- Saída do sinal de controle que define quando ocorre Branch 
        Mem_Write_out    : out std_logic;                        -- Saída do sinal de controle que define quando a Memória será escrita
        Mem_Read_out     : out std_logic;                        -- Saída do sinal de controle que define quando a Memória será lida
        Reg_Write_out    : out std_logic;                        -- Saída do sinal de controle que define quando o registrador será escrito
        Mem_To_Reg_out    : out std_logic;                        -- Saída do sinal de controle que define quando um dado será passado da memória para o registrador
        New_PC_out       : out std_logic_vector(31 downto 0);   -- Soma do PC com imediato (jal) ou reg com imediato substituindo PC (jalr)
        Zero_out        : out std_logic;                        -- Quando o resultado da ALU foi zero (serve para Branch)
        ALU_result_out   : out std_logic_vector(31 downto 0);    -- Saída do resultado da operação da ALU
        read2_out       : out std_logic_vector(31 downto 0);    -- Saída do valor lido do read data 2
        Rd_out          : out std_logic_vector(4 downto 0);     -- Saída da instrução atual buscada na memória de instruções
        Jalr_ou_Jal_out	: out std_logic					        -- Saída que indica se é Jalr ou Jal
    );
END EXMEM;


ARCHITECTURE Behavioral OF EXMEM IS

SIGNAL exmem_sig : std_logic_vector(107 downto 0);

BEGIN

    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            exmem_sig(0)    <= Branch_in;          
            exmem_sig(1)    <= Mem_Write_in;          
            exmem_sig(2)   <= Mem_Read_in;      
            exmem_sig(3)   <= Reg_Write_in;
            exmem_sig(4)   <= Mem_To_Reg_in;  
            exmem_sig(36 downto 5)    <= New_PC_in;       
            exmem_sig(37)           <= Zero_in;   
            exmem_sig(69 downto 38)    <= ALU_result_in;   
            exmem_sig(101 downto 70)    <= read2_in;   
            exmem_sig(106 downto 102)    <= Rd_in;   
            exmem_sig(107) <= Jalr_ou_Jal_in;
        END IF;
        IF (falling_edge(clk)) THEN
            Branch_out    <= exmem_sig(0);       
            Mem_Write_out  <= exmem_sig(1);     
            Mem_Read_out  <= exmem_sig(2);      
            Reg_Write_out <= exmem_sig(3);    
            Mem_To_Reg_out <= exmem_sig(4);
            New_PC_out <= exmem_sig(36 downto 5);
            Zero_out <= exmem_sig(37);
            ALU_result_out <= exmem_sig(69 downto 38);
            read2_out <= exmem_sig(101 downto 70);
            Rd_out <= exmem_sig(106 downto 102);
            Jalr_ou_Jal_out <= exmem_sig(107);
        END IF;
    END PROCESS;

    
END Behavioral;
