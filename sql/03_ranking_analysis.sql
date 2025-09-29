SELECT 
    customer_id,
    name,
    region,
    total_revenue,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) as row_num,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as rank,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) as dense_rank,
    PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_revenue) as percent_rank
FROM (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
WHERE ROWNUM <= 15
ORDER BY region, total_revenue DESC;
