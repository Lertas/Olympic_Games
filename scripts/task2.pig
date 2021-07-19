---Lertas George, Malfa Ilia Aikaterini

---Find the number of gold medals, the number of silver medals, the number of bronze medals, 
---and the total number of medals won by an athlete (Name) in a single event (Games).

A = LOAD 'athlete_events.tsv' using PigStorage ('/')  as (ID:int , Name:chararray , Sex:chararray , Age:int, Height:long, Weight:long, Team:chararray ,NOC:chararray ,Games:chararray, Year:int , Season:chararray, City:chararray, Sport:chararray, Event:chararray, Medal:chararray);
B = Group A by (Name, Games);
C = FOREACH B{ Gold = FILTER A BY Medal == 'Gold'; Silver = FILTER A BY Medal == 'Silver'; Bronze = FILTER A BY Medal == 'Bronze'; GENERATE FLATTEN(group.Name), FLATTEN(A.Sex), FLATTEN(A.Age), FLATTEN(A.Team), FLATTEN(A.Sport), FLATTEN(group.Games), COUNT(Gold) AS Gold, COUNT(Silver) AS Silver, COUNT(Bronze) AS Bronze, (COUNT(Gold)+COUNT(Silver)+COUNT(Bronze)) AS Total;};
unique = DISTINCT C;
ranked = RANK unique BY Gold DESC, Total DESC;
ordered = ORDER ranked BY rank_unique ASC, Name ASC;
task2 = LIMIT ordered 10;
STORE task2 INTO 'Output/task2' USING PigStorage('/');
