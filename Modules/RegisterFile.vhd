library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
  port(
    Read_Register_1           : in std_logic_vector(4 downto 0);    -- Endereço do primeiro registrador a ser lido
    Read_Register_2           : in std_logic_vector(4 downto 0);    -- Endereço do segundo registrador a ser lido
    Write_Register      	    : in std_logic_vector(4 downto 0);    -- Endereço do registrador a ser escrito
    Write_Data                : in  std_logic_vector(31 downto 0);  -- Dado a ser escrito
    Reg_Write  			          : in  std_logic;     				          -- Sinal de controle
    Read_Data_1         	    : out  std_logic_vector(31 downto 0); -- Dado do primeiro registrador lido
    Read_Data_2       	      : out  std_logic_vector(31 downto 0); -- Dado do segundo registrador lido
    clk                 	    : in  std_logic                       -- Sinal do CLOCK
  );
end RegisterFile;

architecture Behavioral of RegisterFile is
  type RegisterFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal Registers : RegisterFile := 
   ("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000");

begin
  regFile : process (clk) is
  begin
    if falling_edge(clk) then
      if (Registers(to_integer(unsigned(Read_Register_1))) = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") THEN -- Caso o valor do registrador esteja indefinido, a saída será "000..."
      	Read_Data_1 <= (others => '0');  
      ELSE 
      	Read_Data_1 <= registers(to_integer(unsigned(Read_Register_1)));  -- Leitura do valor contido no registrador 1
      END IF;
      IF (Registers(to_integer(unsigned(Read_Register_2))) = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") THEN -- Caso o valor do registrador esteja indefinido, a saída será "000..."
      	Read_Data_2 <= (others => '0');  
      ELSE
      	Read_Data_2 <= registers(to_integer(unsigned(Read_Register_2)));  -- Leitura do valor contido no registrador 2 
      END IF;
    end if; 
    if rising_edge(clk) then
      if Reg_Write = '1' then
        Registers(to_integer(unsigned(Write_Register))) <= Write_Data;      -- Escrita do valor no registrador selecionado
      end if;
    end if;
  end process;
  
end Behavioral;
