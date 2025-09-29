-- LAG()/LEAD() - Month-over-month growth
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
    LAG(monthly_sales, 1) OVER (ORDER BY month) as prev_month,
    ROUND(
        ((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month)) / 
         LAG(monthly_sales, 1) OVER (ORDER BY month)) * 100, 2
    ) as growth_pct
FROM monthly_sales
ORDER BY month;
