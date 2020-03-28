
/*----------CHAPTER 4----------*/


USE Northwinds2019TSQLV5;
GO





-- 1 
-- Write a query that returns all orders placed on the last day of activity that can be found in the Orders table.
-- Tables involved: HR.Employees and Sales.Orders
-- Proposition: There is order data on the last day that orders were placed

SELECT 
		OrderID, 
		OrderDate, 
		CustomerID, 
		EmployeeID
FROM Sales.[Order]
WHERE OrderDate = (SELECT MAX(OrderDate) FROM Sales.[Order]); -- Subquery















-- 3
-- Write a query that returns employees who did not place orders on or after May 1, 2008
-- Tables involved: HR.Employees and Sales.Orders
-- Proposition: There are employees who did not place orders on or after May 1st, 2008

SELECT 
	EmployeeID, 
	EmployeeFirstName, 
	EmployeeLastName
FROM HumanResources.[Employee]
WHERE EmployeeId NOT IN (SELECT EmployeeId 
						 FROM Sales.[Order]
						 WHERE OrderDate >= '20160501'); --Could've solved without subquery by using <'20160501'











-- 4
-- Write a query that returns countries where there are customers but not employees
-- Tables involved: Sales.Customers and HR.Employees
-- Proposition: There exists countries were customers are and employees are not

SELECT DISTINCT 
		CustomerCountry
FROM Sales.[Customer]
WHERE CustomerCountry NOT IN (SELECT EmployeeCountry 
							  FROM HumanResources.Employee);










-- 5
-- Write a query that returns for each customer all orders placed on the customer’s last day of activity.
-- Tables involved: Sales.Orders
-- Proposition: For each customer, there are orders placed on the last day of activity

SELECT 
	 CustomerID, 
	 O.OrderID, 
	 O.OrderDate, 
	 EmployeeID
FROM Sales.[Order] AS O
WHERE OrderDate = (SELECT MAX(O2.OrderDate) -- get last day
				   FROM Sales.[Order] AS O2 
				   WHERE O2.CustomerID = O.CustomerID)
ORDER BY CustomerID;









-- 6
-- Write a query that returns customers who placed orders in 2007 but not in 2008.
-- Tables involved: Sales.Customers and Sales.Orders
-- Proposition: There are customers who have placed orders in 2007 but not in 2008.

SELECT 
	CustomerID,
	CustomerCompanyName
FROM 
	Sales.Customer AS C
WHERE EXISTS (SELECT *
			  FROM Sales.[Order] AS O
			  WHERE O.CustomerID = C.CustomerID
			  AND O.OrderDate >= '20150101'
			  AND O.OrderDate < '20160101')
			  AND NOT EXISTS (SELECT *
							  FROM Sales.[Order] AS O
							  WHERE O.CustomerID = C.CustomerID
							  AND O.OrderDate >= '20160101'
							  AND O.OrderDate < '20170101');













/*----------CHAPTER 5----------*/


-- 1-1
-- Write a query that returns the maximum value in the orderdate column for each employee.
-- Tables involved: TSQL2012 database, Sales.Orders table
-- Proposition: There exists a maximum value in the order date column for each employee


SELECT 
		EmployeeID, 
	    MAX(OrderDate) AS OrderDate
FROM Sales.[Order]
GROUP BY EmployeeID;










-- 1-2
-- Encapsulate the query from Exercise 1-1 in a derived table. Write a join query between the derived
-- table and the Orders table to return the orders with the maximum order date for each employee.
-- Tables involved: Sales.Orders
-- Proposition: Combining both the derived table and the orders table will return the orders with the maximum order date for each employee



SELECT O.EmployeeID, O.OrderDate, O.OrderID, O.CustomerID
FROM Sales.[Order] AS O
INNER JOIN (SELECT EmployeeID, 
				   MAX(OrderDate) AS OrderDate
			FROM Sales.[Order]
			GROUP BY EmployeeID) AS D
ON O.EmployeeID = D.EmployeeID
AND O.OrderDate = D.OrderDate;










-- 2-1
-- Write a query that calculates a row number for each order based on orderdate, orderid ordering.
-- Tables involved: Sales.Orders
-- Proposition: There exists a query that calculates a row number for each order



SELECT 
	OrderID, 
	OrderDate, 
	CustomerID, 
	EmployeeID,
    ROW_NUMBER() OVER(ORDER BY OrderDate) AS RowNumber
FROM Sales.[Order];










-- 2-2
-- Write a query that returns rows with row numbers 11 through 20 based on the row number definition
-- in Exercise 2-1. Use a CTE to encapsulate the code from Exercise 2-1.
-- Tables involved: Sales.Orders
-- Proposition: Using the table above, there exists the same information that starts with row 11 through row 20


WITH MyQuery AS
(SELECT 
	OrderID,
	OrderDate, 
	CustomerID, 
	EmployeeID,
    ROW_NUMBER() OVER(ORDER BY OrderDate) AS RowNumber
 FROM Sales.[Order])
SELECT * FROM MyQuery WHERE RowNumber BETWEEN 11 AND 20;











-- 4-1
-- Create a view that returns the total quantity for each employee and year.
-- Tables involved: Sales.Orders and Sales.OrderDetails
-- Proposition: There exists a view that returns the total quantity for each employee and year


IF OBJECT_ID('Sales.CreatedView') IS NOT NULL
DROP VIEW Sales.CreatedView;
GO

CREATE VIEW Sales.CreatedView
AS
SELECT
	EmployeeID,
    YEAR(OrderDate) AS YearOfOrder,
    SUM(Quantity) AS totalQuantity
FROM Sales.[Order] AS O
INNER JOIN Sales.OrderDetail AS OD
	ON O.OrderID = OD.OrderID
GROUP BY
	EmployeeID,
	YEAR(OrderDate);
GO









-- 5-1
/*
Create an inline function that accepts as inputs a supplier ID (@supid AS INT) and a requested number of products (@n AS INT). 
The function should return @n products with the highest unit prices that are supplied by the specified supplier ID.
*/
-- Tables involved: Production.Products
-- Proposition: There is an inline function that acceps a supplierID and requested number which returns a query with according values


IF OBJECT_ID('Production.getTopProducts') IS NOT NULL
DROP FUNCTION Production.getTopProducts;
GO

CREATE FUNCTION Production.getTopProducts (@SupplierID AS INT, @Number AS INT)
RETURNS TABLE
AS
RETURN
	SELECT TOP (@Number) 
			P.ProductID, 
			P.ProductName, 
			P.UnitPrice
	FROM Production.Product AS P
	WHERE SupplierId = @SupplierID
	ORDER BY UnitPrice DESC;
GO










-- 5-2
--Using the CROSS APPLY operator and the function you created in Exercise 4-1, return, for each supplier, the two most expensive products.
-- Proposition: There is a query for each supplier that can be displayed using the above function



SELECT 
	PS.SupplierID, 
	PS.SupplierCompanyName, 
	P.ProductID, 
	P.ProductName,
	P.UnitPrice
FROM Production.Supplier AS PS
CROSS APPLY Production.getTopProducts(PS.SupplierID, 2) AS P; -- Use previous function