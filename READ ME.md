# Financial Transaction Audit Analysis
### SQL Analysis of 6.3 Million Financial Transactions

---

## Project Overview

This project is focused on applying SQL based analysis of a syntetic fiancial transaction 
dataset (PaySim) containing 6.3 million rows. This analysis is approched from an audit prespective,
by using SQL for identifying:
- Fraud patterns
- Reconciliation exceptions
- High risk accounts

This project was built to apply my domain knowledge in financial audits, to gain hands on understanding 
of data analytic skills.

---

## Business Context

The analysis simulates the work of a data analyst 
embedded in an audit team, tasked with:

- Identifying fraudulent transactions
- Classifying accounts by risk level
- Performing reconciliation checks
- Producing an executive audit summary

---
## Dataset 

| attribute | Detail |
|-----------|--------|
| Source | PaySim (Kaggle) |
| Size | 6,362,620 transactions |
| Period | 743 simulation steps (hours) |
| Fraud cases | 8,213 (0.13% of transactions) |
| Total value | 1.14 Trillion |
| Fraud value | 12 Billion (1.05% of total) |

**Dataset Link:** https://www.kaggle.com/datasets/ealaxi/paysim1

**Transaction Types:**
- CASH_OUT — Withdrawal via agent
- TRANSFER — Account to account transfer
- PAYMENT — Merchant payment
- CASH_IN — Deposit via agent
- DEBIT — Direct debit

---

## Tools Used

- **Database:** SQLite
- **IDE:** DBeaver
- **Version Control:** GitHub
- **Visualisation:** Power BI 

--- 

## SQL Concepts Covered

| Concept | Part | Business Application |
|---------|------|---------------------|
| SELECT, LIMIT, DISTINCT | 1.1 | Data familiarisation |
| WHERE, AND, OR, BETWEEN | 1.2 | Transaction filtering |
| GROUP BY, Aggregations | 2.1 | Management summaries |
| HAVING | 2.2 | Suspicious account detection |
| CASE Statements | 3.1 | Risk classification |
| INNER JOIN, LEFT JOIN | 4.1 | Account enrichment |
| Subqueries | 4.2 | Anomaly detection |
| ROW_NUMBER, RANK, NTILE | 5.1 | Transaction ranking |
| Running Totals, Moving Avg | 5.2 | Trend analysis |
| Combined Analysis | 6.1 | Final audit report |
| Star Schema | 6.2 | Export to PowerBI |

---

## Key Findings

### 1. Fraud Concentration
Even though only 0.13% of transaactions are marked as fraud. 
But in value terms it comes to 1.05% (8x) of total value.

### 2. High Risk Transaction Types
- TRANSFER:  0.77% fraud rate - HIGH RISK
- CASH_OUT:  0.18% fraud rate - MEDIUM RISK
- PAYMENT:   0.00% fraud rate - LOW RISK
- DEBIT:     0.00% fraud rate - LOW RISK
- CASH_IN:   0.00% fraud rate - LOW RISK

### 3. Fraud Value Concentration (Pareto Principle)
High value transactions (>200K):
- 26% of total transactions
- 98% of total fraud value (11.8 Billion)
- 8x higher fraud rate than low value transactions
Audit recommendation: Focus 80% of resources
on high value transactions for maximum coverage

### 4. Transaction Cap Exploitation
Top CASH_OUT frauds consistently hit 10,000,000 (the system maximum per transaction).
Which suggests coordinated fraud, maxing transaction limits.
These accounts were single had transaction and never used again (Hit & Run Pattern).

### 5. U-Shape Fraud Distribution
Highest fraud rates at value extremes:
- Decile 1 (highest value): 1.34% fraud rate
- Decile 10 (lowest value): 0.27% fraud rate
- Middle deciles: 0.12-0.17% (stable, low risk)

*Interpretation:* Fraudsters operate at both ends, large targets AND small test transactions.

### 6. Data Quality Findings
Reconciliation break rates:
- DEBIT:    84.46% fail reconciliation
- PAYMENT:  63.52% fail reconciliation
- CASH_OUT: 53.86% fail reconciliation
- TRANSFER: 46.16% fail reconciliation

*Conclusion:* Balance-based reconciliation unreliable. Fraud detection relies on behavioral patterns
and isFraud flag rather than balance arithmetic.

### 7. System Lifecycle Fraud Pattern
- Phase 1 (Steps 1-8):   0.26% fraud rate (highest)
- Phase 2 (Steps 9-19):  0.03% fraud rate (lowest)
- Phase 3 (Steps 20-30): 0.11% fraud rate

*Interpretation:* Fraud highest when volume lowest, fraudsters exploiting newly launched
systems before controls mature

---

## Dataset Limitations

- PaySim is a **synthetic simulation** — not real banking data
- Opening and Closing Balance fields unreliable — 46-84% reconciliation breaks
- Customer IDs are near-unique (avg 1.0015 transactions per account), this limits frequency-based fraud detection
- Time represented as simulation steps, not real dates
- Phase Analysis
  - Phase analysis limited to first 30 of 743 steps
  - Final steps (28-30) show 100% fraud rate but only 4-8 
    transactions — statistically insignificant
- Since PaySim has a near unique customer ID design, the account dimention table (star schema for PowerBI) is almost
  as big as the raw transactions data. 



---

## About

**Neolinn Joy**

Data Analyst | CA Intermediate  

Transitioning to Data Analytics 4+ years audit & Tax experience 

[GitHub](https://github.com/ReverseWhammy)
