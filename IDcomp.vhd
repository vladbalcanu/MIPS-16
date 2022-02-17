----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2021 05:31:37 PM
-- Design Name: 
-- Module Name: IDcomp - Behavioral
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


entity IDcomp is
port(clk :in std_logic;
enableWrite: in std_logic;
instr: in std_logic_vector(15 downto 0);
WD: in std_logic_vector(15 downto 0);
RegWrite : in std_logic;
RegDst :in std_logic;
ExtOp :in std_logic;
RD1: out std_logic_vector(15 downto 0);
RD2: out std_logic_vector(15 downto 0);
Ext_Imm:out std_logic_vector (15 downto 0);
func:out std_logic_vector (2 downto 0);
sa :out std_logic;
WAout:out std_logic_vector(2 downto 0);
WriteAdress:in std_logic_vector(2 downto 0)
);
end IDcomp;

architecture Behavioral of IDcomp is

signal outmux1 : std_logic_vector(2 downto 0);
signal ExtUnit : std_logic_vector(15 downto 0);

component REGFILE is
Port (RA1 : in std_logic_vector (2 downto 0);
  RA2 : in std_logic_vector (2 downto 0);
  WA : in std_logic_vector (2 downto 0);
  WD :in std_logic_vector(15 downto 0);
  RegWr: in std_logic;
  clk : in std_logic;
  enable1 : in std_logic;
  RD1 : out std_logic_vector( 15 downto 0);
  RD2 : out std_logic_vector (15 downto 0) );
end component;



begin
registru:REGFILE port map(instr(12 downto 10),instr(9 downto 7),WriteAdress,WD,RegWrite,clk,enableWrite,RD1,RD2);
WAout<= instr(6 downto 4) when RegDst ='1' else instr(9 downto 7);
ExtUnit<= "000000000" & instr(6 downto 0);
Ext_Imm<=ExtUnit;
sa <= instr(3);
func <=instr(2 downto 0);
end Behavioral;
