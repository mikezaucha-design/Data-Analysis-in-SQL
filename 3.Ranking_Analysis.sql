-- Which 5 products generate the highest revenue
select TOP 5
p.product_name,
SUM(f.sales_amount) as total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p on p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

select * 
FROM ( select
p.product_name,
SUM(f.sales_amount) as total_revenue,
RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
from gold.fact_sales f
LEFT JOIN gold.dim_products p on p.product_key = f.product_key
GROUP BY p.product_name)t
where rank_products <= 5


-- What 5 products are the worst-performing in terms of sales
select TOP 5
p.product_name,
SUM(f.sales_amount) as total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_products p on p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- The 3 Customers with the fewest orders placed
SELECT TOP 3
c.customer_key, 
CONCAT(c.first_name, ' ', c.last_name) as full_name,
COUNT(distinct order_number) as total_orders
from gold.fact_sales f
JOIN gold.dim_customers c on c.customer_key = f.customer_key
GROUP BY 
c.customer_key, 
CONCAT(c.first_name, ' ', c.last_name)
order by total_orders