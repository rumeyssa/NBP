--------------------
--POGLEDI
--------------------
use Tecajevi
--Kreirajte pogled Student koji će odabrati sve kolone iz tabele Polaznik gdje je TipId=1
CREATE VIEW Student AS
SELECT *
FROM Polaznik
WHERE TipId=1

--Kreirajte pogled Raspored koji će imati kolone: TecajId, PredavacId, LokacijaId, naziv tečaja, šifra
--tečaja, početak održavanja, broj dana tečaja, broj sati po danu, naziv lokacije gdje se održava tečaj.
--Tabele: Održavanje, Tečaj, Lokacija
CREATE VIEW RASPORED AS
SELECT O.TecajId, O.PredavacId, O.LokacijaId, T.Naziv AS NazivTecaja, T.Sifra, O.Pocetak, T.BrojDana, T.BrojSatiPoDanu, L.Naziv AS NazivLokacije
FROM Tecaj as T
LEFT JOIN Odrzavanje as O
ON T.Id = O.TecajId
LEFT JOIN Lokacija AS L
ON O.LokacijaId = L.Id

--Pregled pogleda Raspored
SELECT * FROM RASPORED

--Ispis rasporeda za mjesec januar 2015. godine
SELECT * FROM RASPORED
WHERE Month(Pocetak)=1 and Year(Pocetak)=2015

--Ispis rasporeda uz dodatak imena i prezimena predavača iz tabele Predavac.
SELECT RASPORED.*, Ime, Prezime
FROM RASPORED INNER JOIN Predavac ON PredavacId=Predavac.Id
--rj 2
SELECT RASPORED.*, Ime + ' ' + Prezime AS Predavac
FROM RASPORED INNER JOIN Predavac ON PredavacId=Predavac.Id

--Brisanje pogleda, ključna riječ DROP VIEW
DROP VIEW RASPORED

-------------
--INDEKSI
-------------
CREATE INDEX Indeks_PolaznikId
ON Pohadjanje(PolaznikId)

SELECT * FROM Pohadjanje WHERE PolaznikId=99

CREATE INDEX Indeks_PredavacId_TecajId
ON Odrzavanje(PredavacId, TecajId)

SELECT * FROM Odrzavanje WHERE PredavacId=10 and TecajId=25

--Brisanje indeksa
DROP INDEX Indeks_PolaznikId
ON Pohadjanje
-----------------------------
--POGLEDI (ZADACI)
-----------------------------
--northwind
/* 1
Koristeći tabele Employees, EmployeeTerritories, Territories i Region baze Northwind kreirati pogled view_Employee koji će sadržavati prezime i ime uposlenika kao polje ime i prezime, 
teritoriju i regiju koju pokrivaju. Uslov je da su stariji od 30 godina i pokrivaju terirotiju Western.
*/
CREATE VIEW view_Employee AS
SELECT	E.LastName + ' ' + E.FirstName AS 'prezime i ime', T.TerritoryDescription, R.RegionDescription, DATEDIFF(YEAR, E.BirthDate, GETDATE()) AS 'broj godina'
FROM Employees AS E INNER JOIN EmployeeTerritories AS ET ON	E.EmployeeID = ET.EmployeeID
INNER JOIN Territories AS T ON ET.TerritoryID = T.TerritoryID
INNER JOIN Region AS R ON T.RegionID = R.RegionID
WHERE	DATEDIFF(YEAR, E.BirthDate, GETDATE()) > 30 AND  R.RegionDescription = 'Western'
/* 2
Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee2 
koji će sadržavati ime uposlenika i ukupnu vrijednost svih narudžbi koje je taj uposlenik 
napravio u 1997. godini ako je ukupna vrijednost veća od 50000, pri čemu će se rezultati sortirati 
uzlaznim redoslijedom prema polju ime.
*/
select * from view_Employee2

CREATE VIEW view_Employee2 AS
SELECT top 10 E.FirstName, SUM (ROUND((OD.UnitPrice-OD.Discount*OD.UnitPrice)*OD.Quantity,2)) AS 'ukupno'
FROM		Employees AS E INNER JOIN Orders AS O
ON			E.EmployeeID = O.EmployeeID
INNER JOIN	[Order Details] AS OD
ON			O.OrderID = OD.OrderID
WHERE		O.OrderDate BETWEEN '1/1/1997' AND '12/31/1997'
GROUP BY 	E.FirstName
HAVING		SUM ((OD.UnitPrice-OD.Discount*OD.UnitPrice)*OD.Quantity)>50000
/* 3
Koristeći tabele Orders i Order Details kreirati pogled koji će sadržavati polja: 
Orders.EmployeeID, [Order Details].ProductID i suma po UnitPrice.
*/
create view view_suma as 
SELECT	Orders.EmployeeID, [Order Details].ProductID, SUM([Order Details].UnitPrice) AS suma
FROM	[Order Details] INNER JOIN Orders 
ON		[Order Details].OrderID = Orders.OrderID
GROUP BY Orders.EmployeeID, [Order Details].OrderID, [Order Details].ProductID
go

/* 4
Koristeći prethodno kreirani pogled izvršiti ukupno sumiranje po uposlenicima. 
Sortirati po ID uposlenika.
*/
select EmployeeID, SUM (suma)
from view_suma
group by EmployeeID
order by 1
/* 5
Koristeći tabele Categories, Products i Suppliers kreirati pogled koji će sadržavati polja: 
CategoryName, ProductName i CompanyName. 
*/
CREATE VIEW zadatak5 AS
SELECT CategoryName, ProductName, CompanyName
FROM Categories
         JOIN Products P on Categories.CategoryID = P.CategoryID
         JOIN Suppliers S on P.SupplierID = S.SupplierID;
/* 6
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kompanijama. 
Sortirati po nazivu kompanije.
*/
SELECT CompanyName, COUNT(ProductName)
FROM zadatak5
GROUP BY CompanyName
order by 1;
/* 7
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kategorijama. 
Sortirati po nazivu kompanije.
*/
SELECT CategoryName, COUNT(ProductName)
FROM zadatak5
GROUP BY CategoryName
order by 1;
/* 8
Koristeći bazu Northwind kreirati pogled view_supp_ship koji će sadržavati polja: 
Suppliers.CompanyName, Suppliers.City i Shippers.CompanyName. 
*/
CREATE VIEW view_supp_ship AS
SELECT Suppliers.CompanyName, Suppliers.City, Shippers.CompanyName AS 'Shipper'
FROM Suppliers
         LEFT JOIN Products P on Suppliers.SupplierID = P.SupplierID
         LEFT JOIN [Order Details] ON P.ProductID = [Order Details].ProductID
         LEFT JOIN Orders ON [Order Details].OrderID = Orders.OrderID
         LEFT JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID;
/* 9
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj kompanija po prevoznicima.
*/
SELECT Shipper, COUNT(CompanyName)
FROM view_supp_ship
GROUP BY Shipper;
/* 10
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj prevoznika po kompanijama. 
Uslov je da se prikažu one kompanije koje su imale ili ukupan broj prevoza manji od 30 ili veći od 150. 
Upit treba da sadrži naziv kompanije, prebrojani broj prevoza i napomenu "nizak promet" za kompanije 
ispod 30 prevoza, odnosno, "visok promet" za kompanije preko 150 prevoza. 
Sortirati prema vrijednosti ukupnog broja prevoza.
*/
--rj 1
SELECT CompanyName,
       COUNT(Shipper),
       (CASE
            WHEN COUNT(Shipper) < 30 THEN 'Nizak promet'
            ELSE 'Visok promet' END) AS 'Napomena'
FROM view_supp_ship
GROUP BY CompanyName
HAVING COUNT(Shipper) < 30
    OR COUNT(Shipper) > 150
ORDER BY COUNT(Shipper);

--rj 2
select CompanyName, COUNT(*) br_prevoza, 'nizak' napomena
from view_supp_ship
group by CompanyName
having COUNT(*) < 30
union 
select CompanyName, COUNT(*) br_prevoza, 'visok' napomena
from view_supp_ship
group by CompanyName
having COUNT(*) > 150
order by 2

/* 11
Koristeći tabele Products i Order Details kreirati pogled view_prod_price koji će sadržavati 
naziv proizvoda i sve cijene po kojima se prodavao. 
*/
CREATE VIEW view_prod_price AS
SELECT DISTINCT ProductName, OD.UnitPrice * (1 - Discount) AS 'Cijena'
FROM Products
         LEFT JOIN [Order Details] OD on Products.ProductID = OD.ProductID;
/* 12
Koristeći pogled view_prod_price dati pregled srednjih vrijednosti cijena proizvoda.
*/
SELECT ProductName, ROUND(AVG(Cijena), 2) FROM view_prod_price
GROUP BY ProductName;
/* 13
Koristeći tabele Orders i Order Details kreirati pogled view_ord_quan koji će sadržavati ID uposlenika i vrijednosti količina bez ponavljanja koje je isporučio pojedini uposlenik.
*/
CREATE VIEW view_ord_quan AS
SELECT DISTINCT EmployeeID, Quantity
FROM Orders
         LEFT JOIN [Order Details] OD on Orders.OrderID = OD.OrderID;
/* 14
Koristeći pogled view_ord_quan dati pregled srednjih vrijednosti količina po uposlenicima proizvoda.
*/
SELECT EmployeeID, AVG(Quantity) FROM view_ord_quan
GROUP BY EmployeeID;
/* 15
Koristeći tabele Categories, Products i Suppliers kreirati tabelu kat_prod_komp koja će sadržavati 
polja: CategoryName, ProductName i CompanyName. 
*/
SELECT CategoryName, ProductName, CompanyName
INTO kat_prod_komp
FROM Categories
         LEFT JOIN Products P on Categories.CategoryID = P.CategoryID
         LEFT JOIN Suppliers S on P.SupplierID = S.SupplierID;
/* 16
Koristeći tabele Orders i Customers kreirati pogled view_ord_cust koji će sadržavati ID uposlenika, 
Customers.CompanyName i Customers.City.
*/
CREATE VIEW view_ord_cust AS
SELECT EmployeeID, CompanyName, City
FROM Orders
         LEFT JOIN Customers C on C.CustomerID = Orders.CustomerID;
/* 17
Koristeći pogled view_ord_cust kreirati upit kojim će se prebrojati sa koliko različitih kupaca je 
uposlenik ostvario saradnju.
*/
SELECT EmployeeID, COUNT(DISTINCT CompanyName) AS 'Broj saradnji'
FROM view_ord_cust
GROUP BY EmployeeID;

-----------------------
--Rad sa objektima
-----------------------
use AdventureWorks2014;
--AdventureWorks2014 > Security > Schemas 

/*1. 
a) Kreirati šemu vjezba. U okviru baze AdventureWorks kopirati tabele Sales.Store, Sales.Customer, 
Sales.SalesTerritoryHistory i Sales.SalesPerson 
u tabele istih naziva a koje će biti u šemi vjezba. Nakon kopiranja u novim tabelama definisati iste PK i FK 
kojima su definisani odnosi među tabelama.
*/
create schema vjezba
go

select *
into vjezba.Store
from Sales.Store

SELECT * INTO vjezba.Customer FROM Sales.Customer;
SELECT * INTO vjezba.SalesTerritoryHistory FROM Sales.SalesTerritoryHistory;
SELECT * INTO vjezba.SalesPerson FROM Sales.SalesPerson;

select * from vjezba.Store

-----------------PK
alter table vjezba.Store
add constraint PK_Store primary key (BusinessEntityID)

alter table vjezba.Customer
add constraint PK_Customer primary key (CustomerID)

alter table vjezba.SalesTerritoryHistory
add constraint PK_SalesTerritoryHistory primary key (BusinessEntityID, TerritoryID, StartDate)

alter table vjezba.SalesPerson
add constraint PK_SalesPerson primary key (BusinessEntityID)

--------------------------FK
alter table vjezba.Customer
add constraint FK_Customer_Store_storeID foreign key (StoreID) references vjezba.Store(BusinessEntityID)

alter table vjezba.Store
add constraint FK_SalesPerson_Store_SalesPersonID foreign key (SalesPersonID) references vjezba.SalesPerson (BusinessEntityID)

alter table vjezba.SalesTerritoryHistory
add constraint FK_SalesPerson_SalesTerritoryHistory_BusinessEntityID foreign key (BusinessEntityID) references vjezba.SalesPerson (BusinessEntityID)

/*
b) Definisati sljedeća ograničenja (prva dva samo za tabele Customer i SalesPerson): 
	1. ModifiedDate kolone - defaultna vrijednost je aktivni datum  
	2. rowguid - defaultna vrijednost slučajno generisani niz znakova
	3. SalesQuota u tabeli SalesPerson - defaultna vrijednost 0.00
									   - zabrana unosa vrijednost manje od 0.00
	4. EndDate u tabeli SalesTerritoryHistory - zabrana unosa starijeg datuma od StartDate
*/

--ModifiedDate, rowguid
alter table vjezba.Customer
add constraint DF_ModifiedDate_c default (getdate()) for ModifiedDate

alter table vjezba.Customer
add constraint DF_rowguid_c default (newid()) for rowguid

--modifieddate, rowguid
alter table vjezba.SalesPerson
add constraint DF_ModifiedDate_S default (getdate()) for ModifiedDate

alter table vjezba.SalesPerson
add constraint DF_rowguid_s default (newid()) for rowguid

--salesquota
alter table vjezba.SalesPerson
add constraint DF_SalesQuota default (0.00) for SalesQuota

alter table vjezba.SalesPerson
add constraint CK_SalesQuota check (SalesQuota >= 0.00)


--EndDate
alter table vjezba.SalesTerritoryHistory
add constraint CK_SalesTerritoryHistory_EndDate check (EndDate >= StartDate)

/*
c) Dodati tabele u dijagram
*/

/*2.
U tabeli vjezba.Customer:
a) dodati stalno pohranjenu kolonu godina koja će preuzimati godinu iz kolone ModifiedDate
b) ograničiti dužinu kolone rowguid na 10 znakova, a zatim postaviti defaultnu vrijednost na 10 slučajno 
generisanih znakova
c) obrisati PK tabele (i constraint i kolonu), a zatim definirati kolonu istog naziva koja će biti identity 
sa početnom vrijednošću 1 i inkrementom 2
d) izvršiti insert podataka iz tabele Sales.Customer
e) kreirati upit za prikaz zapisa u kojima je StoreID veći od 500, a zatim pokrenuti upit 
sa uključenim vremenom i planom izvršavanja
f) nad kolonom StoreID kreirati nonclustered indeks, 
a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
g) kreirati upit za prikaz zapisa u kojima je TerritoryID veći od 1, a zatim pokrenuti upit 
sa uključenim vremenom i planom izvršavanja
h) nad kolonom TerritoryID kreirati nonclustered indeks, a zatim pokrenuti upit sa uključenim 
vremenom i planom izvršavanja
*/
--a
ALTER TABLE vjezba.Customer
    ADD godina AS YEAR(ModifiedDate);

--b
alter table vjezba.Customer
drop constraint DF_rowguid_c

alter table vjezba.Customer
alter column rowguid char(40)

update vjezba.Customer
set rowguid = LEFT (rowguid, 10)

alter table vjezba.Customer
add constraint CK_Lenrowguid check (len(rowguid)=10)

alter table vjezba.Customer
add constraint DF_rowguid default (left(newid(),10)) for rowguid

--c
alter table vjezba.Customer
drop constraint PK_Customer

alter table vjezba.Customer
drop column CustomerID

alter table vjezba.Customer
add CustomerID int identity(1,2) constraint PK_Customer primary key (CustomerID)

--d
insert into vjezba.Customer
select PersonID, StoreID, TerritoryID, AccountNumber, left(rowguid,10), ModifiedDate
from Sales.Customer

--e
set statistics time on;
go 
select * from vjezba.Customer
where StoreID > 500
order by StoreID
go
set statistics time off;
go
/*
parse - provjera sintakse
compile - optimizer za kreiranje optimalnog plana izvršenja
CPU time - vrijeme zauzeća procesora
elapsed time - zbir parse i compile
razlika CPU i elapsed - vrijeme čekanja da CPU obradi upit ili
						vrijeme izvršavanja IO operacija
ponavljanjem upita elapsed time se smanjuje (dolazi do 0 nakon dovoljnog broja ponavljanja) jer je server zapamtio compile postavke i ne obavlja parse
*/

--f)
--nad kolonom StoreID kreirati nonclustered indeks, 
--a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
create nonclustered index IX_store_id
on vjezba.Customer(StoreID)
set statistics time on;
go 
select * from vjezba.Customer
where StoreID > 500
order by StoreID
go
set statistics time off;
go

----------------ostatak za zadaću, provjeriti statistiku prije i poslije kreiranja indeksa
--g
set statistics time on
select CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, godina
from vjezba.Customer
where TerritoryID > 1 
order by TerritoryID
set statistics time off

--h
create nonclustered index IX_TerritoryID
on vjezba.Customer (TerritoryID)

set statistics time on
select CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, godina
from vjezba.Customer
where TerritoryID > 1 
order by TerritoryID
set statistics time off

drop index IX_TerritoryID on vjezba.Customer

/*
parse - provjera sintakse
compile - optimizer za kreiranje optimalnog plana izvršenja
CPU time - vrijeme zauzeća procesora
elapsed time - zbir parse i compile
razlika CPU i elapsed - vrijeme čekanja da CPU obradi upit ili
						vrijeme izvršavanja IO operacija
ponavljanjem upita elapsed time se smanjuje (dolazi do 0 nakon dovoljnog broja ponavljanja) jer je server zapamtio compile postavke i ne obavlja parse
*/

--3.
/*
northwind
Koristeći tabele Order Details i Products kreirati upit kojim će se dati prikaz naziva proizvoda, jedinične cijene i količine uz uslov da se 
prikažu samo oni proizvodi koji počinju slovima A ili C. Uključiti prikaz vremena i plana izvršavanja.
*/

set statistics time on;
go 
SELECT Products.ProductName, [Order Details].UnitPrice, [Order Details].Quantity
FROM [Order Details] INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
where Products.ProductName like '[AC]%';
go
set statistics time off;
go

--4.
/*
northwind
Koristeći tabele Order i Customers kreirati upit kojim će se dati prikaz naziva kompanije, poštanskog broja, datuma narudžbe i datuma isporuke uz uslov da se 
prikažu samo oni proizvodi za koje je razlika OrderDate i ShippedDate pozitivna. Uključiti prikaz vremena i plana izvršavanja.
*/
set statistics time on;
GO
SELECT Customers.CompanyName, Customers.PostalCode, Orders.OrderDate, Orders.ShippedDate
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
where day (Orders.OrderDate) - day (Orders.ShippedDate) > 0;
GO
set statistics time off;
GO