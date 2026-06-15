-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 6: Final Audit Report
-- Sub Part 6.1: Comprehensive Audit Summary
-- Business Question: What is the complete risk
-- picture of this transaction dataset?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================


-- ============================================
-- SECTION 1: EXECUTIVE SUMMARY
-- ============================================
SELECT 
	COUNT(*) AS total_transaction,
	ROUND(SUM(amount),2) AS total_value,
	SUM(isFraud) AS confirmed_fraud_case,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2)||'%' AS overall_fraud_rate,
	ROUND(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),2) AS total_fraud_value,
	ROUND(SUM(CASE WHEN isFraud=1 THEN amount ELSE 0 END)*100.0/
						SUM(amount),2)||'%' AS fraud_value_rate
FROM transactions t 	

-- ============================================
-- SECTION 2: RISK BREAKDOWN BY TYPE
-- Transaction type risk profile
-- ============================================
SELECT 
	type,
	COUNT(*) AS transaction_count,
	ROUND(SUM(amount),2) AS total_value,
	ROUND(AVG(amount),2) AS avg_value,
	SUM(isFraud) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2)||'%' AS fraud_rate,
	ROUND(SUM(CASE WHEN  isFraud = 1 THEN amount ELSE 0 END),2) AS fraud_value,
	CASE
		WHEN SUM(isFraud)*100.0/COUNT(*) > 0.5 THEN 'HIGH RISK'
		WHEN SUM(isFraud)*100.0/COUNT(*) > 0.1 THEN 'MEDIUM RISK'
		ELSE 'LOW RISK'
	END AS risk_rating
FROM transactions
GROUP BY type
ORDER BY fraud_count DESC;


-- ============================================
-- SECTION 3: TOP 20 HIGH PRIORITY ACCOUNTS
-- Accounts requiring immediate investigation
-- Combines fraud + high value + reconciliation
-- ============================================
SELECT 
	nameOrig AS account,	
	COUNT(*) AS transaction_count,
	ROUND(SUM(amount),2) AS total_transacted,
	SUM(isFraud) AS fraud_count,
	SUM(CASE
		WHEN t."type" IN ('CASH_OUT','TRANSFER')
		AND oldbalanceOrg - amount != newbalanceOrig
		AND oldbalanceOrg != 0 
		THEN 1 ELSE 0
		END) AS reco_breaks,
	SUM(CASE
		WHEN oldbalanceOrg = 0 AND newbalanceOrig = 0
		THEN 1 ELSE 0
		END
		) AS zero_balance_flag,
	CASE 
		WHEN isFraud > 0 THEN "IMMEDIATE ACTION"
		WHEN SUM(CASE WHEN type IN ('CASH_OUT',"TRANSFER")
					AND oldbalanceOrg - amount != newbalanceOrig
					AND oldbalanceOrg != 0	
					THEN 1 ELSE 0 END)>0 THEN 'INVESTIGATE'
		ELSE 'MONITOR'
	END AS audit_action
	FROM transactions t 
	GROUP BY account 
	HAVING SUM(isFraud)> 0 
		OR 
		SUM(CASE
			WHEN oldbalanceOrg - amount != newbalanceOrig
			AND oldbalanceOrg != 0 
			THEN 1 ELSE 0
		END)>0
ORDER BY fraud_count DESC, total_transacted  DESC,  reco_breaks DESC
LIMIT 20;
-- FINDING
-- Top 20 accounts by fraud + value
-- almost all exactly 10,000,000
-- fraudsters consistently hitting
-- the system's maximum transaction cap



-- ============================================
-- SECTION 4: RECONCILIATION EXCEPTION SUMMARY
-- Data quality and reconciliation overview
-- ============================================
SELECT 
	type,
	COUNT(*) AS total_transactions,
	SUM(CASE
		WHEN ROUND(oldbalanceOrg - amount) != newbalanceOrig
		AND oldbalanceOrg != 0
		THEN 1 ELSE 0
		END
		) AS reco_breaks,
	SUM(CASE 
		WHEN oldbalanceOrg = 0 AND newbalanceOrig = 0
		THEN 1 ELSE 0 
		END
		) AS zero_balance_flags,
	ROUND(SUM(CASE
		WHEN ROUND(oldbalanceOrg - amount) != newbalanceOrig
		AND oldbalanceOrg != 0
		THEN 1 ELSE 0
		END
		)*100.0/ COUNT(*),2) ||'%' AS reco_break_rate
FROM transactions t 
WHERE type  != "CASH_IN"
GROUP BY "type" 
ORDER BY reco_breaks DESC;

-- ============================================
-- SECTION 5: FRAUD VALUE AT RISK
-- Financial exposure by risk tier
-- ============================================
SELECT 
	CASE
		WHEN amount > 200000 THEN 'HIGH VALUE (>200K)'
		WHEN amount BETWEEN 50000 AND 200000 THEN "Medium Value"
		ELSE "Low Value (<50K)"
	END AS value_tier,
	-- NOTE: 200,000 threshold is illustrative only
	-- In production, threshold should be defined by
	-- materiality calculation or regulatory guidelines
	COUNT(*) AS total_transactions,
	SUM(isFraud) AS fraud_cases,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2)||'%' AS fraud_rate,
	ROUND(SUM(CASE
		WHEN isFraud = 1 THEN amount ELSE 0
		END),2) AS fraud_value_exposed
FROM transactions t 
GROUP BY value_tier 
ORDER BY fraud_value_exposed DESC;
	



