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

## Project Structure
financial-audit-sql/
│
├── Part_1_Data_Exploration/
│   ├── 1.1_select_basics.sql
│   ├── 1.2_where_filtering.sql
│   └── Results/
│
├── Part_2_Business_Summary/
│   ├── 2.1_groupby_aggregations.sql
│   ├── 2.2_having_filters.sql
│   └── Results/
│
├── Part_3_Risk_Classification/
│   ├── 3_case_statements.sql
│   └── Results/
│
├── Part_4_Data_Relationships/
│   ├── 4.1_joins.sql
│   ├── 4.2_subquery.sql
│   └── Results/
│
├── Part_5_Trend_Analysis/
│   ├── 5.1_window_ranking.sql
│   ├── 5.2_running_totals.sql
│   └── Results/
│
├── Part_6_Final_Audit_Report/
│   ├── 6.1_final_audit_report.sql
│   └── Results/

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



