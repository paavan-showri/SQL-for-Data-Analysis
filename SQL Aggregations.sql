/*Find the total amount of poster_qty paper ordered in the orders table.*/
SELECT SUM(poster_qty) FROM orders;

/*Find the total amount of standard_qty paper ordered in the orders table.*/
SELECT SUM(standard_qty) FROM orders;

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
SELECT SUM(total_amt_usd) FROM orders;

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.*/
SELECT (standard_amt_usd + gloss_amt_usd) AS total_amt FROM orders;

/*Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation 
and a mathematical operator.*/
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_per_unit FROM orders;

/*When was the earliest order ever placed? You only need to return the date.*/
SELECT MIN(occurred_at) FROM orders;

/*Try performing the same query as in question 1 without using an aggregation function.*/
SELECT * FROM orders
ORDER BY occurred_at
LIMIT 1;

/*When did the most recent (latest) web_event occur?*/
SELECT MAX(occurred_at) FROM web_events;

/*Try to perform the result of the previous query without using an aggregation function.*/

SELECT occurred_at FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as 
the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, 
as well as the average amount.*/

SELECT AVG(standard_qty) AS avg_standard_qty, AVG(gloss_qty) AS avg_gloss_qty, AVG(poster_qty) AS avg_poster_qty, 
AVG(standard_amt_usd) AS avg_standard_usd, AVG(gloss_amt_usd) AS avg_gloss_usd,AVG(poster_amt_usd) AS avg_poster_usd
FROM orders;

/*Via the video, you might be interested in how to calculate the MEDIAN. T
hough this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?*/
/*Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. 
This is the average of 2483.16 and 2482.55. This gives the median of 2482.855*/

SELECT * FROM 
(SELECT total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT ((SELECT COUNT(*) FROM orders)/2)) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/

SELECT accounts.name, occurred_at
FROM orders
JOIN accounts ON accounts.id = orders.account_id
ORDER BY 2
LIMIT 1;

/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd 
and the company name.*/

SELECT name,SUM(total_amt_usd) AS total_sales
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY name;

/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/

SELECT occurred_at, channel, name AS account_name
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
ORDER BY occurred_at DESC
LIMIT 1;

/*Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.*/

SELECT channel,COUNT(*) AS total_number_of_times
FROM web_events
GROUP BY channel
ORDER BY total_number_of_times DESC;

/*Who was the Sales Rep associated with the earliest web_event?*/

SELECT occurred_at, sales_reps.name AS sales_rep_name
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
ORDER BY occurred_at
LIMIT 1;

/*Who was the primary contact associated with the earliest web_event?*/

SELECT occurred_at, primary_poc
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
ORDER BY occurred_at
LIMIT 1;

/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/

SELECT name,MIN(total_amt_usd) AS smalled_order_amount
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY name
ORDER BY smalled_order_amount;

/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/

SELECT region.name AS region_name ,COUNT(*) AS number_of_sales_reps
FROM region
JOIN sales_reps ON region.id = sales_reps.region_id
GROUP BY region_name
ORDER BY number_of_sales_reps;

/*For each account, determine the average amount of each type of paper they purchased across their orders. 
Your result should have four columns - one for the account name and one for the average quantity purchased 
for each of the paper types for each account.*/

SELECT accounts.name AS account_name, AVG(standard_qty) AS avg_standard_qty,AVG(gloss_qty) AS avg_gloss_qty,AVG(poster_qty) AS avg_poster_qty
FROM orders
JOIN accounts ON accounts.id = orders.account_id
GROUP BY accounts.id
ORDER BY account_name;

/*For each account, determine the average amount spent per order on each paper type. 
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/

SELECT accounts.name AS account_name, AVG(standard_amt_usd) AS avg_standard_amt_usd,AVG(gloss_amt_usd) AS avg_gloss_amt_usd,AVG(poster_amt_usd) AS avg_poster_amt_usd
FROM orders
JOIN accounts ON accounts.id = orders.account_id
GROUP BY accounts.id
ORDER BY account_name;


/*Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

SELECT sales_reps.name AS sales_rep_name, channel, COUNT(*) AS total_number_of_channel_usage
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY sales_rep_name,channel
ORDER BY total_number_of_channel_usage DESC;


/*Determine the number of times a particular channel was used in the web_events table for each region. 
Your final table should have three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

SELECT region.name AS region_name, channel, COUNT(*) AS total_occurances
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
JOIN region ON region.id = sales_reps.region_id
GROUP BY region_name,channel
ORDER BY total_occurances DESC;

/*Use DISTINCT to test if there are any accounts associated with more than one region.*/

/*The below two queries have the same number of resulting rows (351), 
so we know that every account is associated with only one region. 
If each account was associated with more than one region, the first query should have returned more rows than the second query.
*/

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;

/*Have any sales reps worked on more than one account?*/

SELECT sales_reps.id, sales_reps.name, COUNT(*) number_of_accounts
FROM accounts
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY 1,2
ORDER BY number_of_accounts;


/*Questions: HAVING/*

/*Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double check your solutions, my answers can be found at the top of the next concept./*

/*How many of the sales reps have more than 5 accounts that they manage?*/

SELECT sales_reps.name AS s_name, COUNT(accounts.id) AS qty
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
GROUP BY s_name
HAVING COUNT(accounts.id)>5
ORDER BY qty DESC;

/*How many accounts have more than 20 orders?*/

SELECT accounts.id,COUNT(orders.total) as total
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY accounts.id
HAVING COUNT(orders.total)>20
ORDER BY total

/*Which account has the most orders?*/

SELECT accounts.id, count(*) as total
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY accounts.id
ORDER BY count(*) DESC
LIMIT 1;

/*How many accounts spent more than 30,000 usd total across all orders?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

/*Which accounts spent less than 1,000 usd total across all orders?*/
SELECT accounts.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.id
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_amount;

/*Which account has spent the most with us?*/
SELECT accounts.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.id
ORDER BY total_amount DESC
LIMIT 1;

/*Which account has spent the least with us?*/
SELECT accounts.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.id
ORDER BY total_amount
LIMIT 1;

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/
SELECT accounts.name, channel, COUNT(*) AS total_usage
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
WHERE channel LIKE 'facebook'
GROUP BY accounts.id, channel
HAVING COUNT(*) > 6
ORDER BY total_usage DESC;

/*Which account used facebook most as a channel?*/
SELECT accounts.name, channel, COUNT(*) AS total_usage
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
WHERE channel LIKE 'facebook'
GROUP BY accounts.id, channel
ORDER BY total_usage DESC
LIMIT 1;

/*Which channel was most frequently used by most accounts?*/
SELECT channel, COUNT(*) AS total_usage
FROM web_events
GROUP BY channel
ORDER BY total_usage DESC
LIMIT 1;

/*Which channel was most frequently used by most accounts? (including account name)*/
SELECT accounts.name, channel, COUNT(*) AS total_usage
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
GROUP BY accounts.id, channel
ORDER BY total_usage DESC;


/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?*/

SELECT DATE_PART('year',occurred_at), SUM(total_amt_usd) AS total_dollars
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?*/

SELECT DATE_PART('month',occurred_at), SUM(total_amt_usd) AS total_dollars
FROM orders
GROUP BY 1
ORDER BY 2 DESC LIMIT 1;

/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?*/

SELECT DATE_PART('year',occurred_at), SUM(total_amt_usd) AS total_dollars
FROM orders
GROUP BY 1
ORDER BY 2 DESC LIMIT 1;

/*Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?*/

SELECT DATE_PART('month',occurred_at), SUM(total) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC LIMIT 1;

/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

SELECT DATE_PART('month',orders.occurred_at), SUM(orders.gloss_amt_usd) AS total_usd, accounts.name AS name
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
WHERE accounts.name='Walmart'
GROUP BY 1
ORDER BY 2 DESC LIMIT 1;

								/*Questions: CASE*/

/*Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.*/

SELECT account_id, total_amt_usd,
CASE
WHEN total_amt_usd >= 3000 THEN 'Large'
ELSE 'Small'
END AS order_level
FROM orders

/*Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

SELECT
CASE
WHEN total >=2000 THEN 'At Least 2000'
WHEN total >=1000 AND total <=2000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000'
END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY order_category;

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.*/

SELECT accounts.name,SUM(total_amt_usd),
CASE
WHEN SUM(total_amt_usd) > 200000 THEN 'TOP'
WHEN SUM(total_amt_usd) > 100000 THEN 'SECOND'
ELSE 'LOW'
END AS Level
FROM orders
JOIN accounts
ON accounts.id=orders.account_id
GROUP BY accounts.name
ORDER BY 2 DESC;

/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/

SELECT accounts.name,SUM(total_amt_usd) AS total_sales_of_all_orders,
CASE
WHEN SUM(total_amt_usd) > 200000 THEN 'Top'
WHEN SUM(total_amt_usd) >= 200000 AND SUM(total_amt_usd) <= 100000 THEN 'Middle'
ELSE 'Low'
END AS customer_level
FROM accounts
JOIN orders ON accounts.id = orders.account_id
WHERE DATE_PART('year',occurred_at) BETWEEN 2016 AND 2017
GROUP BY accounts.id
ORDER BY 2 DESC;

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.*/

SELECT sales_reps.name, COUNT(*) AS total_number_of_orders,
CASE
WHEN SUM(total) > 200 THEN 'Top'
ElSE 'normal' 
END AS sales_rep_performance_level
FROM orders
JOIN accounts ON accounts.id = orders.account_id
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;

/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/

SELECT sales_reps.name, COUNT(*), SUM(total_amt_usd) total_spent, 
CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top'
WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle'
ELSE 'low' END AS sales_rep_level
FROM orders
JOIN accounts ON accounts.id = orders.account_id 
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY sales_reps.name
ORDER BY 3 DESC;