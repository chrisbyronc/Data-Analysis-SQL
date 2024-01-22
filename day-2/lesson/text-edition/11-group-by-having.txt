/*

* The purpose of group by is to compute aggregates over a set of rows that all share a value in one or more column. 

* Some examples of the available aggregates are:
    * min,
    * max,
    * count,
    * sum,
    * average
    * More: https://dev.mysql.com/doc/refman/8.0/en/numeric-functions.html

* Demonstrate with this query:
*/

SELECT 
  customerid,
  COUNT(1) AS number_of_purchases,
  SUM(totaldue) AS total_spent,
  AVG(totaldue) AS avg_purchase_amount,
  MIN(totaldue) AS smallest_purchase,
  MAX(totaldue) AS largest_purchase
FROM 
  salesorderheader
GROUP BY
  customerid
ORDER BY
  number_of_purchases DESC,
  total_spent DESC,
  avg_purchase_amount DESC;

/*
* Notes:
    * `count(1)` count increments for any non-null value, but we're aggregating a non-null field (every entry in salesorderheader represents an actual sale, so we want to increment for EVERY record). So count(1) saves a small amount of computation. count(totaldue) would return the same results (and you can prove this by changing the query!)
    * order by the aliase doesn't work in all versions of SQL (or even all versions of MySQL). We must repeat the aggregates in older versions.

* We can also:
    * limit records prior to the grouping, using `where`
    * limit records after the grouping, using `having`
    
* So, what's different about how this query will be processed?
*/

SELECT 
  customerid,
  COUNT(1) AS number_of_purchases,
  SUM(totaldue) AS total_spent,
  AVG(totaldue) AS avg_purchase_amount,
  MIN(totaldue) AS smallest_purchase,
  MAX(totaldue) AS largest_purchase
FROM 
  salesorderheader
WHERE
  totaldue > 100
GROUP BY
  customerid
HAVING 
  COUNT(1) > 5 -- note: cannot use aliase in having or where
ORDER BY
  number_of_purchases DESC,
  total_spent DESC,
  avg_purchase_amount DESC;

/*
* Notes:
    * The `where` prevents us from considering any purchases of less than $100 BEFORE we compute the aggregates, which is why the largest "number of purchases" is smaller.
    * The `having` filters rows after the aggregates, meaning our report doesn't include any records for customers who have made fewer than 5 purchases. 

* Group by plays nice with join. All the joins happen before the `group by` is processed.

*/