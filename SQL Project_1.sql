CREATE DATABASE Project_1;

USE Project_1;

SELECT * FROM retail_sales;

CREATE TABLE retail_sales
    (
        transactions_id	INT PRIMARY KEY,
        sale_date DATE,
        sale_time TIME,
        customer_id	INT,
        gender	VARCHAR(20),
        age	INT,
        category VARCHAR(20),
        quantiy	INT,
        price_per_unit FLOAT,	
        cogs FLOAT,
        total_sale FLOAT
);

SELECT 
    COUNT(*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE price_per_unit IS NULL ;

SELECT count(distinct customer_id) as total_sales from retail_sales;
SELECT  distinct customer_id from retail_sales order by customer_id desc;

SELECT distinct category from retail_sales;

-- basic problems --  
  
-- Q1 . Write a query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2  Write a query to retrieve all transactions where the category is 'Clothing' and the quanity sold is more than 10 in the month of NOV-2022 

SELECT * 
FROM retail_sales
WHERE category  = 'Clothing'
AND 
quantiy >= '4'
AND 
sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3 Write a query to calculate total sales (total_sales) for each category 

SELECT 
    category,
    sum(total_sale) as net_sales
FROM retail_sales   
Group by 1;

-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'beauty' categroy.

SELECT 
    round(avg(age),2) as Average_age
FROM retail_sales
WHERE category = 'beauty';

-- Q5 Write a SQL query to find all transactions where total_sales is greater than 1000. 

select  * from retail_sales
where total_sale > 1000;

-- Q6 Write a SQL query to find the total number of transaction (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    count(*) as total_transaction
FROM retail_sales
Group BY
    category,
    gender
ORDER BY 1;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.

select * from
(
    select 
        year(sale_date) as Year,
        month(sale_date) as Month,
        round(avg(total_sale),2 ) Average_sale,
        rank() over(partition by year(sale_date) order by avg(total_sale) Desc) as Ranking
    from retail_sales
    group by 1,2
) as t1
Where ranking = 1;

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
    sum(total_sale) as total_sales 
from retail_sales
group by 1
order by 2 desc
limit 5 ;

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
    category,
    COUNT(DISTINCT customer_id) as Unique_customers
FROM retail_sales
GROUP BY category;

-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening >17)

WITH hourly_sale
AS 
(
SELECT *,
    CASE
        when hour(sale_time) < 12 THEN 'Morning'
        when hour(sale_time) between 12 and 17 THEN 'Afternoon'
        else 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_order
 FROM hourly_sale
 GROUP BY shift
;
