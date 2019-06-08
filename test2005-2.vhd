
-- Big number search engine, Single Shot operation
process
wait until rising_edge(Clock);

case J(0) is
when '0' =>
	if J(3 downto 2)="00" and Search ='1' then
		J(0) <= '1';
	end if;
when '1' =>
	if J(3) ='1' then
		J(0) <= '0';
	end if;
end case;

J(3 downto 1) <= J(2 downto 0);

	if J(1 downto 0)="01" then
		RamAddr <= A;
	elsif J(1 downto 0)="11" then
		RamAddr <= RamAddr +1;
	end if;
	
Reg1 <= RamData

	if J(3)='1'and ((J(0) ='1' or Reg1GTReg2 ='1') then
		Reg2 <= Reg1;
	end if;
end process;

Reg1GTReg2 <= '1' when Reg1 > Reg2 else '0';


-- Big number Search Engine, Continuous Operation
process
wait until rising_edge(Clock);

case J(0) is
when '0' =>
	if J(1)='0' and Search ='1' then
		J(0) <= '1';
	end if;
when '1' =>
	if J(1) ='1' then
		J(0) <= '0';
	end if;
end case;

J(5 downto 1) <= J(4 downto 0);

	if J(1 downto 0)="01" then
		RamAddr <= A;
	elsif (J(1)='1' or J(2)='1') then
		RamAddr <= RamAddr +1;
	end if;
	
Reg1 <= RamData

	if J(3 downto 2)="11" or (J(4)='1' and Reg1GTReg2 ='1') then
		Reg2 <= Reg1;
	end if;

	if J(5 downto 4)="10" then
		if Reg1GTReg2 ='1' then
			Reg3 <= Reg1;
		else
			Reg3 <= Reg2;
		end if;
	end if;
end process;

Reg1GTReg2 <= '1' when Reg1 > Reg2 else '0';


