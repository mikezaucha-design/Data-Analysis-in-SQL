/* Segment products into cost ranges 
and count how many products fall into each cateogry*/
WITH product_segments AS (
Select
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'Above 1000'
END cost_range
from gold.dim_products)

select cost_range,
COUNT(product_key) AS total_products
from product_segments
GROUP BY cost_range
ORDER BY total_products DESC