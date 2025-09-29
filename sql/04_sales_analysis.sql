-- Navigation: Month-over-month growth analysis
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
        SUM(amount) as monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sales_month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY sales_month) as prev_month_sales,
    LEAD(monthly_sales, 1) OVER (ORDER BY sales_month) as next_month_sales,
    ROUND(
        ((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY sales_month)) / 
         LAG(monthly_sales, 1) OVER (ORDER BY sales_month)) * 100, 2
    ) as growth_percentage
FROM monthly_sales
ORDER BY sales_month;
