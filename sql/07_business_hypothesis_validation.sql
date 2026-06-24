-- ==================================================
-- H1:
-- Does late delivery reduce ratings?
--
-- H0: Late deliveries and on-time deliveries
-- have the same average review score.
--
-- H1: 
-- Late deliveries have lower review scores.
-- ==================================================
SELECT	
	CASE 
		WHEN o.order_delivered_customer_date >
			 o.order_estimated_delivery_date
			THEN 'Late'
		ELSE 'On Time'
	END AS delivery_status,
	ROUND(AVG(ord.review_score), 2) AS average_review_score
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset ord 
	ON o.order_id = ord.order_id
WHERE o.order_delivered_customer_date IS NOT NULL 
GROUP BY delivery_status;
-- ==================================================
-- FINDING
-- On-time deliveries received an average review score
-- of 4.29, while late deliveries received an average
-- review score of 2.57.
--
-- The difference, 1.72 rating points suggests a 
-- strong relationship between delivery performance
-- and customer satisfaction. 
--
-- BUSINESS INTERPRETATION
-- The results strongly support  the hypothesis that
-- late delivery is associated with lower customer ratings.
--
-- Delivery reliability appears to be one of the most
-- important drivers of customer satisfaction. Reducing
-- late deliveries may substantially improve customer 
-- experience and overall review scores on the platform.
-- ==================================================

-- ==================================================
-- H2:
-- Do repeat customers spend more?
--
-- H0: Repeat customers and one-time customers spend
-- the same amount on average.
--
-- H1: 
-- Repeat customers spend more on average. 
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
-- One-time customers spent an average of $138.67, while
-- repeat customers spent an average of $262.03. 
--
-- Repeat customers spent approximately 89% more than 
-- one-time customers.
--
-- BUSINESS INTERPRETATION
-- The results support the hypothesis that repeat 
-- customers spend more than one-time customers.
--
-- Customer retention appears to have a direct impact
-- on revenue generation. Strategies that encourage
-- repeat purchases may increase customer lifetime
-- value and overall revenue.
-- ==================================================

-- ==================================================
-- H3:
-- Do high-freight orders receive worse reviews?
--
-- H0: Orders with higher freight costs receive the same
-- average review score as orders with lower freight costs.
--
-- H1: Orders with higher freight costs receive lower
-- average review score as orders with lower freight costs.
-- ==================================================
SELECT 
	ord.review_score,
	ROUND(AVG(100*(oi.freight_value)/(oi.price)), 2) AS average_freight_percentage
FROM olist_order_reviews_dataset ord 
JOIN olist_order_items_dataset oi
	ON ord.order_id = oi.order_id
GROUP BY ord.review_score
ORDER BY ord.review_score;
-- ==================================================
-- FINDING
-- Orders with lower review scores tend to have slightly
-- higher freight costs relative to product value. However,
-- the differences were relatively small across review 
-- score groups. 
--
-- BUSINESS INTERPRETATION
-- The results provide limited support for the hypothesis
-- that high freight costs lead to worse reviews.
--
-- Compared to delivery performance, freight cost appears 
-- to be a much wearker driver of customer satisfaction. 
-- ==================================================

-- ==================================================
-- H4:
-- Are some states systemically slower?
-- 
-- H0: Avergae delivery times are the same across all states.
--
-- H1: Average delivery times differ across states.
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
-- Significant differences in delivery performance were
-- observed across states. Northern and remote states 
-- such as RR, AP, and AM experienced the longest
-- average delivery times, often exceeding twice the 
-- overall average delivery duration.
--
-- BUSINESS INTERPRETATION
-- The results support the hypothesis that some states
-- are systemically slower than others.
--
-- Geographic location and logistics infrastructure
-- appear to have a substantial impact on delivery
-- performance. Targeted investments in logistics
-- and distribution networks may help reduce delivery
-- delays in underserved regions.
-- ==================================================