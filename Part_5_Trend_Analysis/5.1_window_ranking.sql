-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 5: Trend Analysis
-- Sub Part 5.1: Window Functions - Ranking
-- Business Question: How do transactions and
-- accounts rank against each other?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- Query 1: Rank ALL transactions by amount
-- ROW_NUMBER gives unique rank to every row
-- No two rows get the same rank
SELECT 
	nameOrig,
	type,
	amount,
	isFraud,
	ROW_NUMBER() OVER (ORDER BY amount DESC) AS overall_rank
FROM transactions t 
LIMIT 20;


-- Query 2: Rank transactions WITHIN each type
-- PARTITION BY = reset rank counter for each type
SELECT 
	nameOrig,
	type,
	amount,
	isFraud,
	ROW_NUMBER() OVER (PARTITION BY type 
						ORDER BY amount DESC)
						AS rank_within_type
FROM transactions t 
LIMIT 20;


-- Query 3: RANK vs ROW_NUMBER
-- RANK gives same rank to equal values (like exam results)
-- ROW_NUMBER always gives unique rank
SELECT 
	type,
	amount,
	ROW_NUMBER() OVER(ORDER BY amount DESC) AS row_number,
	RANK() OVER (ORDER BY amount DESC) AS rank_value,
	DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank
FROM transactions t 
LIMIT 20;


-- Query 4: Top 3 highest transactions per type
-- Practical audit use: who are the biggest movers
-- in each transaction category?
SELECT *
FROM(
	SELECT
	nameOrig,
	type,
	amount,
	isFraud,
	ROW_NUMBER() OVER(PARTITION BY type 
					ORDER BY amount DESC) AS rank_within_type
	FROM transactions t 
	)
WHERE rank_within_type <=3
ORDER BY type, rank_within_type;  
-- Top 3 transactions per type reveal critical pattern:
-- All top 3 CASH_OUT transactions confirmed fraud
-- at exactly 10,000,000 -- the system's maximum limit
-- Suggests coordinated fraud maxing out transaction caps
-- TRANSFER top 3 show no fraud despite 60-92M amounts
-- Indicates fraud detection gap for high value transfers
-- Audit recommendation: Manual review of all CASH_OUT
-- transactions at or near the 10,000,000 limit


-- Query 5: Percentile ranking of transactions
-- NTILE(10) divides all rows into 10 equal buckets
-- Bucket 10 = top 10%, Bucket 1 = bottom 10%
SELECT
	decile,
	COUNT(*) AS tran_count,
	ROUND(AVG(amount),2) AS avg_amount,
	ROUND(SUM(isFraud),2) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(isFraud),2)||'%' AS fraud_ratio
FROM 
	(SELECT
	amount,
	isFraud,
	NTILE(10) OVER (ORDER BY amount DESC) AS decile
	FROM transactions t 
	WHERE type IN('CASH_OUT','TRANSFER')
	)
GROUP BY decile 
ORDER BY decile  
;

-- Fraud rate follows a U-shape across deciles
-- Highest in decile 1 (1.34%) - high value targets
-- Decile 2 (0.28%) and Decile 10 (0.27%) both elevated
-- suggesting fraud activity at high AND low value ranges
-- Middle deciles 3-9 show stable low fraud rates
-- Audit recommendation: Prioritise decile 1 for value
-- recovery, monitor decile 10 for account testing patterns








