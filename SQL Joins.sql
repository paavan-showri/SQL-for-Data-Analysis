--Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen

SELECT primary_poc, occurred_at, channel,name
FROM web_events
JOIN accounts
ON accounts.id=web_events.account_id
WHERE name='Walmart';

--JOINS_2
--Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name 


SELECT region.name r_name,sales_reps.name s_name,accounts.name a_name 
FROM sales_reps
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id;

--JOINS_3

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT region.name r_name,accounts.name as a_name,(total_amt_usd)/(total+0.01) as unit_price
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
JOIN orders
ON accounts.id = orders.account_id;

--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name./*

SELECT region.name r_name,sales_reps.name s_name,accounts.name a_name 
FROM sales_reps
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
AND region.name='Midwest'
ORDER BY a_name;

--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT region.name r_name,sales_reps.name s_name,accounts.name a_name 
FROM sales_reps
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id AND AND sales_reps.name LIKE 'S%'
JOIN region
ON region.id=sales_reps.region_id
AND region.name='Midwest'
ORDER BY a_name;

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT region.name r_name,accounts.name as a_name,(total_amt_usd)/(total+0.01) as unit_price
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
JOIN orders
ON accounts.id = orders.account_id AND orders.standard_qty > 100

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01)./*

SELECT region.name r_name,accounts.name as a_name,(total_amt_usd)/(total+0.01) as unit_price
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
JOIN orders
ON accounts.id = orders.account_id AND orders.standard_qty > 100 AND poster_qty >50 ORDER BY unit_price;

--What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values./*

SELECT DISTINCT channel,account_id from web_events
WHERE account_id= 1001;

--Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd./*

SELECT orders.occurred_at, orders.total,orders.total_amt_usd,accounts.name
FROM orders
JOIN accounts
ON orders.account_id=accounts.id
WHERE orders.occurred_at BETWEEN '01-01-2015' AND '01-01-2016';
