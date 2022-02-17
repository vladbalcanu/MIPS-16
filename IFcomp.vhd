----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2021 07:38:51 PM
-- Design Name: 
-- Module Name: IFcomp - Behavioral
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



entity IFcomp is
  Port (enablePC: in std_logic;
  enableResetPC:in std_logic;
  clk :in std_logic;
  branchADR:in std_logic_vector(15 downto 0);
  jumpADR:in std_logic_vector(15 downto 0);
  jump:in std_logic;
  PCSrc:in std_logic;
  instr:out std_logic_vector(15 downto 0);
  PC:out std_logic_vector(15 downto 0);
  impar:out std_logic );
end IFcomp;

architecture Behavioral of IFcomp is

type ROM_COMP is array (0 to 62) of std_logic_vector(15 downto 0) ;
signal rom1 : ROM_COMP :=(
B"000_000_000_100_0_000", --0   x"0040"
B"000_000_000_111_0_000", --1   x"0070"
B"001_000_101_0010000",   --2   x"2290"   
B"001_000_110_0000001",   --3   x"2301"
B"000_000_000_010_0_000", --4   x"0020"
B"000_000_000_011_0_000", --5   x"0030"
B"100_100_101_0100110",   --6   x"92A6"
B"0000000000000000",      --7   x"0000"
B"0000000000000000",      --8   x"0000"
B"0000000000000000",      --9   x"0000" 
B"010_100_001_0000000",   --10  x"5080"
B"001_110_110_0000001",   --11  x"3B01"
B"0000000000000000",      --12  x"0000"
B"0000000000000000",      --13  x"0000"
B"0000000000000000",      --14  x"0000"
B"000_000_110_011_0_000", --15  x"0330"
B"000_000_110_010_0_000", --16  x"0320"
B"0000000000000000",      --17  x"0000"
B"0000000000000000",      --18  x"0000"
B"100_000_011_0000111",   --19  x"8187"  
B"0000000000000000",      --20  x"0000"
B"0000000000000000",      --21  x"0000"
B"0000000000000000",      --22  x"0000"
B"000_001_110_001_0_001", --23  x"0711"
B"101_011_011_0000001",   --24  x"AD81"
B"111_0000000010010",     --25  x"E012"
B"0000000000000000",      --26  x"0000"
B"110_001_000_0001110",   --27  x"C40E"
B"0000000000000000",      --28  x"0000"
B"0000000000000000",      --29  x"0000"
B"0000000000000000",      --30  x"0000"
B"100_001_000_0000101",   --31  x"8405"  
B"0000000000000000",      --32  x"0000"
B"0000000000000000",      --33  x"0000"
B"0000000000000000",      --34  x"0000"
B"111_0000000001010",     --35  x"E00A"
B"0000000000000000",      --36  x"0000"
B"010_100_001_0000000",   --37  x"5080"
B"0000000000000000",      --38  x"0000"
B"0000000000000000",      --39  x"0000"
B"0000000000000000",      --40  x"0000"
B"000_001_111_111_0_000", --41  x"07F0"
B"001_100_100_0000001",   --42  x"3201"
B"111_0000000000011",     --43  x"E003"
B"0000000000000000",      --44  x"0000"
B"000_000_111_001_0_000", --45  x"0390"
B"011_101_111_0000000",   --46  x"7280"
B"0000000000000000",      --47  x"0000"
B"0000000000000000",      --48  x"0000"
B"000_001_001_001_1_010", --49  x"009A"
B"0000000000000000",      --50  x"0000"
B"0000000000000000",      --51  x"0000"
B"0000000000000000",      --52  x"0000"
B"000_001_001_001_1_011", --53  x"009B"
B"0000000000000000",      --54  x"0000"
B"0000000000000000",      --55  x"0000"
B"0000000000000000",      --56  x"0000"
B"100_111_001_0000100",   --57  x"9C84"
B"0000000000000000",      --58  x"0000"
B"0000000000000000",      --59  x"0000"
B"0000000000000000",      --60  x"0000"
B"000_000_111_001_0_000", --61  x"0390"
others=>x"0000"
);

signal PCD:std_logic_vector(15 downto 0);
signal PCQ:std_logic_vector(15 downto 0);
signal PCnumarator :std_logic_vector(15 downto 0);
signal outmux1 : std_logic_vector(15 downto 0);
signal internalImpar:std_logic:='0';
begin
process(clk)
begin
if enableResetPC='1' then
PCQ<=x"0000";
end if;
if clk'event and clk='1' then 
 if enablePC='1' then
 PCQ<=PCD;
 end if; 
end if;
if PCQ="0000000000011011" then
internalImpar <= '1';
end if;
end process;
outmux1<=branchADR when PCSrc='1' else PCnumarator;
PCD<=jumpADR when jump='1' else outmux1;
PCnumarator<=PCQ+'1';
PC<=PCnumarator;
instr<= rom1(conv_integer(PCQ));
impar<=internalImpar;
end Behavioral;
