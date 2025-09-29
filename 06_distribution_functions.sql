-- 1. NTILE(4) - Customer quartiles
SELECT 
    customer_id,
    name,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent) as spending_quartile
FROM (
    SELECT c.customer_id, c.name, SUM(t.amount) as total_spent
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name
);

-- 2. CUME_DIST() - Cumulative distribution
SELECT 
    customer_id,
    name,
    total_spent,
    CUME_DIST() OVER (ORDER BY total_spent) as cumulative_dist
FROM (
    SELECT c.customer_id, c.name, SUM(t.amount) as total_spent
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name
);
