library IEEE;
use IEEE.std_logic_1164.all;

entity TopMajority15 is
end TopMajority15;

architecture SIM of TopMajority15 is

signal   SysClk_Test   : std_logic:='0';
signal   Yes_Test      : std_logic_vector (15 downto 1):="000000000000000";
signal   No_Test       : std_logic_vector (15 downto 1):="000000000000000";
signal   Win_Test      : std_logic:='0';

component Majority15B
   port (
    SysClk      : in  std_logic;
    Yes         : in  std_logic_vector (15 downto 1);
    No          : in  std_logic_vector (15 downto 1);
    Win         : out std_logic
    );
end component;

begin

-------------------------------------------------------------------------------
--  System Clock
-------------------------------------------------------------------------------
process
begin
SysClk_Test <='0';
wait for 10 ns;
SysClk_Test <='1';
wait for 10 ns;
end process;

-------------------------------------------------------------------------------
--  Test Data
-------------------------------------------------------------------------------
process begin

wait for 20 ns;

Yes_Test <= "000000000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "100000000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "110000000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111000000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111100000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111110000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111000000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111100000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111100000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111110000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111111000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111111100";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111111110";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111111111";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111000000";
No_Test  <= "000000000000000";

wait for 20 ns;

Yes_Test <= "111111111000000";
No_Test  <= "100000000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "110000000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111000000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111100000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111110000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111000000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111100000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111110000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111000000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111100000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111110000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111111000";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111111100";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111111110";

wait for 20 ns;

Yes_Test <= "111111110000000";
No_Test  <= "111111111111111";

end process;
-------------------------------------------------------------------------------
--  Component Connection
-------------------------------------------------------------------------------
MJ: Majority15B port map
( SysClk =>  SysClk_Test,
  Yes    =>  Yes_Test,
  No     =>  No_Test,
  Win    =>  Win_Test
);


end;
