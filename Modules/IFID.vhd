LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY IFID IS
  	PORT (
		clk         : IN  std_logic;                    -- Entrada do CLOCK
		PC_in        : IN  std_logic_vector(31 DOWNTO 0); -- Entrada do valor atual do PC (contador de programa)
		PC4_in	 : IN  std_logic_vector(31 downto 0); -- Entrada do valor do PC mais 4 (próxima instrução)
		Write_Enable   : IN std_logic;                 -- Entrada do sinal de habilitação de escrita no IFID
		Instruction_In      : IN  std_logic_vector(31 DOWNTO 0); -- Entrada da instrução atual buscada na memória de instruções
		PC_out       : OUT std_logic_vector(31 DOWNTO 0); -- Saída do valor atual do PC (contador de programa)
		PC4_out	 : OUT std_logic_vector(31 downto 0); -- Saída do valor do PC mais 4 (próxima instrução)
		Instruction_Out     : OUT std_logic_vector(31 DOWNTO 0);  -- Saída da instrução atual buscada na memória de instruções
		Rs1 : OUT std_logic_vector(4 DOWNTO 0);  -- Saída da instrução atual buscada na memória de instruções
		Rs2 : OUT std_logic_vector(4 DOWNTO 0);  -- Saída da instrução atual buscada na memória de instruções
		Rd : OUT std_logic_vector(4 DOWNTO 0)  -- Saída da instrução atual buscada na memória de instruções
    );
END IFID;


ARCHITECTURE Behavioral OF IFID IS

signal opcode : std_logic_vector(6 downto 0);	-- Opcode da Instrução
signal s_Rs1 : std_logic_vector(4 downto 0);		-- Rs1 da Instrução
signal s_Rs2 : std_logic_vector(4 downto 0);		-- Rs2 da Instrução
signal s_Rd : std_logic_vector(4 downto 0);		-- Rd da Instrução
SIGNAL IDIF : std_logic_vector(117 DOWNTO 0);  	-- Registrador de 96 bits para armazenar os valores do IFID

BEGIN
	-- Definição do Opcode da Instrução
	opcode(0) <= Instruction_In(0);
	opcode(1) <= Instruction_In(1);
	opcode(2) <= Instruction_In(2);
	opcode(3) <= Instruction_In(3);
	opcode(4) <= Instruction_In(4);
	opcode(5) <= Instruction_In(5);
	opcode(6) <= Instruction_In(6);

	process(opcode)
	begin
	-- Rs1
		IF NOT (opcode = "1101111" or opcode = "0110111") THEN  -- Tipos diferentes de U e UJ tem Rs1
		s_Rs1 (0) <= Instruction_In(15);
		s_Rs1 (1) <= Instruction_In(16);
		s_Rs1 (2) <= Instruction_In(17);
		s_Rs1 (3) <= Instruction_In(18);
		s_Rs1 (4) <= Instruction_In(19);
		END IF;

	-- Rs2
		IF (opcode = "0110011" or opcode = "0100011" or opcode = "1100011") THEN  -- Tipos R, S e Sb tem Rs2
		s_Rs2 (0) <= Instruction_In(20);
		s_Rs2 (1) <= Instruction_In(21);
		s_Rs2 (2) <= Instruction_In(22);
		s_Rs2 (3) <= Instruction_In(23);
		s_Rs2 (4) <= Instruction_In(24);
		END IF;

	-- Rd
		IF NOT (opcode = "0100011" or opcode = "1100011") THEN  -- Tipos diferentes de S e Sb tem Rd
		s_Rd (0) <= Instruction_In(7); 
		s_Rd (1) <= Instruction_In(8);
		s_Rd (2) <= Instruction_In(9);
		s_Rd (3) <= Instruction_In(10);
		s_Rd (4) <= Instruction_In(11);
		END IF;
	end process;

	
	PROCESS (clk, Write_Enable)
	BEGIN
		IF (rising_edge(clk)) THEN                   	-- Detecção de subida de CLOCK
			if (Write_Enable = '1') then             	-- Vericação se o Write_Enable está habilitado
				IDIF(31 DOWNTO 0) <= Instruction_In;       
				IDIF(63 DOWNTO 32) <= PC_in;          	-- Armazena o valor atual do PC
				IDIF(95 downto 64) <= PC4_in;       	-- Armazena o valor do PC mais 4 (próxima instrução)
				IDIF(102 downto 96) <= opcode;		-- Armazena o opcode
				IDIF(107 downto 103) <= s_Rs1;		-- Armazena o Rs1
				IDIF(112 downto 108) <= s_Rs2;		-- Armazena o Rs2
				IDIF(117 downto 113) <= s_Rd;			-- Armazena o Rd
			end if;
		END IF;
		IF (falling_edge(clk)) THEN                 		-- Detecção de descida de CLOCK
			PC_out <= IDIF(63 DOWNTO 32);           	-- Definição do PC atual
			Instruction_Out <= IDIF(31 DOWNTO 0);        -- Definição da instrução armazenada
			PC4_out <= IDIF(95 downto 64);        		-- Saída de PC+4
			Rs1 <= IDIF(107 downto 103);				-- Saída do Rs1
			Rs2 <= IDIF(112 downto 108);				-- Saída do Rs2
			Rd <= IDIF(117 downto 113);				-- Saída do Rd
		END IF;
	END PROCESS;
	
END Behavioral;
