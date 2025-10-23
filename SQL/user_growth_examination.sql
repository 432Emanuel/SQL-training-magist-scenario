-- USER GROWTH ANALYSIS


-- ORDERS PER MONTH
-- Purpose: Count how many orders were placed each month.
-- Use in Tableau: Line chart for user growth trend.
-- Interpretation: Steady rise = healthy growth; drop at beginning & end = incomplete data snapshot.


SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS orders_per_timestamp
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year ASC, order_month ASC;



-- LAST RECORDED ORDER

-- Use in Tableau: Add as annotation or note for dataset cutoff.
-- Interpretation: Confirms dataset ends mid-October 2018 → explains apparent drop.


SELECT MAX(order_purchase_timestamp) 
FROM orders;



-- CHECK DATE RANGE FOR SEPTEMBER 2018

-- Use in Tableau: Validation note only (not a visual).
-- Interpretation: If full month present but fewer orders, cause lies in seller data or sync issue.


SELECT 
    MIN(order_purchase_timestamp) AS first_order_september,
    MAX(order_purchase_timestamp) AS last_order_september
FROM orders
WHERE order_purchase_timestamp LIKE '2018-09%';



-- ACTIVE SELLERS PER MONTH

-- Use in Tableau: Compare seller activity vs. order volume (dual-axis or side-by-side bars).
-- Interpretation: Drop from 1280 → 1 → 0 = data synchronization issue, not business decline.


SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT i.seller_id) AS active_sellers
FROM orders o
JOIN order_items i
  ON o.order_id = i.order_id
GROUP BY year, month
ORDER BY year, month;



-- USER GROWTH ANALYSIS (CLEAN DATASET)

-- query for removing incomplete boundary months and data artifacts.
-- time window: January 2017 – August 2018
-- returns dataset for visualizing order and seller growth (User growth)

SELECT
  a.year,
  a.month,
  a.orders_per_month,
  b.active_sellers
FROM (
    SELECT
      YEAR(o.order_purchase_timestamp)  AS year,
      MONTH(o.order_purchase_timestamp) AS month,
      COUNT(DISTINCT o.order_id)        AS orders_per_month
    FROM orders o
    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp <  '2018-09-01'
    GROUP BY year, month
) a
LEFT JOIN (
    SELECT
      YEAR(o.order_purchase_timestamp)  AS year,
      MONTH(o.order_purchase_timestamp) AS month,
      COUNT(DISTINCT i.seller_id)       AS active_sellers
    FROM orders o
    JOIN order_items i
      ON i.order_id = o.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp <  '2018-09-01'
    GROUP BY year, month
) b
ON a.year = b.year AND a.month = b.month
ORDER BY a.year, a.month;

-- query for examining active customers

SELECT
  YEAR(order_purchase_timestamp)  AS year,
  MONTH(order_purchase_timestamp) AS month,
  COUNT(DISTINCT customer_id)     AS active_customers
FROM orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp <  '2018-09-01'
GROUP BY year, month
ORDER BY year, month;

-- "computers", "computers_accessories", "telephony", "watches_gifts", 'cool_stuff', 'electronics', 'signaling_and_security'

-- Comparison to tech related categories 

-- Orders:

SELECT 
    YEAR(o.order_purchase_timestamp)  AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id)        AS orders_per_timestamp
FROM orders o
JOIN order_items i 
    ON o.order_id = i.order_id
JOIN products p 
    ON i.product_id = p.product_id
WHERE p.product_category_name IN (
    'computers',
    'computers_accessories',
    'telephony',
    'watches_gifts',
    'cool_stuff',
    'electronics',
    'signaling_and_security'
)
GROUP BY order_year, order_month
ORDER BY order_year ASC, order_month ASC;

-- Sellers:

SELECT 
    YEAR(o.order_purchase_timestamp)  AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT i.seller_id)       AS active_sellers
FROM orders o
JOIN order_items i
    ON o.order_id = i.order_id
JOIN products p
    ON i.product_id = p.product_id
WHERE p.product_category_name IN (
    'computers',
    'computers_accessories',
    'telephony',
    'watches_gifts',
    'cool_stuff',
    'electronics',
    'signaling_and_security'
)
GROUP BY year, month
ORDER BY year, month;

-- buyers:

SELECT
  YEAR(o.order_purchase_timestamp)  AS year,
  MONTH(o.order_purchase_timestamp) AS month,
  COUNT(DISTINCT o.customer_id)     AS active_customers
FROM orders o
JOIN order_items i
    ON o.order_id = i.order_id
JOIN products p
    ON i.product_id = p.product_id
WHERE o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'
  AND p.product_category_name IN (
      'computers',
      'computers_accessories',
      'telephony',
      'watches_gifts',
      'cool_stuff',
      'electronics',
      'signaling_and_security'
  )
GROUP BY year, month
ORDER BY year, month;





