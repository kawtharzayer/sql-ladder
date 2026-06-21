-- 62) Which employee made which sale? Join the `employees` table onto the `transactions` table by `employee_id`. You only need to include the employee's first/last name from `employees`.
SELECT "firstname" , "lastname"
from "employees" e join "transactions" t
on e."ID" = t."employee_id"

-- 63) What is the name of the employee who made the most in sales? Find this answer by doing a join as in the previous problem. Your resulting query will be difficult for someone else to read.
SELECT firstname, lastname, SUM("unit_price"*"quantity") AS total_sales
FROM employees e JOIN transactions t 
ON e."ID" = t."employee_id"
GROUP by e.ID
ORDER BY total_sales DESC
LIMIT 1;

-- 64) Solve the previous problem by joining `employees` onto the `trans_by_employee` view.
SELECT firstname , lastname , total_cost as total_sales
FROM "employees" e JOIN "trans_by_employee" t
on e.ID = t.employee_id
ORDER by total_sales DESC
LIMIT 1

-- 65) Next, the company will try to give bonuses based on performance. Show all employees who've made more in sales than 1.5 times their salary.
SELECT firstname , lastname , salary ,total_cost as total_sales
FROM "employees" e JOIN "trans_by_employee" t
on e.ID = t.employee_id
WHERE t.total_cost > 1.5 * e.salary

-- 66) Do we have potentially erroneous rows? Find all transactions which occurred _before_ the employee was even hired! (Make sure each transaction only occupies one row).
SELECT DISTINCT t.order_id, t.customer, t.orderdate , e.firstname, e.lastname, e.startdate
FROM "transactions" t
JOIN "employees" e
on t.employee_id = e.ID
WHERE t.orderdate < e.startdate

-- 67) Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue of our company versus the total trading volume of Yum! in that month. Format the columns nicely. (Hint: look at the views) That is, a sample row of your result might look like this:
-- 
-- ```
-- | year | month | company_revenue | yum_trade_volume |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- 
-- -- * _Hint:_ You don't need any `WHERE` statements here. You can get the right answer simply by changing what kind of join you do!
SELECT t.year, t.month,
    printf('$%,d', t.total_cost) AS company_revenue,
    printf('%,d', y.tot_volume) AS yum_trade_volume
FROM trans_by_month t JOIN yum_by_month y 
ON t.year = y.year AND t.month = y.month
ORDER BY t.year, t.month

