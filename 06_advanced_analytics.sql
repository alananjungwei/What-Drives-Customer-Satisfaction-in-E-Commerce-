-- ==================================================
-- QUESTION 21:
-- Do 20% of customers generate 80% of revenue?
-- ==================================================
WITH customer_revenue AS (
	SELECT
		c.customer_unique_id,
		ROUND(SUM(oi.price), 2) AS total_spend
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	JOIN olist_order_items_dataset oi
		ON o.order_id = oi.order_id
	GROUP BY c.customer_unique_id
)
SELECT 
	customer_unique_id,
	total_spend,
	ROUND((SUM(total_spend) OVER (ORDER BY total_spend DESC)), 2) AS cumulative_revenue,
	ROUND((SUM(total_spend) OVER ()), 2) AS total_revenue,
	ROUND(100 * (SUM(total_spend) OVER (ORDER BY total_spend DESC)) / (SUM(total_spend) OVER ()), 2) AS cumulative_percentage,
	ROW_NUMBER() OVER (ORDER BY total_spend DESC) AS customer_rank,
	COUNT(*) OVER () AS total_customers,
	ROUND(100 * ROW_NUMBER() OVER (ORDER BY total_spend DESC) / COUNT(*) OVER (), 2) AS customer_percentage
FROM customer_revenue
ORDER BY total_spend DESC;
-- ==================================================
-- FINDING
-- The top 20% of customers generated approximately
-- 57% of the total revenue of Olist.
--
-- While revenue is concentrated among higher-value 
-- customers, the distribution is much less extreme
-- than the classic 80/20 Pareto Principle. 
--
-- BUSINESS INTERPRETATION
-- High-value customers contribute a disproportionate
-- share of revenue, highlighting the importance of
-- customer retention and loyalty initiatives. 
-- 
-- However, revenue is not solely dependent on a small
-- group of customers, suggesting that Olist benefits
-- from a relatively braod and diversified customer base.
-- ==================================================

-- ==================================================
-- QUESTION 22:
-- How well does Olist retain customers over time?
-- ==================================================
WITH customer_first_purchase AS (
	SELECT
		c.customer_unique_id,
		strftime('%Y-%m', MIN(o.order_purchase_timestamp)) AS cohort_month,
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	GROUP BY c.customer_unique_id
)
-- ==================================================
-- FINDING
-- 
--
-- BUSINESS INTERPRETATION
-- 
-- ==================================================

-- ==================================================
-- QUESTION 23:
-- RFM Customer Segmentation?
-- ==================================================

-- ==================================================
-- FINDING
-- 
--
-- BUSINESS INTERPRETATION
-- 
-- ==================================================

