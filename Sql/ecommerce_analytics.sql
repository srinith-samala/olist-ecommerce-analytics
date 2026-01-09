/* =========================================================
   E-COMMERCE ANALYTICS (OLIST SAMPLE DATASET)
   SQL Portfolio Project
   Author: Srinith Samala
   ========================================================= */


/* ---------------------------------------------------------
   1. TOTAL REVENUE
   --------------------------------------------------------- */
SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments_sample;


/* ---------------------------------------------------------
   2. AVERAGE ORDER VALUE (AOV)
   --------------------------------------------------------- */
SELECT 
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders_sample o
JOIN payments_sample p
  ON o.order_id = p.order_id;


/* ---------------------------------------------------------
   3. ORDER FUNNEL (STATUS BREAKDOWN)
   --------------------------------------------------------- */
SELECT 
    order_status,
    COUNT(*) AS orders
FROM orders_sample
GROUP BY order_status
ORDER BY orders DESC;


/* ---------------------------------------------------------
   4. DELIVERY RATE (%)
   --------------------------------------------------------- */
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS delivery_rate_percent
FROM orders_sample;


/* ---------------------------------------------------------
   5. REVENUE BY PRODUCT CATEGORY
   --------------------------------------------------------- */
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items_sample oi
JOIN products_sample p
  ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;


/* ---------------------------------------------------------
   6. TOP 5 PRODUCTS BY REVENUE
   --------------------------------------------------------- */
SELECT
    p.product_id,
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items_sample oi
JOIN products_sample p
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_category_name
ORDER BY revenue DESC
LIMIT 5;


/* ---------------------------------------------------------
   7. AVERAGE ITEMS PER ORDER
   --------------------------------------------------------- */
SELECT
    ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(*) AS item_count
    FROM order_items_sample
    GROUP BY order_id
) t;


/* ---------------------------------------------------------
   8. NUMBER OF REPEAT CUSTOMERS
   --------------------------------------------------------- */
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT 
        c.customer_unique_id
    FROM customers_sample c
    JOIN orders_sample o
      ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) t;


/* ---------------------------------------------------------
   9. TOP 5 CUSTOMERS BY REVENUE
   --------------------------------------------------------- */
SELECT 
    c.customer_unique_id,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM customers_sample c
JOIN orders_sample o
  ON c.customer_id = o.customer_id
JOIN payments_sample p
  ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 5;


/* ---------------------------------------------------------
   10. REVENUE CONCENTRATION (80/20 RULE)
   --------------------------------------------------------- */
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS revenue
    FROM customers_sample c
    JOIN orders_sample o
      ON c.customer_id = o.customer_id
    JOIN payments_sample p
      ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),
ranked AS (
    SELECT
        customer_unique_id,
        revenue,
        RANK() OVER (ORDER BY revenue DESC) AS rnk
    FROM customer_revenue
),
limits AS (
    SELECT CEIL(COUNT(*) * 0.2) AS top_n
    FROM customer_revenue
)
SELECT
    ROUND(
        100.0 * SUM(r.revenue) / (SELECT SUM(revenue) FROM customer_revenue),
        2
    ) AS top_20_percent_revenue_share
FROM ranked r, limits l
WHERE r.rnk <= l.top_n;
