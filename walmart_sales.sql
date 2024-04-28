
-- Create Database
create database if not exists Walmartsales;
use walmartsales;

-- create table--

create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
tax_pct float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time Time not null,
payment varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4),
rating float(2,1)
);
select * from sales;

-- ---------------------------------------------------------------------------------------
----------------------------- Feature Engineering ----------------------------------------

--  Time_of_Day

select 
	time,
    (case 
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
    ) as time_of_day
from sales;

Alter Table sales add column time_of_day varchar(20);


UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


select * from sales;

--- ----------------------------- Day_Name ---------------------------------------------
-- -------------------------------------------------------------------------------------

select 
	date,
    dayname(date) as 'day_name'
from sales;


alter table sales add column day_name varchar(10);

update sales set day_name=dayname(date);
select * from sales;

-- ------------------------------------------- Month_Name----------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

select date, monthname(date) from sales;

alter table sales add column month_name  varchar(20);

update sales set month_name=monthname(date);

select * from sales;

-- -------------------------------------------------------------------------------------------

-- ----------------------------------- Generic -----------------------------------------------

-- How many unique cities does the data have ?

select distinct(city) from sales;

-- In which city is each branch

select distinct city, branch from sales;

-- ------------------------ Product ---------------------------------------
-- How many unique product lines does the data have ?

select count(distinct product_line) from sales;

--  What is the most common payment method ?

select payment, count(payment) as count from sales group by payment order by count desc;

-- What is the most selling product line ?

select product_line, count(product_line) as count from sales group by product_line order by count desc;

-- What is the total revenue by month?

select month_name as month, sum(total) as total_revenue from sales group by month_name order by total_revenue;

-- What month had the largest COGS ?

select month_name, sum(cogs) from sales group by month_name order by month_name desc;

-- What product line had the largest revenue?

select product_line, sum(total) as total_revenue from sales group by product_line order by total_revenue desc;

-- What is the city with the largest revenue ?
select city, sum(total) as total_revenue from sales group by city order by total_revenue desc;

-- What product line had the largest VAT?

select product_line, avg(tax_pct) AS 'avg_rev' from sales GROUP by product_line order by avg_rev desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

-- Which branch sold more products than aveage product sold?

select branch, sum(quantity) as qty from sales group by branch having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender

select gender, product_line, count(gender) as total_cnt from sales group by gender, product_line order by total_cnt desc;

-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as rating  from sales group by product_line order by rating desc;

-- ---------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------ Sales --------------------------------------------------------------------

-- Number of sales made in each time of the day per weeday?

select time_of_day, count(*) as total_sales from sales 
where day_name= "Monday" group by time_of_day order by total_sales desc;

-- Which of the customer types brings the most revenue? 
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

-- Which city has the largest tax percentage/ VAT (Value Added Tax)?

select city, avg(tax_pct) as percentage  from sales group by city order by percentage desc;

-- Which customer type pays the most in VAT?

select * from sales;
select customer_type, avg(tax_pct) as avg_precentage from sales group by customer_type order by avg_precentage desc;

-- ------------------------------------------------------------------------------------------------------------- 

-- --------------------------------- Customer -------------------------------------------------------------------
-- How many unique customer types does the data have?
select * from sales;

select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?

select distinct(payment) from sales;

-- What customer type buys the most?

select customer_type, count(*) as cust_cnt from sales group by customer_type;

-- What is the gender of most of the customers?

select gender, count(*) as gender_cnt from sales group by gender order by gender_cnt desc;

-- what is the gender distribution per branch?

select gender, count(*) as gender_cnt from sales where branch="B" group by gender;

-- Which time of the day do customers give most ratings?

select time_of_day, avg(rating) as avg_rating from sales group by time_of_day order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?

select time_of_day, avg(rating) as avg_rating from sales where branch="B" group by time_of_day order by avg_rating desc;

-- Which day of the week has the best avg rating?

select day_name, avg(rating) as avg_rating from sales group by day_name	order by avg_rating Desc;

-- Which day of the week has the best average ratings per branch?

select day_name, avg(rating) as avg_rating from sales where branch="A" group by day_name order by avg_rating desc;
