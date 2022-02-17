

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MEMcomp is
 Port (
 clk:in std_logic;
 enable:in std_logic;
 MEMwrite: in std_logic;
 ALUResin : in std_logic_vector(15 downto 0);
 RD2 : in std_logic_vector(15 downto 0);
 MEMdata : out std_logic_vector(15 downto 0);
 ALURes : out std_logic_vector(15 downto 0)
  );
end MEMcomp;

architecture Behavioral of MEMcomp is
signal WRadresa : integer := 0;
type ROM_COMP is array (0 to 16) of std_logic_vector(15 downto 0) ;
signal RAM : ROM_COMP :=(
x"0004",
x"0005",
x"0003",
x"0009",
x"0006",
x"0010",
x"0007",
x"0005",
x"0001",
x"000A",
x"0004",
x"0008",
x"0007",
x"0002",
x"0001",
x"0003",
others=>"0000000000000000"
);
begin
MEMdata<=RAM(conv_integer(ALUResin(4 downto 0)));
ALURes<=ALUResin;
process(clk)
begin
if clk'event and clk='1' then
    if MEMwrite='1' and enable='1' then
       RAM(conv_integer(ALUResin(4 downto 0)))<=RD2;
    end if;
end if;

end process;


end Behavioral;
