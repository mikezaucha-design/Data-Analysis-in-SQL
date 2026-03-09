-- Calculate the total sales per month
-- Calculate total sales over time
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (order by order_date) as running_total_sales,
AVG(avg_price) OVER (order by order_date) as moving_average
FROM
(
SELECT
DATETRUNC(year, order_date) as order_date,
SUM(sales_amount) as total_sales,
AVG(price) as avg_price
FROM gold.fact_sales
where order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
) t

