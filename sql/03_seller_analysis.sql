-- ==================================================
-- QUESTION 9:
-- Which sellers generate the most revenue?
-- ==================================================
SELECT
	oi.seller_id,
	ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC;
-- ==================================================
-- FINDING
-- The Top 10 sellers each generated between $135k 
-- and $229k in revenue.
--
-- BUSINESS INTERPRETATION
-- Revenue does not seem to be concentrated within a 
-- single seller. Instead, multiple sellers contributed
-- meaningful amounts of revenue to Olist.
--
-- This diversification reduces dependence on any single
-- individual seller and contribute to a a more resilient
-- moarketplace ecosystem.
-- ==================================================

-- ==================================================
-- QUESTION 10:
-- Which sellers process the most orders?
-- ==================================================
SELECT 
	oi.seller_id,
	ROUND(SUM(oi.price), 2) AS total_revenue,
	COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY number_of_orders DESC;
-- ==================================================
-- FINDING
-- Five of the ten highest-volume sellers also appear among
-- the ten highest-revenue sellers. This suggest that order 
-- volume is an important contributor to seller revenue.
--
-- BUSINESS INTERPRETATION
-- Order volume appears to be an important driver of seller 
-- revenue, as many of the highest-volume sellers also rank
-- among the highest-revenue sellers.
-- ==================================================

-- ==================================================
-- QUESTION 11:
-- How does seller revenue relate to customer ratings?
-- ==================================================
SELECT
	ROUND(AVG(review_score), 2) AS overall_average_review_score
FROM olist_order_reviews_dataset;
-- ==================================================
-- FINDING
-- The overall average review score is 4.09.
-- ==================================================
SELECT
	oi.seller_id,
	ROUND(SUM(oi.price), 2) AS total_revenue,
	ROUND(AVG(ord.review_score), 2) AS average_review_score
FROM olist_order_items_dataset oi
JOIN olist_order_reviews_dataset ord
	ON oi.order_id = ord.order_id
GROUP BY oi.seller_id
ORDER BY total_revenue DESC;
-- ==================================================
-- FINDING
-- Six out of the top 10 sellers have their average score lower 
-- than the overall average of 4.09.
--
-- BUSINESS INTERPRETATION
-- High seller revenue does not necessarily translate into 
-- higher customer satisfaction.
--
-- Several of the highest-revenue sellers received below-average
-- review scores, suggesting that strong sales performance and customer
-- experience are not always aligned. 
--
-- There is an opportunity for Olist to improve customer satisfaction
-- among its most commercially important sellers.
-- ==================================================

-- ==================================================
-- QUESTION 12:
-- Which sellers generate the highest revenue per order?
-- ==================================================
SELECT 
	oi.seller_id,
	ROUND(
		SUM(oi.price)
		/
		COUNT(DISTINCT oi.order_id),
		2
	) AS revenue_per_order
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY revenue_per_order DESC;
-- ==================================================
-- FINDING
-- Sellers with the highest revenue per order differ
-- substantially from the sellers generating the highest
-- total revenue.
--
-- This suggests that seller success on the platform is
-- achieved through different business models, including
-- both high-volume sales and high-value transactions.
--
-- BUSINESS INTERPRETATION
-- Some sellers generate revenue through a large number of
-- transactions, while the others generate substantial
-- revenue through fewer, high-value orders.
--
--Understanding these different seller profiles may help Olist 
-- tailor seller support, marketing, and growth strategies.
-- ==================================================