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
		strftime('%Y-%m', MIN(o.order_purchase_timestamp)) AS cohort_month
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
	GROUP BY c.customer_unique_id
),

customer_purchases AS (
	SELECT DISTINCT 
		c.customer_unique_id,
		strftime('%Y-%m', o.order_purchase_timestamp) AS purchase_month
	FROM olist_customers_dataset c
	JOIN olist_orders_dataset o
		ON c.customer_id = o.customer_id
),

cohort_data AS (
    SELECT
        fp.customer_unique_id,
        fp.cohort_month,
        cp.purchase_month,

        (
            CAST(substr(cp.purchase_month,1,4) AS INTEGER) * 12
            +
            CAST(substr(cp.purchase_month,6,2) AS INTEGER)
        )
        -
        (
            CAST(substr(fp.cohort_month,1,4) AS INTEGER) * 12
            +
            CAST(substr(fp.cohort_month,6,2) AS INTEGER)
        ) AS months_since

    FROM customer_first_purchase fp
    JOIN customer_purchases cp
        ON fp.customer_unique_id = cp.customer_unique_id
),

retention_data AS (
	SELECT 
		cd.cohort_month,
		cd.months_since,
		COUNT(DISTINCT cd.customer_unique_id) AS customers
	FROM cohort_data cd
	GROUP BY
		cd.cohort_month,
		cd.months_since
),

cohort_size AS (
	SELECT 
		rd.cohort_month,
		rd.customers AS cohort_size
	FROM retention_data rd
	WHERE months_since = 0
)

SELECT 
	rd.cohort_month,
	rd.months_since,
	rd.customers,
	cs.cohort_size,
	
	ROUND(100.0 * rd.customers / cs.cohort_size, 2) AS retention_rate
FROM retention_data rd
JOIN cohort_size cs
	ON rd.cohort_month = cs.cohort_month
ORDER BY
	rd.cohort_month,
	rd.months_since;
-- ==================================================
-- FINDING
-- Customer retention declines sharply after the initial 
-- purchase. Across all cohorts, only 461 customers 
-- remained active one month after acquisition, compared
-- to over 96,000 customers in Month 0.
--
-- Retention continues to decrease steadily in 
-- subsequent months.
--
-- BUSINESS INTERPRETATION
-- Olist seems to face significant challenges in 
-- customer retention after the first purchase.
-- 
-- Low retention rates are consistent in earlier findings
-- showing that customers are rarely repeat buyers. 
--
-- Initiatives focused on customer loyalty, repeat-purchase
-- incentives, and post-purchase engagement could represent
-- valuable opportunities and revenue growth.
-- ==================================================

-- ==================================================
-- QUESTION 23:
-- RFM Customer Segmentation?
-- ==================================================
WITH rfm_base AS (
    SELECT
        c.customer_unique_id,

        ROUND(
            julianday(
                (
                    SELECT MAX(order_purchase_timestamp)
                    FROM olist_orders_dataset
                )
            )
            -
            julianday(MAX(o.order_purchase_timestamp)),
            0
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.price) AS monetary

    FROM olist_customers_dataset c

    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id

    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
),

rfm_scores AS (
	SELECT 
		rb.customer_unique_id,
		NTILE(5)
		OVER (
			ORDER BY rb.frequency
		) AS f_score,
		NTILE(5)
		OVER (
			ORDER BY rb.recency DESC
		) AS r_score,
		NTILE(5)
		OVER (
			ORDER BY rb.monetary
		) AS m_score
	FROM rfm_base rb
)

SELECT
    customer_segment,
    COUNT(*) AS customers
FROM (
    SELECT
        CASE
            WHEN r_score >= 4
                 AND f_score >= 4
                 AND m_score >= 4
                THEN 'Champion'

            WHEN r_score >= 3
                 AND f_score >= 3
                THEN 'Loyal'

            WHEN r_score <= 2
                 AND f_score <= 2
                THEN 'Lost'

            ELSE 'Potential'
        END AS customer_segment
    FROM rfm_scores
)
GROUP BY customer_segment
ORDER BY customers DESC;
	
-- ==================================================
-- FINDING
-- Loyal customers represent the largest customer segment,
-- accounting for approximately 43% of all customers. Lost 
-- customers represent nearly 39% of the customer base, while
-- Champion customers account for approximately 16%.
--
-- BUSINESS INTERPRETATION
-- The RFM analysis supports previous findings from 
-- the retention and repeat-purchase analyses.
--
-- While Olist has a substantial base of loyal and Champion 
-- customers, a large proportion of customers become
-- inactive after their first purchases.
--
-- This suggests that improving customer retention and 
-- encouraging repeat purchases may represent one of 
-- the largest opportunities for sustainable revenue
-- growth. 
-- ==================================================

