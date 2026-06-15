-- ============================================
-- FINANCIAL AUDIT ANALYSIS
-- Part 5: Trend Analysis
-- Sub Part 5.2: Window Functions - Running Totals
-- Business Question: How does transaction volume
-- and fraud accumulate across the simulation period?
-- Author: Neolinn Joy
-- Date: June 2026
-- ============================================



-- Query 1: Running total of transaction volume by step
-- Shows cumulative money flow over time
-- Like a cumulative cash flow statement
SELECT 
	step,
	COUNT(*) AS daily_transactions,
	ROUND(SUM(amount),2) AS daily_volume,
	ROUND(SUM(SUM(amount)) OVER (ORDER BY step),2) AS running_total_volume
FROM transactions t 
GROUP BY step 
ORDER BY t.step 
LIMIT 30;

-- Query 2: Conforming where mejority of fraud occurs (based on first 30 step):
-- Note: Phase analysis based on first 30 steps only
-- Dataset contains 743 steps total
-- Full phase analysis requires deeper time series work
-- Recommended for future analysis iteration
SELECT 
	CASE
		WHEN step BETWEEN 1 AND 8 THEN 'Phase 1 Ramp-up'
		WHEN step BETWEEN 9 AND 19 THEN 'Phase 2 Peak'
		WHEN step BETWEEN 20 AND 30 THEN 'Phase 3 Wind Down'
	END AS simulation_phase,
	COUNT(*) AS transactions,
	SUM(isFraud) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2) || '%' AS fraud_rate
FROM transactions t 
WHERE t.step BETWEEN 1 AND 30
GROUP BY simulation_phase 
ORDER BY fraud_count DESC
;

-- Analysis scoped to first 30 steps for phase clarity
-- 743 total steps exist - full analysis recommended
-- for future iteration
--
-- Key finding: Fraud rate highest in Phase 1 (0.26%)
-- when transaction volume was lowest
-- Consistent with real world pattern of fraudsters
-- exploiting newly launched systems before controls mature
-- Phase 2 peak volume shows lowest fraud rate (0.03%)
-- suggesting controls strengthen as system matures


-- Query 3: Running total by transaction type
-- How does each type accumulate over time?
-- PARTITION BY resets running total for each type
SELECT 
	step,
	type,
	ROUND(SUM(amount),2) AS period_volume,
	ROUND(SUM(SUM(amount)) OVER(PARTITION BY type
								ORDER BY step),2) AS running_total_by_type
FROM transactions t 
GROUP BY step , type 
ORDER BY "type"  , step  
LIMIT 30;


-- Query 4: Moving average of transaction volume
-- Smooths out daily spikes to show underlying trend
-- Standard technique in financial time series analysis
SELECT 
	step,
	ROUND(SUM(amount),2) AS daily_volume,
	ROUND(AVG(SUM(amount)) OVER 
							(ORDER BY step
							ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
							),2) AS moving_avg_7periods
FROM transactions t 
GROUP BY step 
ORDER BY step
LIMIT 30;
-- Insights from MA analysis:
-- Moving average reveals clear system lifecycle:
-- Steps 1-8:   Ramp up phase, volume growing
-- Steps 9-19:  Steady state, ~7B per step
-- Steps 20+:   Wind down, volume collapsing

-- Query 5: Daily fraud rate trend
-- Is fraud increasing or decreasing over time?
SELECT 	
	step,
	COUNT(*) AS total_transactions,
	ROUND(SUM(amount),2) AS transaction_volume,
	ROUND(SUM(isFraud),2) AS fraud_count,
	ROUND(SUM(isFraud)*100.0/COUNT(*),2) ||'%' AS fraud_rate,
	ROUND(AVG(SUM(isFraud)*100.0/COUNT(*)) OVER (ORDER BY step
							ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
							),2) || '%' AS moving_avg_fraud_rate
FROM transactions t 
GROUP BY step 
ORDER BY step 
LIMIT 30;
-- Fraud rate trend:
-- Starts high (0.59%) during low volume phase
-- Drops to 0.02-0.04% during peak operation
-- Spikes to 100% in final steps (28-30)
-- WARNING: Final steps have only 4-8 transactions
-- 100% fraud rate is statistically insignificant
-- due to extremely small sample size
-- Should be excluded from fraud trend conclusions
























