-- Creating a separate table of high risk accounts
-- A watchlist/blacklist table
CREATE TABLE flagged_accounts AS
SELECT DISTINCT
	nameOrig AS account_id,
	CASE
		WHEN COUNT(*) OVER (PARTITION BY nameOrig) >1
			THEN 'High Frequency'
		WHEN SUM(amount) OVER (PARTITION BY nameOrig) >500000
			THEN 'High Value'
		ELSE 'Standard'
	END AS risk_profile,
	ROUND(SUM(amount) OVER (PARTITION BY nameOrig),2) AS total_transacted
	FROM transactions
	WHERE type IN ('CASH_OUT','TRANSFER');
	

SELECT COUNT(*)
FROM flagged_accounts;

--Risk Profile breakdown
SELECT 
	risk_profile,
	COUNT(*) AS account_count
FROM flagged_accounts
GROUP BY risk_profile 
ORDER BY account_count DESC;