---Lertas George, dit2010dsc, dit2010dsc@office365.uop.gr
---Malfa Ilia Aikaterini, dit2011dsc, dit2011dsc@office365.uop.gr
---TASK 1

A = LOAD 'athlete_events.tsv' using PigStorage ('/')  as (ID:int , Name:chararray , Sex:chararray , Age:int, Height:long, Weight:long, Team:chararray ,NOC:chararray ,Games:chararray, Year:int , Season:chararray, City:chararray, Sport:chararray, Event:chararray, Medal:chararray);
B = FILTER A BY Medal == 'Gold';
C = GROUP B BY (ID, Name, Sex);
D = FOREACH C GENERATE FLATTEN(group), COUNT(B.Medal);
task1 = ORDER D BY ID ASC;
STORE task1 INTO 'Output/task1' USING PigStorage('/');