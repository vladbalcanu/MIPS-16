----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2021 11:32:42 AM
-- Design Name: 
-- Module Name: SSD - Behavioral
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



entity SSD is
  Port (    
  clk : in std_logic;
  Digit0: in std_logic_vector(3 downto 0);
   Digit1: in std_logic_vector(3 downto 0);
    Digit2: in std_logic_vector(3 downto 0);
    Digit3: in std_logic_vector(3 downto 0);
    segmenteDCD: out std_logic_vector(6 downto 0);
    anod:out std_logic_vector(3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal numarator : std_logic_vector(15 downto 0) := "0000000000000000";
signal outmux1 : std_logic_vector(3 downto 0) :="0000";
signal outmux2: std_logic_vector(3 downto 0):="0000";
signal out7seg:std_logic_vector(6 downto 0):="0000000";

begin 
process(clk)
begin
if clk'event and clk='1' then
    numarator <= numarator + '1';
end if;

case numarator(15 downto 14) is
when "00"=> outmux1 <=Digit0 ; outmux2 <="1110";
when "01"=> outmux1 <=Digit1 ; outmux2 <="1101";
when "10"=> outmux1 <=Digit2 ; outmux2<="1011"; 
when "11"=> outmux1<=Digit3 ; outmux2 <="0111";
end case;

case outmux1 is
when "0000" => out7seg <="1000000"; --'0' abcdefg
when "0001" => out7seg <="1111001"; --'1'
when "0010" => out7seg <="0100100"; --'2'0100100
when "0011" => out7seg <="0110000"; --'3'   
when "0100" => out7seg <="0011001"; --'4'
when "0101" => out7seg <="0010010"; --'5'
when "0110" => out7seg <="0000010"; --'6'
when "0111" => out7seg <="1111000"; --'7'
when "1000" => out7seg <="0000000"; --'8'
when "1001" => out7seg <="0010000"; --'9'
when "1010" => out7seg <="0001000"; --"10" sau 'A'
when "1011" => out7seg <="0000011"; --"11" sau 'b'
when "1100" => out7seg <="1000110"; --"12" sau 'C'
when "1101" => out7seg <="0100001"; --"13" sau 'd'
when "1110" => out7seg <="0000110"; --"14" sau 'E'
when "1111" => out7seg <="0001110"; --"15" sau 'F'
end case;


segmenteDCD <= out7seg;
anod <= outmux2;

end process;


end Behavioral;
