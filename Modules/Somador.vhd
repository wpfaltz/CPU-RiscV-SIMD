LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL; 

ENTITY Somador IS
  PORT (
    A, B        : IN  std_logic_vector(31 DOWNTO 0); 	-- Entrada de vetores de 32 bits
    Z           : OUT std_logic_vector(31 DOWNTO 0) 	-- Saída do vetor resultado da soma
  );
END Somador;

ARCHITECTURE Behavioral OF Somador IS

BEGIN

Z <= A + B; -- Vetor resultado da soma

END Behavioral;
