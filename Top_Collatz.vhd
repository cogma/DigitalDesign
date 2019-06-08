Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
--use IEEE.std_logic_arith.all;
-- Designed by Yoshinao Kobayashi 20161225
entity TopCollatz is
end TopCollatz;
architecture SIM of TopCollatz is
    signal SysClk   :std_logic:= '0';
    signal reset    :std_logic:= '0';
    signal Go   :std_logic:= '0';
    signal Din  :std_logic_vector(7 downto 0) :=(others => '0');
    signal monA :std_logic_vector(15 downto 0) :=(others => '0');
    signal Dout :std_logic_vector(7 downto 0) :=(others => '0');
    signal monC :std_logic_vector(1 downto 0) :=(others => '0');
    signal done :std_logic := '0';
    component Collatz
        port(
            SysClk  :in std_logic:= '0';
            reset   :in std_logic:= '0';
            Go  :in std_logic:= '0';
            Din :in std_logic_vector(7 downto 0) := (others => '0');
            monA    :out std_logic_vector(15 downto 0) :=(others => '0');
            Dout    :out std_logic_vector(7 downto 0) :=(others => '0');
            monC    :out std_logic_vector(1 downto 0) :=(others => '0');
            done    :out std_logic := '0'
            );
    end component;
begin
CL : Collatz port map(
    SysClk =>SysClk,
    reset => reset,
    Go => Go,
    Din => Din,
    monA => monA,
    Dout => Dout,
    monC => monC,
    done => done
    );
process begin
    SysClk <= '1';
    wait for 10 ns;
    SysClk <= '0';
    wait for 10 ns;
end process ;
process begin
    wait for 5 ns;
    reset <= '1';
    Din <= "00010100";
    wait for 40 ns;
    reset <= '0';
    Go <= '1';
    wait for 40 ns;
    Go <= '0';
    wait for 5500 ns;
    end process;
end;
