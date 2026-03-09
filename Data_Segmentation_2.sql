/* Group customers into three segments based on their spending behavior: 
-VIP: Customers with at least 12 months of history and spending more than 5000
-Regular: Customers with at least 12 months of history and spending less than 5000
-New: Customers with a lifespan less than 12 months
Find the number of customers by each group */

WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT
customer_segment,
COUNT(customer_key) AS total_customers
FROM (
SELECT 
customer_key,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending < 5000 THEN 'Regular'
     ELSE 'New'
END customer_segment
from customer_spending) t
GROUP BY customer_segment
ORDER BY total_customers DESC

