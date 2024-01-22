-- Often times we'll want to combine fields from an individual row to create a new column.
-- SQL provides a wide variety of operators and functions for such situations.
-- Consider this query:
USE adventureworks;

SELECT 
  salesorderid,
  unitprice,
  unitpricediscount,
  unitprice - (unitpricediscount*unitprice) AS discounted_unit_price,
  orderqty,
  (unitprice - (unitpricediscount*unitprice))*orderqty as total_price,
  orderqty > 5 as "Ordered more than 5"
FROM salesorderdetail
WHERE unitpricediscount > 0
LIMIT 500;

-- Here, we're using numerical operators (subtraction and multiplication) to create two "derived columns"
-- that we call discounted_unit_price and total_price.
-- Also notice that the same comparison operators we used in WHERE clauses can also be used this way, 
-- and always produce "true" or "false"

-- We can also use functions and operators with textual data. For example:
SELECT 
	title,
	firstname,
	middlename,
	lastname,
	suffix,
	firstname || ' ' || lastname AS firstlast,
	CONCAT(firstname, ' ', middlename, ' ', lastname) AS firstmiddlelast,
	CONCAT_WS(' ', title, firstname, middlename, lastname, suffix) AS fullname
FROM contact
limit 500;

-- Here are some other useful string processing functions...
SELECT 
	CONCAT_WS(' ', title, firstname, middlename, lastname, suffix) AS fullname,
	length(CONCAT_WS(' ', title, firstname, middlename, lastname, suffix)) AS fullname_length,
	substring(CONCAT_WS(' ', title, firstname, middlename, lastname, suffix), 1, 5) AS first_5_chars_of_fullname,
	substring(CONCAT_WS(' ', title, firstname, middlename, lastname, suffix), 5, 4) AS chars_5_to_9,
	UPPER(firstname) AS firstname_all_caps,
	LOWER(firstname) AS firstname_lower,
	LOCATE('D', UPPER(firstname)) position_of_first_d
FROM contact
LIMIT 500;

-- A note on datatypes: some operations might return a surprising result.
SELECT 1.0/2.0; -- this returns 0.5

-- This is because "integer division" always truncates the result 
-- by rounding down to a whole number (always DOWN, never up). 
-- If you want to perform division with columns that have integer types,
-- you need to CAST at least one of them first:
SELECT CAST(1 AS FLOAT) / 2;
SELECT 1 / CAST(2 AS FLOAT);

-- Micro-Exercise: Examine the table purchaseorderdetail, then write a query that computes the following:
--  * The initial price (combine unitprice and orderqty)
--  * The rejection refund amount (combine rejectedqty and unitprice)
--  * The price after incoroprating the rejection refund (combine both of the two previously derived values)