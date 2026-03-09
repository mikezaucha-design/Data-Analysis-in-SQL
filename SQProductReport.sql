/* Product Report
Purpose: Report consolidates key product metrics and behaviors.
Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics: total orders, total sales, total quantity sold, lifespan (in months)
4. Calculates valuable KPIs: Recency (months since last sale), average order revenue, average monthly revenue
*/
CREATE VIEW gold.report_products AS

WITH base_query AS (
-- Base query: Retrieve core columns from the tables and join them
SELECT 
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
),

product_aggregations AS (
-- Product Aggregations: Summarizes key metrics at the product level
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
MAX(order_date) AS last_order_date,
COUNT(DISTINCT order_number) as total_orders,
COUNT(DISTINCT customer_key) as total_customers,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
ROUND(AVG(CAST(sales_amount as FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
product_key,
product_name,
category,
subcategory,
cost)

-- Final Query: Combines all product results into one output
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
CASE WHEN total_sales > 50000 THEN 'High-Performer'
	 WHEN total_sales >= 10000 THEN 'Midrange'
	 ELSE 'Low-Performer'
END AS product_segment,
lifespan,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,
-- Average Order Revenue
CASE WHEN total_orders = 0 THEN 0
ELSE total_sales / total_orders
END AS avg_order_revenue,
-- Average Monthly Revenue
CASE WHEN lifespan = 0 THEN total_sales
ELSE total_sales / lifespan
END AS avg_monthly_revenue
FROM product_aggregations
