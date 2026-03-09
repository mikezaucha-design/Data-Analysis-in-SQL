/* Analyze the yearly performance of products by comparing their sales to both the average sales
performance of the product and the previous year's sales*/

with yearly_product_sales AS (
select
year(f.order_date) as order_year,
p.product_name,
SUM(f.sales_amount) AS current_sales
from gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key where f.order_date IS NOT NULL
group by year(f.order_date), p.product_name)

SELECT 
order_year, product_name,
current_sales,
AVG(current_sales) over (PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER (partition by product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (partition by product_name) > 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) OVER (partition by product_name) < 0 THEN 'Below Avg'
     ELSE 'avg'
     END avg_change,
     LAG(current_sales) over (partition by product_name ORDER BY order_year) py_sales,
     current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year) > 0 then 'Increase'
     WHEN current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year) < 0 then 'Decrease'
     ELSE 'No Change'
     END py_change
from yearly_product_sales
order by product_name, order_year