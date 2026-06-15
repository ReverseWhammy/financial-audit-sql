-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 4: Data Relationships
-- Sub Part 4.1: JOINs
-- Business Question: How do we enrich transaction
-- data with account risk profiles?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- Query 1: INNER JOIN
-- Show only transactions where account exists
-- in our flagged accounts table
-- Like VLOOKUP that only returns matches
SELECT 
	t.nameOrig AS account,
	t.type,
	t.amount,
	f.risk_profile,
	f.total_transacted
FROM transactions t 
INNER JOIN flagged_accounts f
	ON t.nameOrig = f.account_id
WHERE t."type" IN ('CASH_OUT', 'TRANSFER')
LIMIT 20;

-- Query 2: LEFT JOIN
-- Show ALL transactions, with risk profile where available
-- Nulls appear where no match exists in flagged_accounts
SELECT 
	t.nameOrig AS account,
	t.type,
	t.amount,
	f.risk_profile,
	f.total_transacted
FROM transactions t 
LEFT JOIN flagged_accounts f
	ON t.nameOrig = f.account_id
LIMIT 20;

-- Query 3: JOIN with aggregation
-- Summarise fraud by risk profile
-- Which risk profile has most confirmed fraud?
SELECT 
	f.risk_profile,
	COUNT(*) AS transaction_count,
	SUM(t.isFraud) as fraud_count,
	ROUND(SUM(t.isFraud)*100.0/COUNT(*),2) || '%' AS fraud_rate,
	ROUND(SUM(t.amount),2) AS total_value
FROM transactions t 
INNER JOIN flagged_accounts f
	ON t.nameOrig = f.account_id
GROUP BY f.risk_profile
ORDER BY fraud_count DESC ;
-- Findings:
-- High Value accounts are 6 times more likely to be fraudulent than standard accounts.


-- Query 4: Self JOIN
-- Find transactions where sender and receiver
-- are the same account - classic fraud indicator
SELECT 
	t1.nameOrig AS sender,
	t1.nameDest AS reciver,
	t1.amount,
	t1.type
FROM transactions t1
INNER JOIN transactions t2
	ON t1.nameOrig = t2.nameDest 
	AND t1.nameDest = t2.nameOrig 
WHERE t1."type" IN ('CASH_OUT', 'TRANSFER')
LIMIT 20;
-- NOTE: Self JOIN returned zero circular transactions
-- PaySim uses near-unique customer IDs per transaction
-- In real banking data this query would identify
-- money laundering circular payment patterns

