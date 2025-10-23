   -- What categories of tech products does Magist have?
   
   /*
------------------------------------------------------------
ENIAC CASE STUDY – TECH-RELATED PRODUCT CATEGORIES
------------------------------------------------------------
These categories represent products relevant to ENIAC,
a company specializing in Apple-compatible technology
and electronic accessories. The list focuses on tech,
gadgets, and smart devices suitable for a digital marketplace.

Selected Categories:
------------------------------------------------------------
'audio'                          – Headphones, speakers, audio accessories
'auto'                           – Car electronics, chargers, smart car gadgets
'computers'                      – Computer hardware and devices
'computers_accessories'          – Computer peripherals and Apple accessories
'pc_gamer'                       – Gaming PCs, peripherals, and components
'tablets_printing_image'         – Tablets, printers, scanners, imaging devices
'telephony'                      – Smartphones, mobile phones, accessories
'fixed_telephony'                – Landline phones and related tech
'electronics'                    – General electronic devices and gadgets
'home_appliances'                – Large home electronics (e.g., smart home)
'home_appliances_2'              – Small to medium household electronics
'small_appliances'               – Small kitchen or smart appliances
'small_appliances_home_oven_and_coffee' – Smart ovens, coffee machines
'portable_kitchen_food_processors' – Portable or electronic kitchen tools
'consoles_games'                 – Gaming consoles and accessories
'cds_dvds_musicals'              – Physical media (CDs, DVDs – partly electronic)
'dvds_blu_ray'                   – Blu-ray and DVD discs or players
'cine_photo'                     – Cameras, photo equipment, camera accessories
'musical_instruments'            – Electronic or digital instruments
'security_and_services'          – Security tech (cameras, alarms, sensors)
'signaling_and_security'         – Alarm systems, motion sensors, signal tech
'air_conditioning'               – Smart climate control, AC units
'construction_tools_lights'      – Electric tools and lighting systems
'cool_stuff'                     – Gadget category (modern, innovative tech)
------------------------------------------------------------
*/

   
  --  How many products of these tech categories have been sold (within the time window of the database snapshot)? 
  --  What percentage does that represent from the overall number of products sold?
  
 SELECT 
    COUNT(oi.product_id)
FROM
    order_items oi
        LEFT JOIN
    products p ON p.product_id = oi.product_id
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN ('audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff'
        );
  
  -- What’s the average price of the products being sold?
  
  SELECT 
    AVG(oi.price)
FROM
    order_items oi
        LEFT JOIN
    products p ON p.product_id = oi.product_id
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'auto',
        'computers',
        'computers_accessories',
        'pc_gamer',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'small_appliances',
        'small_appliances_home_oven_and_coffee',
        'portable_kitchen_food_processors',
        'consoles_games',
        'cds_dvds_musicals',
        'dvds_blu_ray',
        'cine_photo',
        'musical_instruments',
        'security_and_services',
        'signaling_and_security',
        'air_conditioning',
        'construction_tools_lights',
        'cool_stuff');
  
   -- Are expensive tech products popular? *
   -- * TIP: Look at the function CASE WHEN to accomplish this task.
   
   SELECT MIN(price) AS min_price,
   AVG(price),
   MAX(price) AS max_price,
   COUNT(CASE WHEN price <= (SELECT AVG(price) FROM order_items) THEN 1 END) AS below_avg_price,
   COUNT(CASE WHEN price > (SELECT AVG(price) FROM order_items) THEN 1 END) AS above_avg_price
   FROM
    order_items;
    
   SELECT MIN(price) AS min_price,
   AVG(price),
   MAX(price) AS max_price,
   COUNT(CASE WHEN price <= (SELECT AVG(price) FROM order_items) THEN 1 END) AS below_avg_price,
   COUNT(CASE WHEN price > (SELECT AVG(price) FROM order_items) THEN 1 END) AS above_avg_price
   FROM
    order_items 
        LEFT JOIN
    products USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN (
        'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff') ;
        
      SELECT 
    product_id, price
FROM
    order_items
WHERE
    price > (SELECT 
            AVG(price)
        FROM
            order_items
        WHERE
            product_id IN (SELECT 
                    product_id
                FROM
                    products
                        JOIN
                    product_category_name_translation USING (product_category_name)
                WHERE
                    product_category_name_english IN (
                        'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff')));

-- min'3.49', avg'135.549214715952', max'6729', products_below_avg'19542', products_above_avg'9099'

 SELECT 
    MIN(tech_products.price) AS min_price,
    AVG(tech_products.price),
    MAX(tech_products.price) AS max_price,
    COUNT(CASE
        WHEN
            tech_products.price <= avg_tp.avg_price
        THEN
            1
    END) AS below_avg_price,
    COUNT(CASE
        WHEN
            tech_products.price > avg_tp.avg_price
        THEN
            1
    END) AS above_avg_price
FROM
    (SELECT 
        oi.price
    FROM
        order_items oi
    LEFT JOIN products p USING (product_id)
    LEFT JOIN product_category_name_translation t USING (product_category_name)
    WHERE
        t.product_category_name_english IN ('audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff')) AS tech_products
JOIN (SELECT 
        AVG(oi1.price) AS avg_price
    FROM
        order_items oi1
    LEFT JOIN products p1 USING (product_id)
    LEFT JOIN product_category_name_translation t1 USING (product_category_name)
    WHERE
        t1.product_category_name_english IN ('audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff')) AS avg_tp;







    
    SELECT
  t.product_category_name_english AS category,
  COUNT(DISTINCT oi.order_id) AS orders_total,
  COUNT(DISTINCT CASE WHEN oi.price > ta.avg_price THEN oi.order_id END) AS orders_above_avg,
  ROUND(100 * COUNT(DISTINCT CASE WHEN oi.price > ta.avg_price THEN oi.order_id END)
            / NULLIF(COUNT(DISTINCT oi.order_id),0), 2) AS pct_orders_above_avg
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation t USING (product_category_name)
JOIN (
  SELECT AVG(oi2.price) AS avg_price
  FROM order_items oi2
  JOIN products p2 USING (product_id)
  JOIN product_category_name_translation t2 USING (product_category_name)
  WHERE t2.product_category_name_english IN (
    'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff'
  )
) ta
WHERE t.product_category_name_english IN (
'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff'
)
GROUP BY category
ORDER BY pct_orders_above_avg DESC;
   
   -- How many months of data are included in the magist database?

   
   SELECT COUNT(DISTINCT DATE_FORMAT(order_purchase_timestamp, "%m %Y"))
   FROM orders;
   
   -- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
   
SELECT COUNT(DISTINCT(seller_id)) FROM order_items;

SELECT 
	(SELECT COUNT(DISTINCT(seller_id)) FROM order_items) AS sellers_total,
    COUNT(DISTINCT (oi.seller_id)) AS tech_sellers,
    ROUND(100* tech_sellers / sellers_total)
FROM
    order_items oi
        LEFT JOIN
    products p ON p.product_id = oi.product_id
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN ('audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff');
   
   SELECT 
  x.sellers_total,
  x.tech_sellers,
  ROUND(100.0 * x.tech_sellers / x.sellers_total, 2) AS pct_tech_of_active
FROM (
  SELECT 
    (SELECT COUNT(DISTINCT seller_id) FROM order_items) AS sellers_total,
    COUNT(DISTINCT oi.seller_id) AS tech_sellers
  FROM order_items oi
  JOIN products p ON p.product_id = oi.product_id
  JOIN product_category_name_translation t USING (product_category_name)
  WHERE t.product_category_name_english IN (
    'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff'
  )
) x;
   -- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
   
SELECT ROUND(SUM(oi.price), 2) AS total_amount_all_sellers
FROM order_items AS oi
JOIN orders AS o
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

SELECT ROUND(SUM(oi.price), 2) AS total_amount_tech_sellers
FROM order_items AS oi
JOIN orders AS o
  ON o.order_id = oi.order_id
JOIN products AS p
  ON p.product_id = oi.product_id
JOIN product_category_name_translation AS t
  ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
  AND t.product_category_name_english IN (
    'audio',
    'auto',
    'computers',
    'computers_accessories',
    'pc_gamer',
    'tablets_printing_image',
    'telephony',
    'electronics',
    'home_appliances',
    'home_appliances_2',
    'small_appliances',
    'security_and_services',
    'signaling_and_security',
    'construction_tools_lights',
    'cool_stuff'
  );
   
   -- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

SELECT 
  ROUND(AVG(m.monthly_total), 2) AS avg_monthly_income_all_sellers
FROM (
  SELECT 
    oi.seller_id,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    SUM(oi.price) AS monthly_total
  FROM order_items AS oi
  JOIN orders AS o
    ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id, DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
) AS m;

SELECT 
  ROUND(AVG(m.monthly_total), 2) AS avg_monthly_income_tech_sellers
FROM (
  SELECT 
    oi.seller_id,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    SUM(oi.price) AS monthly_total
  FROM order_items AS oi
  JOIN orders AS o
    ON o.order_id = oi.order_id
  JOIN products AS p
    ON p.product_id = oi.product_id
  JOIN product_category_name_translation AS t
    ON t.product_category_name = p.product_category_name
  WHERE o.order_status = 'delivered'
    AND t.product_category_name_english IN (
      'audio',
      'auto',
      'computers',
      'computers_accessories',
      'pc_gamer',
      'tablets_printing_image',
      'telephony',
      'electronics',
      'home_appliances',
      'home_appliances_2',
      'small_appliances',
      'security_and_services',
      'signaling_and_security',
      'construction_tools_lights',
      'cool_stuff'
    )
  GROUP BY oi.seller_id, DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
) AS m;
   
	-- What’s the average time between the order being placed and the product being delivered?
   
   SELECT 
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) 
  AS avg_delivery_time_days
FROM orders AS o
WHERE o.order_status = 'delivered';
   
	-- How many orders are delivered on time vs orders delivered with a delay?
    -- look for patterns!
    
    SELECT 
  CASE 
    WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on_time'
    ELSE 'delayed'
  END AS delivery_status,
  COUNT(*) AS number_of_orders
FROM orders AS o
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;
    
    -- Is there any pattern for delayed orders, e.g. big products being delayed more often?
    
    