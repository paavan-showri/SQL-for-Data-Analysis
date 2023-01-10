/*On which day-channel pair did the most events occur?*/

SELECT DATE_TRUNC('day',occurred_at) as day, channel, COUNT(*) as number_of_events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;

/*sub query from 1st query */
SELECT * 
FROM 
	(SELECT DATE_TRUNC('day',occurred_at) as day, channel, COUNT(*) as number_of_events
	FROM web_events
	GROUP BY 1,2
	ORDER BY 3 DESC) as sub;
	
/*find the average number of events for each channel. Average per day*/
SELECT channel , AVG (event_count) AS avg_count
FROM 
(SELECT DATE_TRUNC('day',occurred_at) as day, channel,
COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2) AS sub
GROUP BY 1
ORDER BY 2 DESC

/*list of orders happened at the first month in P&P history , ordered by occurred_at */
SELECT * 
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
	(SELECT DATE_TRUNC('month',MIN(occurred_at))
	FROM orders)
ORDER BY occurred_at;

/*list of orders happened at the first day in P&P history , ordered by occurred_at */
SELECT * 
FROM orders
WHERE DATE_TRUNC('day',occurred_at) IN
	(SELECT DATE_TRUNC('day',MIN(occurred_at))
	FROM orders)
ORDER BY occurred_at;


/*average of paper quantity happended at the first month in P&P history*/

SELECT AVG(standard_qty) as s_avg, AVG(gloss_qty)as g_avg, AVG(poster_qty) as p_avg
FROM orders
WHERE DATE_TRUNC('month',occurred_at)=
(SELECT DATE_TRUNC('month',min(occurred_at))
FROM orders);

SELECT SUM(total_amt_usd) as t_sum
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', min(occurred_at)) FROM orders);


/*Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/

SELECT sales_reps.name s_name,region.name r_name,SUM(orders.total_amt_usd)
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed*/

SELECT COUNT(*),SUM(orders.total_amt_usd),region.name
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
GROUP BY 3
ORDER BY 2 DESC LIMIT 1;

           OR

/*How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?*/


SELECT COUNT(accounts.id)
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
HAVING orders.total > 
(SELECT MAX(orders.standard_qty)
	FROM 
	(SELECT SUM(orders.standard_qty),account.name
		FROM orders
		JOIN accounts
		ON accounts.id = orders.account_id
		GROUP BY account.name) sum_s);
