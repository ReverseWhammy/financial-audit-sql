-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 3: Risk Classification
-- Sub Part 3.1: CASE Statements
-- Business Question: How do we classify 
-- transactions by risk level for audit priority?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- Query 1: Basic risk classification by amount
-- Establishes audit priority tiers
-- Similar to audit materiality thresholds
SELECT 
	type AS tran_type,
	amount,
	CASE 
		WHEN amount > 200000 THEN 'High Risk'
		WHEN amount BETWEEN 50000 AND 200000 THEN 'Medium Risk'
		ELSE 'Low Risk'
	END AS risk_category
FROM transactions t 
limit 20;

-- Query 2: Count transactions by risk category
-- How many transactions fall in each risk tier?
SELECT 
	CASE 
		WHEN amount > 200000 THEN 'High Risk'
		-- NOTE: 200,000 threshold is illustrative only
		-- In production, threshold should be defined by
		-- materiality calculation or regulatory guidelines
		WHEN amount BETWEEN 50000 AND 200000 THEN 'Medium Risk'
		ELSE 'Low Risk'
	END AS risk_category,
	COUNT(*) AS count,
	ROUND(SUM(amount),2) as total_value
FROM transactions t 
GROUP BY	 risk_category 
ORDER BY count DESC ;


-- Query 3: Reconciliation check using CASE
-- Flags transactions where balance arithmetic
-- does not add up. (CASH_OUT, TRANSFERS)
SELECT 
	nameOrig,
	oldbalanceOrg,
	amount,
	ROUND(oldbalanceOrg - amount, 2) AS expected_balance,
    newbalanceOrig AS actual_balance,
	CASE 
		WHEN ROUND((oldbalanceOrg - amount),2) = newbalanceOrig 
			THEN 'RECONSILED'
		WHEN oldbalanceOrg = 0 AND newbalanceOrig = 0
			THEN 'ZERO BALANCE - REVIEW'
		ELSE 'RECONCILIATION BREAK'
	END AS audit_status
FROM transactions t 
WHERE t."type" IN('CASH_OUT', 'TRANSFER')
LIMIT 20;
	
-- Query 4: Fraud pattern classification
-- Combines multiple risk indicators into one flag
SELECT 
	nameOrig,
	type,
	amount,
	isFraud,
	CASE 
		WHEN isFraud = 1 AND amount > 200000
			THEN 'Confirmed High Value Fraud'
		WHEN isFraud = 1 AND amount <= 200000
			THEN 'Confirmed Low Value Fraud'
		WHEN oldbalanceOrg = 0 AND newbalanceOrig = 0
        		THEN 'Zero Balance - Data Quality Issue'
		WHEN isFraud = 0 AND ROUND((oldbalanceOrg - amount),2) != newbalanceOrig
		AND oldbalanceOrg !=0
			THEN 'Unditected Reconciliation Break'
		ELSE 'Normal'
	END AS fraud_classification
FROM transactions t 
WHERE "type" IN('CASH_OUT', 'TRANSFER')
LIMIT 50;	
	
-- Query 5: Full audit priority report
-- Combines risk category + reconciliation + fraud flag
-- A summary report of all risks
SELECT 
	type,
	COUNT(*) AS total_transaction,
	SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS confirmed_fraud,
	SUM(CASE WHEN ROUND((oldbalanceOrg - amount),2) != newbalanceOrig
		AND oldbalanceOrg != 0 THEN 1 ELSE 0 END) AS reco_breaks,
		--"oldbalanceOrg != 0" this excludes reco breaks due to bad data quality
	SUM(CASE WHEN amount > 200000 THEN 1 ELSE 0 END) AS high_value_count,
	SUM(CASE WHEN oldbalanceOrg = 0 AND newbalanceOrig = 0
        THEN 1 ELSE 0 END) AS zero_balance_data_quality
FROM transactions t 
WHERE "type" != 'CASH_IN'
	-- Only transaction types where money leaves the sender
GROUP BY "type" 
ORDER BY confirmed_fraud DESC ;
--CASH_OUT reconciliation reliability:
-- 46% have zero opening balances    >> data quality
-- 43% have genuine recon breaks     >> suspicious
-- Only 11% are arithmetically clean >> trustworthy

--Conclusion: Balance based reconciliation 
--analysis not viable on this dataset.
--Fraud detection must rely on:
 	--isFraud flag
 	--Behavioral patterns
 	--Transaction type analysis
 	--Destination account patterns

