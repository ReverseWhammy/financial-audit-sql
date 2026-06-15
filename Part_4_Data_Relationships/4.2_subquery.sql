-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 4: Data Relationships
-- Sub Part 4.2: Subqueries
-- Business Question: How do we identify 
-- transactions and accounts that deviate 
-- from normal patterns?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- Query 1: Transactions above average amount
-- Baseline deviation analysis
-- What's normal?
SELECT 
	nameOrig,
	type,
	amount,
	ROUND((SELECT AVG(amount) FROM transactions),2) AS global_avg,
	ROUND(amount - (SELECT AVG(amount) FROM transactions),2) AS deviation
FROM transactions t 
WHERE t.amount > (SELECT AVG(amount) FROM transactions)
	AND t."type" IN ('CASH_OUT','TRANSFER')
LIMIT 20;


-- Query 2: Accounts with above average transaction count
-- High frequency accounts compared to system average
SELECT 
	nameOrig,
	(SELECT
		ROUND(AVG(tran_count),2)
	FROM
		(SELECT 
			COUNT(*) AS tran_count
		FROM transactions t 
		GROUP BY nameOrig)
		) AS avg_tran_count,
	COUNT(*) AS actual_tran_count
FROM transactions t
GROUP BY nameOrig
HAVING COUNT (*) > ( 
	SELECT
		AVG(tran_count)
	FROM
		(SELECT COUNT(*) AS tran_count		
		FROM transactions t 
		GROUP BY nameOrig)
	) 

ORDER BY actual_tran_count DESC
LIMIT 20;


-- Query 3: Fraud transactions above average fraud amount
-- Are high value frauds slipping through undetected?
SELECT 
	nameOrig AS account_number,
	type,
	amount,
	isFraud,
	(SELECT 
		ROUND(AVG(amount),2)
	FROM transactions
	WHERE isFraud=1
	) as avg_fraud_amount
	FROM transactions t 
	WHERE 
		isFraud=1 
		AND 
		amount	> (SELECT 
		ROUND(AVG(amount),2)
		FROM transactions
		WHERE isFraud=1
		)
	ORDER BY t.amount DESC 
	LIMIT 20;


-- Query 4: Destination accounts receiving 
-- above average amounts
-- Identifies potential money mule accounts
SELECT
    nameDest,
    COUNT(*) AS times_received,
    ROUND(SUM(amount), 2) AS total_received,
    Round(AVG(amount),2) AS avg_received,
    ROUND((SELECT AVG(amount) FROM transactions), 2) AS global_avg,
    ROUND(AVG(amount)/(SELECT AVG(amount) FROM transactions), 2) AS avg_ratio
FROM transactions
WHERE type IN ('CASH_OUT', 'TRANSFER')
AND amount > (SELECT AVG(amount) FROM transactions)
GROUP BY nameDest
ORDER BY total_received DESC
LIMIT 20;


-- Query 5: Transactions in top 10% by amount
-- Materiality based selection
-- Only look at the biggest transactions
SELECT 
	type,
	COUNT(*) AS transaction_count,
	ROUND(AVG(t.amount ),2) AS avg_amount,
	SUM(isFraud) AS 	fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2) || '%' AS fraud_rate
FROM transactions t 
WHERE amount>=
		(SELECT
			amount 
		 FROM transactions t
		 ORDER BY t.amount DESC 
		 LIMIT  1 OFFSET(
		 				SELECT CAST (COUNT(*)*0.10 AS INTEGER)
		 				FROM transactions t
				 		 )
		)
GROUP BY "type" 
ORDER BY transaction_count DESC 
;

-- Despite TRANSFER having 3x higher average amount,
-- CASH_OUT shows 1.5x higher fraud rate in top 10%
-- Suggests fraudsters prefer cash withdrawal over
-- transfers despite lower amounts -- once cash is
-- withdrawn recovery is near impossible
-- Audit priority: High value CASH_OUT transactions


