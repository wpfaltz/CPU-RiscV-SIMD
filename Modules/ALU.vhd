library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ALU is
    port(
        A, B       : in std_logic_vector(31 downto 0);   -- Operandos A e B de 32 bits da ALU
        controle   : in std_logic_vector(3 downto 0);    -- Entrada responsável por determinar a operação da ALU
        result  : out std_logic_vector(31 downto 0);  -- Resultado da operação feita pela ALU
        f_zero     : out std_logic;                      -- Flag indicadora de resultado igual a zero na operacão da ALU
        mode       : in std_logic;                       -- Modo de operação: 0 para operação única e 1 para operação vetorial
        vector_size     : in std_logic_vector(1 downto 0)     -- Tamanho do vetor de operações (usado no modo vetorial)
    );
end ALU;


architecture Behavioral of ALU is

-- Declaração dos sinais temporários da ALU
signal result_nv : std_logic_vector(31 downto 0); -- Resultado não vetorial
signal result_v  : std_logic_vector(31 downto 0); -- Resultado vetorial
signal soma_v       : std_logic_vector(31 downto 0); -- Sinal temporário que armazena o resultado final da soma vetorial
signal sub_v        : std_logic_vector(31 downto 0); -- Sinal temporário que armazena o resultado final da subtração vetorial
signal shiftL_v     : std_logic_vector(31 downto 0); -- Sinal temporário que armazena o resultado final do Shift Left vetorial
signal shiftR_v     : std_logic_vector(31 downto 0); -- Sinal temporário que armazena o resultado final da Shift Right vetorial

signal A16_1 : std_logic_vector(15 downto 0);  -- Vetor que contém os bits de índice 31 até 16 do operando quando vector_size='10' (16 bits)
signal A16_2 : std_logic_vector(15 downto 0);  -- Vetor que contém os bits de índice 15 até 0 do operando quando vector_size='10' (16 bits)

signal A8_1 : std_logic_vector(7 downto 0);  -- Vetor que contém os bits de índice 31 até 24 do operando quando vector_size='01' (8 bits)
signal A8_2 : std_logic_vector(7 downto 0);  -- Vetor que contém os bits de índice 23 até 16 do operando quando vector_size='01' (8 bits)
signal A8_3 : std_logic_vector(7 downto 0);  -- Vetor que contém os bits de índice 15 até 8 do operando quando vector_size='01' (8 bits)
signal A8_4 : std_logic_vector(7 downto 0);  -- Vetor que contém os bits de índice 7 até 0 do operando quando vector_size='01' (8 bits)

signal A4_1 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 31 até 28 do operando quando vector_size='00' (4 bits)
signal A4_2 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 27 até 24 do operando quando vector_size='00' (4 bits)
signal A4_3 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 23 até 20 do operando quando vector_size='00' (4 bits)
signal A4_4 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 19 até 16 do operando quando vector_size='00' (4 bits)
signal A4_5 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 15 até 12 do operando quando vector_size='00' (4 bits)
signal A4_6 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 11 até 8 do operando quando vector_size='00' (4 bits)
signal A4_7 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 7 até 4 do operando quando vector_size='00' (4 bits)
signal A4_8 : std_logic_vector(3 downto 0);  -- Vetor que contém os bits de índice 3 até 0 do operando quando vector_size='00' (4 bits)

signal integer_B : integer;                  -- Integer do valor binário que entra como operando B

begin

    -- Conversão da entrada B para integer para uso nas operações de deslocamento
    integer_B <= to_integer(unsigned(B));

    -- Divisão do sinal de entrada A em subvetores para as operações vetoriais
    A16_1 <= A(31 downto 16);
    A16_2 <= A(15 downto 0);

    A8_1 <= A(31 downto 24);
    A8_2 <= A(23 downto 16);
    A8_3 <= A(15 downto 8);
    A8_4 <= A(7 downto 0);

    A4_1 <= A(31 downto 28);
    A4_2 <= A(27 downto 24);
    A4_3 <= A(23 downto 20);
    A4_4 <= A(19 downto 16);
    A4_5 <= A(15 downto 12);
    A4_6 <= A(11 downto 8);
    A4_7 <= A(7 downto 4);
    A4_8 <= A(3 downto 0);
    
    
    -- Cálculos das operações vetoriais com base no tamanho do vetor (vector_size)
    soma_v <= (A + B) when vector_size = "11" else
             ((A16_1 + B(31 downto 16)) & (A16_2 + B(15 downto 0))) when vector_size = "10" else
             ((A8_1 + B(31 downto 24)) & (A8_2 + B(23 downto 16)) & (A8_3 + B(15 downto 8)) & (A8_4 + B(7 downto 0))) when vector_size = "01" else
             ((A4_1 + B(31 downto 28)) & (A4_2 + B(27 downto 24)) & (A4_3 + B(23 downto 20)) & (A4_4 + B(19 downto 16)) & (A4_5 + B(15 downto 12)) & (A4_6 + B(11 downto 8)) & (A4_7 + B(7 downto 4)) & (A4_8 + B(3 downto 0))) when vector_size = "00";
    
    sub_v <= (A - B) when vector_size = "11" else
             ((A16_1 - B(31 downto 16)) & (A16_2 - B(15 downto 0))) when vector_size = "10" else
             ((A8_1 - B(31 downto 24)) & (A8_2 - B(23 downto 16)) & (A8_3 - B(15 downto 8)) & (A8_4 - B(7 downto 0))) when vector_size = "01" else
             ((A4_1 - B(31 downto 28)) & (A4_2 - B(27 downto 24)) & (A4_3 - B(23 downto 20)) & (A4_4 - B(19 downto 16)) & (A4_5 - B(15 downto 12)) & (A4_6 - B(11 downto 8)) & (A4_7 - B(7 downto 4)) & (A4_8 - B(3 downto 0))) when vector_size = "00";
    
    -- Cálculos das operações de deslocamento vetoriais
    shiftL_v <= (std_logic_vector(shift_left(unsigned(A), integer_B))) when vector_size = "11" else
             ((std_logic_vector(shift_left(unsigned(A16_1), integer_B))) & std_logic_vector(shift_left(unsigned(A16_2), integer_B))) when vector_size = "10" else
             ((std_logic_vector(shift_left(unsigned(A8_1), integer_B))) & (std_logic_vector(shift_left(unsigned(A8_2), integer_B))) & (std_logic_vector(shift_left(unsigned(A8_3), integer_B))) & (std_logic_vector(shift_left(unsigned(A8_4), integer_B)))) when vector_size = "01" else
             ((std_logic_vector(shift_left(unsigned(A4_1), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_2), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_3), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_4), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_5), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_6), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_7), integer_B))) & (std_logic_vector(shift_left(unsigned(A4_8), integer_B)))) when vector_size = "00";

    shiftR_v <= (std_logic_vector(shift_right(unsigned(A), integer_B))) when vector_size = "11" else
             ((std_logic_vector(shift_right(unsigned(A16_1), integer_B))) & std_logic_vector(shift_right(unsigned(A16_2), integer_B))) when vector_size = "10" else
             ((std_logic_vector(shift_right(unsigned(A8_1), integer_B))) & (std_logic_vector(shift_right(unsigned(A8_2), integer_B))) & (std_logic_vector(shift_right(unsigned(A8_3), integer_B))) & (std_logic_vector(shift_right(unsigned(A8_4), integer_B)))) when vector_size = "01" else
             ((std_logic_vector(shift_right(unsigned(A4_1), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_2), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_3), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_4), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_5), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_6), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_7), integer_B))) & (std_logic_vector(shift_right(unsigned(A4_8), integer_B)))) when vector_size = "00";
    

    -- ALU vetorial (mode = 1) 
    result_v <= soma_v when controle = "0010" else
                sub_v when controle = "0110" else
                shiftL_v when controle = "0011" else
                shiftR_v when controle = "0111" else
                (others => '0');
    
    -- ALU não vetorial (mode = 0)
    result_nv <= (A + B) when controle = "0010" else
                   (A - B) when controle = "0110" else
                   (A XOR B) when controle = "0101" else
                   (A OR B) when controle = "0001" else
                   (A AND B) when controle = "0000" else
                   (std_logic_vector(shift_left(unsigned(A), integer_B))) when controle = "0011" else
                   (std_logic_vector(shift_right(unsigned(A), integer_B))) when controle = "0111";
    
    -- Seleção do resultado de acordo com o sinal de controle "mode"
    result <= result_nv when mode = '0' else
                result_v when mode = '1';
                
    -- Sinalização se o resultado é zero (serve para o Branch) -> como as operações vetoriais não incluem Branch, basta verificar do resultado não vetorial
    f_zero <= '1' when result_nv = "00000000000000000000000000000000" else '0';   

end Behavioral;
