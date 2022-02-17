----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2021 11:58:13 AM
-- Design Name: 
-- Module Name: REGFILE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REGFILE is
  Port (RA1 : in std_logic_vector (2 downto 0);
  RA2 : in std_logic_vector (2 downto 0);
  WA : in std_logic_vector (2 downto 0);
  WD :in std_logic_vector(15 downto 0);
  RegWr: in std_logic;
  clk : in std_logic;
  enable1 : in std_logic;
  RD1 : out std_logic_vector( 15 downto 0);
  RD2 : out std_logic_vector (15 downto 0) );
end REGFILE;

architecture Behavioral of REGFILE is
signal Radresa1 : integer := 0;
signal Radresa2 : integer := 0;
signal Wadresa : integer:= 0;
type ROM_COMP is array (0 to 7) of std_logic_vector(15 downto 0) ;
signal rom : ROM_COMP :=(
"0000000000000000",
"0000000000000000",
"0000000000000000",
"0000000000000000",
"0000000000000000",
"0000000000000000",
"0000000000000000",
"0000000000000000",
others=>"0000000000000000"
);
begin
process(clk)
begin 
if clk'event and clk='1' then
    Radresa1 <= conv_integer(RA1);
    Radresa2<= conv_integer(RA2);
    RD1<=rom(Radresa1);
    RD2<=rom(Radresa2);
    Wadresa<= conv_integer(WA);
    if enable1 ='1' and RegWr ='1' then
    rom(Wadresa) <= WD;
    end if;
    
end if;
end process;

end Behavioral;
