-- ====================================
--		Financial Audit Analysis
-- Part 1: Data Exploration
-- What does our transaction data look
-- in first glance?
-- Author: Neolinn Joy
-- ====================================

-- First look at the data
SELECT * FROM transactions LIMIT 10;

-- How may transactions exist?
SELECT COUNT(*) AS total_transactions
FROM transactions;

-- What transaction types exists?
SELECT DISTINCT type
FROM transactions ;

-- Volume & Value by transaction type
SELECT 
	type,
	COUNT(*) as transaction_count,
	SUM(t.amount ) AS transaction_sum
FROM transactions t 
GROUP BY  type
ORDER BY transaction_count DESC ;
-- Result: CASH_OUT has highest volume - red flag for fraud analysis
-- Note: DEBIT transactions surprisingly low compared to TRANSFER