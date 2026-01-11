# E-Commerce Analytics (Olist Dataset)

This project analyzes an e-commerce dataset from Olist (Brazil) using **MySQL** to answer real business questions about revenue, customers, and products.

The goal is to demonstrate **business-grade SQL analytics**, not just dashboards.

---

## 📌 Business Questions Answered

This project answers:

- How much revenue did the company generate?
- What is the Average Order Value (AOV)?
- What % of orders are delivered vs cancelled?
- Which product categories generate the most revenue?
- Which individual products are the top revenue drivers?
- How many customers return and buy again?
- Who are the highest-value customers?
- Does the 80/20 rule (Pareto principle) apply to customers?

---

## 📂 Dataset

Source: **Brazilian E-Commerce Public Dataset by Olist (Kaggle)**

To make analysis fast and reproducible, the dataset was sampled into clean relational tables:

- `customers_sample`
- `orders_sample`
- `order_items_sample`
- `payments_sample`
- `products_sample`

These tables preserve real relationships while keeping the data lightweight for analytics.

---

## 🧱 Data Model

```
customers_sample ──┐
                   ├── orders_sample ── order_items_sample ── products_sample
                   └── payments_sample
```

- `customer_unique_id` is used to track real customers  
- `order_id` links orders, items, and payments  
- Revenue comes from `payments_sample.payment_value`


## 📁 Project Structure

```
sql/     → Business SQL queries  
data/    → Sample-table creation SQL  
powerbi/ → Power BI dashboard  
```


## 🧠 Key Skills Demonstrated

- Multi-table joins  
- Aggregations & GROUP BY  
- Window functions (RANK)  
- Customer-level analytics  
- Funnel analysis  
- Revenue concentration (Pareto / 80-20)  

---

## 📌 Why this project matters
This project shows:
- Who makes the money  
- Where revenue comes from  
- How concentrated customers are  
- Which products truly drive the business  


