-- latency 1
process
wait until riging_edge(SysClk);
WE <= Run
waddr <= ADDR;
end process;

wdata <= rdata +1;



-- latency 2 wo/fowarding
process
wait until riging_edge(SysClk);
RunL <= Run;
WE <= RunL
AReg <= ADDR;
waddr <= AReg;
wdata <= rdata +1;
end process;


-- latency 2  w/fowarding
process
wait until riging_edge(SysClk);
RunL <= Run;
WE <= RunL
AReg <= ADDR;
waddr <= AReg;
  if SameAddress ='0' then
    wdata <= rdata +1;
  else
    wdata <= wdata +1;
  end if;
end process;

SameAddress <= '1' when AReg = waddr else '0';


-- latency 3  wo/fowarding
process
wait until riging_edge(SysClk);
RunL1 <= Run;
RunL2 <= RunL1;
WE <= RunL2
AReg1 <= ADDR;
AReg2 <= AReg1;
waddr <= AReg2;
rdata1 <= rdata;
wdata <= rdata1 +1;
end process;


-- latency 3  w/fowarding
process
wait until riging_edge(SysClk);
RunL1 <= Run;
RunL2 <= RunL1;
WE <= RunL2
AReg1 <= ADDR;
AReg2 <= AReg1;
waddr <= AReg2;
  if Same1 ='0' then
    rdata1 <= rdata;
  else
    rdata1 <= wdata;
  end if;
  if Same2 ='0' then
    wdata <= rdata1 +1;
  else
    wdata <= wdata +1;
  end if;
end process;

Same1 <= '1' when AReg1 = waddr else '0';
Same2 <= '1' when AReg2 = waddr else '0';

