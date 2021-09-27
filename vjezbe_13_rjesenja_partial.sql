/*
	Kreiranje UDT (User-defined data types)
	
	Unutar baze podataka moguće je kreirati user-defined data types (UDTs) koji služe samo kao alias za već postojeće ugrađene tipove podataka. 
	
	Ovo nam omogućava da određeni tip kolone bude konzistentan kroz cijelu bazu.
	
	Primjer: U bazi AdventureWorks2014 već postoji nekoliko primjera UDT-ova
	(Programmability -> Types -> User-Defined Data Types)
*/

CREATE TYPE <type name> FROM <native type and size> [NULL|NOT NULL]

/*
	Kreiranje UDT primjer
*/

DROP TYPE IF EXISTS dbo.CustomerID
GO

CREATE TYPE dbo.CustomerID FROM INT NOT NULL
GO

/*
	Kako smo kreirali UDT, možemo ga koristiti kad definišemo novu tabelu.
*/

/*
	User-Defined Table Types
	
	Specijalni tip user-defines tipa objekta je table type. Table type nam omogućava da proslijedimo tabularne podatke u store proceduru.
	
	Table type je samo definicija, kao i UDT.
*/

CREATE TYPE <schema>.<tableName> AS TABLE 
(
	<col1> <dataType1>,
	<col2> <dataType2>
)
GO

/*
	Primjer kreiranja
*/

DROP PROCEDURE IF EXISTS usp_TestTableVariable
DROP TYPE IF EXISTS dbo.CustomerInfo

CREATE TYPE dbo.CustomerInfo AS TABLE
(
	CustomerID INT NOT NULL PRIMARY KEY,
	FavoriteColor VARCHAR(20) NULL,
	FavoriteSeason VARCHAR(20) NULL
)
GO

/*
	Nakon što smo kreirali CustomerInfo tip, možemo ga pronaći u Programmability -> Types -> User-Defined Table Types
	
	Iako vidimo properties CustomerInfo tipa, ne možemo dodati podatke u isti, niti ga možemo query-jati.
*/

/*
	Kreirati i populisati table varijablu baziranu na tipu
*/

DECLARE @myTableVariable [dbo].[CustomerInfo]

INSERT INTO @myTableVariable(CustomerID, FavoriteColor, FavoriteSeason)
VALUES(11001, 'Blue','Summer'),(11002,'Orange','Fall')

SELECT CustomerID, FavoriteColor, FavoriteSeason
FROM @myTableVariable;
GO

/*
	Kreirati store proceduru, a pri tome da koristimo kreiranu table varijablu
*/

--1 - prihvata varijablu tipa CustomerInfo. 
CREATE PROC dbo.usp_TestTableVariable @myTable CustomerInfo READONLY AS
SELECT c.CustomerID, AccountNumber, FavoriteColor, FavoriteSeason
FROM AdventureWorks2019.Sales.Customer AS C INNER JOIN @myTable MT
ON C.CustomerID = MT.CustomerID;
GO

--2 - deklaracija i popunjavanje vrijednosti table varijable
DECLARE @myTableVariable [dbo].[CustomerInfo]
INSERT INTO @myTableVariable(CustomerID, FavoriteColor, FavoriteSeason)
VALUES(11001, 'Blue','Summer'),(11002,'Orange','Fall');

--3 - izvršavanje procedure sa proslijeđenim table tipom
EXEC usp_TestTableVariable @myTableVariable;


/*
	TRANSAKCIJE
	
	Atomicity - Transakcija je jedan unit of work. Ili će sve proći ili neće ništa
	Consistency - Pri završetku transakcije, baza mora biti u stanju konzistentnosti. Transakcija prati sva pravila definisana u bazi (npr. constraints)
	Isolation - Ne smije uticati na druge transakcije koje se istovremeno dešavaju
	Durability - Nakon što je transakcija uspješno završena, izmjene ne mogu biti izgubljene (ni nakon reboot-a ili nestanka struje i sl.)
*/

/*
	Sintaksa
*/

BEGIN TRAN|TRANSACTION
 <statement 1>
 <statement 2>
COMMIT [TRAN|TRANSACTION]

/*
	Primjer i objašnjenje
*/

DROP TABLE IF EXISTS [dbo].[demoTransaction];
GO

CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO

--1
BEGIN TRAN
 INSERT INTO dbo.demoTransaction (col1) VALUES (1);
 INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN

--2
BEGIN TRAN
 INSERT INTO dbo.demoTransaction (col1) VALUES (3);
 INSERT INTO dbo.demoTransaction (col1) VALUES ('a');
COMMIT TRAN
GO

--3
SELECT col1
FROM dbo.demoTransaction;

/*
	ROLLBACK TRAN
	
*/

-- SINTAKSA
BEGIN TRAN|TRANSACTION
 <statement 1>
 <statement 2>
ROLLBACK [TRAN|TRANSACTION]

/*
	Primjer i objašnjenje
*/

DROP TABLE IF EXISTS [dbo].[demoTransaction]
GO

CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO

--1
BEGIN TRAN
 INSERT INTO dbo.demoTransaction (col1) VALUES (1);
 INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN

--2
BEGIN TRAN
 INSERT INTO dbo.demoTransaction (col1) VALUES (3);
 INSERT INTO dbo.demoTransaction (col1) VALUES (4);
ROLLBACK TRAN
GO

--3
SELECT col1
FROM dbo.demoTransaction;

/*
	XACT_ABORT
	
	XACT_ABORT automatski uradi rollback transakcije i zaustavlja batch u slučaju runtime grešaka kao što je violation primary ili foreign ključeva.
	
	Isključena je po defaultu zato što se pruža mogućnost recovery iz greške sa TRY/CATCH, a u slučaju kad se automatski rollback-a, ne postoji ta mogućnost.
*/

-- Slučaj sa XACT_ABORT OFF
CREATE TABLE #Test_XACT_OFF(COL1 INT PRIMARY KEY, COL2 VARCHAR(10))

--2
BEGIN TRANSACTION
 INSERT INTO #Test_XACT_OFF(COL1,COL2)
 VALUES(1,'A');
 INSERT INTO #Test_XACT_OFF(COL1,COL2)
 VALUES(2,'B');
 INSERT INTO #Test_XACT_OFF(COL1,COL2)
 VALUES(1,'C');
COMMIT TRANSACTION

--3
SELECT * FROM #Test_XACT_OFF;
GO

-- Slučaj sa XACT_ABORT ON
--1
CREATE TABLE #Test_XACT_ON(COL1 INT PRIMARY KEY, COL2 VARCHAR(10));
--2
--Turn on the setting
SET XACT_ABORT ON;
GO
--3
BEGIN TRANSACTION
 INSERT INTO #Test_XACT_ON(COL1,COL2)
 VALUES(1,'A');
 INSERT INTO #Test_XACT_ON(COL1,COL2)
 VALUES(2,'B');
 INSERT INTO #Test_XACT_ON(COL1,COL2)
 VALUES(1,'C');
COMMIT TRANSACTION;
GO
--4
SELECT * FROM #Test_XACT_ON;
GO
--5 Isključit ćemo da vratimo default vrijednost
SET XACT_ABORT OFF

/*
	RAZNI ZADACI
*/

/*
	1. Koristeći podupit koji uključuje Sales.SalesOrderDetail tabelu, prikazati nazive proizvoda i njihovih ID-jeva iz tabele Production.Product, a koji su naručeni
*/
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID IN
(SELECT ProductID FROM Sales.SalesOrderDetail);

/*
	2. Koristeći prethodni query, prikazati proizvode koji nisu naručeni
*/

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID NOT IN (
 SELECT ProductID FROM Sales.SalesOrderDetail
 WHERE ProductID IS NOT NULL);

/*
	3. U bazi AdventureWorks2014 dodati novu tabelu Production.ProductColor u kojoj ćemo imati jedinstvene nazive boja svih proizvoda
*/

DROP TABLE IF EXISTS Production.ProductColor;
CREATE table Production.ProductColor
 (Color nvarchar(15) NOT NULL PRIMARY KEY);
GO

-- Unijeti jedinstvene vrijednosti
INSERT INTO Production.ProductColor
	SELECT DISTINCT Color
	FROM Production.Product
	WHERE Color IS NOT NULL and Color <> 'Silver';
GO

/*
	4. Napisati query koji kombinuje ModifiedDate iz tabele Person.Person i HireData iz tabele HumanResources.Employee koji neće vratiti duplikate
*/

SELECT ModifiedDate
FROM Person.Person
UNION
SELECT HireDate
FROM HumanResources.Employee;

/*
	5. Kreirati stored proceduru dbo.usp_CustomerTotals koja prikazuje ukupnu prodaju iz kolone TotalDue na godišnjem i mjesečnom nivou za svakog kupca.
*/

CREATE OR ALTER PROCEDURE dbo.usp_CustomerTotals AS
 SELECT C.CustomerID,
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	SUM(TotalDue) AS TotalSales
 FROM Sales.Customer AS C
	INNER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
 GROUP BY C.CustomerID, YEAR(OrderDate),
 MONTH(OrderDate)
GO

EXEC dbo.usp_CustomerTotals
GO

/*
	6. Modifikovati stored proceduru iz prethodnog zadatka tako da uključimo parametar @CustomerID u where uslov.
*/

CREATE OR ALTER PROCEDURE dbo.usp_CustomerTotals
 @CustomerID INT AS
 SELECT C.CustomerID,
	 YEAR(OrderDate) AS OrderYear,
	 MONTH(OrderDate) AS OrderMonth,
	 SUM(TotalDue) AS TotalSales
 FROM Sales.Customer AS C
	 INNER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
	 WHERE C.CustomerID = @CustomerID
 GROUP BY C.CustomerID,
 YEAR(OrderDate), MONTH(OrderDate)
GO

EXEC dbo.usp_CustomerTotals 17910
GO

/*
	7. Kreirati stored proceduru dbo.usp_ProductSales koja prima ProductID kao parametar, a kao OUTPUT vraća ukupan broj prodatih proizvoda iz tabele Sales.SalesOrderDetail
*/

CREATE OR ALTER PROCEDURE dbo.usp_ProductSales
 @ProductID INT,
 @TotalSold INT = NULL OUTPUT 
AS
 SELECT @TotalSold = SUM(OrderQty)
 FROM Sales.SalesOrderDetail
 WHERE ProductID = @ProductID;
GO

DECLARE @TotalSold INT;
EXEC dbo.usp_ProductSales @ProductID = 776, @TotalSold = @TotalSold OUTPUT
PRINT @TotalSold
GO

/*
	Napomena: Ostatak zadataka probajte riješiti sami, pa ćemo u sljedećoj sedmici u nadoknadi riješiti zajedno
*/