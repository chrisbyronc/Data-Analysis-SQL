# Exercise: Group By

Use `GROUP BY` and `having` to create the following queries / answer the following questions:

1. How many SalesOrders were placed each year, and what was the average `totaldue` of them (again by year)?

```sql
SELECT 
  EXTRACT(year FROM orderdate) AS year,
  COUNT(1) AS sales, 
  AVG(totaldue) AS average_sale_value
FROM salesorderheader
GROUP BY EXTRACT(year FROM orderdate);
```

2. How many SalesOrders were placed each month of each year, and what was the average `totaldue` of them (again by month and year)?

```sql
SELECT 
  EXTRACT(year FROM orderdate) AS year,
  EXTRACT(month FROM orderdate) AS month,
  COUNT(1) AS sales, 
  AVG(totaldue) AS average_sale_value
FROM salesorderheader
GROUP BY 
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate)
ORDER BY 
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate);
```

3. Join the `salesperson` table to the `Salesorderheader` table, then calculate the average `totaldue` by year, month, and salesperson along with the salespersons name. (you will need to JOIN more tables to get the name... checkout `contact`)

```sql
SELECT
  CONCAT(p.firstname, ' ', p.middlename, ' ', p.lastname),
  EXTRACT(year FROM orderdate) AS year,
  EXTRACT(month FROM orderdate) AS month,
  COUNT(1) AS sales, 
  AVG(totaldue) AS average_sale_value
FROM salesorderheader soh
  JOIN salesperson sp on sp.salespersonid=soh.salespersonid
  JOIN employee e on e.employeeid=sp.salespersonid
  JOIN contact p on p.contactid=e.contactid
GROUP BY
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate),
  p.contactid
ORDER BY
  CONCAT(p.firstname, ' ', p.middlename, ' ', p.lastname),
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate);
```

4. Make a separate query (or use a subquery) to determine the global average `totaldue` and then limit the above list to only records with a monthly per-salesperson average that is above the global average.

```sql
SELECT AVG(totaldue) FROM salesorderheader; -- => 3915.9951093564277769

-- You can use that number directly in the having clause, or AS a subquery. A subquery is more robust for something such AS automated reporting purposes, since it will always be up to date. For a one time exploration of the data, making two queries is perfectly fine.

SELECT
  CONCAT(p.firstname, ' ', p.middlename, ' ', p.lastname),
  EXTRACT(year FROM orderdate) AS year,
  EXTRACT(month FROM orderdate) AS month,
  COUNT(1) AS sales, 
  AVG(totaldue) AS average_sale_value
FROM salesorderheader soh
  JOIN salesperson sp on sp.salespersonid=soh.salespersonid
  JOIN employee e on e.employeeid=sp.salespersonid
  JOIN contact p on p.contactid=e.contactid
GROUP BY
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate),
  p.contactid
having AVG(totaldue) > (SELECT AVG(totaldue) FROM salesorderheader)
ORDER BY
  CONCAT(p.firstname, ' ', p.middlename, ' ', p.lastname),
  EXTRACT(year FROM orderdate),
  EXTRACT(month FROM orderdate);
```

5. Make a query that determines how many unique products each vendor supplies to AdventureWorks.

```sql
SELECT 
  v.name,
  COUNT(p.productid) AS product_COUNT
FROM vendor v
  JOIN productvendor pv on pv.vendorid=v.vendorid
  JOIN product p on p.productid=pv.productid
GROUP BY
  v.vendorid
ORDER BY
  COUNT(p.productid) desc;
```

6. Make a query that determines the average, minimum, and maximum `listprice` of products by `class`. 

```sql
SELECT 
  class,
  MAX(listprice),
  MIN(listprice),
  AVG(listprice)
FROM product
GROUP BY class
ORDER BY class;
```

7. Update the previous query to only include products that have a `listprice` of more than $200 in the aggregates.

```sql
SELECT 
  class,
  max(listprice),
  min(listprice),
  AVG(listprice)
FROM product
WHERE listprice > 200 -- note: we use where NOT having for this. Filter before grouping!
GROUP BY class
ORDER BY class;
```