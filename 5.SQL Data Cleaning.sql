/************** LEFT & RIGHT ***************/

/*1.In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. Pull these extensions and provide how many of each website type exist in the accounts table.*/

WITH numb as (SELECT 
RIGHT(website,3) as domain, name
FROM accounts
GROUP BY 1,2
ORDER BY 1)

SELECT domain, COUNT(name) as w_total
FROM numb
GROUP BY 1
ORDER BY 2 DESC


/*2.There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).*/ 

WITH numb as (SELECT 
LEFT(name,1) as first, name
FROM accounts
GROUP BY 1,2
ORDER BY 1)

SELECT first, COUNT(name) as c_total
FROM numb
GROUP BY 1
ORDER BY 2 DESC


/*3.Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?*/


WITH sub as (SELECT name,
CASE
WHEN LEFT(name,1) IN ('1','2','3','4','5','6','7','8','9','0') THEN 'num'
ELSE 'letter'
END AS result
FROM accounts
ORDER BY 1)

SELECT COUNT(r) as g_num
FROM sub
WHERE result = 'num'

SELECT COUNT(result) as g_letter
FROM sub
WHERE result = 'letter'


/*4.Consider vowels as `a`, `e`, `i`, `o`, and `u`. What proportion of company names start with a vowel, and what percent start with anything else?*/

SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, 
        CASE 
            WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
            THEN 1 ELSE 0 END AS vowels, 
        CASE 
            WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
            THEN 0 ELSE 1 END AS other
        FROM accounts) t1;


/****** POSITION & STRPOS *************/

/*1.  Use the `accounts` table to create **first** and **last** name columns that hold the first and last names for the `primary_poc`.*/

SELECT primary_poc,POSITION(' ' IN primary_poc) as pos,
LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc,
  (LENGTH(primary_poc)-POSITION(' ' IN primary_poc))) AS last_name
FROM accounts

/*2.  Now see if you can do the same thing for every rep `name` in the `sales_reps` table. Again provide **first** and **last** name columns.*/

SELECT name,POSITION(' ' IN name) as pos,
LEFT(name,POSITION(' ' IN name)-1) AS first_name,
RIGHT(name,
  (LENGTH(name)-POSITION(' ' IN name))) AS last_name
FROM sales_reps

/****** CONCATE or || *************/

/*1. Each company in the `accounts` table wants to create an email address for each `primary_poc`. The email address should be the first name of the **primary_poc** `.` last name **primary_poc** `@` company name `.com`.*/

WITH names as
(SELECT name,primary_poc,POSITION(' ' IN primary_poc) as pos,
LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc,
  (LENGTH(primary_poc)-POSITION(' ' IN primary_poc))) AS last_name
FROM accounts)

SELECT primary_poc,
CONCAT(first_name,'.',last_name,'@',name,'.com') as email
FROM names

/*2.  You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account `name`, but otherwise your solution should be just as in question `1`. Some helpful documentation is [here](https://www.postgresql.org/docs/8.1/static/functions-string.html).*/

WITH names as
(SELECT name,primary_poc,POSITION(' ' IN primary_poc) as pos,
LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc, (LENGTH(primary_poc)-POSITION(' ' IN primary_poc))) AS last_name
FROM accounts)

SELECT primary_poc,
CONCAT(first_name,'.',last_name,'@',name,'.com') as email
FROM names

/*3. We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the `primary_poc`'s first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.*/

SELECT name,primary_poc,
(f_1 || f_2 || l_1 || l_2 || l_first || l_last)|| REPLACE(UPPER(name), ' ', '') as password
FROM 
    (SELECT name,primary_poc,
    LOWER(LEFT(first_name,1)) AS f_1, 
    LOWER(RIGHT(first_name,1)) AS f_2,
    LOWER(LEFT(last_name,1)) AS l_1, 
    LOWER(RIGHT(last_name,1)) AS l_2,
    LENGTH(first_name) as l_first,
    LENGTH(last_name) as l_last
    FROM  
        (SELECT name,primary_poc,
        LEFT(primary_poc, pos-1) AS first_name,
        RIGHT(primary_poc, (LENGTH(primary_poc)-pos)) AS last_name
        FROM 
            (SELECT name,primary_poc,POSITION(' ' IN primary_poc) as pos 
            FROM accounts)
            as positions)
        as names) 
    as name_length

