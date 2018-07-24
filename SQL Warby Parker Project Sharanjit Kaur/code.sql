--What columns does the table have? --
SELECT * 
FROM survey 
LIMIT 10;

--What is the number of repsonse for each question?--
SELECT question,
	COUNT (DISTINCT user_id)
FROM survey
GROUP BY question;

--First 5 rows of the tables quiz, hometryon, and purchase--
SELECT *
FROM quiz
limit 5;

SELECT *
FROM home_try_on
limit 5;

SELECT *
FROM purchase
limit 5;

--LEFT JOIN to combine the 3 tables
--

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;
   
--Funnel: Conversion rates from quiz to tryon & tryon to purchase--   
With funnels AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT number_of_pairs,
	COUNT (*) AS 'num_quiz',
	SUM (is_home_try_on) AS 'num_home_try_on',
  SUM (is_purchase) AS 'num_purchase',
  1.0 * SUM(is_home_try_on) / COUNT (user_id) AS 'quiz_to_try_on',
	1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_on_to_purchase'
FROM funnels;

--Difference in purchase rates b/w number of apirs --

With funnels AS (SELECT DISTINCT 		h.number_of_pairs,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   p.user_id IS NOT NULL AS 'is_purchase',
   q.user_id
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT number_of_pairs,
	COUNT (*) AS 'num_quiz',
	SUM (is_home_try_on) AS 'num_home_try_on',
  SUM (is_purchase) AS 'num_purchase',
	1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_on_to_purchase'
FROM funnels
GROUP BY number_of_pairs
ORDER BY number_of_pairs;
 