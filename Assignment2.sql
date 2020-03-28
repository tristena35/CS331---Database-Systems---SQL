USE Northwinds2019TSQLV5;
GO

-- 1
-- Explain the difference between the UNION ALL and UNION operators
-- In what cases are they equivalent?
-- When they are equivalent, which one should you use?

/*

	UNION ALL - Union All is different from Union in the sense that all duplicates are disregarded.
				In addition to that, rows are not compared and all rows from both sets are added.

	UNION - Union may result in duplicates, and there are also unique values found. The main difference
			is that this returns a true set rather than a multi set.

	There are cases in where they are equivalent, which is where there are no duplicates when using UNION, and 
	when they are equivalent, you should use UNION ALL since SQL will check for duplicates.

*/

-- 2
-- Write a query that generates a virtual auxiliary table of 10 numbers
-- in the range 1 through 10
-- Tables involved: no table

-- Proposition: There is a table with numbers 1 through 10

SELECT 1 AS n
UNION
SELECT 2
UNION
SELECT 3
UNION
SELECT 4
UNION
SELECT 5
UNION
SELECT 6
UNION
SELECT 7
UNION
SELECT 8
UNION
SELECT 9
UNION
SELECT 10;




-- 3
-- Write a query that returns customer and employee pairs 
-- that had order activity in January 2016 but not in February 2016
-- Tables involved: TSQLV4 database, Orders table

-- Proposition: There are customers and employees who have ordered in January but not in February 2016

SELECT CustomerID, EmployeeID
FROM Sales.[Order] WHERE OrderDate >= '20160101' AND OrderDate < '20160201'
EXCEPT
SELECT CustomerID, EmployeeID
FROM Sales.[Order]
WHERE OrderDate >= '20160201' AND OrderDate < '20160301';




-- 4
-- Write a query that returns customer and employee pairs 
-- that had order activity in both January 2016 and February 2016
-- Tables involved: TSQLV4 database, Orders table

-- Proposition: There are customers and employees that had ordered in both January and February 2016

SELECT CustomerID, EmployeeID FROM Sales.[Order]
WHERE OrderDate >= '20160101' AND OrderDate < '20160201'
INTERSECT 
SELECT CustomerID, EmployeeID
FROM Sales.[Order]
WHERE OrderDate >= '20160201' AND OrderDate < '20160301';




-- 5
-- Write a query that returns customer and employee pairs 
-- that had order activity in both January 2016 and February 2016
-- but not in 2015
-- Tables involved: TSQLV4 database, Orders table

--Proposition: There are customers and employees that both ordered in Jan and Feb 2016, but not in 2015

(SELECT CustomerID, EmployeeID FROM Sales.[Order]
WHERE OrderDate >= '20160101' AND OrderDate < '20160201'
INTERSECT 
SELECT CustomerID, EmployeeID
FROM Sales.[Order]
WHERE OrderDate >= '20160201' AND OrderDate < '20160301')
EXCEPT
--Make sure to except all the dates in 2015
SELECT CustomerID, EmployeeID
FROM Sales.[Order]
WHERE OrderDate >= '20150101' AND OrderDate < '20160101';




