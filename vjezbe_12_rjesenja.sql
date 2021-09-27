/*
Views ne sadrže podatke, to su samo pohranjeni query definitions
Developeri ih koriste da pojednostave kodiranje
Isto tako, mogu se koristiti da u svrhu sigurnosti podataka, tj.
Možete dodijeliti krajnjem korisniku permisije da selektuje samo iz odgovarajućih
views bez da mu date permisiju na tabeli
*/

/*
Također postoje i materijalizovani pogledi (indexed view) koji sadrže podatke. Da bi se 
kreirao indexed view, potrebno je dodati clustered index na view.
*/

/*
VIEWS (POGLEDI)
*/

--1
USE AdventureWorks2014;
GO
DROP VIEW IF EXISTS dbo.vw_Customer;
GO

-- Kreiranje pogleda primjer
--2
CREATE VIEW dbo.vw_Customer AS
 SELECT c.CustomerID, c.AccountNumber, c.StoreID,
 c.TerritoryID, p.FirstName, p.MiddleName,
 p.LastName
 FROM Sales.Customer AS c
 INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;
GO
--3
SELECT CustomerID,AccountNumber,FirstName,
 MiddleName, LastName
FROM dbo.vw_Customer;
GO
--4
ALTER VIEW dbo.vw_Customer AS
 SELECT c.CustomerID,c.AccountNumber,c.StoreID,
 c.TerritoryID, p.FirstName,p.MiddleName,
 p.LastName, p.Title
 FROM Sales.Customer AS c
 INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;
GO
--5
SELECT CustomerID,AccountNumber,FirstName,
 MiddleName, LastName, Title
FROM dbo.vw_Customer
ORDER BY CustomerID;

-- Uobičajeni problemi pri korištenju views

--1
DROP VIEW IF EXISTS dbo.vw_Dept;
DROP TABLE IF EXISTS dbo.demoDept;

--2
-- Kreiranje tabele dbo.demoDept iz HumanResources.Department tabele
SELECT DepartmentID,Name,GroupName,ModifiedDate
INTO dbo.demoDept
FROM HumanResources.Department;
GO

--3
-- Kreiranje pogleda vw_Dept koristeći sintaksu sa zvjezdicom (*) na dbo.demoDept
-- tabelu
CREATE VIEW dbo.vw_Dept AS
 SELECT *
 FROM dbo.demoDept;
GO

--4
-- Selektujemo sve redove iz pogleda i rezultati izgledaju OK
SELECT DepartmentID, Name, GroupName, ModifiedDate
FROM dbo.vw_Dept;

--5
-- Drop-at ćemo dbo.demoDept tabelu
DROP TABLE dbo.demoDept;
GO

--6
-- Kreirat ćemo ponovo tabelu dbo.demoDept, ali ćemo poredati kolone drugim redoslijedom
SELECT DepartmentID, GroupName, Name, ModifiedDate
INTO dbo.demoDept
FROM HumanResources.Department;
GO

--7
-- Vidimo kako je to uticalo na rezultat query-ja jer su kolone Name i GroupName preokrenute
SELECT DepartmentID, Name, GroupName, ModifiedDate
FROM dbo.vw_Dept;
GO

-- Da bismo to popravili, potrebno je uraditi "refresh definicije" sa ALTER VIEW komandom

--8
-- Drop-at ćemo view
DROP VIEW dbo.vw_Dept;
GO

--9
-- Kreirati ponovo view, ali da probamo prisliti određeni order u definiciji
CREATE VIEW dbo.vw_Dept AS
 SELECT TOP(100) PERCENT DepartmentID,
 Name, GroupName, ModifiedDate
 FROM dbo.demoDept
 ORDER BY Name;
GO

--10
-- Vidimo da ORDER BY nema apsolutno nikakvog uticaja
SELECT DepartmentID, Name, GroupName, ModifiedDate
FROM dbo.vw_Dept;


/* Manipulacija podacima preko view-a */

/*
Dosad smo vidjeli kako view možemo koristiti da selektujemo podatke. Također,
moguće je mijenjati podatke tabele tako što ćemo raditi update na view, ali nekoliko
stvari se mora paziti:
- Izmjenom podataka view-a kroz insert ili update može da utiče samo na jednu tabelu koja se koristi u view-u
- Ne mogu se obrisati podaci iz view-a koji su sastavljeni od više od jedne tabele
- Updated kolone moraju biti direktno linkane sa kolonama koje je moguće update-ovati
unutar tabele, tj. ne možete uraditi update view-a koji je baziran na nekom izrazu ili nekoj koloni
koja se ne može update-ovati
- Insert se može uraditi samo ako se sve REQUIRED kolone nalaze u view-u 
*/

--1
-- Ovdje ćemo dropati tabele i view
DROP TABLE IF EXISTS dbo.demoCustomer;
DROP TABLE IF EXISTS dbo.demoPerson;
DROP VIEW IF EXISTS dbo.vw_Customer;

--2
-- Kreirat ćemo dvije tabele pomoću select into
SELECT CustomerID, TerritoryID, StoreID, PersonID
INTO dbo.demoCustomer
FROM Sales.Customer;
SELECT BusinessEntityID, Title, FirstName, MiddleName, LastName
INTO dbo.demoPerson
From Person.Person;
GO

--3
-- Kreirat ćemo view
CREATE VIEW vw_Customer AS
 SELECT CustomerID, TerritoryID, PersonID, StoreID,
 Title, FirstName, MiddleName, LastName
 FROM dbo.demoCustomer
 INNER JOIN dbo.demoPerson ON PersonID = BusinessEntityID;
GO

--4
-- Da pogledamo kako izgledaju podaci prije nego ih izmijenimo
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.vw_Customer
WHERE CustomerID IN (29484,29486,29489,100000);

--5
-- Promijenit ćemo ime Kim u Kathi i ovo će raditi zato što utiče samo na jednu tabelu
UPDATE dbo.vw_Customer SET FirstName = 'Kathi'
WHERE CustomerID = 29486;
GO

--6
-- Probat ćemo uraditi update, FirstName je dio jedne tabele, a TerritoryID dio druge tabele
-- Update će pasti
UPDATE dbo.vw_Customer SET FirstName = 'Franie',TerritoryID = 5
WHERE CustomerID = 29489;
GO

--7
-- Ako probamo izbrisati, opet će nam pokazati grešku jer brisanje radi samo
-- ako se view sastoji od jedne bazne tabele
DELETE FROM dbo.vw_Customer
WHERE CustomerID = 29484;
GO

--8
-- Probat ćemo uraditi insert na view
-- Ovaj view će proći zato što su nam exposed sva non-null polja 
INSERT INTO dbo.vw_Customer(TerritoryID,
 StoreID, PersonID)
VALUES (5,5,100000);
GO

--9
-- Napisat ćemo još jedan insert, ali ovaj put će pasti jer view ne expose non-null kolonu BusinessEntityID
-- i nemoguće je da postavimo validnu vrijednost
INSERT INTO dbo.vw_Customer(Title, FirstName, LastName)
VALUES ('Mrs.','Lady','Samoyed');

--10
-- Saćemo vidjeti rezultate skripte
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.vw_Customer
WHERE CustomerID IN (29484,29486,29489,100000);

--11
SELECT CustomerID, TerritoryID, StoreID, PersonID
FROM dbo.demoCustomer
WHERE PersonID = 100000;

/*
INDEXED VIEW
*/

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;
--Create view with schemabinding.
IF OBJECT_ID ('Sales.vOrders', 'view') IS NOT NULL
   DROP VIEW Sales.vOrders ;
GO
CREATE VIEW Sales.vOrders
   WITH SCHEMABINDING
   AS  
      SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Revenue,
         OrderDate, ProductID, COUNT_BIG(*) AS COUNT
      FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o
      WHERE od.SalesOrderID = o.SalesOrderID
      GROUP BY OrderDate, ProductID;
GO
--Create an index on the view.
CREATE UNIQUE CLUSTERED INDEX IDX_V1
   ON Sales.vOrders (OrderDate, ProductID);
GO
--This query can use the indexed view even though the view is
--not specified in the FROM clause.
SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev,
   OrderDate, ProductID
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SalesOrderHeader AS o
   ON od.SalesOrderID=o.SalesOrderID
      AND ProductID BETWEEN 700 and 800
      AND OrderDate >= CONVERT(datetime,'05/01/2002',101)
   GROUP BY OrderDate, ProductID
   ORDER BY Rev DESC;
GO
--This query can use the above indexed view.
SELECT OrderDate, SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SalesOrderHeader AS o
   ON od.SalesOrderID=o.SalesOrderID
      AND DATEPART(mm,OrderDate)= 3
      AND DATEPART(yy,OrderDate) = 2002
    GROUP BY OrderDate
    ORDER BY OrderDate ASC;

/*
Zadaci
*/

/*
1. Kreirati pogled dbo.vw_Products koji prikazuje listu proizvoda iz tabele Production.Product
koja je joined sa tabelom Production.ProductCostHistory. Uključiti kolone koje opisuju
proizvod i prikazati historiju proizvoda za svaki pojedinačno. Testirajte view kroz query
koji vraća podatke iz pogleda (view-a)
*/

IF OBJECT_ID('dbo.vw_Products') IS NOT NULL BEGIN
 DROP VIEW dbo.vw_Products;
END;
GO
CREATE VIEW dbo.vw_Products AS (
 SELECT P.ProductID, P.Name, P.Color,
 P.Size, P.Style,
 H.StandardCost, H.EndDate, H.StartDate
 FROM Production.Product AS P
 INNER JOIN Production.ProductCostHistory AS H
 ON P.ProductID = H.ProductID);
GO
SELECT ProductID, Name, Color, Size, Style,
 StandardCost, EndDate, StartDate
FROM dbo.vw_Products;

/*
2. Kreirati pogled dbo.vw_CustomerTotals koji prikazuje ukupnu prodaju iz kolone TotalDue
na godišnjem nivou i za svakog kupca. Testirajte view kroz query koji vraća podatke iz view-a
*/

IF OBJECT_ID('dbo.vw_CustomerTotals') IS NOT NULL BEGIN
 DROP VIEW dbo.vw_CustomerTotals;
END;
GO
CREATE VIEW dbo.vw_CustomerTotals AS (
 SELECT C.CustomerID,
 YEAR(OrderDate) AS OrderYear,
 MONTH(OrderDate) AS OrderMonth,
 SUM(TotalDue) AS TotalSales
 FROM Sales.Customer AS C
 INNER JOIN Sales.SalesOrderHeader
 AS SOH ON C.CustomerID = SOH.CustomerID GROUP BY
C.CustomerID,
 YEAR(OrderDate), MONTH(OrderDate));
GO
SELECT CustomerID, OrderYear,
 OrderMonth, TotalSales
FROM dbo.vw_CustomerTotals;

/*
User-Defined Functions

Učili smo o ugrađenm funkcijama koje su dostupne u SQL serveru. Također imamo opciju da kreiramo
svoje funkcije (tzv. User-DEfined Functions) koje mogu biti korištene kao i one ugrađene

Postoje dvije vrste:
- scalar valued koje vraćaju jednu vrijednost
- table valued koje vraćaju set podataka u tabularnom formatu

Koristeći UDF, možemo reuse code da pojednostavimo razvoj i sakrijemo neku kompleksnu logiku
Uglavnom, UDF imaju negativan uticaj na performanse zato što se izvršavaju u svakom redu

Kad su u pitanju scalar funkcije, postoji nekoliko stvari koje trebate zapamtiti
- mogu se koristit skoro svugdje u SQL statementu
- Mogu primiti jedan ili više parametara
- Vraćaju samo jedno vrijednost
- Unutar UDF možemo koristiti logiku tipa IF blok i WHILE petlju
- Mogu pristupati podacima (iako to često nije dobra ideja)
- Ne mogu raditi update podataka
- Mogu pozivati druge funkcije
- Njihova definicija mora uključiti return vrijednost
- Mogu kreirati table varijable, ali ne mogu kreirati temporary tabele ili obične tabele
- Kad se koristi unutar SQL statementa, funkcija se poziva za svaki red

Nekoliko savjeta:
- UDF ne bi trebalo da ovise o tabelama jer želimo da naš kod bude reusable što više
*/

/*
Scalar valued funkcije
*/

-- Dropat ćemo ako postoji
DROP FUNCTION IF EXISTS dbo.udf_Product;
DROP FUNCTION IF EXISTS dbo.udf_Delim;
GO

/*
1. Kreirati UDF koji množi dva broja. Imat ćemo dva ulazna INT parametra,
a kao izlazni parametar imamo proizvod
*/

CREATE FUNCTION dbo.udf_Product(@num1 INT, @num2 INT) RETURNS INT AS
BEGIN
 DECLARE @Product INT;
 SET @Product = ISNULL(@num1,0) * ISNULL(@num2,0);
 RETURN @Product;
END;
GO

/*
2. Kreirati UDF koji prima dva parametra String i Char. Želimo da nam funkcija vraća originalni string
ali na način da je svaki karakter razdvojen od drugog pomoću delimitera
*/
CREATE FUNCTION dbo.udf_Delim(@String VARCHAR(100),@Delimiter CHAR(1))
 RETURNS VARCHAR(200) AS
BEGIN
 DECLARE @NewString VARCHAR(200) = '';
 DECLARE @Count INT = 1;
 WHILE @Count <= LEN(@String) BEGIN
 SET @NewString += SUBSTRING(@String,@Count,1) + @Delimiter;
 SET @Count += 1;
 END
 RETURN @NewString;
END
GO

/*
3. Koristiti prethodne funkcije množeći StoreID i TerritoryID i dodajući zareze
u kolonu FirstName tabele Sales.Customer. Primijetit ćete da su i prva i druga funkcija
DB agnostic, tj. možete ih dodati u bilo koju bazu.
*/
SELECT StoreID, TerritoryID,
 dbo.udf_Product(StoreID, TerritoryID) AS TheProduct,
 dbo.udf_Delim(FirstName,',') AS FirstNameWithCommas
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID= p.BusinessEntityID;

/*
Korištenje Table-Valued

Vraćaju set redova umjesto samo jedne vrijednosti. Ovaj tip funkcija se ne može
koristiti u SELECT izrazu, ali se može koristiti umjesto tabele ili pohraniti 
vrijednosti u temp tabelu za kasnije korištenje u skripti.

Postoje dvije vrste 
- inline table-valued UDF, koja sadrži samo jedan SELECT 
- ostale koje imaju više statetment, često sa uključenom logikom
*/

-- SINTAKSA

--1
--Pozivamo UDF sa parametrom 1. Logika unutar funkcije određuje da BusinessEntityID 1 
--pripada uposleniku i vraća informaciju
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType
FROM dbo.ufnGetContactInformation(1);

--2
-- Ovaj query prosljeđuje 7822 kao parametar. Unutrašnja logika "shvata" da 7822 pripada
-- customeru umjesto employee kao u prvom slučaju i vraća informaciju
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType
FROM dbo.ufnGetContactInformation(7822);

/*
1. Kreirati UDF dbo.fn_AddTwoNumbers koja prihvata dva integer parametra i kao rezultat
vraća sumu ta dva broja.
*/

CREATE OR ALTER FUNCTION dbo.fn_AddTwoNumbers
 (@NumberOne INT, @NumberTwo INT)
RETURNS INT AS BEGIN
 RETURN @NumberOne + @NumberTwo;
END;
GO
SELECT dbo.fn_AddTwoNumbers(1,2);

/*
2. Kreirati funkciju dbo.fn_RemoveNumbers koja uklanja bilo koji numerički karakter
iz VARCHAR(250) stringa. HINT: ISNUMERIC provjerava je li string numeric
*/

CREATE OR ALTER FUNCTION dbo.fn_RemoveNumbers
 (@Expression VARCHAR(250))
RETURNS VARCHAR(250) AS BEGIN
 RETURN REPLACE( REPLACE (REPLACE (REPLACE( REPLACE( REPLACE(
REPLACE( REPLACE( REPLACE(
 REPLACE( @Expression,'1', ''),'2', ''),'3', ''),'4',
''),'5', ''),'6', ''),'7', ''),
 '8', ''),'9', ''),'0', '');
END;
GO
SELECT dbo.fn_RemoveNumbers
 ('abc 123 this is a test');

/*
3. Napisati funkciju dbo.fn_FormatPhone koja uzima string 10 karaktera i formatira
ih u obliku "(###)###-####"
*/

CREATE OR ALTER FUNCTION dbo.fn_FormatPhone
 (@Phone VARCHAR(10))
RETURNS VARCHAR(14) AS BEGIN
 DECLARE @NewPhone VARCHAR(14);
 SET @NewPhone = '(' + SUBSTRING(@Phone,1,3)
 + ') ';
 SET @NewPhone = @NewPhone +
 SUBSTRING(@Phone, 4, 3) + '-';
 SET @NewPhone = @NewPhone +
 SUBSTRING(@Phone, 7, 4);
 RETURN @NewPhone;
END;
GO
SELECT dbo.fn_FormatPhone('5555551234');


/*
4. Napisati UDF "temperature". Treba da prihvata DECIMAL(3,1) i karakter F ili C (koji označavaju
u kojem sistemu da se vrati vrijednost)
*/

CREATE OR ALTER FUNCTION temperature (@temp DECIMAL(3,1),
@ReturnUnitsIn char(1))
RETURNS DECIMAL(3,1)
AS
BEGIN
 DECLARE @Result DECIMAL(3,1) = 0
 IF @ReturnUnitsIn = 'C'
 SET @Result = (@temp - 32) / 1.8;
 ELSE IF @ReturnUnitsIn = 'F'
 SET @Result = (@temp * 1.8) + 32;
 RETURN @result;
END
GO
SELECT dbo.Temperature( 32 , 'C');


/*

NAPOMENA: S obzirom da nismo uspjeli završiti sve zadatke iz vjezbe_12_postavka.sql, dio sam prebacio u vjezbe_13_postavka.sql/vjezbe_13_rjesenja.sql, tako da možemo preći zadatke koji su vezani za vjezbe_13

*/