-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 2: Business Summary
-- Sub Part 2.2: HAVING - Filtering Summaries
-- Business Question: Which account groups show
-- suspicious patterns worth investigating?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- Query 1: Transaction types with more than 
-- 100,000 transactions
-- WHERE filters rows, HAVING filters groups
-- This filters AFTER the grouping is done
SELECT 
	type AS tran_type,
	COUNT(*) AS tran_count
FROM transactions t 
GROUP BY t."type" 
HAVING tran_count > 100000
ORDER BY tran_count DESC;

-- Query 2: Accounts with unusually high 
-- transaction frequency
-- High frequency accounts = potential fraud ring
SELECT 
	nameOrig AS account,
	COUNT(*) AS tran_count,
	ROUND(SUM(t.amount ),2) as total_value
FROM transactions t 
GROUP BY nameOrig
HAVING  tran_count >2
ORDER BY tran_count DESC;
-- NOTE: PaySim assigns near-unique customer IDs per transaction
-- In real banking data, repeat customers would show higher
-- frequency patterns. Frequency based fraud detection limited
-- in this dataset.

-- Query 3: Accounts where average transaction
-- value exceeds 500,000
-- Large average = high value account = priority audit
SELECT 
	nameOrig AS account,
	COUNT(*) AS tran_count,
	AVG(amount) AS avg_tran_value,
	SUM(amount) AS tran_value
FROM transactions t 
GROUP BY nameOrig
HAVING avg_tran_value > 50000000
ORDER BY avg_tran_value DESC ;
-- NOTE: All these accounts have that single
-- high value transaction in them.
-- Case of Hit & Run
-- High probability of account creation for that 
-- one large transation and never used again.
-- This should trigger audit enquiry

-- Query 4: Transaction types where fraud count
-- is greater than zero
-- Isolates only the transaction types with confirmed fraud
SELECT 
	type AS tran_type,
	COUNT(*) AS tran_count, 
	SUM(isFraud) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2) || '%' AS fraud_percent
FROM transactions t 
GROUP BY tran_type 
HAVING fraud_count > 0
ORDER BY tran_count DESC;

-- Query 5: High value destination accounts
-- Accounts receiving large total amounts
-- Could indicate money mule accounts
SELECT 
	nameDest AS destination_acc,
	COUNT(*) AS tran_count,
	ROUND(AVG(amount),2) AS avg_tran_value,
	ROUND(SUM(amount),2) AS tran_value
FROM transactions t 
GROUP BY nameDest
HAVING tran_value > 10000000
ORDER BY tran_value DESC 
LIMIT 20;




