LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY IDEX IS
  PORT (
        CLK             : IN std_logic;                             -- Sinal de entrada de clock            
        ALU_Src_in       : IN std_logic;                            -- Entradas do ALU_Src e ALU_Op, que são sinais de controle para a ALU_Control
        ALU_Op_in        : IN std_logic_vector(1 downto 0);         -- ALUSrc e ALUOp são usados no estágio EX do pipeline, então não aparecem nos proximos regs do pipeline
        funct3_in       : IN std_logic_vector(2 downto 0);          -- Entrada do Funct3, usado na ALU_Control
        funct7_in       : IN std_logic_vector(6 downto 0);          -- Entrada do Funct7, usado na ALU_Control
        PC_in           : IN std_logic_vector(31 downto 0);         -- Entrada do valor atual do PC (contador de programa)
        Soma_PC_in      : IN std_logic;                             -- Sinal de entrada de controle que define quando o PC deve ser somado (jal)        
        Branch_in       : IN std_logic;                             -- Sinal de entrada de controle que define quando ocorre Branch
        Mem_Write_in    : IN std_logic;                             -- Sinal de entrada de controle que define quando a Memória será escrita
        Mem_Read_in     : IN std_logic;                             -- Sinal de entrada de controle que define quando a Memória será lida
        Reg_Write_in    : IN std_logic;                             -- Sinal de entrada de controle que define quando o registrador será escrito
        Mem_To_Reg_in   : IN std_logic;                             -- Sinal de entrada de controle que define quando um dado será passado da memória para o registrador
        read1_in        : IN std_logic_vector(31 downto 0);         -- Entrada do valor lido do read data 1
        read2_in        : IN std_logic_vector(31 downto 0);         -- Entrada do valor lido do read data 2
        immediate_in    : in std_logic_vector(31 downto 0);         -- Entrada do imediato gerado pelo ImmGen
        Rd_in           : IN std_logic_vector(4 downto 0);          -- Entrada da instrução atual buscada na memória de instruções
        Opcode_in		: IN std_logic_vector(6 downto 0);		    -- Entrada do Opcode
        JumpReg_in		: IN std_Logic;					    -- Entrada do JumpReg
        Rs1_In		    : IN std_logic_vector(4 downto 0);		    -- Entrada do Rs1	
        Rs2_In		    : IN std_logic_vector(4 downto 0);		    -- Entrada do Rs2
        mode_in         : in std_logic;                             -- Modo de operação: 0 para operação única e 1 para operação vetorial
        vecsize_in      : in std_logic_vector(1 downto 0);          -- Tamanho do vetor de operações (usado no modo vetorial)
    
        ALU_Src_out     : out std_logic;                            -- Saídas do ALUSrc e ALUOp, que são sinais de controle para a ALU_Control
        ALU_Op_out      : out std_logic_vector(1 downto 0);         -- ALUSrc e ALUOp são usados no estágio EX do pipeline, então não aparecem nos proximos regs do pipeline
        funct3_out      : out std_logic_vector(2 downto 0);         -- Saída do Funct3, usado na ALU_Control    
        funct7_out      : out std_logic_vector(6 downto 0);         -- Saída do Funct7, usado na ALU_Control
        PC_out          : out std_logic_vector(31 downto 0);        -- Saída do valor atual do PC (contador de programa)
        Soma_PC_out     : out std_logic;                            -- Saída do sinal de controle que define quando o PC deve ser somado (jal)
        Branch_out      : out std_logic;                            -- Saída do sinal de controle que define quando ocorre Branch
        Mem_Write_out   : out std_logic;                            -- Saída do sinal de controle que define quando a Memória será escrita
        Mem_Read_out    : out std_logic;                            -- Saída do sinal de controle que define quando a Memória será lida
        Reg_Write_out   : out std_logic;                            -- Saída do sinal de controle que define quando o registrador será escrito
        Mem_To_Reg_out  : out std_logic;                            -- Saída do sinal de controle que define quando um dado será passado da memória para o registrador
        read1_out       : out std_logic_vector(31 downto 0);        -- Saída do valor lido do read data 1
        read2_out       : out std_logic_vector(31 downto 0);        -- Saída do valor lido do read data 2   
        immediate_out   : out std_logic_vector(31 downto 0);        -- Saída do imediato gerado pelo ImmGen
        Rd_out          : out std_logic_vector(4 downto 0);         -- Saída da instrução atual buscada na memória de instruções
        Opcode_out		: out std_logic_vector(6 downto 0);	    -- Saída do Opcode
        JumpReg_out	    : out std_Logic;					    -- Saída do JumpReg
        Rs1_out		    : out std_logic_vector(4 downto 0);	    -- Saída do Rs1	
        Rs2_out		    : out std_logic_vector(4 downto 0)		    -- Saída do Rs2
        mode_out        : out std_logic;                            -- Modo de operação: 0 para operação única e 1 para operação vetorial
        vecsize_out     : out std_logic_vector(1 downto 0)          -- Tamanho do vetor de operações (usado no modo vetorial)
    );  
END IDEX;


ARCHITECTURE Behavioral OF IDEX IS

SIGNAL idex_sig : std_logic_vector(173 DOWNTO 0);  -- Registrador de 151 bits para armazenar os valores do IDEX

BEGIN

    PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN                   -- Detecção de subida de CLOCK
            idex_sig(0) <= ALU_Src_in;          
            idex_sig(2 downto 1) <= ALU_Op_in;          
            idex_sig(5 DOWNTO 3) <= funct3_in;      
            idex_sig(12 DOWNTO 6) <= funct7_in;
            idex_sig(44 DOWNTO 13) <= PC_in ;  
            idex_sig(45) <= Soma_PC_in;       
            idex_sig(46) <= Branch_in;   
            idex_sig(47) <= MemWrite_in;   
            idex_sig(48) <= Mem_Read_in;   
            idex_sig(49) <= Reg_Write_in;   
            idex_sig(50) <= Mem_To_Reg_in;   
            idex_sig(82 DOWNTO 51) <= read1_in;    
            idex_sig(114 DOWNTO 83) <= read2_in;    
            idex_sig(146 DOWNTO 115) <= immediate_in;   
            idex_sig(152 DOWNTO 147) <= Rd_in;
            idex_sig(159 downto 153) <= Opcode_in; 
            idex_sig(160) <= JumpReg_in;  
            idex_sig(165 downto 161) <= Rs1_In;
            idex_sig(170 downto 166) <= Rs2_In;
            idex_sig(171) <= mode_in;        
            idex_sig(173 downto 172) <= vecsize_in;   
        END IF;
        IF (falling_edge(CLK)) THEN                 -- Detecção de descida de CLOCK
            ALU_Src_out <= idex_sig(0);       
            ALU_Op_out  <= idex_sig(2 downto 1);     
            funct3_out <= idex_sig(5 DOWNTO 3);      
            funct7_out <= idex_sig(12 DOWNTO 6);    
            PC_out <= idex_sig(44 DOWNTO 13);
            Soma_PC_out <= idex_sig(45);
            Branch_out <= idex_sig(46);
            Mem_Write_out <= idex_sig(47);
            Mem_Read_out <= idex_sig(48);
            Reg_Write_out <= idex_sig(49);
            Mem_To_Reg_out <= idex_sig(50);
            read1_out <= idex_sig(82 DOWNTO 51);
            read2_out <= idex_sig(114 DOWNTO 83);
            immediate_out <= idex_sig(146 DOWNTO 115);
            Rd_out <= idex_sig(152 DOWNTO 147);
            Opcode_out <= idex_sig(159 downto 153);
            JumpReg_out <= idex_sig(160);
            Rs1_out <= idex_sig(165 downto 161);
            Rs2_out <= idex_sig(170 downto 166);
            mode_out <= idex_sig(171);
            vecsize_out <= idex_sig(173 downto 172);
            
        END IF;
    END PROCESS;

    
END Behavioral;
