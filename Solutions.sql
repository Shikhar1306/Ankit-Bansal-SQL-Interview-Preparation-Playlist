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

--Q4. Complex SQL 6 | Scenario based on join, group by and having clauses | SQL Interview Question
--https://www.youtube.com/watch?v=SfzbR69LquU&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=6

/*write a query to find PersonID, Name, number of friends, sum of marks
of person who have friends with total score greater than 100. */

CREATE TABLE person (
  PersonID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(50),
  Score INT
);

INSERT INTO person (PersonID, Name, Email, Score)
VALUES
  (1, 'Alice', 'alice2018@hotmail.com', 88),
  (2, 'Bob', 'bob2018@hotmail.com', 11),
  (3, 'Davis', 'davis2018@hotmail.com', 27),
  (4, 'Tara', 'tara2018@hotmail.com', 45),
  (5, 'John', 'john2018@hotmail.com', 63);

CREATE TABLE friend (
  PersonID INT,
  FriendID INT,
  PRIMARY KEY (PersonID, FriendID),
  FOREIGN KEY (PersonID) REFERENCES person(PersonID),
  FOREIGN KEY (FriendID) REFERENCES person(PersonID)
);

INSERT INTO friend (PersonID, FriendID)
VALUES
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 3),
  (3, 5),
  (4, 2),
  (4, 3),
  (4, 5);

select * from person;
select * from friend;

with cte as
(
	select f.PersonID, count(f.FriendID) no_of_friends, sum(p.Score) total_score
	from friend f
	inner join person p
	on f.FriendID = p.PersonID
	group by f.PersonID
	having sum(p.Score) > 100
)
select c.PersonID, p.Name, c.no_of_friends, c.total_score
from cte c
inner join person p
on c.PersonID = p.PersonID

--Q5. Complex SQL Problem Asked in a Fintech Startup | SQL For Data Analytics
--https://www.youtube.com/watch?v=X6i1WMx0vnY

--Write SQL to find all couple of trades for same stock that happened in the range of 10 seconds and having price difference by more than 10 %

Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
)

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19)

select * from Trade_tbl;

with cte as
(
	select t1.TRADE_ID first_trade, t1.Price first_trade_price, t2.TRADE_ID second_trade, t2.Price second_trade_price, round(abs(t1.Price - t2.Price) * 100 / t1.price,2) percentdiff
	from Trade_tbl t1 
	inner join Trade_tbl t2
	on DATEDIFF(second, t1.Trade_Timestamp, t2.Trade_Timestamp) <= 10 and DATEDIFF(second, t1.Trade_Timestamp, t2.Trade_Timestamp) > 0 and t1.TRADE_ID <> t2.TRADE_ID
)
select * from cte
where percentdiff > 10
order by first_trade;