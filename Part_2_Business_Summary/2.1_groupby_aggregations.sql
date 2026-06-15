-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 2: Business Summary
-- Sub Part 2.1: GROUP BY & Aggregations
-- Business Question: What does the overall 
-- transaction landscape look like?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================

-- Query 1: Total transaction count and value by type
SELECT 
	type,
	COUNT(*) AS transaction_count,
	SUM(amount) AS total_value,
	ROUND(AVG(amount),2) AS avg_transaction_value,
	MAX(amount) AS largest_transaction,
	MIN(amount) AS smallest_transaction
FROM transactions t 
GROUP BY t."type" 
ORDER BY total_value DESC ;

-- Query 2: Fraud summary by transaction type
-- How much fraud exists in each transaction type?
SELECT 
	type,
	COUNT(*) AS transaction_count,
	SUM(isFraud) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2) || '%' AS fraud_percent
FROM transactions t 
GROUP BY t."type" 
ORDER BY fraud_percent DESC;
-- Fraud detected only in TRANSFER (0.77%) and CASH_OUT (0.18%) in this dataset.
-- PAYMENT and CASH_IN show zero fraud flags however this does
-- not rule out merchant collusion or balance manipulation --
-- those patterns may exist but remain undetected in this data.
-- Scope of fraud detection limited to dataset simulation design.


-- Query 3: Daily transaction volume
-- Spot peak activity periods - useful for audit scheduling
SELECT 
	step AS hour,
	COUNT(*) AS transaction_count,
	SUM(amount) AS total_volume
FROM transactions
GROUP BY step
ORDER BY total_volume DESC 
LIMIT 20;
-- Note: 'step' represents hours elapsed since simulation start
-- Dataset lacks real datetime values - limits time based analysis
-- In production systems actual timestamps would be available

-- Query 4: Average transaction value & variances by type
-- Establishes baseline - deviations from this are suspicious
SELECT 
	type AS tran_type,
	ROUND(AVG(amount),2) AS avg_tran_value,
	ROUND(AVG(oldbalanceOrg),2) AS avg_op_bal,
	ROUND(AVG(newbalanceOrig),2) AS avg_cl_bal,
	ROUND(AVG(newbalanceOrig) - AVG(oldbalanceOrg),2) AS difference 
FROM transactions t 
GROUP BY t."type" ; 
-- AUDIT INSIGHT: TRANSFER shows steepest average balance drop
-- (-44,153 per transaction) confirming it as highest value
-- outflow channel. Combined with 0.77% fraud rate this makes
-- TRANSFER the highest priority for audit investigation.


