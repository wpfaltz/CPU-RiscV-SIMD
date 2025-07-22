library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
    port(
        Funct7    		: IN std_logic_vector(6 downto 0);    	 -- Sinal de entrada funct7
        Funct3    		: IN std_logic_vector(2 downto 0);    	 -- Sinal de entrada funct3
        Op_Code    		: IN std_logic_vector(6 downto 0);   	 -- Sinal de entrada Op_Code
        Alu_Op   		: IN std_logic_vector(1 downto 0);       -- Sinal de entrada códigos de operação da ALU (2 bits)
        ALU_Out 	: OUT std_logic_vector(3 downto 0);      -- Saída do controle de saída da ALU (4 bits)
        Beq_Bne		: OUT std_logic					 -- Sinal de controle de saída para verificação de Beq ou Bne
    );
end ALU_Control;

architecture Behavioral of ALU_Control is
begin

	ALU_Out <= 	"0010" when Alu_Op = "00" else 	-- Operação de Load
			 	"0110" when Alu_Op = "01" else 	-- Operação de Branch
			 	"0010" when Funct7 = "0000000" and Funct3 = "000" else 	-- Operação de Soma
			 	"0110" when Funct7 = "0100000" and Funct3 = "000" else 	-- Operação de Subtração
			 	"0011" when Funct7 = "0000000" and Funct3 = "001" else 	-- Operação de Shift Left
			 	"0101" when Funct7 = "0000000" and Funct3 = "100" else 	-- Operação XOR
			 	"0111" when Funct7 = "0000000" and Funct3 = "101" else 	-- Operação de Shift Right
			 	"0001" when Funct7 = "0000000" and Funct3 = "110" else 	-- Operação OR
			 	"0000" when Funct7 = "0000000" and Funct3 = "111"; 		-- Operação AND
				Beq_Bne <= '1' when Op_Code="1100011" and Funct3="000" else '0';			-- '1' quando a instrução for Beq
	 
end Behavioral;
