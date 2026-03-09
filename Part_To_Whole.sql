-- Which categories contribute the most to overall sales?
with category_sales AS (
SELECT
category,
SUM(sales_amount) total_sales
from gold.fact_sales f
left join gold.dim_products p 
on p.product_key = f.product_key
group by category)

select category, 
total_sales,
SUM(total_sales) OVER () overall_sales,
CONCAT(ROUND((CAST (total_sales AS FLOAT) / SUM(total_sales) OVER ())*100, 2), '%') as percentage_of_total_sales
from category_sales 
ORDER BY total_sales DESC