-- ==================================================
-- QUESTION 5:
-- What percetange of customerse are repeat buyers?
-- ==================================================
WITH customer_orders AS (
	SELECT
		c.customer_unique_id,
		COUNT(o.order_id) AS order_count
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	GROUP BY c.customer_unique_id
)
SELECT 
	ROUND(
		100.0 *
		SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
		/
		COUNT(*),
		2
	) AS repeat_customer_rate
FROM customer_orders;
-- ==================================================
-- FINDING
-- Only 3.12% of the customers are repeat buyers. This indicates
-- that the vast majority of customers only made a single
-- purchase. 
--
-- BUSINESS INTERPRETATION
-- Customer retention seems to be a potential challenge for Olist.
-- Acquiring new customers is typically more expensive compared 
-- to retaining existing ones. Further analyses can show
-- whether the purchase rates are different across different
-- product categories.
-- ==================================================

-- ==================================================
-- QUESTION 6:
-- Who are the highest-value customers?
-- ==================================================
SELECT
	c.customer_unique_id,
	ROUND(SUM(oi.price), 2) AS total_spend,
	COUNT(DISTINCT o.order_id) AS number_of_orders,
	ROUND(
		SUM(oi.price) / 
		COUNT(DISTINCT o.order_id),
		2
	) AS average_order_value
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
	ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spend DESC;
-- ==================================================
-- FINDING
-- The highest-spending customers spent between 
-- $4,000 and $13,000.
--
-- One notable observation is that top-spending
-- customers are single-time shoppers, suggesting
-- that those that generate the highest revenue
-- do not shop more than once.
--
-- BUSINESS INTERPRETATION
-- Customer value appears to be driven mainly by
-- order size instead of purchasing frequency. 
-- Olist serves customer making occassional high-value 
-- purchases, particularly in categories such as 
-- furniture, electronics, or other premium products.
--
-- Strategies to be implemented include attracting
-- the high-spending customers to becoming repeat
-- buyers.  
-- ==================================================

-- ==================================================
-- QUESTION 7:
-- Do Repeat Buyers Spend More Overall?
-- ==================================================
WITH customer_metrics AS (
	SELECT
		c.customer_unique_id,
		ROUND(SUM(oi.price), 2) AS total_spend,
		COUNT(DISTINCT o.order_id) AS number_of_orders
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	JOIN olist_order_items_dataset oi
		ON o.order_id = oi.order_id
	GROUP BY c.customer_unique_id
)

SELECT 
	CASE
		WHEN number_of_orders = 1
			THEN 'One-Time Buyer'
		ELSE 'Repeat Buyer'
	END AS customer_type,
	ROUND(AVG(total_spend), 2) AS average_customer_spend
	
FROM customer_metrics
GROUP BY customer_type;
-- ==================================================
-- FINDING
-- Repeat Buyers do spend more on average compared to
-- One-time buyers.
--
-- BUSINESS INTERPRETATION
-- Although repeat buyers represent a relatively small
-- proportion (~3$) of the customer base, they contribute
-- more revenue per customer than one-time buyers.
--
-- This suggests that improving customer retention could
-- be an effective strategy for increasing long-term
-- revenue growth.
-- ==================================================

-- ==================================================
-- QUESTION 8:
-- Do Repeat Buyers Spend More Per Order?
-- ==================================================
WITH customer_metrics AS (
	SELECT
		c.customer_unique_id,
		ROUND(SUM(oi.price), 2) AS total_spend,
		COUNT(DISTINCT o.order_id) AS number_of_orders,
		ROUND(
		SUM(oi.price) / 
		COUNT(DISTINCT o.order_id),
		2
		) AS average_order_value
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	JOIN olist_order_items_dataset oi
		ON o.order_id = oi.order_id
	GROUP BY c.customer_unique_id
)

SELECT 
	CASE
		WHEN number_of_orders = 1
			THEN 'One-Time Buyer'
		ELSE 'Repeat Buyer'
	END AS customer_type,
	ROUND(
		AVG(average_order_value),
		2
	) AS avg_aov
	
FROM customer_metrics
GROUP BY customer_type;
-- ==================================================
-- FINDING
-- One-time buyers have a slightly higher average order 
-- value than repeat buyers, though the difference is 
-- modest. 
--
-- BUSINESS INTERPRETATION
-- The higher overall spend among repeat buyers is not 
-- caused by larger individual purchases, rather, repeat
-- buyers generate more revenue because they make purchases
-- more frequently.
-- ==================================================