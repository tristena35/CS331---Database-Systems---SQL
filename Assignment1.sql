USE Northwinds2019TSQLV5;
Go

-- 1
-- 1-1
-- Write a query that generates 5 copies out of each employee row
-- Tables involved: TSQLV4 database, Employees and Nums tables

-- Proposition: There are 5 copies that exist of the same employee

SELECT HRE.EmployeeID, HRE.EmployeeFirstName, HRE.EmployeeLastName, dbo.[Nums].N
FROM HumanResources.[Employee] AS HRE
CROSS JOIN Nums WHERE dbo.[Nums].N <= 5
ORDER BY N, HRE.EmployeeID;



-- 1-2 (Optional, Advanced)
-- Write a query that returns a row for each employee and day 
-- in the range June 12, 2016 – June 16 2016.
-- Tables involved: TSQLV4 database, Employees and Nums tables


SELECT HRE.EmployeeID, DATEADD(Day, N - 1, '20160612') AS DATE
FROM HumanResources.[Employee] AS HRE CROSS JOIN Nums
WHERE Nums.N <= DATEDIFF(Day, '20160612', '20160616') + 1
ORDER BY HRE.EmployeeID, Date;





-- 2
-- Explain what’s wrong in the following query and provide a correct alternative
/*
When the Select statement is being used, the table name is incorrect causing the query not to run.
Also, the code never refers to customers as the alias given, C.
*/
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O
ON Customers.custid = Orders.custid;
--Correct QUERY Below--
SELECT C.customerid, C.customercompanyname, O.orderid, O.orderdate
FROM Sales.[Customer] AS C
INNER JOIN Sales.[Order] AS O
ON C.customerid = O.customerid;

