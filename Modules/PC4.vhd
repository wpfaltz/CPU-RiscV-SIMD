library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;


ENTITY PC4 IS
	PORT (
		clk      		: IN  std_logic;                    	-- Entrada do Clock
		reset    		: IN  std_logic;                    	-- Entrada de reset
		PC_in    		: IN  std_logic_vector(31 DOWNTO 0);	-- Entrada do endereço atual
		Write_Enable	: IN std_logic;               			-- Entrada de Habilitação de escrita no PC
		PC_out   		: OUT std_logic_vector(31 DOWNTO 0)  	-- Saída do próximo endereço
	);
END PC4;

ARCHITECTURE Behavioral OF PC4 IS

BEGIN

	PROCESS (clk, reset, Write_Enable)
	BEGIN
		IF (rising_edge(clk)) THEN                      				-- Detecção do Clock
			if (PC_in = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then   	-- Verificação de endereço indefinido
				PC_out <= (others => '0');               			-- Caso indefinido, início no primeiro endereço
			elsif (Write_Enable = '0') then              				-- Write_Enable desabilitado
				PC_out <= PC_in;								-- Manutenção do endereço atual
			elsif (Write_Enable = '1') then						-- Write_Enable habilitado
				PC_out <= PC_in + '1';							-- Atualização do endereço
			end if;
		END IF;
		IF (reset = '1') THEN                           				-- Detecção de reset
			PC_out <= (others => '0');                   			-- Retorno ao primeiro endereço
		END IF;
	END PROCESS;

END Behavioral;
