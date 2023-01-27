-- Q1. Complex SQL Query 1 | Derive Points table for ICC tournament
--https://www.youtube.com/watch?v=qyAgWL066Vo&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=1 


create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

with cte as
(
	select Team_1 Team_Name,
	case when Team_1 = Winner then 1 else 0 end win_flag
	from icc_world_cup 
	union all
	select Team_2 Team_Name,
	case when Team_2 = Winner then 1 else 0 end win_flag
	from icc_world_cup
)
select Team_Name, count(Team_Name) Matches_played, 
sum(case when win_flag = 1 then 1 else 0 end) no_of_wins,
sum(case when win_flag = 0 then 1 else 0 end) no_of_losses
from cte
group by Team_Name