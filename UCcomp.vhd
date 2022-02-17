----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2021 07:51:13 PM
-- Design Name: 
-- Module Name: UCcomp - Behavioral
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

entity UCcomp is
port(instr : in std_logic_vector (2 downto 0);
RegDst :out std_logic;
ExtOp :out std_logic;
ALUSrc : out std_logic;
BRANCH : out std_logic;
JUMP : out std_logic;
ALUOp : out std_logic_vector(2 downto 0);
MEMWrite: out std_logic;
MEMToReg: out std_logic;
REGWrite: out std_logic;
BLTZ:out std_logic
);
end UCcomp;

architecture Behavioral of UCcomp is

begin
process(instr)
begin
RegDst<='0';ExtOp<='0';ALUSrc<='0';BRANCH<='0';JUMP<='0';
ALUOp<="000";MEMWrite<='0';MEMToReg<='0';REGWrite<='0';
bltz<='0';
case(instr)is
    when "000" =>--tipul R
    RegDst<='1';
    REGWrite<='1';
    ALUOp<="000" ; 
    when "001" => -- ADDI
    ExtOp<='1';
    ALUSrc<='1';
    REGWrite<='1';
    ALUOp<="001"; 
    when "010" => --LW
    ExtOp<='1';
    ALUSrc<='1';
    MEMToReg<='1';
    REGWrite<='1';
    ALUOp<="001";
    when "011" => --SW
    ExtOp<='1';
    ALUSrc<='1';
    MEMWrite<='1';
    ALUOp<="001";
    when "100" => -- BEQ
    ExtOp<='1';
    BRANCH<='1';
    ALUOp<="010";
    when "101" =>--SUBI
    ExtOp<='1';
    ALUSrc<='1';
    REGWrite<='1';
    ALUOp<="010";
    when "110" =>--BLTZ
    ExtOp<='1';
    bltz<='1';
    ALUOp<="110";
    when "111" =>--JUMP
    JUMP<='1';
    when others =>
    RegDst<='0'; ExtOp<='0' ; ALUSrc<='0';BRANCH<='0';JUMP<='0';
    MEMWrite<='0';MEMToReg<='0';REGWrite<='0';ALUOp<="000";
    end case;
end process;


end Behavioral;
