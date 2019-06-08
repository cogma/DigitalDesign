library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity tester is
end tester;
architecture sim of tester is
component collatz
port(ck: in std_logic;
data:in std_logic_vector(7 downto 0);
counter:out std_logic_vector(6 downto 0);
num:out std_logic_vector(13 downto 0)
);
end component;
constant cycle: time:=100 ns;
signal ck:std_logic;
signal data:std_logic_vector(7 downto 0):="00000001";
signal counter:std_logic_vector(6 downto 0):="0000000";
signal num:std_logic_vector(13 downto 0):="00000000000001";
subtype byte is std_logic_vector(7 downto 0);
type forkiroku is array(1 to 255) of std_logic_vector(14 downto 0);
type forrank is array(1 to 17) of std_logic_vector(14 downto 0);
signal kiroku:forkiroku:=(others=> (others=>'0')); 
signal rank:forrank:=(others=>(others=>'0'));
begin
CNT: collatz port map(ck,data,counter,num);

process begin
ck<='0';
wait for cycle/2;
ck<='1';
wait for cycle/2;
end process;
process (num)
begin
if num="00000000000001" then
if data>"00000001" then
kiroku(CONV_INTEGER(data))(14 downto 7)<=data;
kiroku(CONV_INTEGER(data))(6 downto 0)<=counter;
rank(17)(14 downto 7)<=data;
rank(17)(6 downto 0)<=counter;
end if;
data<=data+1;
elsif num<"00000100000000"and num>"00000000000000"and data>"00000001" then
if kiroku(CONV_INTEGER(num))="000000000000000" then
kiroku(CONV_INTEGER(num))(14 downto 7)<=data;
kiroku(CONV_INTEGER(num))(6 downto 0)<=counter;
rank(17)(14 downto 7)<=data;
rank(17)(6 downto 0)<=counter;
else
if num/=data  then
kiroku(CONV_INTEGER(data))(14 downto 7)<=data;
rank(17)(14 downto 7)<=data;
if kiroku(CONV_INTEGER(num))(14 downto 7)=num then
kiroku(CONV_INTEGER(data))(6 downto 0)<=(kiroku(CONV_INTEGER(num))(6 downto 0))+counter;
rank(17)(6 downto 0)<=(kiroku(CONV_INTEGER(num))(6 downto 0))+counter;
else
kiroku(CONV_INTEGER(data))(6 downto 0)<=(kiroku(CONV_INTEGER((kiroku(CONV_INTEGER(num))(14 downto 7))))(6 downto 0))-(kiroku(CONV_INTEGER(num))(6 downto 0))+counter;
rank(17)(6 downto 0)<=(kiroku(CONV_INTEGER((kiroku(CONV_INTEGER(num))(14 downto 7))))(6 downto 0))-(kiroku(CONV_INTEGER(num))(6 downto 0))+counter;
end if;
end if;
data<=data+1;
end if;
end if;
end process;
process(rank(17))
begin
if rank(17)(6 downto 0)>rank(1)(6 downto 0) then
rank(1)<=rank(17);
rank(2)<=rank(1);
rank(3)<=rank(2);
rank(4)<=rank(3);
rank(5)<=rank(4);
rank(6)<=rank(5);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(2)(6 downto 0) then
rank(2)<=rank(17);
rank(3)<=rank(2);
rank(4)<=rank(3);
rank(5)<=rank(4);
rank(6)<=rank(5);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(3)(6 downto 0) then
rank(3)<=rank(17);
rank(4)<=rank(3);
rank(5)<=rank(4);
rank(6)<=rank(5);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(4)(6 downto 0) then
rank(4)<=rank(17);
rank(5)<=rank(4);
rank(6)<=rank(5);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(5)(6 downto 0) then
rank(5)<=rank(17);
rank(6)<=rank(5);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(6)(6 downto 0) then
rank(6)<=rank(17);
rank(7)<=rank(6);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(7)(6 downto 0) then
rank(7)<=rank(17);
rank(8)<=rank(7);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(8)(6 downto 0) then
rank(8)<=rank(17);
rank(9)<=rank(8);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(9)(6 downto 0) then
rank(9)<=rank(17);
rank(10)<=rank(9);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(10)(6 downto 0) then
rank(10)<=rank(17);
rank(11)<=rank(10);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(11)(6 downto 0) then
rank(11)<=rank(17);
rank(12)<=rank(11);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(12)(6 downto 0) then
rank(12)<=rank(17);
rank(13)<=rank(12);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(13)(6 downto 0) then
rank(13)<=rank(17);
rank(14)<=rank(13);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(14)(6 downto 0) then
rank(14)<=rank(17);
rank(15)<=rank(14);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(15)(6 downto 0) then
rank(15)<=rank(17);
rank(16)<=rank(15);
elsif rank(17)(6 downto 0)>rank(16)(6 downto 0) then
rank(16)<=rank(17);
end if;
end process;
end sim;
configuration bench of tester is
for sim end for;
end bench;