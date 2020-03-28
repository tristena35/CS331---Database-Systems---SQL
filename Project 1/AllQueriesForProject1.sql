/*
Tristen Aguilar
CS331 Project 1 
SQL Query File
*/


USE Northwinds2019TSQLV5;
GO







--------------------EASY SECTION (5)-------------------






----------(WORST BASIC)----------
/*1*/
--Proposition:There are Customers that placed orders on Feb 2nd, 2016
/*
Explanation: The reason I picked this to be within the top 3 worst is because besides from the fact that its retrieving
			 information from customers that placed orders before Feb 2nd, 2016, in a business aspect it is not very useful.
			 One slight improvement I could've made to this query is to check the top spending Customers and where the
			 bulk of purchases are coming from.
*/
SELECT 
	C.CustomerID,
	C.CustomerCompanyName,
	C.CustomerCountry,
	O.OrderDate,
	O.EmployeeID
FROM Sales.[Order] AS O
INNER JOIN Sales.Customer AS C
ON O.CustomerID = C.CustomerID
AND O.OrderDate = '20160202';
--FOR JSON PATH, ROOT('Customers 02/02/2016');


/* How to approach this query:
		The Query above is asking you to find all of the Customers that have placed
		orders on the date Feb 2nd, 2016. First, you must identify which tables you
		need to use. For this question, you would need to use the Customer Table in order
		to return all of the customers information as well as the Orders table to receive
		date in which the customer has placed the order. Finally, make sure to check for
		results where the customerID's match and make sure the order date is Feb 2nd, 2016.
*/


/*2*/
--Proposition: Return all order details for orders placed between April and May of 2016 that shipped to Madrid

SELECT
	O.OrderID,
	O.CustomerID,
	O.OrderDate,
	O.RequiredDate,
	OD.ProductID,
	OD.UnitPrice,
	OD.Quantity
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
ON OD.OrderID = O.OrderID
AND (O.OrderDate >= '20160401' AND O.OrderDate < '20160601')
AND ShipToCity = 'Madrid'
FOR JSON PATH, ROOT('Orders - April and May 2016');

/* How to approach this query:
		The Query above is asking you to find all order details placed Between April and May of 2016
		that were shipped to Madrid, Spain. Since you are concerned with finding the Order Details, that 
		will be one of the tables we use. In addition to that, we also need to use the Orders table since
		we need to look at all of the dates that orders were placed. Then, once we have linked the two tables
		together based on the OrderID, we must check for 2 conditions; First being that the order was placed
		between April and May, and secondly that the order was shipped to Madrid.
*/


/*3*/
--Proposition: Return the Shipper Company Name and Required date for all orders that were required to be shipped on Jan 1st, 2016

SELECT 
	S.ShipperCompanyName,
	O.RequiredDate
FROM Sales.Shipper AS S
INNER JOIN Sales.[Order] AS O
ON S.ShipperID = O.ShipperID AND O.RequiredDate = '20160101'
FOR JSON PATH, ROOT('Shipper Information');

/* How to approach this query:
		The Query above is asking you to find all Shipper Company Names that possessed Required Shipping Dates on 
		January 1st, 2016. First, you must use both the Shipper table since it is the only table that contains
		the names of the shipping companies. Secondly, you must use the Order table which has the ShipperID
		attribute to link with the shipper table, and it also contains the Required Date. Then, you must 
		return the Shipping Company Name where the Date Required matches Jan 1st, 2016.
*/


/*4*/
--Proposition: Return the number of products that were discontinued with a Unit Price greater than 50 dollars

SELECT 
	COUNT(Discontinued) AS NumberOfDiscontinuedProducts
FROM Production.Product AS P
INNER JOIN Sales.OrderDetail AS OD 
ON P.ProductID = OD.ProductID 
AND P.Discontinued = 1 
AND OD.UnitPrice > 50
FOR JSON PATH, ROOT('Greater than 50 Discounted');

/* How to approach this query:
		The Query above is asking you to return all products that were discontinued where the price of the
		item was greater than 50 dollars. For this query, is it necessary to first reference the Production
		Product table since that table contains the information as to whether or not the item has been discontinued.
		Next, we need to also use the Order Detail table because that table will have the Unit Prices for all of
		the products. Once you have joined both tables using an inner join, you will have to do a quick check to
		see which products have been discontinued by using the boolean value of true, '1'. After that, you need to
		check if the Unit Price is greater than 50.
*/

----------(TOP BASIC)----------
/*5*/ --Using AdventureWorks2014--
USE AdventureWorks2014;
GO
--Proposition: Return all the Design Engineers that are Females and their Pay Rates
/*
Explanation: I found this one to be my most interesting basic query. In my opinion, it is relevant in the sense of a company
			 overlooking its staff, and in the case, all of the female design engineers. Possibly, this could be used by to
			 find which engineer deserves a raise.
*/

SELECT E.JobTitle, E.Gender, PH.Rate FROM HumanResources.Employee AS E
INNER JOIN HumanResources.EmployeePayHistory AS PH
ON E.BusinessEntityID = PH.BusinessEntityID 
AND E.Gender = 'F'
AND E.JobTitle = 'Design Engineer'
FOR JSON PATH, ROOT('Female Design Engineers');

/* How to approach this query:
		The Query above is asking you to return all Female Design Engineers and their pay rates. For this problem,
		you have to use two tables, first being the Human Resources Employee Table. You need to use this table in 
		order to check to see which employees are Females. Also, you need this table to check to see if the employees
		job title is a Design Engineer. Next, you need to use the Employee Pay History Table to connect to the Employee
		table where the BusinessEntityID's are equal.
*/






--------------------MEDIUM SECTION (8)-------------------






/*6*/ --USING NORTHWINDS--
USE Northwinds2019TSQLV5;
GO
--Proposition: Return all of the Products that have a Unit Price greater than the average price of all products and their Category Description. 
--In addition to that, Group them by their Unit Price and provide the number of Supplier Company Name's.
DECLARE @PriceAVG int;
SET @PriceAVG = (SELECT AVG(UnitPrice) FROM Production.Product);

SELECT P.UnitPrice, MAX(C.[Description]) AS ProductDescription, COUNT(S.SupplierCompanyName) AS NumberOfSuppliers
FROM Production.Category AS C
INNER JOIN Production.Product AS P ON C.CategoryID = P.CategoryID 
INNER JOIN Production.Supplier AS S ON P.SupplierID = S.SupplierID
WHERE P.UnitPrice > @PriceAVG
GROUP BY P.UnitPrice
FOR JSON PATH, ROOT('High Price Products');

/* How to approach this query:
		The Query above is asking you to return all queries where the average of all the products is less than the specific
		product price. Then, once you have retreived all products, return their description. Also, you need to return the number
		of suppliers that provide that certain product and finally group them by their unit Price. To start, we must use 
		the Product Category class in order to retrieve the Product Description. Then, we have to use the Production.Product table
		in order to get the price of each product. Lastly, we use the Production Supplier table since we know that table contains
		contains the details on the supplier company's name. After we link all of the tables, we check that all final queries
		include products with unit prices greater than the average price of all products. At last, group the information 
		by the unit price.
*/


/*7*/
--Proposition: Return the number of customers in each country that received an order between May and August of 2016
--and order the results by country

SELECT C.CustomerCountry, COUNT(O.RequiredDate) AS NumberOfCustomersThatReceived
FROM Sales.Customer AS C
INNER JOIN Sales.[Order] AS O
ON C.CustomerID = O.CustomerID
WHERE O.RequiredDate >= '20160501' AND O.RequiredDate < '20160901'
GROUP BY C.CustomerCountry
ORDER BY C.CustomerCountry
FOR JSON PATH, ROOT('Countries Shipped To');

/* How to approach this query:
		The Query above is asking for you to return the number of customers that received an order that they made 
		between the dates of May and August of the year 2016. It then also asks you to return them in order of the
		country in which of the customers live in. First, we must use both the Sales.Customer table along with the 
		Sales.Order table since they both have information on when the order was placed and where the customer lives.
		Then, once you have joined the table based upon the equivalence of their CustomerID's, you will then check 
		to see if the RequiredDate is between the respected range and finally you will order and group the information
		based on the customer's country.
*/


----------(WORST MEDIUM)----------
/*8*/
--Proposition: Return all the number of Orders that were placed on the same day as the employee's birthday that was in charge of the order
/*
Explanation: The reason I picked this to be within the top 3 worst is because it is not business related. Honestly,
			 this was just a query I wanted to have fun with and I do not believe that there are any business motives 
			 behind it. To improve it, instead I could've checked if maybe it was the Customer's birthday to see if maybe
			 there was a discount that applied.
*/
SELECT E.BirthDate, MAX(O.OrderDate) AS CustomerOrderDate, COUNT(O.OrderID) AS NumberOfOrders 
FROM HumanResources.Employee AS E
INNER JOIN Sales.[Order] AS O
ON E.EmployeeID = O.EmployeeID
WHERE MONTH(E.BirthDate) = MONTH(O.OrderDate) AND DAY(E.BirthDate) = DAY(O.OrderDate)
GROUP BY E.BirthDate
ORDER BY E.BirthDate
FOR JSON PATH, ROOT('Special Day');

/* How to approach this query:
		The Query above is asking for you to return the number of orders that were placed on the specific employee's
		birthday in which matched the order date. To start, we will first call upon the Human Resources Employee table since we need to
		know the date of the employee's birth date. Then, once we have received that, we will call upon the Ordes
		table where we will match the EmployeeID to the Employee table. Once the tables are linked, we will then
		check to see where the Month and Day of the Order Date and the Birth Date of the Employee and Order both
		match. If they do, that means that the customer placed the order on the same exact day of the Employee Birth
		Date. Then, we will simply Group and Sort the information according to the Employee's Birth Date.
*/


/*9*/--Using AdventureWorks2014
--Proposition: Return the number of employees in groups that either started their shifts at 7am or 3pm. In addition to that,
--indicate whether the shift is a Morning, Day, or Evening Shift
USE AdventureWorks2014;
GO

SELECT S.StartTime, COUNT(EDH.BusinessEntityID) AS NumberOfEmployees, MAX(S.Name) AS ShiftName
FROM HumanResources.EmployeeDepartmentHistory AS EDH
INNER JOIN HumanResources.[Shift] AS S
ON EDH.ShiftID = S.ShiftID
WHERE S.StartTime = '07:00:00' OR S.StartTime = '15:00:00'
GROUP BY S.StartTime
ORDER BY S.StartTime
FOR JSON PATH, ROOT('Shift Times');

/* How to approach this query:
		The Query above is asking for you to return the number of employees that work at a certain time of the day,
		in this case 7am and 3pm. Also, indicate whether the shift is a morning, day or evening shift. First, we will
		evaluate the EmployeeDepartmentHistory table since this table is responsible for linking the specific employees
		with their according shifts. Then, we must use the Shift table which is responsible for providing us with the
		name and start time of the shift. Once we link them based on their ShiftID's, we can then compare to see which queries
		will return to us the start time of either 7am or 3pm. Once we have found our results, we will group the results
		by the shift start time.
*/


/*10*/
--Proposition: Return all products with their name, ID, price and cost that are above 100 dollars and have been sold for more than 6 months

USE AdventureWorks2014;
GO

SELECT 
	PM.Name, 
	MAX(PM.ProductModelID) AS ProductModelNumber, 
	AVG(P.ListPrice) AS AverageListPrice, 
	MAX(P.StandardCost) AS CostOfMakingProduct
FROM Production.Product AS P
INNER JOIN Production.ProductModel AS PM
ON P.ProductModelID = PM.ProductModelID
WHERE P.ListPrice > 100 AND DATEDIFF(Month, P.SellStartDate, P.SellEndDate) > 6
GROUP BY PM.Name
ORDER BY PM.Name
FOR JSON PATH, ROOT('6 Month Product Line');

/* How to approach this query:
		The Query above is asking for you to find all products that cost more than 100 dollars and to return the name of the product,
		ID, price and cost. First, you have to use the Production Product table in order to pull the List Price and Standard Cost.
		Once you have done that, in order to project these attributes, we will use the MAX function on the Product Model ID since
		the same product has the same ID and we will use an AVG function for the List Price so that we get the price that it has been
		given along all its models. In addition to that, we use the MAX function to get the highest cost that it may take to produce a
		certain product. Once you have done all of that, you will need to join the Product Model table as well in order to retrieve the
		Model ID as well as the Model Name. At this point, the only thing we need to check for 2 conditions: First, we check if the
		list price of the item is greater than 100 dollars. Then, we check to see if the period between the time the product started
		selling and stopped selling is over 6 months. Lastly, order them by the Product Models Name.
*/


/*11*/
--Proposition: Return the amount of businesses that use a vista credit card type
USE AdventureWorks2014;
GO
SELECT C.CardType, COUNT(PCC.BusinessEntityID) AS NumberOfUsingBusinesses FROM Sales.PersonCreditCard AS PCC
INNER JOIN Sales.CreditCard AS C
ON C.CreditCardID = PCC.CreditCardID
WHERE C.CardType = 'Vista'
GROUP BY C.CardType
ORDER BY C.CardType
FOR JSON PATH, ROOT('Vista Card For Businesses');

/* How to approach this query:
		The Query above is asking for you to return the number of businesses that use each type of Credit Card. In order
		to do this, we need to first pull information from the Credit Card Table since this will provide us with
		the Credit Card Type. In addition to that, we will also need to use the Person Credit Credit table to get
		the BusinessEntityID which will provide us with the businesses that have allowed the person to purchase from them.
		Therefore, once we have joined the two tables based on their CreditCardID's, we will now just need to check and
		see which CreditCards had a type of 'Vista', which will lead to our desired results.
*/


----------(TOP MEDIUM)----------
/*12*/
--Proposition: Return all products that were on a discount of more than 10% that did no end their special offer until before 2013 and were
--more expensive than 200 dollars
/*
Explanation: I found this one to be my most interesting medium query. Although this query is specific, variations of the query
itself may be useful. This query was mainly used to find all products that were doing relatively well before the end of the year
2013, and could be varied to find specific products during different time periods.
*/
USE AdventureWorks2014;
GO
SELECT 
	SO.DiscountPct, 
	MAX(SO.EndDate) EndOfDiscountDate, 
	COUNT(P.[Name]) AS NumberOfProductsUnderDiscount, 
	AVG(P.ListPrice) AS AveragePriceForTheseProducts 
FROM Sales.SpecialOfferProduct AS SOP
INNER JOIN Sales.SpecialOffer AS SO
	ON SOP.SpecialOfferID = SO.SpecialOfferID
INNER JOIN Production.Product AS P
	ON SOP.ProductID = P.ProductID
WHERE SO.DiscountPct > 0.10
AND SO.EndDate >= '20130101' AND P.ListPrice > 200
GROUP BY SO.DiscountPct
ORDER BY SO.DiscountPct
FOR JSON PATH, ROOT('Discounts on Expensive Items');


/* How to approach this query:
		The Query above is asking for you to find and return all products that were on a discount of more than 10% and lasted longer
		than the year 2013. Also, you were to make sure that the product cost more than 200 dollars. First, we start with projecting
		the specific attributes(columns) that we desire: DiscountPct, EndDate, ProductName, and list price of the product itself. In
		order to do this, we must start by analyzing the specific tables that we are going to need to use. First, we can see that we
		are going to need the Special Offer table to find the discount percentage on each of the products as well as the day the
		discount ends. Secondly, we must use the Special Offer Product table in order to link the Product table to the Special Offer
		table. Just mentioned, we must also use the Product table in order to find the number of products under the specific discount
		as well as the List Price. Once you have joined all tables based on their according keys, we must make sure to check for
		3 different conditions: First being that the discount percentage is more than 10%, the end date is after 2013 and that the list
		price is greater than 200 dollars. Finally, organized the query by grouping and ordering by the discount percentage.
*/


/*13*/
--Proposition: Return the total number of orders that were shipped to each of the Territories where the subtotal of the order was over 20,000

SELECT 
	ST.[Name],
	COUNT(SOH.SalesOrderID) AS NumberOfOrders,
	AVG(SOH.SubTotal) AS SubTotalOfOrder 
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesTerritory AS ST
ON SOH.TerritoryID = ST.TerritoryID
WHERE SOH.SubTotal > 20000
GROUP BY ST.[Name]
ORDER BY ST.[Name]
FOR JSON PATH, ROOT('Territories');

/* How to approach this query:
		The Query above is asking for you to return the number of orders that are to be shipped to each territory where the subtotal of
		the order is greater than 20000. Like always, we start by identifying which tables are going to be necessary in order to solve
		the query. For this case, we are definitely going to need to use the SalesOrderHeader table since that table holds information
		such as the SalesOrderId used to find total orders as well as the Subtotal of the order. Now, link the tables together by comparing
		their TerritoryID's. After that, check to see if the subtotal that you have retrieved from the SalesTerritory table is greater
		than 20,000 dollars. Once that is done, you may now order and group the information by the Territory name.
*/






--------------------COMPLEX SECTION (7)-------------------






/*CREATE FUNCTION [Sales.OrderDetail].getQuantityOrdered (@OrderID INT)
RETURNS INT 
AS
BEGIN
    DECLARE @quantity int
	SELECT @quantity = Quantity FROM Sales.OrderDetail
    RETURN 1
END
*/


----------(WORST COMPLEX)----------
/*14*/--Using NorthWinds--
USE Northwinds2019TSQLV5;
GO
--Proposition: Return the lowest spending 5 customers that either live in area 10038 or London that have purchased the lowest amount of product
--and placed their order before April 22nd, 2016
/*
Explanation: The reason I picked this to be within the top 3 worst is because of the specifications I added for the query.
			 This query could've possible been more practical if for some reason a company was trying to track a specific 
			 order that was shipped to this area around this time.
*/
--Query
SELECT TOP 5  
		C.CustomerID, 
		MAX(C.CustomerCity) AS CustomerCity,
		C.CustomerPostalCode,
		MAX([Sales].[getTotalPriceOfOrder](OD.Quantity, OD.UnitPrice)) AS TotalAmount, --Use function
		MAX(O.OrderDate) AS OrderDate
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
WHERE (C.CustomerPostalCode = '10038' OR C.CustomerCity = 'London') AND O.OrderDate < '20160422'
GROUP BY C.CustomerID, C.CustomerPostalCode
ORDER BY TotalAmount ASC
FOR JSON PATH, ROOT('Total Price');
--Function
ALTER FUNCTION [Sales].[getTotalPriceOfOrder](@Quantity INT, @UnitPrice FLOAT)
RETURNS DECIMAL(10,2)
BEGIN
	DECLARE @numberOfOrders DECIMAL(10,2)
	SET @numberOfOrders = (@Quantity * @UnitPrice)
	RETURN @numberOfOrders
END
GO



/* How to approach this query:
		The Query above is asking you to return the lowest 5 customers that either live in are 10038 
		or London that have purchased the lowest amount of product. First, we must connect the appropriate
		tables starting with the Sales.Order table. Also, we need to use the Sales.OrderDetails table since
		we can link it to the Order table based on the OrderID. Next we are also going to also need the Sales.Customer
		table since that table will provide use with the CustomerID. Once we have connected all tables, we 
		then need to check conditions to make sure that the information provides us where the CustomerCity is either = 
		London or the Postal Code 10038. Once the information is in ascending order, all you have to do is select the top 5.
*/


/*15*/
--Proposition: Return the highest spending 15 customers that either live in the USA or have a phone number that
--starts with 5 and placed their order before the new year of 2016

SELECT TOP 15  
		C.CustomerID, 
		MAX(C.CustomerCountry) AS CustomerCountry,
		MAX(C.CustomerPhoneNumber) AS CustomerPhoneNumber,
		MAX([Sales].[getTotalPriceOfOrder](OD.Quantity, OD.UnitPrice)) AS TotalAmount,
		MAX(O.OrderDate) AS OrderDate
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
WHERE (C.CustomerCountry = 'USA' OR SUBSTRING(C.CustomerPhoneNumber, 1, 2) = '(5') AND O.OrderDate < '20160101'
GROUP BY C.CustomerID, C.CustomerPostalCode
ORDER BY TotalAmount DESC
FOR JSON PATH, ROOT('TOP 15 Spending');
/*
ALTER FUNCTION [Sales].[getTotalPriceOfOrder](@Quantity INT, @UnitPrice DECIMAL)
RETURNS DECIMAL(10,2)
BEGIN
	DECLARE @numberOfOrders DECIMAL(10,2)
	SET @numberOfOrders = (@Quantity * @UnitPrice) 
	RETURN @numberOfOrders
END
GO
*/


/* How to approach this query:
		The Query above is asking you to return the highest spending 15 customers that either live in the USA or have a phone number that
		starts with 5 and placed their order before the new year of 2016. We know that the tables necessary to solve this query are the
		Sales.OrderDetails, Sales.Order and Sales.Customer tables. We know that because we need the CustomerID, Country and CustomerPhoneNumber
		from the Customer table, the Total amount which comes about from the OrderDetails Table. Lastly, we need the Order table in order
		to track the OrderDate. Once all of these tables have been connected, we then check for the specific conditions which are: The Customer
		Country is the USA or the first 2 characters of the Phone number starts witha '(5'. Finally, we also check to see if the OrderDate is 
		before the 2016 new year.
*/


/*16*/
--Proposition: Return the top 30 number of customers that placed an order with 20 or less days to be delivered. Also, project the discount rate at which
--these customers purchased at

SELECT TOP 30  
		COUNT(C.CustomerID) NumberOfCustomers, 
		(DATEDIFF(day, O.OrderDate, O.RequiredDate)) AS TimeOrderTook,
		MAX(O.OrderDate) AS OrderDate,
		MAX(O.RequiredDate) AS RequiredDate,
		MAX(OD.DiscountPercentage) AS Discount
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
WHERE DATEDIFF(day, O.OrderDate, O.RequiredDate) < 20
GROUP BY O.OrderDate, O.RequiredDate
ORDER BY Discount DESC
FOR JSON PATH, ROOT('Top 30 Customers');

/*
ALTER FUNCTION [Sales].[getTotalShipTime](@OrderDate DATE, @RequiredDate DATE)
RETURNS INT
BEGIN
	DECLARE @numberOfDays INT
	SET @numberOfDays = DATEDIFF(day, @OrderDate, @RequiredDate)
	RETURN @numberOfDays
END
GO
*/

/* How to approach this query:
		The Query above is asking you to return the top 30 number of customers that placed an order with 20 or less days to be delivered. 
		Also, project the discount rate at which these customers purchased at. To begin, we first have to see what tables we need to join.
		Since it is asking for the numebr of customers, we know we are going to need to utilize the CustomerID. Then, we also see that we need
		to know how many days are in between the day the order was placed it was required to ship. Lastly, we need to know the discount 
		percentage that were held under the order. Once we have linked all the tables based on their CustomerID's and OrderID's, we can know we 
		need to use the customer function created. When I created the function, I used the DATEDIFF Functions in order to find the number of days
		between both the Order date and the Required Date. After that, we must use the functions to see if it returns a number less than 20.
*/


/*17*/
--Proposition: Return the number of customers that either placed orders with high amounts of product, or the ones that placed orders with a low
--quantity. Make sure their order time was less than 2 months.

SELECT 
		COUNT(C.CustomerID) AS NumberOfCustomers, 
		OrderStatus = ([Sales].[isOrderAmountHigh](OD.Quantity)) -- Use function
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId	
WHERE DATEDIFF(month, O.OrderDate, O.RequiredDate) < 2 -- Use function
GROUP BY ([Sales].[isOrderAmountHigh](OD.Quantity))
ORDER BY NumberOfCustomers
FOR JSON PATH, ROOT('ORDER AMOUNT');

/*CREATE FUNCTION [Sales].[isOrderAmountHigh](@Quantity INT)
RETURNS nvarchar(10)
AS
BEGIN

    DECLARE @answer nvarchar(10)
    SET @answer= CASE 
					WHEN @Quantity > 10 THEN 'High Order Amount'
					ELSE 'Low Order Amount'

    END
    RETURN @answer
END;
GO*/

/* How to approach this query:
		The Query above is asking for you to return the number of customers that either placed high order amounts or low order amounts. In addition to that,
		make sure the order time for the given order was under 2 months. To start, we know we need to use the Sales.Customer table, Sales.Order table and finally
		then Sales.OrderDetails table. First, you must use the SQL COUNT function in order to receive the number of customers under each category. Then,
		we must use the function created for the specific problem whether to determine if the order quantity was large or small best on the quantity number.
		Lastly, once all the tables have been joined, you must use the function to check whether or not the two dates between ordered and required is at most
		2 months.
*/


/*18*/
--Proposition: Return all customers that have placed orders on now discontinued items and non-discontinued items, show the average discount
--for the products and make sure they were shipped to the USA.

SELECT
	P.Discontinued,
	COUNT(C.CustomerID) AS NumberOfCustomers, 
	AVG(OD.DiscountPercentage) AS Discount,
	MAX(C.CustomerCountry) AS CustomerCountry
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
INNER JOIN Production.Product AS P
	ON OD.ProductId = P.ProductId
WHERE [Sales].[livesInMatchingCountry](C.CustomerCountry,'USA') = 1
GROUP BY P.Discontinued
ORDER BY Discount DESC
FOR JSON PATH, ROOT('Matching Countries');

/*CREATE FUNCTION [Sales].[livesInMatchingCountry](@CustomerCountry NVARCHAR(20), @RequestedCountry NVARCHAR(20))
RETURNS INT
	AS
	BEGIN
		DECLARE @livesInTheCountry INT=
		CASE 
				WHEN @CustomerCountry = @RequestedCountry THEN 1 ELSE 0
		END
		RETURN @livesInTheCountry
END
GO*/


/* How to approach this query:
		The Query above is asking you to return all customers that have placed orders on now discontinued items and non discountinued items, show 
		the average discount for the products and make sure they were shipped to the USA. First step in doing this is deciding what tables we need
		to use in order to solve the queries. For this problem we need to use 4 tables: Sales.Order, Sales.OrderDetail, Sales.Customer and the
		Production.Product table. Once you have linked them upon their according keys, you will then need to use the function created in order to tell
		if the country that the user has decided to look for (in this case the USA) matches the data. Once you have used the function, group the 
		data in respect to what items have been discounted and which havent and use the AVG sql function in order to provide the average discount for 
		all products within the 2 categories.
*/


/*19*/
--Proposition: Return all customers placed orders on products that had prices greater than the average price of a product. On top of that, make sure the
--product was not yet discontinued and return the average price and order date is greater than 2015.

DECLARE @AvgPrice FLOAT;
SET @AvgPrice = (SELECT AVG(UnitPrice) FROM Production.Product);

SELECT
	P.Discontinued,
	COUNT(C.CustomerID) AS NumberOfCustomers, 
	AVG(P.UnitPrice) AS AveragePrice
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
INNER JOIN Production.Product AS P
	ON OD.ProductId = P.ProductId
WHERE [Sales].[productAboveAverage](OD.UnitPrice, @AvgPrice) = 1 -- Use function
AND P.Discontinued = 0
AND O.OrderDate > '20150101'
GROUP BY P.Discontinued
FOR JSON PATH, ROOT('Above Average Product');

/*CREATE FUNCTION [Sales].[productAboveAverage](@UnitPrice FLOAT, @AvgPrice FLOAT)
RETURNS FLOAT
	AS
	BEGIN
		DECLARE @AboveAverage INT
		SET @AboveAverage = 
			CASE 
				WHEN @UnitPrice > @AvgPrice THEN 1 ELSE 0
	END
RETURN @AboveAverage
END
GO*/


/* How to approach this query:
		The Query above is asking you to return all customers that placed orders on products that had prices greater than the average price of a product. On top of 
		that, make sure the product was not yet discontinued and return the average price and order date is greater than 2015. To start, we first have to join 4 tables:
		Sales.CustomerID, Sales.Order, Sales.OrderDetail and Production.Product. Then, you must create a variable that will keep track of what the average price for
		all products is. Once you have linked all tables according to their keys, you then check to see if the average price is less than the current price and after that
		you check to see if it has not been discontinued (value is 0). Lastly, check to see that the date is any time after the start of 2015.
*/


----------(TOP COMPLEX)----------
/*20*/
--Proposition: Return all customers that ordered products that where under the average price 
--of all products that live in Mexico and ordered their product any time after the year 2014 that came within 2 months.
/*
Explanation: This is my Top Complex query, and the reason I picked this one to be the top is because although it is not very
			 business related, it has multiple conditions that you can change in order to find specific queries. I did feel
			 that this was a good way to find products that were not doing as well. 
*/
DECLARE @AvgPrice FLOAT;
SET @AvgPrice = (SELECT AVG(UnitPrice) FROM Production.Product);

SELECT
	P.Discontinued,
	COUNT(C.CustomerID) AS NumberOfCustomers, 
	AVG(P.UnitPrice) AS AveragePrice,
	MAX(C.CustomerCountry) AS CustomerCountry
FROM Sales.OrderDetail AS OD
INNER JOIN Sales.[Order] AS O
	ON OD.OrderID = O.OrderID
INNER JOIN Sales.Customer AS C
	ON O.CustomerId = C.CustomerId
INNER JOIN Production.Product AS P
	ON OD.ProductId = P.ProductId
WHERE [Sales].[productAboveAverage](OD.UnitPrice, @AvgPrice) = 0
AND [Sales].[livesInMatchingCountry](C.CustomerCountry,'Mexico') = 1
AND O.OrderDate > '20140101'
AND DATEDIFF(month, O.OrderDate, O.RequiredDate) < 2
GROUP BY P.Discontinued;
FOR JSON PATH, ROOT('Customers Under Average in Mexico');

--Corresponding Function--
Use ALL FUNCTIONS


/* How to approach this query:
		The Query above is asking you to return all customers that ordered products that where under the average price of all products that live in Mexico and ordered
		their product any time after the year 2014 that came within 2 months. Like some of the previous, this query will require 4 tables: Sales.Customer,
		Sales.Order, Sales.OrderDetail and Production.Product. With this query, we will need to use multiple functions I have created in order to solve it. The
		functions we need to use are listed: [Sales].[productAboveAverage], [Sales].[livesInMatchingCountry], [Sales].[getTotalShipTime]. From the conditions provided,
		using all of these functions will give you the answer.
*/