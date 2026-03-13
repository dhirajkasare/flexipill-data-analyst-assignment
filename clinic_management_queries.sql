-- Flexipill Data Analyst Assignment
-- Candidate: Dhiraj Bhausaheb Kasare

    -- clinic_management_queries

-- B. For the below schema for a clinic management system, provide queries that solve for below questions :-

-- 1. Find the revenue we got from each sales channel in a given year

SELECT sales_channel, SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- 2. Find top 10 the most valuable customers for a given year

SELECT uid, SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;


-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year

SELECT DATE_FORMAT(cs.datetime,'%Y-%m') AS month,
SUM(cs.amount) AS revenue,
SUM(e.amount) AS expense,
SUM(cs.amount) - SUM(e.amount) AS profit,

CASE 
WHEN SUM(cs.amount) - SUM(e.amount) > 0
THEN 'Profitable'
ELSE 'Not Profitable'
END AS status
FROM clinic_sales cs
LEFT JOIN expenses e
ON cs.cid = e.cid
GROUP BY month;


-- 4. For each city find the most profitable clinic for a given month

WITH clinic_profit AS ( SELECT  c.city, c.clinic_name,
SUM(cs.amount) - SUM(e.amount) AS profit
FROM clinics c
JOIN clinic_sales cs ON c.cid = cs.cid
LEFT JOIN expenses e ON c.cid = e.cid
GROUP BY c.city, c.clinic_name
)
SELECT * FROM ( SELECT *,
RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
FROM clinic_profit
) x
WHERE rnk = 1;


-- 5. For each state find the second least profitable clinic for a given month

WITH clinic_profit AS ( SELECT c.state, c.clinic_name,
SUM(cs.amount) - SUM(e.amount) AS profit
FROM clinics c
JOIN clinic_sales cs ON c.cid = cs.cid
LEFT JOIN expenses e ON c.cid = e.cid
GROUP BY c.state, c.clinic_name
)
SELECT * FROM ( SELECT *,
DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
FROM clinic_profit
) t
WHERE rnk = 2;

-- -----------------------------------------------------------------------------------------------------------------