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

--Q2. Complex SQL 2 | find new and repeat customers | SQL Interview Questions
--https://www.youtube.com/watch?v=MpAMjtvarrc&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=2

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);

select * from customer_orders;

with cte as
(
	select customer_id, order_date, row_number() over(partition by customer_id order by customer_id) rn
	from customer_orders
)
select order_date, sum(case when rn = 1 then 1 else 0 end) new_customer_count,
sum(case when rn > 1 then 1 else 0 end) repeat_customer_count
from cte
group by order_date
order by order_date;

--Q3. Complex SQL 3 | Scenario based Interviews Question for Product companies
--https://www.youtube.com/watch?v=P6kNMyqKD0A&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=3

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

with floor_visit_rnk as
(
	select name, floor, count(name) no_of_floor_visits, dense_rank() over(order by count(name) desc) rnk
	from entries
	group by name, floor
),
total_visits as
(
	select name, count(floor) total_visits
	from entries
	group by name
),
distinct_resources as
(
	select distinct resources resources, name
	from entries
),
resources_used as
(
	select name, string_agg(resources,',') resources_used
	from distinct_resources
	group by name
)
select fvr.name, tv.total_visits, fvr.floor most_visited_floor, ru.resources_used
from floor_visit_rnk fvr
inner join total_visits tv
on fvr.name = tv.name
inner join resources_used ru
on fvr.name = ru.name
where fvr.rnk = 1



