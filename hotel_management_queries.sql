-- Flexipill Data Analyst Assignment
-- Candidate: Dhiraj Bhausaheb Kasare

    -- hotel_management_queries 

-- A. Given the below schema for a hotel management system, write appropriate query to answer the following :-

-- 1. For every user in the system, get the user_id and last booked room_no

SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
SELECT user_id, MAX(booking_date) AS last_booking
FROM bookings
GROUP BY user_id
) lb
ON b.user_id = lb.user_id 
AND b.booking_date = lb.last_booking;


-- 2. Get booking_id and total billing amount of every booking created in November, 2021

SELECT bc.booking_id, SUM(i.item_rate * bc.item_quantity) AS total_bill
FROM booking_commercials bc
JOIN items i 
ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-11-01'
AND bc.bill_date < '2021-12-01'
GROUP BY bc.booking_id;


-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000

SELECT bc.bill_id, SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i 
ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000;


-- 4. Determine the most ordered and least ordered item of each month of year 2021

WITH item_orders AS ( SELECT DATE_FORMAT(bc.bill_date,'%Y-%m') AS month,
i.item_name, SUM(bc.item_quantity) AS total_quantity
FROM booking_commercials bc
JOIN items i
ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
GROUP BY month, i.item_name
)
SELECT * 
FROM ( SELECT *,
RANK() OVER (PARTITION BY month ORDER BY total_quantity DESC) AS most_rank,
RANK() OVER (PARTITION BY month ORDER BY total_quantity ASC) AS least_rank
FROM item_orders
) t WHERE most_rank = 1 OR least_rank = 1;


-- 5. Find the customers with the second highest bill value of each month of year 2021

WITH monthly_bills AS ( SELECT DATE_FORMAT(bc.bill_date,'%Y-%m') AS month,
b.user_id, SUM(i.item_rate * bc.item_quantity) AS bill_value
FROM booking_commercials bc
JOIN bookings b ON bc.booking_id = b.booking_id
JOIN items i ON bc.item_id = i.item_id
GROUP BY month, b.user_id
)
SELECT * FROM ( SELECT *,
DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_value DESC) AS rnk
FROM monthly_bills
) x
WHERE rnk = 2;

-- -----------------------------------------------------------------------------------------------------------------

