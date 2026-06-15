import pandas as pd
import sqlite3
df = pd.read_csv(r'D:\Data from Kaggle\Financial-Audit_data\PS_20174392719_1491204439457_log.csv')
print(df.shape)
print(df.head())

conn = sqlite3.connect(r'D:\Data from Kaggle\Financial-Audit_data\Financial_Audit.db')
df.to_sql('transactions', conn, if_exists = 'replace', index = False)
print('Data loaded successfully into the database.')

results = pd.read_sql_query('SELECT COUNT(*) as total_rows FROM transactions', conn)
print(results)