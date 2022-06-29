-- Capstone Projects 

-- Question 1, What are the main DB tables where Sales information is stored and what relationships do these tables have 
-- Main DB Tables are SalesOrderHeader and SalesOrderDetail 
-- SalesOrderHeader VS Sales.SaleOrderDetail  ONE TO MANY
--- SalesOrderHeader relationship with SalesOrderDetail: ONE SalesOrderHeader entry can be associated with multiple entries of SalesOrderDetail 
SELECT  *
FROM Sales.SalesOrderDetail

SELECT *
FROM Sales.SalesOrderHeader

-- 2.	What are the main DB tables where Purchasing Information is stored and what relationships do these tables have?
-- Purchasing.PurchaseOrderHeader VS Purchasing.PurchaseOrderDetail: ONE TO MANY 
-- One PurchaseOrderHeader enntry can be associated with multiple entries of Purchasing.PurchaseOrderDetail 

SELECT *
FROM Purchasing.PurchaseOrderDetail

SELECT *
FROM Purchasing.PurchaseOrderHeader

-- How many Employees does the company have? 290

SELECT Count(LoginID) AS Num_Employees
FROM HumanResources.Employee

-- Report2, The name of the Most Sold Product for the year 2014.
-- Table Hint: Sales.SalesOrderDetail, Sales.SalesOrderHeader, Production.Product , COUNT, JOIN and GROUP BY
-- OrderQTY, ProductID AND SALESORDERID 
SELECT *
FROM Sales.SalesOrderDetail

-- OrderDate AND SALESORDERID 
SELECT * 
FROM Sales.SalesOrderHeader

-- Name AND ProductID 
SELECT  *
FROM Production.Product 



-- jOIN THREE TABLES to include OrderQty, Name and OrderDate -WaterBottle 
SELECT  COUNT(OrderQty) AS Max_Order, Name
FROM Sales.SalesOrderDetail AS ssod 
JOIN Production.Product AS pp 
ON ssod.ProductID = pp.ProductID
JOIN Sales.SalesOrderHeader AS ssoh 
ON ssoh.SalesOrderID = ssod.SalesOrderID 
WHERE YEAR(OrderDate) = 2014 
GROUP BY Name 
HAVING COUNT(OrderQTY) > 2000



-- Report 3: How much sales did the company make in 2014 that were attributed to any Sales Rep? Sales.SalesOrderHeader 
-- Hint: Sum, Group by, Year, Null 

SELECT  SUM(TotalDue) as Total_Sales
FROM Sales.SalesOrderHeader 
WHERE YEAR(OrderDate) = 2014 and SalesPersonID IS NOT NULL 


-- Report 4: Provide a Report of the Total sales per Month from 2011 to 2014 
-- Sales.SalesOrderHeader , SUM, GROUP BY, YEAR


SELECT YEAR(OrderDate)as Year, MONTH(OrderDate) AS Month, SUM(TotalDue) AS Total
FROM Sales.SalesOrderHeader 
GROUP BY MONTH(OrderDate), YEAR(OrderDate)
ORDER BY Year, Month ASC


-- Report 5: Categorise sales Transactions for the year 2013, for Sales below 500 mark as Low, 
-- for sales between 500 and 2000 Mark as Medium and for sales Above 2000 Mark as High, name the column Rating
-- Sales.SalesOrderHeader . CASE 

SELECT PurchaseOrderNumber, TotalDue, CASE 
WHEN TotalDue < 500 THEN 'LOW'
WHEN TotalDue BETWEEN 500 AND 2000 THEN 'MEDIUM'
ELSE 'HIGH'
END AS Ranking
FROM Sales.SalesOrderHeader 


-- Report6: List of salesPersons and the amount of sales they made for each year from 2011 to 2014
-- Add A Bar chart showing this information
-- Sales.SalesOrderHeader, HumanResources.Employee ; SUM, GROUP BY, YEAR, PIVOT, JOIN, CTE 

SELECT *
FROM HumanResources.Employee

SELECT * 
FROM Sales.SalesOrderHeader 

SELECT *
FROM Person.Person 

SELECT FirstName + ' '+ LastName AS Full_Name, SUM(TotalDue) AS Sub_Total_Due, YEAR(OrderDate) AS Yrs
FROM Person.Person AS pp2
JOIN HumanResources.Employee AS hre 
ON hre.BusinessEntityID = pp2.BusinessEntityID
JOIN Sales.SalesOrderHeader AS ssord 
ON ssord.SalesPersonID = hre.BusinessEntityID
GROUP BY FirstName + ' ' + LastName, YEAR(OrderDate)


SELECT DISTINCT YEAR(OrderDate)
FROM Sales.SalesOrderHeader

SELECT DISTINCT *
FROM Sales.SalesOrderHeader

-- Create temporary derived table 
WITH Annual_Report AS (
    SELECT FirstName + ' '+ LastName AS Full_Name, SUM(TotalDue) AS Sub_Total_Due, YEAR(OrderDate) AS Yrs
    FROM Person.Person AS pp2
    JOIN HumanResources.Employee AS hre 
    ON hre.BusinessEntityID = pp2.BusinessEntityID
    JOIN Sales.SalesOrderHeader AS ssord 
    ON ssord.SalesPersonID = hre.BusinessEntityID
    GROUP BY FirstName + ' ' + LastName, YEAR(OrderDate)

)

--SELECT * FROM Annual_Report

-- Apply Pivot Operator 
SELECT *
FROM Annual_Report
PIVOT(
    SUM(Sub_Total_Due) FOR Yrs  IN ([2011], [2012], [2013], [2014])
) AS F 





