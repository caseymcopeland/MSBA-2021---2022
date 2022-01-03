-- Question 1
SELECT COUNT (*) AS count_of_customers,
       MIN(stay_credits_earned) AS min_credits,
       MAX(stay_credits_earned) AS max_credits
FROM customer;

-- Question 2
SELECT c.customer_id AS Customer,
       COUNT(reservation_id) AS Number_of_Reservations,
       MIN(check_in_date) AS earliest_check_in
FROM customer c JOIN reservation r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Question 3
SELECT city,
       state,
       ROUND(AVG(stay_credits_earned),0) AS avg_credits_earned
FROM customer
GROUP BY city,state
ORDER BY state ASC, avg_credits_earned DESC;

-- Question 4 -- 
SELECT c.customer_id, --customer table
       c.last_name, -- customer table
       r.room_number, -- room table
       COUNT(res.reservation_id) AS stay_count --reservation table
FROM customer c
    INNER JOIN reservation res ON c.customer_id = res.customer_id
    INNER JOIN reservation_details rd
        ON res.reservation_id = rd.reservation_id
    INNER JOIN room r
        ON rd.room_id = r.room_id
WHERE res.location_id = 1
GROUP BY c.customer_id, c.last_name,r.room_number
ORDER BY c.customer_id ASC, stay_count DESC;


--Question 5 - 
SELECT c.customer_id, --customer table
       c.last_name, -- customer table
       r.room_number, -- room table
       COUNT(res.reservation_id) AS stay_count --reservation table
FROM customer c
    INNER JOIN reservation res ON c.customer_id = res.customer_id
    INNER JOIN reservation_details rd
        ON res.reservation_id = rd.reservation_id
    INNER JOIN room r
        ON rd.room_id = r.room_id
WHERE res.location_id = 1 AND res.status = 'C'
HAVING COUNT(res.reservation_id) >= 2
GROUP BY c.customer_id, c.last_name,r.room_number
ORDER BY c.customer_id ASC, stay_count DESC;

-- Question 6 Part A
SELECT location_name,
       check_in_date,
       COUNT(number_of_guests)
FROM reservation res
    JOIN reservation_details rd
        ON res.reservation_id = rd.reservation_id
    JOIN room r
        ON rd.room_id = r.room_id
    JOIN location l
        ON r.location_id = l.location_id
WHERE check_in_date > SYSDATE
GROUP BY ROLLUP(location_name, check_in_date);

-- Question 6 Part B
-- Cube is an extension of the GROUP BY clause that allows you to
-- generate subtotals similar to the ROLLUP function. 
-- The CUBE operator can calculate subtotals and grand totals for all
-- variations of the columns specified in it
-- Another difference between the two is that CUBE, in place of ROLLUP,
-- will put the summary row at the top of the result set instead of the bottom     


-- Question 7
SELECT feature_name,
       COUNT(DISTINCT location_id) AS count_of_locations
FROM features f
    JOIN location_features_linking lfl
        ON f.feature_id = lfl.feature_id
HAVING COUNT(DISTINCT location_id) > 2
GROUP BY feature_name;

--- SUBQUERY QUESTIONS ----

-- Question 8
SELECT DISTINCT customer_id, first_name, last_name, email
FROM customer
WHERE customer_id NOT IN
    (SELECT customer_id
    FROM reservation);
    
-- Question 9
SELECT first_name, 
       last_name, 
       email,
       phone,
       stay_credits_earned       
    FROM customer
        WHERE stay_credits_earned >
        (SELECT AVG(stay_credits_earned)
        FROM customer)
    ORDER BY stay_credits_earned;

-- Question 10
SELECT city, 
       state,
       (total_earned-total_used) AS credits_remaining
FROM 
    ((SELECT city, 
             state, 
             total_earned,
             total_used
      FROM customer c JOIN
            (SELECT customer_id, 
                SUM(stay_credits_earned) AS total_earned, 
                SUM(stay_credits_used) AS total_used
             FROM customer
             GROUP BY customer_id) sub  
      ON c.customer_id = sub.customer_id
      ORDER BY state,city))
ORDER BY credits_remaining DESC;


-- Question 11
SELECT res.confirmation_nbr,
       res.date_created,
       res.check_in_date,
       res.status,
       rd.room_id
FROM reservation res
    JOIN reservation_details rd
        ON res.reservation_id = rd.reservation_id
    JOIN room r
        ON rd.room_id = r.room_id
WHERE rd.room_id IN
    (SELECT DISTINCT room_id
    FROM reservation_details
    HAVING COUNT(room_id) < 5
    GROUP BY room_id)
AND NOT status = 'C';

-- Question 12
SELECT DISTINCT cp.cardholder_first_name,
                cp.cardholder_last_name,
                cp.card_number,
                cp.expiration_date,
                cp.cc_id
FROM customer_payment cp INNER JOIN
    (SELECT c.customer_id, 
            COUNT(reservation_id) AS count_of_reservations
        FROM customer c JOIN reservation r
            ON c.customer_id = r.customer_id
        WHERE status = 'C'
        HAVING COUNT(reservation_id) = 1 
        GROUP BY c.customer_id) sub
ON cp.customer_id = sub.customer_id -- help here 
WHERE cp.card_type = 'MSTR';



