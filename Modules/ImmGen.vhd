library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ImmGen is
    Port( 
        instruction: in std_logic_vector(31 downto 0);  	-- Entrada da Instrução 
        immediate: out std_logic_vector(31 downto 0)  		-- Saída do Valor Imediato
        );
end ImmGen;

architecture Behavioral of ImmGen is
    signal opcode       : std_logic_vector(6 downto 0);  		-- Sinal para armazenr o opcode da instrução
    signal S_imm  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";  -- Sinal auxiliar para definição do imediato

begin

    opcode <= instruction(6 downto 0);  -- Definição do opcode

    process(opcode)
    begin
        if (opcode = "0010011" or opcode = "0000011" or opcode = "1100111") then  	-- Tipo I 
            S_imm(11 downto 0)  <= instruction(31 downto 20);  					-- Seleciona o imediato 
            S_imm(31 downto 12) <= (others => instruction(31));  				-- Extensão do Bit de Sinal
        elsif (opcode = "1101111") then  									-- Tipo UJ 
            S_imm(20) <= instruction(31);  									-- Seleciona o imediato
            S_imm(10 downto 1) <= instruction(30 downto 21);					-- Seleciona o imediato
            S_imm(11) <= instruction(20);									-- Seleciona o imediato	
            S_imm(19 downto 12) <= instruction(19 downto 12);					-- Seleciona o imediato
            S_imm(31 downto 21) <= (others => instruction(31));					-- Extensão do Bit de Sinal
        elsif (opcode = "0110111" or opcode = "0010111") then										-- Tipo U 
        	  S_imm(31 downto 12) <= instruction(31 downto 12);  					-- Seleciona o imediato	
        elsif (opcode = "0100011") then  									-- Tipo S 
            S_imm(11 downto 5)  <= instruction(31 downto 25);  					-- Seleciona o imediato
            S_imm(4 downto 0)   <= instruction(11 downto 7);   					-- Seleciona o imediato
            S_imm(31 downto 12) <= (others => instruction(31));  				-- Extensão do Bit de Sinal
        elsif (opcode = "1100011") then  									-- Tipo SB
            S_imm(12)           <= instruction(31);          					-- Seleciona o imediato
            S_imm(11)           <= instruction(7);           					-- Seleciona o imediato
            S_imm(10 downto 5)  <= instruction(30 downto 25);  					-- Seleciona o imediato
            S_imm(4 downto 1)   <= instruction(11 downto 8);   					-- Seleciona o imediato
            S_imm(31 downto 13) <= (others => instruction(31));  				-- Extensão do Bit de Sinal
        end if;
    end process;

    immediate <= S_imm;  												-- Atribui o valor imeadiato à saída

end Behavioral;
