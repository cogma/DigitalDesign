-----------------------------------------------------------------
-----------------------------------------------------------------
--- Chat : Chat.vhd
--
-- Designed by      Yoshinao   Kobayashi
--
--  Stimulus of ASIC "Eowyn"
-- Instruction set of the Chat Processor
--
-- 00 - 7F  bus write cycle
-- 80 NOP
-- 81 Set Timer and Wait Timer Carry
-- 82 Wait TACT input
-- 83 Set Timer and Wait Timer Carry or TACT input
-- 91 Set Loop0 and repeat next Instruction
-- 92 Set Loop1
-- 94 Set Loop2
-- 98 Set Loop3
-- A1 Absolute Jump
-- A2 Decrement Loop1 and Jump to Absolute address in op land when Loop1 /=0
-- A4 Decrement Loop2 and Jump to Absolute address in op land when Loop2 /=0
-- A8 Decrement Loop3 and Jump to Absolute address in op land when Loop3 /=0
-- B1 Set extended Op Code
-- B2 Set extended OP land
-- B8 Increment extended Op Land
-- C0 do eOp_Code + eOp_Land
--
-----------------------------------------------------------------
-----------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-----------------------------------------------------------------
--  Entity               --
-----------------------------------------------------------------
entity Chat is
    port(
	RefClk		:in    std_logic;
	HD			:inout  std_logic_vector(17 downto 0);
	RS			:out    std_logic;
	CSB			:out    std_logic;
	RDB			:out    std_logic;
	WRB			:out    std_logic;
	TACT    	:in     std_logic;
    TestMon     :out std_logic_vector(10 downto 1);
    LastCommand   :out     std_logic_vector(31 downto 0);
	RESETB    : out std_logic
    );
end Chat ;

-----------------------------------------------------------------
--  Architecture                                               --
-----------------------------------------------------------------
architecture RTL of Chat is

-----------------------------------------------------------------
--  Component Declaration                                      --
-----------------------------------------------------------------

component ProgramROM
port(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

-----------------------------------------------------------------
--  Variable Declaration                                       --
-----------------------------------------------------------------

signal CLKA : std_logic_vector(8 downto 0);
signal IReg : std_logic_vector(31 downto 0);
signal RomData : std_logic_vector(31 downto 0);
signal ICounter : std_logic_vector(8 downto 0);
signal ICycle : std_logic_vector(1 downto 0);
signal CCycle : std_logic_vector(2 downto 0);
signal DCycle : std_logic_vector(2 downto 0);
signal WCycle : std_logic;
signal RCycle : std_logic;
signal Time10uS : std_logic;
signal Time2mS : std_logic;
signal LoopCarry1 : std_logic;
signal LoopCarry2 : std_logic;
signal LoopCarry3 : std_logic;
signal TACTint : std_logic;
signal TactHit : std_logic;
signal TactTail : std_logic;
signal SameCommand : std_logic;
signal WaitTimer : std_logic_vector(11 downto 0);
signal RepeatCounter : std_logic_vector(23 downto 0);
signal LoopCounter1 : std_logic_vector(23 downto 0);
signal LoopCounter2 : std_logic_vector(23 downto 0);
signal LoopCounter3 : std_logic_vector(23 downto 0);
signal RefTimer : std_logic_vector(15 downto 0);
signal ExtOp : std_logic_vector(7 downto 0);
signal ExtData : std_logic_vector(17 downto 0);
signal PreviousCommand : std_logic_vector(6 downto 0);

-----------------------------------------------------------------
-- START  START  START  START  START  START  START
-----------------------------------------------------------------
begin
-----------------------------------------------------------------
-- Port Map
-----------------------------------------------------------------
IROM : ProgramROM port map
    (
		address => ICounter,
		clock   => refclk,
		q       => RomData
	);
-----------------------------------------------------------------
-- Chat Processor
-----------------------------------------------------------------

process
begin
wait until rising_edge(RefCLK);

  RefTimer <= RefTimer +1;
  
  if RefTimer(0) ='1' then
    if RefTimer(7 downto 1) ="1111111" then
      Time10uS <= '1';
    else
      Time10uS <= '0';
    end if;
  
    if RefTimer(15 downto 1) ="111111111111111" then
      Time2mS <= '1';
    else
      Time2mS <= '0';
    end if;
  
-----------------------------------------------------------------
-- Instruction fetch control state machine
-----------------------------------------------------------------
    case ICycle(0) is
    when '0' =>
      if ICycle(1) ='0' and WCycle ='0' and CCycle=0 then
        ICycle(0) <= '1';
      end if;
    when '1' =>
      if ICycle(1)='1' then
        ICycle(0) <= '0';
      end if;
    end case;
    
    ICycle(1) <= ICycle(0);

-----------------------------------------------------------------
-- Instruction register
-----------------------------------------------------------------
    if ICycle ="01" then
      if RomData(31 downto 28)="1100" then
        IReg <= ExtOp & "000000" & ExtData;
      else
        IReg <= RomData;
      end if;
  
      if IReg(31) ='0' then
        PreviousCommand <= IReg(30 downto 24);
      end if;
  
      LastCommand <= IReg;
    end if;
  
-----------------------------------------------------------------
-- Wait Instruction
-----------------------------------------------------------------
    case WCycle is
    when '0' =>
      if ICycle ="11" and IReg(31 downto 28)="1000" and(IReg(24)='1' or IReg(25)='1') then
        WCycle <='1';
      end if;
    when '1'=>
      if((IReg(24)='1' and WaitTimer ="111111111111" and Time10uS='1' )
       or(IReg(25)='1' and TACTHit ='1')) then
        WCycle <='0';
      end if;
    end case;
    
------------------------------------------------------------------
-- Wait Timer
-----------------------------------------------------------------
    if ICycle ="11" and IReg(31 downto 28)="1000" and IReg(24)='1' then
      WaitTimer <= not IReg(11) & not IReg(10) & not IReg(9) & not IReg(8) & not IReg(7) & not IReg(6)
                   & not IReg(5) & not IReg(4) & not IReg(3) & not IReg(2) & not IReg(1) & not IReg(0);
    elsif Time10uS ='1' then
      if WCycle='0' then
        WaitTimer <= "000000000000";
      else 
        WaitTimer <= WaitTimer +1;
      end if;
    end if;
    
-----------------------------------------------------------------
-- Repeat Instruction
-----------------------------------------------------------------
    case RCycle is
    when '0' =>
      if ICycle ="11" and IReg(31 downto 28)="1001" and IReg(24)='1' then
        RCycle <='1';
      end if;
    when '1'=>
      if ICycle ="11" and RepeatCounter ="111111111111111111111111" then
        RCycle <= '0';
      end if;
    end case;
      
-----------------------------------------------------------------
-- Repeat Counter
-----------------------------------------------------------------
    if ICycle ="11" then
      if IReg(31 downto 28)="1001" and IReg(24)='1' then
        RepeatCounter <= not IReg(23) & not IReg(22) & not IReg(21) & not IReg(20) & not IReg(19) & not IReg(18)
                   & not IReg(17) & not IReg(16) & not IReg(15) & not IReg(14) & not IReg(13) & not IReg(12)
                   & not IReg(11) & not IReg(10) & not IReg(9) & not IReg(8) & not IReg(7) & not IReg(6)
                   & not IReg(5) & not IReg(4) & not IReg(3) & not IReg(2) & not IReg(1) & not IReg(0);
      elsif RCycle ='1' then
        RepeatCounter <= RepeatCounter +1;
      end if;
    
      if IReg(31 downto 28)="1001" and IReg(25)='1' then
        LoopCounter1 <= not IReg(23) & not IReg(22) & not IReg(21) & not IReg(20) & not IReg(19) & not IReg(18)
                   & not IReg(17) & not IReg(16) & not IReg(15) & not IReg(14) & not IReg(13) & not IReg(12)
                   & not IReg(11) & not IReg(10) & not IReg(9) & not IReg(8) & not IReg(7) & not IReg(6)
                   & not IReg(5) & not IReg(4) & not IReg(3) & not IReg(2) & not IReg(1) & not IReg(0);
      elsif IReg(31 downto 28)="1010" and IReg(25)='1' then
        LoopCounter1 <= LoopCounter1 +1;
      end if;
      
      if IReg(31 downto 28)="1001" and IReg(26)='1' then
        LoopCounter2 <= not IReg(23) & not IReg(22) & not IReg(21) & not IReg(20) & not IReg(19) & not IReg(18)
                   & not IReg(17) & not IReg(16) & not IReg(15) & not IReg(14) & not IReg(13) & not IReg(12)
                   & not IReg(11) & not IReg(10) & not IReg(9) & not IReg(8) & not IReg(7) & not IReg(6)
                   & not IReg(5) & not IReg(4) & not IReg(3) & not IReg(2) & not IReg(1) & not IReg(0);
      elsif IReg(31 downto 28)="1010" and IReg(26)='1' then
        LoopCounter2 <= LoopCounter2 +1;
      end if;
    
      if IReg(31 downto 28)="1001" and IReg(27)='1' then
        LoopCounter3 <= not IReg(23) & not IReg(22) & not IReg(21) & not IReg(20) & not IReg(19) & not IReg(18)
                   & not IReg(17) & not IReg(16) & not IReg(15) & not IReg(14) & not IReg(13) & not IReg(12)
                   & not IReg(11) & not IReg(10) & not IReg(9) & not IReg(8) & not IReg(7) & not IReg(6)
                   & not IReg(5) & not IReg(4) & not IReg(3) & not IReg(2) & not IReg(1) & not IReg(0);
      elsif IReg(31 downto 28)="1010" and IReg(27)='1' then
        LoopCounter3 <= LoopCounter3 +1;
      end if;
  
-----------------------------------------------------------------
-- Instruction Counter
-----------------------------------------------------------------
      if IReg(31 downto 28)="1010" and ( IReg(24)='1'
                                      or(IReg(25)='1' and LoopCarry1 ='0')
                                      or(IReg(26)='1' and LoopCarry2 ='0')
                                      or(IReg(27)='1' and LoopCarry3 ='0')) then
        ICounter <= IReg(8 downto 0);
      elsif RCycle ='0' then
        ICounter <= ICounter +1;
      end if;
      
-----------------------------------------------------------------
-- Register Operation
-----------------------------------------------------------------
      if IReg(31 downto 24)="10110001" then
        ExtOP <= IReg(7 downto 0);
      end if;
      
      if IReg(31 downto 24)="10110010" then
        ExtData <= IReg(17 downto 0);
      elsif IReg(31 downto 24)="10111000" then
        ExtData <= ExtData +1;
      end if;
      
    end if;
-----------------------------------------------------------------
-- Command Cycle Generator
-----------------------------------------------------------------
    case CCycle(0) is
    when '0' =>
      if ICycle ="11" and IReg(31)='0' and CCycle(2 downto 1)="00" and SameCommand ='0' then
        CCycle(0) <='1';
      end if;
    when '1' =>
      if CCycle(2) ='1' then
        CCycle(0) <='0';
      end if;
    end case;
    
    CCycle(2 downto 1) <= CCycle(1 downto 0);
  
-----------------------------------------------------------------
-- Data Cycle Generator
-----------------------------------------------------------------
    case DCycle(0) is
    when '0' =>
      if DCycle(1) ='0' and (CCycle(1 downto 0)="10"
                         or (ICycle ="11" and IReg(31)='0' and SameCommand ='1')) then
        DCycle(0) <='1';
      end if;
    when '1' =>
      if DCycle(1) ='1' then
        DCycle(0) <='0';
      end if;
    end case;
    
    DCycle(2 downto 1) <= DCycle(1 downto 0);
  
-----------------------------------------------------------------
-- Bus Control
-----------------------------------------------------------------
    if ICycle ="11" and IReg(31)='0' and SameCommand ='0' then
      HD <= "00000000000" & IReg(30 downto 24);
    elsif((ICycle ="11" and IReg(31)='0' and SameCommand ='1')
        or CCycle(1 downto 0)="10") then
      HD <= IReg(17 downto 0);
    end if;
    
-----------------------------------------------------------------
-- TACT Control
-----------------------------------------------------------------
    if Time2mS ='1' then
      if TACT ='0' then
        TACTint <='1';
      else
        TACTint <='0';
      end if;
    end if;
  
    case TactHit is
    when '0' =>
      if TactTail ='0' and TACTint ='1' then
        TactHit <= '1';
      end if;
    when '1' =>
      TactHit <= '0';
    end case;
    
    case TactTail is
    when '0' =>
      if TactHit ='1' then
        TactTail <='1';
      end if;
    when '1' =>
      if TACTint ='0' then
        TactTail <= '0';
      end if;
    end case;
  end if;
end process;

SameCommand <= '1' when PreviousCommand = IReg(30 downto 24) else '0';

-----------------------------------------------------------------
-- Internal Control
-----------------------------------------------------------------
LoopCarry1 <= '1' when LoopCounter1="111111111111111111111111" else '0';
LoopCarry2 <= '1' when LoopCounter2="111111111111111111111111" else '0';
LoopCarry3 <= '1' when LoopCounter3="111111111111111111111111" else '0';

-----------------------------------------------------------------
-- External Control
-----------------------------------------------------------------
CSB <= '0' when (CCycle(2)='1' or CCycle(0)='1' or DCycle(2)='1' or DCycle(1)='1' or DCycle(0)='1')else '1';

RS <= '0' when (CCycle(0)='1' or CCycle(1)='1') else '1';

WRB <= '0' when(CCycle(1 downto 0) ="11" or DCycle(1) ='1')else '1';

RDB <= '1';

RESETB <= '1';

TestMon(1) <= ICycle(0);
TestMon(2) <= CCycle(0);
TestMon(3) <= DCycle(0);
TestMon(4) <= WCycle;
TestMon(5) <= RCycle;
TestMon(6) <= SameCommand;
TestMon(7) <= '0' when (CCycle(2)='1' or CCycle(0)='1' or DCycle(2)='1' or DCycle(1)='1' or DCycle(0)='1')else '1';  -- CSB
TestMon(8) <= '0' when (CCycle(0)='1' or CCycle(1)='1') else '1'; -- RS
TestMon(9) <= '0' when(CCycle(1 downto 0) ="11" or DCycle(1) ='1')else '1';  -- WRB
TestMon(10)<= HD(7);
-----------------------------------------------------------------
--  END     END     END     END     END     END     END     END
-----------------------------------------------------------------
end RTL;
