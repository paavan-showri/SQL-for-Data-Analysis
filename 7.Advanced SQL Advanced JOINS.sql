
/*****************SQL Advanced JOINS**************/


/*Query with `FULL OUTER JOIN` for selecting all of the columns in both of the relevant tables, `accounts` and `sales_reps`)


    1.each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)

    2.but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)*/

SELECT * 
FROM accounts
FULL OUTER JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL;

/*Inequality Join
 
Write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number 
 and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name

The query results should be a table with three columns: 
the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), 
and the sales representative's name (e.g. Samuel Racine)*/

SELECT accounts.name,accounts.primary_poc,sales_reps.name
FROM accounts
LEFT JOIN sales_reps
ON sales_reps.id = accounts.sales_rep_id
AND accounts.primary_poc < sales_reps.name;

/*Appending Data via UNION

Write a query that uses `UNION ALL` on two instances (and selecting all columns) of the `accounts` table. Then inspect the results and answer the subsequent quiz.*/

SELECT * FROM accounts as a1
UNION ALL
SELECT * FROM accounts as a2

/*Pretreating Tables before doing a UNION

Add a `WHERE` clause to each of the tables that you unioned in the query above, filtering the first table where `name` equals Walmart and filtering the second table where `name` equals Disney. Inspect the results then answer the subsequent quiz.*/

SELECT * FROM accounts
WHERE name='Walmart'
UNION ALL
SELECT * FROM accounts
WHERE name = 'Disney';

/*Perform the union in your first query (under the **Appending Data via UNION** header) in a common table expression and name it `double_accounts`. Then do a `COUNT` the number of times a `name` appears in the `double_accounts` table. If you do this correctly, your query results should have a count of 2 for each `name`.*/

WITH double_accounts
(SELECT * FROM accounts
UNION ALL
SELECT * FROM accounts)

SELECT name,COUNT(name) as name_count
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;



