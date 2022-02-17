----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 08:23:14 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal selectie: STD_LOGIC_VECTOR(15 downto 0):= x"0000"; -- numarator pentru decizia de operatie
signal enable1: STD_LOGIC;
signal enable2: std_logic;
signal iesiriDCD: std_logic_vector( 6 downto 0) := "0000000";
signal iesiriAnod : std_logic_vector (3 downto 0) :="0000";
signal adresa : integer := 0;
signal valoare : std_logic_vector(15 downto 0);
signal instructiune: std_logic_vector(15 downto 0);
signal progcont:std_logic_vector(15 downto 0);
signal jumpADR: std_logic_vector(15 downto 0);
signal branchADR: std_logic_vector(15 downto 0);

component MPG is
port (     en: out  STD_LOGIC;
           input: in STD_LOGIC;
           clk : in  STD_LOGIC);
          end component;
          
component SSD is
Port (    
  clk : in std_logic;
  Digit0: in std_logic_vector(3 downto 0);
   Digit1: in std_logic_vector(3 downto 0);
    Digit2: in std_logic_vector(3 downto 0);
    Digit3: in std_logic_vector(3 downto 0);
    segmenteDCD: out std_logic_vector(6 downto 0);
    anod:out std_logic_vector(3 downto 0));
end component;

component REGFILE is
port(RA1 : in std_logic_vector (3 downto 0);
  RA2 : in std_logic_vector (3 downto 0);
  WA : in std_logic_vector (3 downto 0);
  WD :in std_logic_vector(15 downto 0);
  RegWr: in std_logic;
  clk : in std_logic;
  RD1 : out std_logic_vector( 15 downto 0);
  RD2 : out std_logic_vector (15 downto 0)
  );
end component;

component RAM is
port(WRA: in std_logic_vector(3 downto 0);
 RD: out std_logic_vector(15 downto 0);
 WD: in std_logic_vector(15 downto 0);
 WE: in std_logic;
 clk: in std_logic);
end component;

component ROM is
port(clk :in std_logic;
    RA:in std_logic_vector(3 downto 0);
    RD:out std_logic_vector(15 downto 0));
end component;

component IFcomp is
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
end component;

component IDcomp is
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
WAout: out std_logic_vector(2 downto 0);
WriteAdress: in std_logic_vector(2 downto 0)
);
end component;
         
component UCcomp is
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
end component;

component EXcomp is
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
 bltzEX:out std_logic);
end component;  

component MEMcomp is
 Port (
 clk:in std_logic;
 MEMwrite: in std_logic;
 enable:in std_logic;
 ALUResin : in std_logic_vector(15 downto 0);
 RD2 : in std_logic_vector(15 downto 0);
 MEMdata : out std_logic_vector(15 downto 0);
 ALURes : out std_logic_vector(15 downto 0)
  );
end component;

signal WD: std_logic_vector(15 downto 0);
signal RegWrite: std_logic;
signal RegDst : std_logic;
signal ExtOp :std_logic;
signal ALUSrc : std_logic;
signal BRANCH: std_logic;
signal JUMP: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MEMWrite: std_logic;
signal MEMToReg:std_logic;
signal outadress1: std_logic_vector(15 downto 0);
signal outadress2: std_logic_vector(15 downto 0);
signal Ext_Imm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal Zero:std_logic;
signal ALURes:std_logic_vector(15 downto 0);
signal MEMdata: std_logic_vector(15 downto 0);
signal ALUResout:std_logic_vector(15 downto 0);
signal PCSrc :std_logic;
signal impar:std_logic;
signal bltz:std_logic;
signal bltzEX:std_logic;
signal WAout:std_logic_vector(2 downto 0);


--MIPS PIPELINE
--IF/ID
signal Reg_IF_ID:std_logic_vector(31 downto 0);

signal Instruction_IF_ID:std_logic_vector(15 downto 0);
signal PC_IF_ID:std_logic_vector(15 downto 0);

--ID/EX
signal Reg_ID_Ex:std_logic_vector(86 downto 0);

signal RD1_ID_EX:std_logic_vector(15 downto 0);
signal RD2_ID_EX:std_logic_vector(15 downto 0);
signal Ext_Imm_ID_EX:std_logic_vector(15 downto 0);
signal PC_ID_EX:std_logic_vector(15 downto 0);
signal func_ID_EX:std_logic_vector(2 downto 0);
signal sa_ID_EX: std_logic;
signal MemWrite_ID_EX:std_logic;
signal MemToReg_ID_EX:std_logic;
signal RegWrite_ID_EX:std_logic;
signal Branch_ID_EX:std_logic;
signal BLTZ_ID_EX:std_logic;
signal ALUOp_ID_EX:std_logic_vector(2 downto 0);
signal ALUSrc_ID_EX:std_logic;
signal RegDst_ID_EX:std_logic;
signal RA2_ID_EX:std_logic_vector(2 downto 0);
signal RA2MUx_ID_EX:std_logic_vector(2 downto 0);
signal WAout_ID_EX:std_logic_vector(2 downto 0);

--EX/MEM
signal Reg_EX_MEM: std_logic_vector(57 downto 0);

signal BranchAdr_EX_MEM:std_logic_vector(15 downto 0);
signal Zero_EX_MEM:std_logic;
signal AluRes_EX_MEM:std_logic_vector(15 downto 0);
signal MemToReg_EX_MEM:std_logic;
signal RegWrite_EX_MEM:std_logic;
signal MemWrite_EX_MEM:std_logic;
signal Branch_EX_MEM:std_logic;
signal BLTZ_EX_MEM:std_logic;
signal BLTZEX_EX_MEM:std_logic;
signal RD2_EX_MEM:std_logic_vector(15 downto 0);
signal WA_EX_MEM:std_logic_vector(2 downto 0);
signal WAout_EX_MEM:std_logic_vector(2 downto 0);

--MEM/WB
signal Reg_MEM_WB:std_logic_vector(36 downto 0);
 
signal WA_MEM_WB:std_logic_vector (2 downto 0);
signal RD_MEM_WB:std_logic_vector (15 downto 0);
signal AluRes_MEM_WB:std_logic_vector ( 15 downto 0);
signal MemToReg_MEM_WB:std_logic;
signal RegWrite_MEM_WB:std_logic;
signal WAout_MEM_WB:std_logic_vector(2 downto 0);


begin



componenta1 : MPG port map(enable1,btn(0),clk);
componenta2 : SSD port map(clk,valoare(3 downto 0),valoare(7 downto 4),valoare(11 downto 8) ,valoare(15 downto 12),iesiriDCD , iesiriAnod);
componenta3 : MPG port map(enable2,btn(2),clk);



componentaIF: IFcomp port map(enable1,enable2,clk,Reg_EX_MEM(54 downto 39),jumpADR,JUMP,PCSrc,instructiune,progcont,impar);

componentaID: IDcomp port map(clk,enable1,Reg_IF_ID(15 downto 0),WD(15 downto 0),Reg_MEM_WB(33),RegDst,ExtOp,outadress1(15 downto 0),outadress2(15 downto 0),Ext_Imm,func,sa,WAout,Reg_MEM_WB(36 downto 34));
componentaUC: UCcomp port map(Reg_IF_ID(15 downto 13),RegDst,ExtOp,ALUSrc,BRANCH,JUMP,ALUOp(2 downto 0),MEMWrite,MEMToReg,RegWrite,BLTZ);

componentaEX: EXcomp port map(Reg_ID_EX(47 downto 32),Reg_ID_EX(15 downto 0),Reg_ID_EX(31 downto 16),Reg_ID_EX(76),Reg_ID_EX(63 downto 48),Reg_ID_EX(67),
Reg_ID_EX(66 downto 64),Reg_ID_EX(75 downto 73),Zero,BranchADR,ALURes,bltzEX);

componentaMEM:MEMcomp port map(clk,Reg_Ex_MEM(18),enable1, Reg_EX_MEM(15 downto 0),Reg_EX_MEM(37 downto 22),MEMdata,ALUResout);

PCSrc <= (Reg_EX_MEM(19) and Reg_EX_MEM(38))or(Reg_EX_MEM(20) and Reg_EX_MEM(21));
jumpADR<="000" & Reg_IF_ID(12 downto 0);
WD<=Reg_MEM_WB(15 downto 0) when Reg_MEM_WB(32)='1' else Reg_MEM_WB(31 downto 16);

process(clk,enable1)
begin
if clk'event and clk='1' then
if(btn(1)='1') then
    selectie <=x"0000";
    else if enable1='1' then
    --IF/ID
    
    --Instruction_IF_ID<= instructiune; 
    --PC_IF_ID <=progcont;
    
    Reg_IF_ID(15 downto 0)<= instructiune;
    Reg_IF_ID(31 downto 16)<= progcont;
    
    
    --ID/EX
    
    --RD1_ID_EX<=outadress1;
    --RD2_ID_EX<=outadress2;
    --PC_ID_EX<= Reg_IF_ID(31 downto 16);
    --Ext_Imm_ID_EX<=Ext_Imm;
    --func_ID_EX<=Reg_IF_ID(2 downto 0);
    --sa_ID_EX<=Reg_IF_ID(3);
    --MemToReg_ID_EX<=MemToReg;
    --RegWrite_ID_EX<=RegWrite;
    --RegDst_ID_EX<=RegDst;
    --Branch_ID_EX<=Branch;
    --BLTZ_ID_EX<=BLTZ;
    --ALUOp_ID_EX<=ALUOp;
    --ALUSrc_ID_EX<=ALUSrc;
    --RA2_ID_EX<=Reg_IF_ID(9 downto 7);
    --RA2Mux_ID_EX<=Reg_IF_ID(6 downto 4);
    --MemWrite_ID_EX<=MemWrite;
    --WAOut_ID_EX<=WAout;
    
    Reg_ID_EX(15 downto 0)<=outadress1;
    Reg_ID_EX(31 downto 16)<=outadress2;
    Reg_ID_EX(47 downto 32)<=Reg_IF_ID(31 downto 16);
    Reg_ID_EX(63 downto 48)<=Ext_Imm;
    Reg_ID_EX(66 downto 64)<=Reg_IF_ID(2 downto 0);
    Reg_ID_EX(67)<=Reg_IF_ID(3);
    Reg_ID_EX(68)<=MemToReg;
    Reg_ID_EX(69)<=RegWrite;
    Reg_ID_EX(70)<=RegDst;
    Reg_ID_EX(71)<=Branch;
    Reg_ID_EX(72)<=BLTZ;
    Reg_ID_EX(75 downto 73)<=ALUOp;
    Reg_ID_EX(76)<=ALUSrc;
    Reg_ID_EX(79 downto 77)<=Reg_IF_ID(9 downto 7);
    Reg_ID_EX(82 downto 80)<=Reg_IF_ID(6 downto 4);
    Reg_ID_EX(83)<=MemWrite;
    Reg_ID_EX(86 downto 84)<= WAout;
    
    --EX/MEM
    
    --AluRes_EX_MEM<=AluRes;
    --MemToReg_EX_MEM<=Reg_ID_EX(68);
    --RegWrite_EX_MEM<=Reg_ID_EX(69);
    --MemWrite_EX_MEM<=Reg_ID_EX(83);
    --Branch_EX_MEM<=Reg_ID_EX(71);
    --BLTZ_EX_MEM<=Reg_ID_EX(72);
    --BLTZEX_EX_MEM<=bltzEX;
    --RD2_EX_MEM<=Reg_ID_EX(31 downto 16);
    --Zero_EX_MEM<=Zero;
    --BranchAdr_EX_MEM<=BranchAdr;
    --WAout_EX_MEM<=Reg_ID_EX(86 downto 84);
    
    Reg_EX_MEM(15 downto 0)<=AluRes;
    Reg_EX_MEM(16)<=Reg_ID_EX(68);
    Reg_EX_MEM(17)<=Reg_ID_EX(69);
    Reg_Ex_MEM(18)<=Reg_ID_EX(83);
    Reg_EX_MEM(19)<=Reg_ID_Ex(71);
    Reg_EX_MEM(20)<=Reg_ID_EX(72);
    Reg_EX_MEM(21)<=bltzEX;
    Reg_EX_MEM(37 downto 22)<=Reg_ID_EX(31 downto 16);
    Reg_EX_MEM(38)<=Zero;
    Reg_EX_MEM(54 downto 39)<=BranchAdr;
    Reg_EX_MEM(57 downto 55)<=Reg_ID_EX(86 downto 84);
    
    --MEM/WB
    
    --WA_MEM_WB<=WA_EX_MEM;
    --RD_MEM_WB<=MeMData;
    --AluRes_MEM_WB<=AluResOut;
    --MemToReg_MEM_WB<=Reg_EX_MEM(16);
    --RegWrite_MEM_WB<=Reg_EX_MEM(17);
    --WAout_MEM_WB<=Reg_EX_MEM(57 downto 55);
    
    Reg_MEM_WB(15 downto 0)<=MemData;
    Reg_MEM_WB(31 downto 16)<=AluResOut;
    Reg_MEM_WB(32)<=Reg_EX_MEM(16);
    Reg_MEM_WB(33)<=Reg_EX_MEM(17);
    Reg_MEM_WB(36 downto 34)<=Reg_EX_MEM(57 downto 55);
   
         if sw(15)='1'then
            selectie <= selectie + '1';
        else
             selectie <=selectie - '1';
         end if;
end if;
end if;
end if;
case (sw(8 downto 5)) is
when "0000" => valoare <= instructiune;
when "0001" => valoare <= progcont;
when "0010" => valoare <=outadress1;
when "0011" => valoare <=outadress2;
when "0100" => valoare <= Ext_Imm;
when "0101" => valoare <=ALUResout;
when "0110" => valoare <=MEMdata;
when "0111" => valoare <=WD;
when "1000" => valoare <="0000000000000"&WA_MEM_WB;
when "1001"=>valoare <=Reg_ID_EX(15 downto 0);
when "1010"=>valoare <=RD2_ID_EX;
when "1011"=>valoare <= JumpAdr;
when "1100"=>valoare <= Reg_IF_ID(15 downto 0);
when others => valoare <= x"0000";
end case;
end process;
led(0)<=RegWrite;led(1)<=RegDst;led(2)<=ExtOp;led(13)<=BRANCH; led(4)<=JUMP ; led(5)<=ALUSrc; led(6)<=MEMWrite; led(7)<=MEMToReg;led(8)<=PCsrc;
led(15)<=impar; led(14)<=Reg_EX_MEM(38);
led(3)<=Reg_EX_MEM(19);
cat <= iesiriDCD;
an <=iesiriAnod;
end Behavioral;
