---Lertas George, dit2010dsc, dit2010dsc@office365.uop.gr
---Malfa Ilia Aikaterini, dit2011dsc, dit2011dsc@office365.uop.gr
---TASK 3

A = LOAD 'athlete_events.tsv' using PigStorage ('/')  as (ID:int , Name:chararray , Sex:chararray , Age:int, Height:long, Weight:long, Team:chararray ,NOC:chararray ,Games:chararray, Year:int , Season:chararray, City:chararray, Sport:chararray, Event:chararray, Medal:chararray);
B = Group A by (Name, Games);
B = FILTER A BY Sex == 'F';
C = GROUP B BY (ID,Games);
D = FOREACH C GENERATE FLATTEN(group) AS (ID,Games), FLATTEN(B.Team) AS Team, FLATTEN(B.NOC) AS NOC, FLATTEN(B.Sport);
E = DISTINCT D;
F = GROUP E BY(Games, Team, NOC);
G = FOREACH F GENERATE FLATTEN(group) AS (Games,Team,NOC), COUNT(E) AS womenCount;
H = GROUP E BY (Games, Team, NOC, Sport);
I = FOREACH H GENERATE FLATTEN(group) AS (Games,Team,NOC,Sport), COUNT(E) AS counter;
J = JOIN G BY (Games, Team), I BY (Games, Team);
K = FOREACH J GENERATE FLATTEN(I::Games) AS Games, FLATTEN(I::Team) AS Team, FLATTEN(I::NOC) AS NOC, FLATTEN(G::womenCount) AS WomenCount, FLATTEN(I::Sport) AS Sport, FLATTEN(I::counter) AS SportCount;
L = GROUP K BY(Games, Team);
M = FOREACH L { M1 = ORDER K BY SportCount DESC; M2 = LIMIT M1 1; GENERATE FLATTEN(group) AS (Games,Team), FLATTEN(M2.NOC) AS NOC, FLATTEN(M2.WomenCount) AS WomenCount, FLATTEN(M2.Sport) AS Prominent_Sport;}
N = GROUP M BY Games;
P = FOREACH N { P1 = ORDER M BY WomenCount DESC; P2 = LIMIT P1 3; GENERATE group, P2;}
task3 = FOREACH P GENERATE FLATTEN($1);
STORE task3 INTO 'Output/task3' USING PigStorage('/');
