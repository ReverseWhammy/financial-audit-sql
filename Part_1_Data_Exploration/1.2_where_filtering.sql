-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 1: Data Exploration
-- Sub-Part 2: WHERE Clause - Filtering Transactions
-- Business Question: Which transactions should
-- an auditor flag for further review?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================

-- QUERY 1: Show only CASH_OUT transactions
-- CASH_OUT is higher risk, we isolate it 
-- befroe moving further
SELECT *
FROM transactions 
WHERE type = 'CASH_OUT'
LIMIT 10;

-- QUERY 2: High value transactions above 200K
-- Any value above the limit requires a 
-- mandatory review per std audit procedures
SELECT *
FROM transactions t 
WHERE t.amount > 200000
LIMIT 20;

-- QUERY 3: Transactions that are flagged as fradulent
SELECT *
FROM transactions t 
WHERE isFraud = 1
LIMIT 10;

-- Query 4: High value CASH_OUT transactions
-- Combining two filters - the highest risk combination
-- Large cash withdrawals are classic fraud indicators
SELECT *
FROM transactions t 
WHERE 
	t."type" = 'CASH_OUT'
	AND t.amount > 200000
LIMIT 20;

-- Query 5: Transactions where sender balance 
-- dropped to zero after transaction
-- Classic sign of account emptying - fraud red flag
SELECT *
FROM transactions t 
WHERE 
	newbalanceOrig = 0
	AND amount >100000
LIMIT 20;

-- AUDIT FINDING: Multiple transactions where 
-- balance arithmetic doesn't reconcile.
-- Suggests either fraud or system data integrity issues.
-- Requires escalation in real audit scenario.
