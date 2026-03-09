-- show quantity of sales per year 
-- show the number of customers and number of orders
select 
YEAR(order_date) as order_year,
MONTH(order_date) as order_month,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
group by YEAR(order_date), MONTH(order_date)
order by YEAR(order_date), MONTH(order_date)

select 
DATETRUNC(year,order_date) as order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
group by DATETRUNC(year,order_date)
order by DATETRUNC(year,order_date)