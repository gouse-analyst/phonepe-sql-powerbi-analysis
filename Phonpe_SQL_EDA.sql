create database phonepe_analysis;
use phonepe_analysis;

create table all_users(
	User_ID varchar (20) primary key,
    Name varchar(255),
    Age int,
    Join_date date
);

SELECT COUNT(*) FROM all_users;

USE phonepe_analysis;

CREATE TABLE all_transactions (
    Transaction_ID VARCHAR(50),
    Amount DECIMAL(12,2),
    User_ID VARCHAR(20),
    Service VARCHAR(100),
    Service_Type VARCHAR(100),
    Payment_Status VARCHAR(50),
    Reason VARCHAR(255),
    Date DATE
);

LOAD DATA LOCAL INFILE 'C:/Users/SYEDG/OneDrive/Desktop/Phonepe project/All_Transactions.csv'
INTO TABLE all_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Transaction_ID, Amount, User_ID, Service, Service_Type, Payment_Status, Reason, Date);

SELECT COUNT(*) AS transactions FROM all_transactions;\

#1st question Find the total number of transactions and the total transaction amount from all_transactions

select 
	count(*) as No_Of_Transactions,
	sum(amount) as Total_Transaction_Amount
from all_transactions;

#2.Find the average transaction amount, along with the minimum and maximum transaction amount.

select
	avg(amount) as Average_Transaction_Amount,
    min(amount) as minimum_transaction_Amount,
    max(amount) as maximum_transaction_Amount
from all_transactions;

/*3rd Task: Find:

How many transactions are Successful
How many are Failed
The total amount for each status*/

SELECT
    Payment_Status,
    COUNT(*) AS No_Of_Transactions,
    SUM(Amount) AS Total_Transaction_Amount
FROM all_transactions
GROUP BY Payment_Status;

/*
Find for each Service:

Number of transactions
Total transaction amount*/

select
	service_type,
    count(*)  as No_Of_transaction,
    sum(amount) as total_transaction_amount
from all_transactions
group by service_type;

/*5th
Find each Payment_Status with:

Number of transactions
Total transaction amount*/

select
	payment_status,
	count(*) as no_of_transactions,
	sum(amount) as Total_Transaction_amount
from all_transactions
group by payment_status;

/*6th
find each Service with:

Number of transactions
Total transaction amount*/
select
	service,
	count(*) as No_of_Transactions,
    sum(amount) as Total_Transaction_Amount
from all_transactions
group by service;

/*7th
Show services ordered from highest to lowest number of transactions.*/

select 
	service,
    count(*) as No_of_Transactions
from all_transactions
group by service 
order by No_of_Transactions desc;

/*8th For each Service, show each Payment_Status and the number of transactions.*/

select 
	service,
    payment_status,
    count(*) as no_of_transactions
from all_transactions
group by service , payment_status;


/*9th
Find:

Month
Number of transactions
Total transaction amount*/

select
    Month(date) as Month_name,
    count(*) as No_of_Transactions,
    sum(amount) as Total_Transaction_amount
from all_transactions
group by month(date)
order by month(date);

/*10th
Year
Month
Number of transactions
Total transaction amount*/

select
	year(date) as year,
    month(date) as month,
    count(*) as no_of_transactions,
    sum(amount) as total_transaction_amount
from all_transactions
group by year(date) ,  month(date) 
order by year(date) ,  month(date);

/*11TH *Find the number of users in different age groups:*/

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Other'
    END AS Age_Group,
    COUNT(*) AS No_Of_Users
FROM all_users
GROUP BY
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Other'
    END;

/*12th Find the top 10 users based on total transaction amount.*/

select
	au.user_id,
	sum(amount) as total_transaction_amount
from all_users au
left join all_transactions at
on au.user_id = at.user_id
group by user_id
order by total_transaction_amount desc
Limit 10 ;

/* 13Find the top 10 users based on the number of transactions, not transaction amount.*/

select
	user_id,
    count(*) as no_of_transactions
from all_transactions
group by user_id
order by no_of_transactions desc
Limit 10;

/* 14th Find the top 10 users by average transaction amount.*/

select
	user_id,
    avg(amount) as average_transaction_amount
from all_transactions
group by user_id
order by average_transaction_amount desc
Limit 10;

# 15th Rank users based on their total transaction amount, highest to lowest.

with cte as(
	select user_id,
			sum(amount) as total_transaction_amount
	from all_transactions
    group by user_id
)

Select user_id, total_transaction_amount,
dense_rank() over ( order by total_transaction_amount desc) as dr
from cte;


# 16th Find users who made more than 5 transactions.

select
	user_id,
    count(*) as no_of_transactions
from all_transactions
group by user_id
having no_of_transactions > 5
order by no_of_transactions;

/*17th Find the top 10 users based on total transaction amount, but this time use DENSE_RANK() and return only ranks 1–10.*/

WITH cte AS (
    SELECT
        user_id,
        SUM(amount) AS total_transaction_amount
    FROM all_transactions
    GROUP BY user_id
),
ranked AS (
    SELECT
        user_id,
        total_transaction_amount,
        DENSE_RANK() OVER (
            ORDER BY total_transaction_amount DESC
        ) AS dr
    FROM cte
)
SELECT
    user_id,
    total_transaction_amount,
    dr
FROM ranked
WHERE dr <= 10
ORDER BY dr;


/* 18th For each month, calculate:

Total transaction amount
Previous month's transaction amount
Month-over-month change*/

with cte as(
	select 
		month(date) as month ,sum(amount) as Total_Transaction_Amount
	from all_transactions
    group by month
    )
select month, Total_Transaction_Amount,
LAG(Total_Transaction_Amount) over (order by month ) as previous_month_transaction_amount,
Total_transaction_amount - LAG(Total_Transaction_Amount) over (order by month )  as MOM_CHANGE
from cte;








