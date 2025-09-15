# 🛒 E-commerce Sales Analysis (Excel + Python + SQL Project)
## 📌 Project Overview

This project simulates a real-world E-commerce analytics workflow:

1. Excel → Initial validation & data exploration

2. Python (Pandas) → Automated data cleaning & preprocessing

3. PostgreSQL (SQL) → Business insights with 20 queries
## 📁 Dataset
The dataset contains 3 files:

1. Orders.csv → Customer orders (Order ID, Date, Ship Mode, Segment, Region)

2. Order_Details.csv → Product-level sales details (Product, Category, Sales, Profit, Discount, Quantity)

3. Sales_Targets.csv → Monthly sales targets

## 🧹 Data Cleaning Workflow
### 🔹 Excel Cleaning
1. Checked for invalid values

2. Removed duplicates

3. Standardized category and subcategory names

4. Ensured numeric columns (sales, profit, quantity, discount) had valid numbers

### 🔹 Python Cleaning
A Python script (cleaning_script.py) was created to automate cleaning with pandas.

``` python
import pandas as pd

# Load raw files
orders = pd.read_csv("orders.csv")
order_details = pd.read_csv("order_details.csv")
sales_targets = pd.read_csv("sales_targets.csv")

# --- Clean Orders ---
orders.drop_duplicates(inplace=True)
orders['order_date'] = pd.to_datetime(orders['order_date'], errors='coerce')
orders = orders.dropna(subset=['order_date'])
text_cols = ['ship_mode', 'segment', 'region', 'customer_id']
orders[text_cols] = orders[text_cols].apply(lambda x: x.str.strip())

# --- Clean Order_Details ---
order_details.drop_duplicates(inplace=True)
num_cols = ['sales', 'profit', 'quantity', 'discount']
for col in num_cols:
    order_details[col] = pd.to_numeric(order_details[col], errors='coerce')
order_details.dropna(subset=['sales', 'profit', 'quantity'], inplace=True)
order_details = order_details[(order_details['sales'] >= 0) & (order_details['quantity'] > 0)]
order_details['category'] = order_details['category'].str.strip().str.title()
order_details['sub_category'] = order_details['sub_category'].str.strip().str.title()

# --- Clean Sales_Targets ---
sales_targets.drop_duplicates(inplace=True)
sales_targets['target_sales'] = pd.to_numeric(sales_targets['target_sales'], errors='coerce')
sales_targets.dropna(subset=['target_sales'], inplace=True)

# --- Export Clean Files ---
orders.to_csv("clean_orders.csv", index=False)
order_details.to_csv("clean_order_details.csv", index=False)
sales_targets.to_csv("clean_sales_targets.csv", index=False)
```
### ✅ Output:
- clean_orders.csv

- clean_order_details.csv

- clean_sales_targets.csv

These cleaned files were imported into PostgreSQL for analysis.

## 🗄️ Database Schema (PostgreSQL)

``` sql
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    region VARCHAR(50),
    customer_id VARCHAR(50)
);

CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales NUMERIC,
    profit NUMERIC,
    quantity INT,
    discount NUMERIC,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE sales_targets (
    month_year VARCHAR(7) PRIMARY KEY,
    target_sales NUMERIC
);
```

## 📊 SQL Analysis

- Orders → Trends, Segments, Shipping modes

- Order Details → Profitability, Discounts, Best-sellers

- Joins → Sales per customer, AOV, Top products

- Targets → Actual vs Target sales

- Advanced → Customer Lifetime Value, Cohort Analysis

## 🚀 Tech Stack
- Excel → Initial cleaning & validation

- Python (pandas) → Automated data cleaning

- PostgreSQL → Data storage & SQL analysis

## 💡 Thanks for checking out my project!
