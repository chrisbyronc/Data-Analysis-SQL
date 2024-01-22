# Solution: operators

1. Select the full names of the people from `contact` whose last name is longer than 10 characters.

```sql
SELECT 
  CONCAT_WS(' ', title, firstname, middlename, lastname, suffix) AS fullname,
  lastname, -- The writeup didn't ask for these, but it helps verify the results.
  length(lastname) 
FROM contact
WHERE length(lastname) > 10;
```

2. Select the `orderqty`, and `scrappedqty` from `workorder` and also compute the percent of the total order that was scarped for each order. 

```sql
SELECT
  orderqty,
  scrappedqty,
  CAST(scrappedqty AS float) / orderqty AS scrapped_precent
FROM workorder;
```

3. Using the `-` operator, expand your answer from number 2 to include the number of days that elapsed between `startdate` and `enddate`.

```sql
SELECT
  orderqty,
  scrappedqty,
  CAST(scrappedqty AS float) / orderqty AS scrapped_precent,
  enddate-startdate AS time_to_process
FROM workorder;
```

4. For every entry in the `address` table compute the full mailing address, including proper line breaks for each section of the address. 

This might be harder than it seems at first...

Hint 1: in MySQL you can use `CHAR(13)` to represent a linebreak in a string. 

Hint 2: the coalesce function might help as well: [https://www.w3schools.com/Sql/func_mysql_coalesce.asp](https://www.w3schools.com/Sql/func_mysql_coalesce.asp)

Hint 3: You need to use a join, because some of the information you need is in the `stateprovince` table, and some more is in the `countryregion` table. Use joins!

```sql
SELECT
CONCAT_WS(CHAR(13),
    CONCAT_WS(' ', p.title, p.firstname, p.middlename, p.lastname, p.suffix),
    a.addressline1,
    a.addressline2,
    CONCAT_WS(' ', a.city || ',', sp.stateprovincecode, a.postalcode),
    cr.name
) AS "Full Address",
at.name
FROM contact AS p
JOIN vendorcontact AS vc
JOIN vendoraddress bea ON bea.vendorid = vc.vendorid
JOIN address a ON bea.addressid = a.addressid
JOIN stateprovince sp ON sp.stateprovinceid = a.stateprovinceid
JOIN countryregion cr ON cr.countryregioncode = sp.countryregioncode
JOIN addresstype at ON at.addresstypeid = bea.addresstypeid;

```
