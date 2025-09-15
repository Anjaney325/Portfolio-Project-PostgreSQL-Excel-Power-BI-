
-- A. Orders Table Insights

-- 1. Count total number of orders
SELECT COUNT(*) AS total_orders FROM orders;

-- 2. Orders by customer segment
SELECT segment, COUNT(*) AS total_orders
FROM orders
GROUP BY segment
ORDER BY total_orders DESC;

-- 3. Most common shipping mode
SELECT ship_mode, COUNT(*) AS usage_count
FROM orders
GROUP BY ship_mode
ORDER BY usage_count DESC;

-- 4. Top 10 customers by number of orders
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- B. Order Details Insights

-- 5. Top 10 best-selling products by sales
SELECT product_name, SUM(sales) AS total_sales
FROM order_details
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 6. Top 5 most profitable categories
SELECT category, SUM(profit) AS total_profit
FROM order_details
GROUP BY category
ORDER BY total_profit DESC
LIMIT 5;

-- 7. Products with negative profit
SELECT product_name, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM order_details
GROUP BY product_name
HAVING SUM(profit) < 0;

-- 8. Average discount given per category
SELECT category, ROUND(AVG(discount), 2) AS avg_discount
FROM order_details
GROUP BY category;

-- C. Joins: Orders + Order Details

-- 9. Total sales and profit per customer
SELECT o.customer_id, SUM(od.sales) AS total_sales, SUM(od.profit) AS total_profit
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY total_sales DESC;

-- 10. Sales by segment
SELECT o.segment, SUM(od.sales) AS total_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.segment
ORDER BY total_sales DESC;

-- 11. Top products by sales within each category
SELECT category, product_name, SUM(sales) AS total_sales
FROM order_details
GROUP BY category, product_name
ORDER BY category, total_sales DESC;

-- 12. Average order value (AOV)
SELECT ROUND(SUM(od.sales)::numeric / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id;

-- D. Actual vs Target (with sales_targets)

-- 13. Monthly actual sales vs targets
SELECT st.month_year,
       st.target_sales,
       COALESCE(SUM(od.sales),0) AS actual_sales,
       (COALESCE(SUM(od.sales),0) - st.target_sales) AS variance
FROM sales_targets st
LEFT JOIN orders o ON TO_CHAR(o.order_date, 'YYYY-MM') = st.month_year
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY st.month_year, st.target_sales
ORDER BY st.month_year;

-- 14. Best performing months vs targets
SELECT st.month_year, SUM(od.sales) AS actual_sales, st.target_sales
FROM sales_targets st
LEFT JOIN orders o ON TO_CHAR(o.order_date, 'YYYY-MM') = st.month_year
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY st.month_year, st.target_sales
HAVING SUM(od.sales) > st.target_sales
ORDER BY (SUM(od.sales) - st.target_sales) DESC;

-- 15. Customer lifetime value (CLV)
SELECT o.customer_id, SUM(od.sales) AS lifetime_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY lifetime_value DESC
LIMIT 10;

