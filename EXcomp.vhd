
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EXcomp is
 Port(  
 PCentry: in std_logic_vector(15 downto 0);
 RD1: in std_logic_vector( 15 downto 0);
 RD2 : in std_logic_vector(15 downto 0);
 ALUSrc: in std_logic;
 Ext_Imm: in std_logic_vector(15 downto 0);
 sa: in std_logic;
 funct : in std_logic_vector(2 downto 0 );
 ALUOp: in std_logic_vector(2 downto 0);
 Zero: out std_logic;
 BRANCHAdress: out std_logic_vector(15 downto 0);
 ALURes: out std_logic_vector(15 downto 0);
 bltzEX:out std_logic
);
end EXcomp;

architecture Behavioral of EXcomp is
signal ALUCtrl : std_logic_vector (2 downto 0);
signal outmux1 : std_logic_vector( 15 downto 0);
signal ALURESINTERN: std_logic_vector( 15 downto 0);

begin
outmux1 <= RD2(15 downto 0) when ALUSrc ='0' else Ext_Imm(15 downto 0);
BRANCHAdress<= PCentry+Ext_Imm;
process(ALUOp,funct)
begin
case ALUOp is 
when "000" =>
case funct is 
when "000" => ALUCtrl <="000" ; --add
when "001" => ALUCtrl <="001" ; --sub
when "010" => ALUCtrl <="010"; --srl
when "011" => ALUCtrl <="011"; --sll
when "100" => ALUCtrl <="100"; --and
when "101" =>ALUCtrl <="101"; -- or
when "110" =>ALUCtrl <="110"; --xor
when "111" =>ALUCtrl <="111"; --and
when others => ALUCtrl <= (others =>'X'); --unknown
end case;
when "001" => ALUCtrl <="000"; --addi,sw,lw
when "010" => ALUCtrl <= "001";--subi,beq,bltz
when "101" =>ALUCtrl <="100"; --andi
when "110" => ALUCtrl <="110"; -- bltz
when others => ALUCtrl <= (others => 'X'); --unknown
end case;
end process;

process(ALUCtrl,RD1,outmux1,sa)
begin
bltzEX<='0';
case ALUCtrl is 
when "000" => ALURESINTERN<=outmux1+RD1;
when "001" => ALURESINTERN<=RD1-outmux1;
when "010" => ALURESINTERN(15)<='0' ; ALURESINTERN(14 downto 0)<= RD1(15 downto 1) ;
when "011" => ALURESINTERN(15 downto 1)<=RD1(14 downto 0) ;ALURESINTERN(0)<='0';
when "100" => ALURESINTERN<= RD1 and outmux1;
when "101"=> ALURESINTERN <= RD1 or outmux1;
when "110" =>ALURESINTERN <= RD1-outmux1;
when "111" => ALURESINTERN <= RD1 and outmux1;
when others =>ALURESINTERN <= (others =>'X'); 
end case;
if(ALURESINTERN(15)='1' and ALUCTRL="110") then
bltzEX<='1';
end if;
end process;
Zero<='1' when ALURESINTERN= 0 else '0';
ALURes<=ALURESINTERN;


end Behavioral;
