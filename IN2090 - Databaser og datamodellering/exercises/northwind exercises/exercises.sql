/*
1. Select categoryName and Description from the categories table sorted
   by categoryName */

SELECT categoryName, Description
FROM categories
ORDER BY categoryName;

/*
2. Select ContactName, CompanyName, ContactTitle, and Phone from the Customers
   table sorted by Phone */
SELECT ContactName AS Name, CompanyName AS company, ContactTitle, Phone
FROM Customers
ORDER BY Phone;

/*
3. Create a report showing employees´s first and last names and hire dates
   sorted from newest to oldest employees. */
SELECT first_name, last_name, hire_date AS hired
FROM employees
ORDER BY hired DESC;

/*
4. Create a report showing Northwind's orders sorted by Freight from most
   expensive to cheapest. Show OrderID, OrderDate, ShippedDate, CustomerID,
   and Freight. */
SELECT order_id, order_date, shipped_date, customer_id, freight
FROM orders
ORDER BY freight DESC;


/*
5. Select CompanyName, Fax, Phone, HomePage and Country from the Suppliers table sorted by
   Country in descending order and then by CompanyName in ascending order. */
SELECT company_name, Fax, Phone, country
FROM suppliers
ORDER BY country DESC, company_name ASC;


/*
6. Create a report showing all the company names and contact names of
   Northwind's customers in Buenos Aires. */

SELECT company_name, contact_name
FROM customers
WHERE city = 'Buenos Aires';

/*
7. Create a report showing the product name, unit price and quantity per unit
   of all products that are out of stock.*/
SELECT product_name, unit_price, quantity_per_unit
FROM products AS p
WHERE units_in_stock = 0;

/*
8. Create a report showing the order date, shipped date, customer id, and freight
   of all orders placed on May 19, 1997. */

SELECT order_date, shipped_date, customer_id, freight
FROM orders
where order_date = '1997-05-19';

/*
9. Create a report showing the first name, last name and country of all
   employees not in the United States. */

SELECT first_name || ' ' || last_name AS fullname, country
FROM employees
WHERE country != 'USA';

/*
10. Create a report that shows the employee id, order id, customer id,
    required date, and shipped date of all orders that were shipped later
    than they were required. */
SELECT employee_id, order_id, customer_id, required_date, shipped_date
FROM orders
WHERE required_date < shipped_date;

/* 11. Create a report that shows the city, company name, and contact name of
       all the customers who are in cities that begin with "A" or "B"*/
SELECT company_name, contact_name, city
FROM customers
WHERE city LIKE ('A%') OR
      city LIKE ('B%')
ORDER BY city ASC;

/*
12. Create a report that shows all orders that have a freight cost of
    more than $500.00 */

SELECT order_id, customer_id, employee_id,
       freight, ship_name, ship_address, ship_country
FROM orders
WHERE freight > 500;

/*
13. Create a report that shows the product_name, units in stock, and reorder
    level of all products that are up for reorder. */
SELECT product_name, units_in_stock, reorder_level
FROM products
WHERE units_on_order > 0;

/*
14. Create a report that shows the company name, contact name and fax number
    of all customers that have a fax number.*/

SELECT company_name, contact_name, fax
FROM customers
WHERE fax IS NOT NULL;

/*
15. Create a report that shows the first and last name of all employees
    who dot not report to anybody. */
select first_name, last_name
from employees
WHERE reports_to IS NULL;

/*
16. Create a report that shows the company name, contract name and fax number
    of all customers that a fax number. Sort by company name.*/

SELECT company_name, contact_name, fax
FROM customers
WHERE fax IS NOT NULL
ORDER BY company_name ASC;

/*
17. Create a report that shows the city, company name, and contact name of all
    customers are in cities that begin with "A" or "B". Sort by contact name
    in descending order. */
SELECT city, company_name, contact_name
FROM customers
WHERE city LIKE ('A%') OR
      city LIKE ('B%')
ORDER BY city DESC;

/*
18. Create a report that shows the first and last names and birth date of
    all employees born in the 1950s.*/

SELECT first_name || ' ' || last_name,
        birth_date AS birthday
FROM employees
WHERE birth_date >= '1950-01-01' AND
      birth_date <= '1959-12-31';

/*
19. Create a report that shows the product_name and supplier_id for all
    products supplied by Exotic Liquids, Grandma Kelly's Homestead and Tokyo
    Traders. */

SELECT product_name, supplier_id
FROM products
WHERE supplier_id IN (
  SELECT supplier_id
  FROM suppliers
  WHERE company_name = 'Exotic Liquids' OR
        supplier_id = 3 OR
        company_name = 'Tokyo Traders'
);

/*
20. Create a report that shows the shipping postal code, order id, and order
    date for all orders with a ship postal code
