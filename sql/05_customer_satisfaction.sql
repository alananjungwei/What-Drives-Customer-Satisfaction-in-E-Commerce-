-- ==================================================
-- QUESTION 17:
-- Does late delivery reduce review scores?
-- ==================================================
SELECT
	ROUND(AVG(review_score), 2) AS overall_average_review_score
FROM olist_order_reviews_dataset;
-- ==================================================
-- FINDING
-- The overall average review score is 4.09.
-- ==================================================
SELECT 
	ord.review_score,
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
FROM olist_order_reviews_dataset ord
JOIN olist_orders_dataset o
	ON ord.order_id = o.order_id
GROUP BY ord.review_score;
-- ==================================================
-- FINDING
-- The percentage of late delivery does seem to reflect
-- on the review score, as a 31.19% late devliery percentage
-- show a score 1, and 3% late devliery percentage showed
-- a score of 5. 
--
-- BUSINESS INTERPRETATION
-- Delivery punctuality appears to be an important driver
-- of customer satisfaction. 
--
-- Customers who experienced late deliveries were 
-- substantially more likely to leave poor reviews,
-- suggesting that logistics performance has a direct
-- impact on the customer experience. 
--
-- Investments in improving on-time delivery rates may 
-- help increase customer satisfaction and strengthen overall
-- marketplace trust. 
-- ==================================================

-- ==================================================
-- QUESTION 18:
-- Which product categories receive the lowest ratings?
-- ==================================================
SELECT
	ROUND(AVG(review_score), 2) AS average_review_score,
	pcnt.product_category_name_english
FROM olist_order_reviews_dataset ord 
JOIN olist_order_items_dataset oi
	ON ord.order_id = oi.order_id
JOIN olist_products_dataset p
	ON oi.product_id = p.product_id 
JOIN product_category_name_translation pcnt
	ON p.product_category_name = pcnt.product_category_name
GROUP BY pcnt.product_category_name_english
ORDER BY average_review_score DESC;
-- ==================================================
-- FINDING
-- The average review score is 4.09. Notable product 
-- categories that have a higher rating are books, 
-- children clothes, music, tools, and shoes. Product 
-- categories that show a much lower score than average
-- are furnitures, female and male clothing, and home comfort. 
--
-- BUSINESS INTERPRETATION
-- Customer satisfaction greatly varies across product 
-- categories. 
--
-- Categories such as books, children clothes, music,
-- tools, and shoes, received ratings above the average,
-- suggesting that customer expectations in these 
-- categories are generally being met or exceeded.
--
-- In contrast, clothing, home comfort, and furniture 
-- received below-average ratings, indicating potential
-- challenges related to product quality, sizing expectations,
-- fulfillment, or delivery performance.
--
-- Interestingly, from previous analysis, furniture shows
-- a lower review score also due to late delivery, suggesting
-- that logistics performance may contribute to lower 
-- customer satisfaction. 
-- ==================================================

-- ==================================================
-- QUESTION 19:
-- Does the shipping cost relative to the product
-- price affect ratings?
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
-- Order with lower reviews might be due to a higher 
-- shipping cost. However, differences between high 
-- and low review scores don't show significantly
-- different percentage of shipping cost.
--
-- BUSINESS INTERPRETATION
-- The relationship between review score and freight 
-- percentage seems to be weak. 
--
-- Compared to delivery delays, freight cost does not 
-- appear to be a major driver of customer satisfaction.
-- 
-- Customers seem to be more sensitive to on-time delivery
-- as suppposed to shipping cost. 
-- ==================================================

-- ==================================================
-- QUESTION 20:
-- Do expensive products receive better ratings?
-- ==================================================
SELECT 
	ord.review_score,
	ROUND(AVG(oi.price), 2) AS average_price
FROM olist_order_reviews_dataset ord 
JOIN olist_order_items_dataset oi
	ON ord.order_id = oi.order_id
GROUP BY ord.review_score
ORDER BY ord.review_score
-- ==================================================
-- FINDING
-- No clear relationship was observed between product 
-- price and customer review scores.
--
-- Average product prices ranged from $110 to $127 across 
-- review scores, with no consistent increase or decrease
-- as ratings improved.
--
-- BUSINESS INTERPRETATION
-- Product price alone does not appear to be a significant
-- driver of customer satisfaction.
--
-- Expensive products are not rated better or worse, 
-- suggesting that factors such as delivery performance
-- and product quality might play a larger role
-- in customer satisfaction.
-- ==================================================