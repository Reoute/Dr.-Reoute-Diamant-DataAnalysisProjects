--Reoute Diamant Project2--
--Q1--

SELECT ProductID, Name, Color, ListPrice, Size
FROM Production.Product
WHERE ProductID NOT IN (SELECT ProductID
                        FROM Sales.SalesOrderDetail )
ORDER BY ProductID


--Q2--

SELECT DISTINCT c.CustomerID, ISNULL (FirstName, 'Unknown') AS 'First Name',
       ISNULL (LastName, 'Unknown') AS 'Last Name'
FROM sales.Customer c LEFT JOIN person.Person p 
     ON c.CustomerID=p.BusinessEntityID
WHERE c.customerid NOT IN (SELECT s.CustomerID
                        FROM sales.SalesOrderHeader s)
ORDER BY CustomerID ASC

--Q3--

SELECT TOP 10 soh.customerid, p.FirstName, p.LastName, COUNT (soh.SalesOrderID) AS "Count of Orders"
FROM sales.SalesOrderHeader soh JOIN sales.Customer c 
	ON soh.CustomerID= c.CustomerID
	join person.person p ON c.PersonID=p.BusinessEntityID
GROUP BY  soh.customerid, p.FirstName, p.LastName
ORDER BY COUNT (soh.SalesOrderID) DESC


--Q4--

SELECT p.FirstName, p.LastName, e.JobTitle, e.HireDate, 
	  COUNT (JobTitle) OVER (PARTITION BY JobTitle) AS 'CountTitle' 
FROM HumanResources.Employee e JOIN person.person p 
	 ON e.businessEntityID= P.businessEntityID 
ORDER BY e.JobTitle

--Q5--

SELECT
    SalesOrderID,CustomerID,LastName,FirstName,LastOrder,PreviousOrder
FROM (
    SELECT SalesOrderID, CustomerID,FirstName,LastName,OrderDate AS LastOrder,
        LEAD(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS PreviousOrder,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RNK
    FROM (
        SELECT s.SalesOrderID,s.OrderDate,c.CustomerID,p.FirstName,p.LastName
        FROM Sales.SalesOrderHeader s JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
        JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
		) o
	 ) s
WHERE RNK = 1
ORDER BY LastName


--Q6--

SELECT [YEAR], SalesOrderID, LastName, FirstName, TOTAL
FROM (
	SELECT YEAR(s.OrderDate) AS YEAR,s.SalesOrderID,p.LastName, p.FirstName,
		SUM(d.UnitPrice * (1 - d.UnitPriceDiscount) * d.OrderQty) AS TOTALPRICE,
		DENSE_RANK() OVER (PARTITION BY YEAR(s.OrderDate) 
		ORDER BY SUM(d.UnitPrice * (1 - d.UnitPriceDiscount) * d.OrderQty) DESC) AS RNK,
		FORMAT(SUM(d.UnitPrice * (1 - d.UnitPriceDiscount) * d.OrderQty), '#,#.0') AS TOTAL
	FROM sales.SalesOrderDetail d JOIN Sales.SalesOrderHeader s 
		ON d.SalesOrderID=s.SalesOrderID
        JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
        JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
		GROUP BY YEAR (s.OrderDate), s.SalesOrderID, p.LastName, p.FirstName
		)s
WHERE RNK=1

--Q7--

SELECT Month, [2011], [2012], [2013], [2014]
FROM
    (SELECT MONTH (OrderDate) AS 'Month', YEAR (OrderDate) AS YY, SalesOrderID
	 FROM sales.SalesOrderHeader o JOIN Sales.Customer c ON o.CustomerID=c.CustomerID) tbl
	 pivot (COUNT (SalesOrderID) for YY in ([2011], [2012], [2013], [2014])) pvt
ORDER BY MONTH

--Q8--

WITH CTE1
AS
(	SELECT YEAR(OrderDate) AS [Year], MONTH(OrderDate) AS [Month], 
	FORMAT(SUM(d.UnitPrice* (1-d.UnitPriceDiscount)), '##.00') AS SumPrice
	FROM  sales.SalesOrderDetail d JOIN Sales.SalesOrderHeader s 
		ON d.SalesOrderID=s.SalesOrderID
	GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),

CTE2
AS
(	SELECT [Year], CAST([Month] AS varchar) AS [Month],   
	CAST (SumPrice AS NUMERIC (11,2)) AS SumPrice,
	CAST(SUM(CAST(SumPrice AS numeric(11, 2))) OVER (PARTITION BY [Year] ORDER BY [Month]) AS numeric(11, 2)) AS CumSum,
	ROW_NUMBER () OVER (PARTITION BY [Year] ORDER BY [Month])AS RN
	FROM CTE1
UNION
	SELECT YEAR (orderdate), 'Grand_total', null, CAST(SUM(UnitPrice* (1- UnitPriceDiscount)) AS numeric(11, 2)), 13
	FROM sales.SalesOrderDetail d JOIN Sales.SalesOrderHeader s 
		ON d.SalesOrderID=s.SalesOrderID
	GROUP BY YEAR (OrderDate)
)

SELECT [Year], [Month], SumPrice, CumSum
FROM CTE2
ORDER BY [YEAR], RN

--Q9--

WITH CTE 
AS 
(
	SELECT 
        d.Name AS 'DepartmentName', p.BusinessEntityID AS 'EmployeeID', CONCAT (p.FirstName,' ' , p.LastName) AS 'EmployeeFullName',
        e.HireDate AS 'HireDate', DATEDIFF(MONTH, e.HireDate, GETDATE()) AS 'Seniority',
        LEAD(p.FirstName + ' ' + p.LastName, 1) OVER (PARTITION BY d.Name ORDER BY e.HireDate DESC) AS PreviousEmpName,
        LEAD(e.HireDate, 1) OVER (PARTITION BY d.Name ORDER BY e.HireDate DESC) AS PreviousEmpHDate
    FROM 
        Person.Person p JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
        JOIN HumanResources.EmployeeDepartmentHistory ed ON e.BusinessEntityID = ed.BusinessEntityID
        JOIN HumanResources.Department d ON ed.DepartmentID = d.DepartmentID
)
SELECT DepartmentName, EmployeeID, EmployeeFullName, HireDate, Seniority,PreviousEmpName, PreviousEmpHDate, 
       DATEDIFF(DAY, PreviousEmpHDate, HireDate) AS DiffDays
FROM CTE

--Q10--

SELECT DISTINCT e.HireDate, ed.DepartmentID,
	   STRING_AGG(CONCAT(p.BusinessEntityID, ' ', p.LastName, ' ', p.FirstName), '; ')as 'TeamEmployees'	   
FROM  Person.Person p JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
	JOIN HumanResources.EmployeeDepartmentHistory ed ON e.BusinessEntityID = ed.BusinessEntityID
WHERE ed.EndDate is null 
GROUP BY ed.DepartmentID, e.hiredate
ORDER BY HireDate DESC




	 
 
