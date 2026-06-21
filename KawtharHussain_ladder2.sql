--32) How many rows are in the `pets` table?
select count(*) num_of_rows
from "pets"

-- 33) How many female pets are in the `pets` table?
select count(*) num_of_female_pets
from "pets"
where "sex" like "f"

-- 34) How many female cats are in the `pets` table?
select count(*) num_of_female_catss
from "pets"
where "sex" like "f" and "species" like "cat"

-- 35) What's the mean age of pets in the `pets` table?
SELECT AVG(age) AS mean_age_of_pets
FROM "pets"

-- 36) What's the mean age of dogs in the `pets` table?
SELECT AVG(age) AS mean_age_of_dogs
FROM "pets"
where "species" like "dog"

-- 37) What's the mean age of male dogs in the `pets` table?
SELECT AVG(age) AS mean_age_of_dogs
FROM "pets"
where "species" like "dog" and "sex" like "m"

-- 38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
--     * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!
SELECT AVG(age) , count(*)   , min(age)  , max(age) 
FROM "pets"

-- 39) Repeat the previous problem with the following stipulations:
--     * Round the average to one decimal place.
--     * Give each column a human-readable column name (for example, "Average Age")
SELECT round(AVG(age),1) AS avrage_age_of_pets , count(*) as count  , min(age) minimum_age , max(age) maximum_age
FROM "pets"

-- 40) How many rows in `employees_null` have missing salaries?
SELECT count(*)
from "employees_null"
where "salary" is null 

41) How many salespeople in `employees_null` having _nonmissing_ salaries?
SELECT count(*)
from "employees_null"
where "salary" is not null and "job" like "sales"

--  42) What's the mean salary of employees who joined the company after 2010? Go back to the usual `employees` table for this one.
--     * _Hint:_ You may need to use the `CAST()` function for this. To cast a string as a float, you can do `CAST(x AS REAL)`
select avg("salary")
from "employees"
where STRFTIME('%Y', startdate) > '2010'

-- 43) What's the mean salary of employees in Swiss Francs?
--     * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.
select avg("salary"*0.97) as avg_salary_in_Swiss_Francs
from "employees" 

-- 44) Create a query that computes the mean salary in USD as well as CHF. Give the columns human-readable names (for example "Mean Salary in USD"). Also, format them with comma delimiters and currency symbols.
--     * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite, so rounding (down) to the nearest dollar or franc will be done for us.
--     * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`. So an example output will look like `100,000 Fr.`.
SELECT 
    PRINTF('$%,d', AVG(salary)) AS "Mean_Salary_in_USD",
    PRINTF('%,d Fr.', AVG(salary * 0.97)) AS "Mean_Salary_in_CHF"
FROM "employees"

-- 45) What is the average age of `pets` by species?
select avg(age)
from "pets"
GROUP by "species"

-- 46) Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`
select "species",avg(age)
from "pets"
GROUP by "species"

-- 47) What is the count, mean, minimum, and maximum age by species in `pets`?
SELECT "species", AVG(age) AS avrage_age , count(*) as count  , min(age) minimum_age , max(age) maximum_age
from "pets"
GROUP by "species"

-- 48) Show the mean salaries of each job title in `employees`.
select "job",avg("salary") mean_salaries
from "employees"
GROUP by "job"

-- 49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--     * _NOTE:_ 1 USD = 1.65 NZD.
select "job",avg("salary"*1.65) mean_salaries_in_NZD
from "employees"
GROUP by "job"

-- 50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.
select "job",  count(*) as count,avg("salary") mean_salaries   , min(salary) minimum_salary , max(salary) maximum_salary
from "employees"
GROUP by "job"

-- 51) Show the mean salaries of each job title in `employees` sorted descending by salary.
select "job",avg("salary") mean_salaries
from "employees"
GROUP by "job"
ORDER by mean_salaries DESC

-- 52) What are the top 5 most common first names among `employees`?
select "firstname",count(*) num
from "employees"
GROUP by "firstname"
ORDER by num DESC
limit 5

-- 53) Show all first names which have exactly 2 occurrences in `employees`.
select "firstname"
from "employees"
GROUP by "firstname"
having count(*) =2

-- 54) Take a look at the `transactions` table to get a idea of what it contains. Note that a transaction may span multiple rows if different items are purchased as part of the same order. The employee who made the order is also given by their ID.
select *
from "transactions"

-- 55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.
select "order_id", "customer" , sum ("quantity") order_quantity
from "transactions"
group by "order_id" , "customer"
order by order_quantity DESC
LIMIT 5

-- 56) Show the total cost of each transaction.
--     * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--     * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.
select "order_id", "customer" , sum ("unit_price"*"quantity") total_cost
from "transactions"
group by "order_id" , "customer"

--57) Show the top 5 transactions in terms of total cost.
select "order_id", "customer" , sum ("unit_price"*"quantity") total_cost
from "transactions"
group by "order_id" , "customer"
order by total_cost DESC
LIMIT 5

-- 58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)
select  "customer" , sum ("unit_price"*"quantity") total_revenue
from "transactions"
group by  "customer"
order by total_revenue DESC
LIMIT 5

59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)
select  "employee_id" , sum ("unit_price"*"quantity") total_sales_revenue 
from "transactions"
group by  "employee_id"
order by total_sales_revenue DESC
LIMIT 5

-- 60) Which customer worked with the largest number of employees?
--     * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.
select "customer", count (DISTINCT "employee_id" ) total_employees
from "transactions"
group by  "customer"
order by total_employees DESC
LIMIT 1

-- 61) Show all customers who've done more than $80,000 worth of business with us.
select  "customer" , sum ("unit_price"*"quantity") total_revenue
from "transactions"
group by  "customer"
having total_revenue>80000

