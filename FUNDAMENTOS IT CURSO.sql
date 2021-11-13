use AdventureWorks2019

 --CLASS ONE PART
SELECT BusinessEntityID, VacationHours from HumanResources.Employee where VacationHours > 90; 

SELECT Name, ListPrice, ListPrice * 1.21 as WihtIVA  FROM Production.Product WHERE ListPrice <> 0; 

SELECT PRODUCTID, NAME, ListPrice FROM Production.Product WHERE ProductID = 776 OR ProductID = 777 OR ProductID = 778;

SELECT FirstName + ' ' + LastName as Persona FROM PERSON.PERSON  WHERE LastName = 'JOHNSON';

SELECT NAME, Color, ListPrice FROM PRODUCTION.Product WHERE (ListPrice <= 150 AND Color = 'RED') OR (ListPrice >= 500 AND Color = 'BLACK');

SELECT BusinessEntityID AS CODIGO, HireDate AS 'FECHA DE INGRESO', VacationHours AS 'HORAS DE VACACIONES'  FROM HumanResources.Employee
WHERE HireDate >= '2000-01-01';

SELECT NAME, ProductNumber, ListPrice, ListPrice * 1.10 AS 'INCREMENTADO 10%' , SellEndDate FROM Production.Product 
WHERE SellEndDate < GETDATE();

SELECT BusinessEntityID FROM Sales.SalesPerson WHERE TerritoryID IS NULL;

SELECT ISNULL (Weight,0) AS WEIGHT FROM Production.Product;



SELECT name, color, ListPrice FROM Production.Product where ListPrice >= 100;

SELECT NAME FROM Production.Product WHERE NAME LIKE '%mountain bike%';

SELECT FirstName FROM Person.Person WHERE FirstName LIKE 'Y%'

SELECT LastName FROM Person.Person WHERE LastName LIKE '_S%';

SELECT FirstName + ' ' + LastName AS NOMBRES FROM Person.Person WHERE LastName LIKE '%EZ';

SELECT Name, ProductNumber FROM Production.Product WHERE ProductNumber LIKE '%[0-9]';

SELECT FirstName FROM Person.Person WHERE FirstName LIKE '[C-c]_[^D-G][J-W]%';

SELECT Name, ListPrice FROM Production.Product WHERE ListPrice BETWEEN 200 AND 300;

SELECT BirthDate FROM HumanResources.Employee WHERE BirthDate BETWEEN '1970' AND '1985';

SELECT OrderDate, AccountNumber, SubTotal FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) BETWEEN 2005 AND 2006;

SELECT OrderDate, AccountNumber, SubTotal FROM Sales.SalesOrderHeader WHERE SubTotal BETWEEN 50 AND 70;

SELECT SalesOrderID, OrderQty, ProductID, UnitPrice FROM Sales.SalesOrderDetail WHERE ProductID IN (750, 753, 770);

SELECT COLOR FROM Production.Product WHERE Color NOT IN ('GREEN', 'WHITE', 'BLUE');



SELECT LastName, FirstName FROM Person.Person ORDER BY LastName, FirstName

SELECT TOP 5 NAME, ListPrice  FROM Production.Product ORDER BY ListPrice DESC, NAME



--CLASS TWO PART

select distinct ProductID from Sales.SalesOrderDetail


select ProductID from Sales.SalesOrderDetail
union all
select ProductID from Production.WorkOrder


select ProductID from Sales.SalesOrderDetail
union
select ProductID from Production.WorkOrder



--Obtener el id y una columna denominada sexo cuyo valores disponibles sean “Masculino” y ”Femenino”
select BusinessEntityID = case when Gender = 'F' then 'Femenino'
							else 'Masculino' 
							end	
from HumanResources.Employee



--Mostrar el id de los empleados si tiene salario deberá mostrarse descendente de lo contrario ascendente
select BusinessEntityID, SalariedFlag from HumanResources.Employee 
order by 
case SalariedFlag when 1 then BusinessEntityID end desc,
case when SalariedFlag = 0 then BusinessEntityID end asc


--Mostrar la fecha más reciente de venta
select max(OrderDate)  from sales.SalesOrderHeader  


--Mostrar el precio más barato de todas las bicicletas
select min(ListPrice) as precio from Production.Product where Name like '%bike%'


--Mostrar la fecha de nacimiento del empleado más joven 
select max(BirthDate) as FechaMasJoven from HumanResources.Employee 


-- Mostrar el promedio del listado de precios de productos
select avg(ListPrice) as promedio from Production.Product


-- Mostrar la cantidad y el total vendido por productos 
select count(1) as Cantidad, sum(LineTotal) as Total from Sales.SalesOrderDetail


--Laboratorio Group by

--1) Mostrar el código de subcategoría y el precio del producto más barato de cada una de ellas

SELECT ProductSubcategoryID, ListPrice, ProductID FROM Production.Product AS PP
WHERE ListPrice = (SELECT MIN(ListPrice) AS ListPrice
					FROM Production.Product PP1
					WHERE PP.ProductSubcategoryID = PP1.ProductSubcategoryID )
					ORDER BY ProductSubcategoryID


--2) Mostrar los productos y la cantidad total vendida de cada uno de ellos

SELECT ProductID, SUM(OrderQty) AS CANTIDAD FROM Sales.SalesOrderDetail GROUP BY ProductID ORDER BY ProductID
		

--3) Mostrar los productos y el total vendido de cada uno de ellos, ordenados por el total vendido

SELECT ProductID, SUM(LineTotal) AS TOTAL FROM Sales.SalesOrderDetail GROUP BY ProductID ORDER BY SUM(LineTotal)


--4) Mostrar el promedio vendido por factura.

SELECT SalesOrderID, AVG(LineTotal) AS PROMEDIO FROM Sales.SalesOrderDetail GROUP BY SalesOrderID



--Laboratorio Having

--1) Mostrar todas las facturas realizadas y el total facturado de cada una de ellas ordenado por número de factura
--pero sólo de aquellas órdenes superen un total de $10.000

SELECT SalesOrderID, SUM(LineTotal) AS TOTAL FROM Sales.SalesOrderDetail GROUP BY SalesOrderID HAVING SUM(LineTotal) > 10000


--2) Mostrar la cantidad de facturas que vendieron más de 20 unidades

SELECT SalesOrderID, SUM(OrderQty) AS CANTIDAD FROM Sales.SalesOrderDetail GROUP BY SalesOrderID HAVING SUM(OrderQty) > 20 


--3) Mostrar las subcategorías de los productos que tienen dos o más productos que cuestan menos de $150

SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CANTIDAD
FROM Production.Product 
WHERE ListPrice>150 
GROUP BY ProductSubcategoryID
HAVING COUNT(ProductSubcategoryID) > 2


--4) Mostrar todos los códigos de subcategorías existentes junto con la cantidad para los productos cuyo precio de
--lista sea mayor a $ 70 y el precio promedio sea mayor a $ 300.

SELECT  ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CANTIDAD, AVG(ListPrice) AS PROMEDIO 
FROM Production.Product WHERE ListPrice > 70 
GROUP BY ProductSubcategoryID HAVING AVG(ListPrice) > 300

--Laboratorio Rollup

--1) Mostrar el número de factura, el monto vendido, y al final, totalizar la facturación.

SELECT SalesOrderID, SUM(UnitPrice*OrderQty) AS TOTAL FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID WITH ROLLUP


--CLASS THREE
--Laboratorio Joins

--1) Mostrar los empleados que también son vendedores

SELECT HRE.BusinessEntityID FROM HumanResources.Employee AS HRE
INNER JOIN Sales.SalesPerson AS s
ON HRE.BusinessEntityID = s.BusinessEntityID;

--CLASS PART THREE

--Laboratorio Joins

--1) Mostrar los empleados que también son vendedores
SELECT hre.BusinessEntityID FROM HumanResources.Employee AS HRE
INNER JOIN SALES.SALESPERSON AS SSP
ON HRE.BusinessEntityID = SSP.BusinessEntityID

--2) Mostrar los empleados ordenados alfabéticamente por apellido y por nombre
SELECT pp.LastName, pp.FirstName FROM HumanResources.Employee hre
inner join person.Person pp
on hre.BusinessEntityID = pp.BusinessEntityID
order by LastName, FirstName

--3) Mostrar el código de logueo, número de territorio y sueldo básico de los vendedores
SELECT HRE.LoginID, SSP.TerritoryID, SSP.Bonus FROM HumanResources.Employee HRE
INNER JOIN Sales.SalesPerson SSP
ON HRE.BusinessEntityID = SSP.BusinessEntityID

--4) Mostrar los productos que sean ruedas
SELECT PP.Name FROM Production.Product PP 
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
WHERE PP.Name LIKE '%WHEEL%'

--5) Mostrar los nombres de los productos que no son bicicletas
SELECT PP.Name FROM Production.Product PP 
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
WHERE PP.Name NOT LIKE '%BIKE%'

--6) Mostrar los precios de venta de aquellos productos donde el precio de venta sea inferior al precio de lista
--recomendado para ese producto ordenados por nombre de producto
SELECT DISTINCT PP.ProductID, PP.Name producto, PP.ListPrice [precio de lista], SSO.UnitPrice AS 'Precio de Venta recomendado'
FROM Sales.SalesOrderDetail AS SSO
INNER JOIN	Production.Product AS PP 
ON SSO.ProductID = PP.ProductID AND SSO.UnitPrice < PP.ListPrice;

--7) Mostrar todos los productos que tengan igual precio. Se deben mostrar de a pares, código y nombre de cada uno
--de los dos productos y el precio de ambos.ordenar por precio en forma descendente
SELECT p1.ProductiD, p1.Name, p1.ListPrice ,p2.ProductiD, p2.Name, p2.ListPrice FROM Production.Product p1
INNER JOIN	Production.Product p2
ON p1.ListPrice = p2.ListPrice
WHERE p1.ProductID > p2.ProductID
ORDER BY p1.ListPrice DESC;

--8) Mostrar el nombre de los productos y de los proveedores cuya subcategoría es 15 ordenados por nombre de proveedor
SELECT pp.ProductSubcategoryID, pp.Name as Producto, pv.Name as Proveedor
FROM Production.Product pp
INNER JOIN Purchasing.ProductVendor ppv 
ON pp.ProductID = ppv.ProductID
INNER JOIN Purchasing.Vendor pv
ON ppv.BusinessEntityID=pv.BusinessEntityID
WHERE pp.ProductSubcategoryID=13;

--9) Mostrar todas las personas (nombre y apellido) y en el caso que sean empleados mostrar también el login id, sino mostrar null
SELECT pp.firstname, pp.lastname, he.LoginID FROM Person.Person pp   
LEFT JOIN HumanResources.Employee he
ON pp.BusinessEntityID = he.BusinessEntityID


--Laboratorio Tablas Temporales - CTE
--1) Clonar estructura y datos de los campos nombre, color y precio de lista de la tabla production.product en una tabla llamada #Productos

SELECT	Color, Name, ListPrice INTO	#Productos FROM	Production.Product;


--2) Clonar solo estructura de los campos identificador, nombre y apellido de la tabla person.person en una tabla llamada #Personas

SELECT BusinessEntityID, FirstName, LastName INTO #personas FROM Person.Person


--3) Eliminar si existe la tabla #Productos
IF OBJECT_ID (N'tempdb..#Productos', N'U') IS NOT NULL
	DROP TABLE #Productos;
GO

--4) Eliminar si existe la tabla #Personas
if OBJECT_ID (N'tempdb..#personas', N'U') is not null
	DROP TABLE #personas;
GO


--5)Crear una CTE con las órdenes de venta                           ENTRENAR ESTO OJEARLO
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
AS
(SELECT  SalesPersonID ,SalesOrderID, YEAR(OrderDate) AS Anio FROM Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL)  

  SELECT SalesPersonID, SalesOrderID, SalesYear
FROM [Sales_CTE] 


