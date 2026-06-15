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
- **Visualisation:** Power BI (Part 7 — upcoming)

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

