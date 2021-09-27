/*
Zagrijavanje

0.0. Kreirati/objasniti običnu SP (Store Procedure) bez parametara
*/

CREATE OR ALTER PROC dbo.usp_CustomerName 
AS
 SET NOCOUNT ON;
 SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
 FROM Sales.Customer AS c
 INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
 ORDER BY p.LastName, p.FirstName,p.MiddleName ;
 RETURN 0;
GO

EXEC dbo.usp_CustomerName
GO

/*
0.1. Kreirati/objasniti SP sa jednostavnom logikom
*/

CREATE OR ALTER PROC dbo.usp_CustomerName 
	@CustomerID INT 
AS
 SET NOCOUNT ON;
 IF @CustomerID > 0 
 BEGIN
	 SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
	 FROM Sales.Customer AS c
	 INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
	 WHERE c.CustomerID = @CustomerID;
	 RETURN 0;
 END
 ELSE BEGIN
	RETURN -1;
 END;
GO

EXEC dbo.usp_CustomerName @CustomerID = 15128
GO

/*
0.2. Kreirati/objasniti default values na parametrima u SP
*/
CREATE OR ALTER PROC dbo.usp_CustomerName 
	@CustomerID INT = -1 
AS
 SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
 FROM Sales.Customer AS c
 INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
 WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID
END
 RETURN 0
GO

-- Sa parametrom
EXEC dbo.usp_CustomerName @CustomerID = 15128
GO

-- Bez parametra
EXEC dbo.usp_CustomerName
GO

/*
0.3. Kreirati/objasniti korištenje output parametara
*/

CREATE OR ALTER PROC dbo.usp_OrderDetailCount 
	@OrderID INT,
	@Count INT OUTPUT 
AS
 SELECT @Count = COUNT(*)
 FROM Sales.SalesOrderDetail
 WHERE SalesOrderID = @OrderID
 RETURN 0
GO

DECLARE @OrderCount INT
EXEC usp_OrderDetailCount 71774, @OrderCount OUTPUT
PRINT @OrderCount

/*
0.4. Korištenje logike u SP
*/

USE tempdb
GO

CREATE OR ALTER PROC usp_ProgrammingLogic 
AS
 CREATE TABLE #Numbers(number INT NOT NULL);
 
 DECLARE @count INT;
 
 SET @count = ASCII('!');
 
 WHILE @count < 200 
BEGIN
 INSERT INTO #Numbers(number) VALUES (@count);
 SET @count = @count + 1;
END;
 
 ALTER TABLE #Numbers ADD symbol NCHAR(1);
 UPDATE #Numbers SET symbol = CHAR(number);
 SELECT number, symbol FROM #Numbers;
GO

/*
1. Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person baze AdventureWorks2014 kojom će se dati prikaz polja BusinessEntityID, FirstName i LastName. Proceduru podesiti da se rezultati sortiraju po BusinessEntityID.
*/

USE AdventureWorks2014
GO

CREATE PROCEDURE HumanResources.proc_Employees
AS
BEGIN
    SELECT E.BusinessEntityID, P.FirstName, P.LastName
    FROM HumanResources.Employee AS E INNER JOIN Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID
    ORDER BY E.BusinessEntityID
END

-- Izvršavanje procedure
EXEC HumanResources.proc_Employees
GO

/*
2. Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person kojom će se definirati sljedeći ulazni parametri: EmployeeID, FirstName, LastName, Gender. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara. Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
	1. EmployeeID = 20, 
	2. LastName = Miller
	3. LastName = Abercrombie, Gender = M 
*/

CREATE PROCEDURE HumanResources.proc_EmployeesParameters
    (
    @EmployeeID INT = NULL,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR (50) = NULL,
    @Gender CHAR(1) = NULL
)
AS
BEGIN
    SELECT E.BusinessEntityID, P.FirstName, P.LastName, E.Gender
    FROM HumanResources.Employee AS E INNER JOIN Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID
    WHERE E.BusinessEntityID = @EmployeeID OR
        P.FirstName = @FirstName OR
        P.LastName = @LastName OR
        E.Gender = @Gender
END

-- Izvršavanje procedure
--1
EXEC HumanResources.proc_EmployeesParameters @EmployeeID = 20
GO

--2
EXEC HumanResources.proc_EmployeesParameters @LastName='Miller'
GO

--3
EXEC HumanResources.proc_EmployeesParameters @LastName='Abercrombie', @Gender = 'M'
GO

/*
3. Proceduru HumanResources.proc_EmployeesParameters koja je kreirana nad tabelama HumanResources.Employee i Person.Person izmijeniti tako da je prilikom izvršavanja moguće unijeti bilo koje vrijednosti za prva tri parametra (možemo ostaviti bilo koje od tih polja bez unijete vrijednosti), a da vrijednost četvrtog parametra bude F, odnosno, izmijeniti tako da se dobija prikaz samo osoba ženskog pola.
Nakon izmjene pokrenuti proceduru za sljedeće vrijednosti parametara:
    1. EmployeeID = 52, 
    2. LastName = Miller
*/

ALTER PROCEDURE HumanResources.proc_EmployeesParameters
    (
    @EmployeeID INT = NULL,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR (50) = NULL,
    @Gender CHAR(1) = 'F'
)
AS
BEGIN
    SELECT E.BusinessEntityID, P.FirstName, P.LastName, E.Gender
    FROM HumanResources.Employee AS E INNER JOIN Person.Person AS P
        ON E.BusinessEntityID = P.BusinessEntityID
    WHERE	(E.BusinessEntityID = @EmployeeID OR
        P.FirstName = @FirstName OR
        P.LastName = @LastName) AND
        E.Gender = @Gender
END

-- IZVRŠAVANJE PROCEDURE
--1
EXEC HumanResources.proc_EmployeesParameters @EmployeeID = 52
GO

--2
EXEC HumanResources.proc_EmployeesParameters @LastName='Miller'
GO

/*
4. Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail kreirati pogled view_promet koji će se sastojati od kolona CustomerID, SalesOrderID, ProductID i proizvoda OrderQty i UnitPrice. 
*/

create view view_promet
as
    select soha.CustomerID, soda.SalesOrderID, soda.ProductID, soda.OrderQty * soda.UnitPrice as ukupno
    from Sales.SalesOrderHeader soha join Sales.SalesOrderDetail soda
        on soha.SalesOrderID = soda.SalesOrderID
go

select *
from view_promet
go

/*
5. Koristeći pogled view_promet kreirati pogled view_promet_cust_ord koji neće sadržavati kolonu ProductID i vršit će sumiranje kolone ukupno.
*/

create view view_promet_cust_ord
as
    select CustomerID, SalesOrderID, SUM (ukupno) as suma
    from view_promet
    group by CustomerID, SalesOrderID
go

/*
6. Nad pogledom view_promet_cust_ord kreirati proceduru kojom će se definirati ulazni parametri: CustomerID, SalesOrderID i suma.
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za vrijednost parametara CustomerID = 11019.
Obrisati proceduru, a zatim postaviti uslov da procedura vraća samo one zapise u kojima je suma manje od 100, pa ponovo pokrenuti za istu vrijednost parametra.
*/

CREATE PROCEDURE proc_view_promet_cust_ord
(
	@CustomerID INT = NULL,
	@SalesOrderID int = NULL,
	@suma money = NULL
)
AS
BEGIN 
SELECT	*
FROM	view_promet_cust_ord
WHERE	(CustomerID = @CustomerID OR
		SalesOrderID = @SalesOrderID OR
		suma = @suma)
		/*and 
		suma < 100*/
END

-- IZVRŠAVANJE PROCEDURE
exec proc_view_promet_cust_ord @CustomerID = 11019
GO

/*
7. Kreirati proceduru Narudzba nad tabelama Customers, Products, Order Details i Order baze Northwind kojom će se definirati sljedeći ulazni parametri: ContactName, ProductName, UnitPrice, Quantity i Discount. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. ContactName = Mario Pontes
2. Quantity = 10 ili Discount = 0.15
3. UnitPrice = 20
*/

USE Northwind
GO

create procedure narudzba 
(
	@ContactName nvarchar (50) = null,
	@ProductName nvarchar (50) = null,
	@UnitPrice money = null,
	@Quantity int = null,
	@Discount real = null
)
as
begin
select	c.ContactName, p.ProductName, od.UnitPrice, od.Quantity, od.Discount
from	Customers c 
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
where	c.ContactName = @ContactName or
		p.ProductName = @ProductName or
		od.UnitPrice = @UnitPrice or
		od.Quantity = @Quantity or
		od.Discount = @Discount
end

exec narudzba @ContactName = 'Mario Pontes'
GO
--32
exec narudzba @Quantity = 10, @Discount = 0.15
GO
--331
exec narudzba @UnitPrice = 20
GO
--15

/*
8. Kreirati proceduru nad tabelama Production.Product, Production.ProductSubcategory, Production.ProductListPriceHistory, Purchasing.ProductVendor kojom će se definirati parametri: p_name za naziv proizvoda, Color, ps_name za naziv potkategorije, ListPrice sa zaokruživanjem na dvije decimale, AverageLeadTime, MinOrderQty, MaxOrderQty i Razlika kao razliku maksimalne i minimalne naručene količine. Dati odgovarajuće nazive. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra. Zapisi u proceduri trebaju biti sortirani po vrijednostima parametra ListPrice.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. MaxOrderQty = 1000
2. Razlika = 350
3. Color = Red i naziv potkategorije = Helmets
*/
USE AdventureWorks2014
GO

create procedure proc_subcat
(
	@p_name nvarchar (50) = null,
	@Color nvarchar (15) = null,
	@ps_name nvarchar (50) = null,
	@ListPrice money = null,
	@AverageLeadTime int = null,
	@MinOrderQty int = null,
	@MaxOrderQty int = null,
	@Razlika int = null
)
as
begin
select	p.Name, p.Color, ps.Name potkategorija, ROUND (plph.ListPrice,2) cijena,
		pv.AverageLeadTime,	pv.MinOrderQty, pv.MaxOrderQty,
		pv.MaxOrderQty - pv.MinOrderQty as razlika
from	Purchasing.ProductVendor pv join Production.Product p
on		pv.ProductID = p.ProductID
		join Production.ProductListPriceHistory plph
		on plph.ProductID = p.ProductID
			join Production.ProductSubcategory ps
			on ps.ProductSubcategoryID = p.ProductSubcategoryID
where	p.Name = @p_name or
		p.Color = @Color or
		ps.Name = @ps_name or
		plph.ListPrice = @ListPrice or
		pv.AverageLeadTime = @AverageLeadTime or
		pv.MinOrderQty = @MinOrderQty or
		pv.MaxOrderQty = @MaxOrderQty or
		pv.MaxOrderQty - pv.MinOrderQty = @Razlika
end

exec proc_subcat @MaxOrderQty = 1000
GO
--63

exec proc_subcat @Razlika = 350
GO
--4

exec proc_subcat @Color = Red, @ps_name=Helmets
GO
--9

/*
9. Izvršiti izmjenu kreirane procedure tako da prosljeđuje samo one zapise u kojima je razlika veća od 500.
Nakon kreiranja pokrenuti proceduru bez postavljanja vrijednosti za bilo koji parametar, a zatim za sljedeće vrijednosti parametara:
1. MinOrderQty = 100 
2. Color = Red
3. ps_name= Helmets
*/

alter procedure proc_subcat
(
	@p_name nvarchar (50) = null,
	@Color nvarchar (15) = null,
	@ps_name nvarchar (50) = null,
	@ListPrice money = null,
	@AverageLeadTime int = null,
	@MinOrderQty int = null,
	@MaxOrderQty int = null,
	@Razlika int = null
)
as
begin
select	p.Name, p.Color, ps.Name potkategorija, ROUND (plph.ListPrice,2) cijena,
		pv.AverageLeadTime,	pv.MinOrderQty, pv.MaxOrderQty,
		pv.MaxOrderQty - pv.MinOrderQty as razlika
from	Purchasing.ProductVendor pv join Production.Product p
on		pv.ProductID = p.ProductID
		join Production.ProductListPriceHistory plph
		on plph.ProductID = p.ProductID
			join Production.ProductSubcategory ps
			on ps.ProductSubcategoryID = p.ProductSubcategoryID
where	pv.MaxOrderQty - pv.MinOrderQty > 500 and
		(p.Name = @p_name or
		p.Color = @Color or
		ps.Name = @ps_name or
		plph.ListPrice = @ListPrice or
		pv.AverageLeadTime = @AverageLeadTime or
		pv.MinOrderQty = @MinOrderQty or
		pv.MaxOrderQty = @MaxOrderQty)	
end

exec proc_subcat @MinOrderQty = 100
go
--63

exec proc_subcat @Color = Red, @ps_name=Helmets
GO
--3

exec proc_subcat @ps_name=Helmets
GO

/*
ZADAĆA
------
10. Koristeći tabelu Sales.Customer kreirati proceduru proc_account_number kojom će se definirati parametar br_cif_account za pregled broja zapisa po broju cifara u koloni AccountNumber. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra. Procedura treba da vrati broj cifara (1-, 2- cifreni) i ukupan broj zapisa po cifrenosti.
Nakon kreiranja zasebno pokrenuti proceduru za 1-, 2-, 3- i 5-cifrene brojeve.
*/



/*
DODACI
(onako da imate)
*/

--Query za provjeru cache-a
SELECT cplan.usecounts, cplan.objtype, qtext.text, qplan.query_plan
FROM sys.dm_exec_cached_plans AS cplan
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS qtext
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qplan
ORDER BY cplan.usecounts DESC