## NAMES: Diego Gaju
## ID: 27395
## Group:A

## Step 1: Problem Definition
**Business Context:** PopStop is an online popcorn store that delivers quality popcorn to the people's doorsteps.
**Data Challenge:** PopStop faces challenges in indentifying the popcorn flavours that do well across different regions.
**Expected Outcome:** Gain insights on the top perfoming popcorn products, monitor the regional sales well and understand our customer's spending habits.	

## Step 2: Success Criteria

**Top 5 Products per Region/Quarter** 
Top 5 popcorn flavors per region/quarter → Use RANK() to rank sales by amount.

**Running Monthly Sales Totals**  
Running monthly sales totals for each flavor → Use SUM() OVER() for cumulative totals.

 **Month-over-Month Growth**  
 Month-over-month growth in sales for key regions → Use LAG()/LEAD() to calculate percentage changes.
 
 **Customer Quartiles**  
Customer quartiles based on purchase frequency → Use NTILE(4) to divide into loyalty tiers.

**3-Month Moving Average Sales**  
3-month moving averages for sales amounts per product → Use AVG() OVER() with a frame clause.

## Step 3: Database Schema

### SQL Schema Creation
-- Customers table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    region VARCHAR2(50)
);

-- Products table  
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    category VARCHAR2(50)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE,
    amount NUMBER
);

<img width="850" height="312" alt="Untitled (1)" src="https://github.com/user-attachments/assets/14ea4492-8d84-44fc-b8e5-f7b5144c5be2" />

### **Step 4: Window Functions Implementation**


## SStep 4: Window Functions Implementation
1. Ranking Functions
Implementation: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK()

Query Example:

sql
SELECT 
    customer_id, name, region, total_revenue,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) as row_num,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as rank
FROM customer_revenues;



## Aggregate Functions
Implementation: SUM() OVER(), AVG() OVER() with frame clauses

Query Example:

sql
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as month,
    SUM(amount) as monthly_sales,
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as running_total
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM');
Results:


Interpretation: Tracked monthly sales trends with running totals and 3-month moving averages. This helps identify growth patterns and smooth out short-term fluctuations.

## Navigation Functions
Implementation: LAG(), LEAD(), growth percentage calculations

Query Example:

sql
SELECT 
    month, monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY month) as prev_month,
    ROUND(((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month)) / 
     LAG(monthly_sales, 1) OVER (ORDER BY month)) * 100, 2) as growth_pct
FROM monthly_sales;
Results:


Interpretation: LAG and LEAD functions enable period-to-period comparisons. Calculated month-over-month growth percentages to identify seasonal patterns and business performance trends.

## Distribution Functions
Implementation: NTILE(4), CUME_DIST()

Query Example:

sql
SELECT 
    customer_id, name, total_spent,
    NTILE(4) OVER (ORDER BY total_spent) as spending_quartile,
    CUME_DIST() OVER (ORDER BY total_spent) as cumulative_distribution
FROM customer_spending;

<img width="650" height="244" alt="customer quatiles" src="https://github.com/user-attachments/assets/170ec057-e540-4b72-8f35-190eec1d408b" />

    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
## Ranking Functions
**Implementation:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`

SELECT 
    customer_id,
    name,
    region,
    total_revenue,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) as row_num,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as rank,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as dense_rank,
    ROUND(PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_revenue) * 100, 2) as percent_rank
FROM customer_revenues
ORDER BY region, total_revenue DESC;
<img width="826" height="374" alt="running_all methods" src="https://github.com/user-attachments/assets/30a29e43-459c-40c1-9701-c8499e242d3d" />

## Window Functions Implementation
**1. Ranking Functions**
Implementation: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK()

Query Example:

sql
WITH customer_revenues AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    customer_id,
    name,
    region,
    total_revenue,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) as row_num,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as rank,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as dense_rank,
    ROUND(PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_revenue) * 100, 2) as percent_rank
FROM customer_revenues
ORDER BY region, total_revenue DESC;
<img width="826" height="374" alt="running_all methods" src="https://github.com/user-attachments/assets/14ee3858-3a77-44d3-aceb-b9e4c09432a6" />

 ## Navigation Functions
Implementation: LAG(), growth percentage calculations

Query Example:

sql
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') as month,
        SUM(amount) as monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY month) as prev_month_sales,
    CASE 
        WHEN LAG(monthly_sales, 1) OVER (ORDER BY month) IS NOT NULL THEN
            ROUND(((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month)) / 
             LAG(monthly_sales, 1) OVER (ORDER BY month)) * 100, 2)
        ELSE NULL
    END as growth_percentage
FROM monthly_sales
ORDER BY month;
Results:
<img width="827" height="376" alt="month over months" src="https://github.com/user-attachments/assets/bcdf4ce0-1f31-4db1-98a6-21c962fd36af" />

## Product Performance Analysis
sql
-- Top 5 Products by Regional Sales
SELECT 
    p.name as product_name,
    p.category,
    c.region,
    SUM(t.amount) as regional_revenue,
    RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) as regional_rank,
    ROUND((SUM(t.amount) / SUM(SUM(t.amount)) OVER (PARTITION BY c.region)) * 100, 2) as region_percentage
FROM products p
JOIN transactions t ON p.product_id = t.product_id
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY p.name, p.category, c.region
ORDER BY c.region, regional_rank;
Results:
<img width="825" height="330" alt="regional perfomace summary" src="https://github.com/user-attachments/assets/5b214211-eac8-4b68-a8c8-ea0ff5f26361" />

## Customer Lifetime Value Analysis
sql
-- Customer Lifetime Value with Window Functions
SELECT 
    c.customer_id,
    c.name,
    c.region,
    COUNT(t.transaction_id) as total_orders,
    SUM(t.amount) as total_spent,
    MIN(t.sale_date) as first_purchase,
    MAX(t.sale_date) as last_purchase,
    ROUND(SUM(t.amount) / COUNT(t.transaction_id), 2) as avg_order_value,
    RANK() OVER (ORDER BY SUM(t.amount) DESC) as spending_rank,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as value_segment
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spent DESC;
Results:
<img width="830" height="353" alt="lifestyle anlysys" src="https://github.com/user-attachments/assets/489ce701-df9f-4663-b509-a3af374fa2f0" />

Interpretation: This comprehensive customer analysis identifies high-value customers based on total spending, order frequency, and average order value. The segmentation helps prioritize customer retention efforts and personalized marketing strategies.

## Monthly Sales Trends with Multiple Metrics
sql
-- Comprehensive Monthly Sales Analysis
WITH monthly_data AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') as month,
        SUM(amount) as monthly_sales,
        COUNT(transaction_id) as transaction_count,
        ROUND(AVG(amount), 2) as avg_transaction_value
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    month,
    monthly_sales,
    transaction_count,
    avg_transaction_value,
    LAG(monthly_sales, 1) OVER (ORDER BY month) as prev_month_sales,
    ROUND(((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month)) / 
         LAG(monthly_sales, 1) OVER (ORDER BY month)) * 100, 2) as sales_growth_pct,
    SUM(monthly_sales) OVER (ORDER BY month) as running_total,
    AVG(monthly_sales) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3month
FROM monthly_data
ORDER BY month;
Results:
<img width="847" height="364" alt="monthly sales trends" src="https://github.com/user-attachments/assets/83b236c8-c0cd-48f9-85bc-be4cf77fefa6" />


Interpretation: This multi-faceted analysis combines growth percentages, running totals, and moving averages to provide a complete picture of sales performance. The integration of multiple window functions reveals both short-term fluctuations and long-term trends.

## Step 5: Results Analysis
Descriptive Analysis (What Happened?)
Caramel Crunch emerged as the top-performing product across all regions

Kigali region generated the highest revenue (45% of total sales)

Monthly sales showed consistent growth from January to July 2024

Sweet category products outperformed savory products by 35%

Top 25% of customers (VIP segment) contributed 42% of total revenue

## Diagnostic Analysis (Why?)
Sweet flavors have universal appeal leading to higher sales volume

Kigali's higher population density and purchasing power drive more sales

Seasonal promotions in April contributed to sales spikes

Customer preferences show clear favoritism toward caramel-based products

Consistent month-over-month growth indicates effective marketing strategies

Prescriptive Analysis (What Next?)
Inventory Optimization: Increase stock of Sweet category products, particularly Caramel Crunch

**Regional Expansion**: Focus marketing efforts in North and East regions to balance regional performance

**Customer Loyalty**: Launch VIP program for top quartile customers identified through NTILE(4) segmentation

**Product Development**: Introduce new caramel variant flavors to capitalize on proven customer preferences

**Promotional Strategy**: Time major promotions based on monthly growth patterns identified through LAG() analysis

**Personalized Marketing**: Use customer segmentation to create targeted campaigns for each spending tier

## Step 6: References & Academic Integrity

##References

**Oracle Database SQL Language Reference - Window Functions**
https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Analytic-Functions.html

**Oracle Base - Analytic Functions (SUM, AVG, COUNT)**
https://oracle-base.com/articles/misc/analytic-functions

**Oracle Tutorial - Window Functions**
https://www.oracletutorial.com/oracle-analytic-functions/

**W3Schools - SQL Window Functions**
https://www.w3schools.com/sql/sql_window_functions.asp

**GeeksforGeeks - SQL Window Functions**
https://www.geeksforgeeks.org/sql-window-functions/

**Microsoft SQL Docs - Window Functions**
https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql

**PostgreSQL Docs - Window Functions**
https://www.postgresql.org/docs/current/tutorial-window.html

**Mode Analytics - SQL Window Functions**
https://mode.com/sql-tutorial/sql-window-functions/

**SQL Shack - Understanding SQL Window Functions**
https://www.sqlshack.com/sql-window-functions/

Oracle Live SQL - Window Functions Examples
https://livesql.oracle.com/apex/livesql/file/tutorial_GQMWH9CQ8QO7QDIBSQSZRZV0S.html

## Academic Integrity Statement
All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation. This project represents my own work in understanding and applying PL/SQL window functions to solve business problems for PopStop Online Popcorn Store.

Course: Database Development with PL/SQL (INSY 8311)
Instructor: Eric Maniraguha
Student: [Diego Gaju]
Submission Date: [29/09/2025]


