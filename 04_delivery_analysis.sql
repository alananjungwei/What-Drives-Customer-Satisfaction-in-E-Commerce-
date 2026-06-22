-- ==================================================
-- QUESTION 13:
-- Average delivery time?
-- ==================================================
SELECT
	SELECT
	ROUND(
		AVG(
			julianday(o.order_delivered_customer_date)
			-
			julianday(o.order_purchase_timestamp)
			),
			2
	) AS overall_average_delivery_days
FROM olist_orders_dataset o
WHERE o.order_delivered_customer_date IS NOT NULL;
-- ==================================================
-- FINDING
-- The overall average delivery days is 12.56. 
--
-- BUSINESS INTERPRETATION
-- Customers wait an average of 12.56 days to receive
-- their orders after purchase.
--
-- Delivery speed is crucial when it comes to 
-- customer satisfaction. Longer delivery times might
-- negatively impact customer satisfaction and harm
-- the retention strategy. 
-- ==================================================

-- ==================================================
-- QUESTION 14:
-- Which states suffer the longest delivery times?
-- ==================================================
SELECT 
	c.customer_state,
	ROUND(
		AVG(
			julianday(o.order_delivered_customer_date)
			-
			julianday(o.order_purchase_timestamp)
			),
			2
	) AS average_delivery_days
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
	ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;
-- ==================================================
-- FINDING
-- RR, AP, AM, AL, PA the top 5 states that suffer from 
-- the highest delivery days are those in northern remote
-- states and the north-eastern region.
--
-- Customers in these states waited more than twice as long
-- as the overall average devliery time 12.56 days.
--
-- BUSINESS INTERPRETATION
-- Geographic distance and logistical challenges may impact
-- delivery efficiency in these regions. 
--
-- Improve logistics performance in these states could help
-- reduce customer wait times and improve overall customer 
-- satisfaction.
-- ==================================================

-- ==================================================
-- QUESTION 15:
-- Percentage of late deliveries?
-- ==================================================
SELECT 
	ROUND(
		100.0 *
		SUM(
			CASE 
				WHEN o.order_delivered_customer_date >
					 o.order_estimated_delivery_date
					 THEN 1
				ELSE 0
			END 
		)
		/
		COUNT(o.order_id)
		, 2) AS late_delivery_percentage
FROM olist_orders_dataset o
WHERE o.order_delivered_customer_date IS NOT NULL;
-- ==================================================
-- FINDING
-- Approximately 8.11% of deliveed orders arrived
-- later than the estimated delivery date. 
--
-- BUSINESS INTERPRETATION
-- Delivery performance appears relatively reliable, 
-- with most orders arriving on time. 
--
-- Nevertheless, late deliveries represent a potential
-- source of customer dissatisfaction and may influence
-- review scores. 

-- Further analysis could be investigated whether this 
-- plays a factor. 
-- ==================================================

-- ==================================================
-- QUESTION 16:
-- Which product categories arrive late most often?
-- ==================================================
SELECT
	pcnt.product_category_name_english,
	ROUND(
	100.0 *
	SUM(
		CASE 
			WHEN o.order_delivered_customer_date >
				 o.order_estimated_delivery_date
				 THEN 1
			ELSE 0
		END 
	)
	/
	COUNT(DISTINCT o.order_id)
	, 2) AS late_delivery_percentage
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
	ON o.order_id = oi.order_id 
JOIN olist_products_dataset p
	ON oi.product_id = p.product_id
JOIN product_category_name_translation pcnt
	ON p.product_category_name = pcnt.product_category_name
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY pcnt.product_category_name_english
ORDER BY late_delivery_percentage DESC;
	
-- ==================================================
-- FINDING
-- The Top 5 categories with the highest late delivery
-- percentage range from 12.4 to 20.8%. Way higher than
-- the average 8.11%. The categories include home, christmas
-- supplies, underwear_beach, furniture, and audio. 
--
-- BUSINESS INTERPRETATION
-- Two noticeable and time-sensitive product categories stand 
-- out. Christmas supplies and underwear beach. One for 
-- Christmas and the other for summer occassions. This may be 
-- vulnerable for customer dissatisfaction, as customers often
-- purchase these products for specific seasons or events.
--
-- Additionally, bulky categories such as furniture may face
-- greater transportation and fulfillment challenges, contributing
-- to delays.
-- ==================================================