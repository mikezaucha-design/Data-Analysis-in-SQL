select sum(sales_amount) as total_sales from gold.fact_sales
select sum(quantity) as total_quantity from gold.fact_sales
select avg(price) as avg_price from gold.fact_sales
select COUNT(DISTINCT order_number) as total_orders from gold.fact_sales
select COUNT(product_key) as total_products from gold.dim_products
select COUNT(customer_key) as total_customers from gold.dim_customers 
select COUNT(DISTINCT customer_key) as total_customers from gold.fact_sales;

-- Generating a report that shows all key metrics

select 'Total Sales' as measure_name, SUM(sales_amount) as measure_value from gold.fact_sales UNION ALL
select 'Total Quantity' as measure_name, SUM(quantity) from gold.fact_sales UNION ALL
select 'Average Price' as measure_name, AVG(price) from gold.fact_sales UNION ALL
select 'Total Orders' as measure_name, COUNT(distinct order_number) from gold.fact_sales UNION ALL
select 'Total Products' as measure_name, COUNT(distinct product_name) from gold.dim_products UNION ALL
select 'Total Customers' as measure_name, COUNT(customer_key) from gold.dim_customers