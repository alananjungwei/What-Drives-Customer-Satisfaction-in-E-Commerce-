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

-- ==================================================
-- FINDING
-- 
--
-- BUSINESS INTERPRETATION
-- 
-- ==================================================