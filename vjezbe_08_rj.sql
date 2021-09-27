/*
1. Kreirati bazu podataka publikacije
*/
create database publikacije
use publikacije
/*
2. Uvažavajuæi DIJAGRAM uz definiranje primarnih i vanjskih kljuèeva, te veza (relationship) izmeðu tabela, kreirati sljedeæe tabele:

a) autor
	-	autor_ID		cjelobrojna vrijednost	primarni kljuè
	-	autor_ime		15 unicode karaktera	
	-	autor_prezime	20 unicode karaktera	
	-	grad_autora_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	
*/
create table autor
(		
	autor_ID int,
	autor_ime nvarchar(15),
	autor_prezime nvarchar(20),
	grad_autora_ID	int,
	spol char(1),
	constraint PK_autor_ID primary key (autor_ID),
	constraint FK_grad_autora_ID foreign key (grad_autora_ID) references grad (grad_ID)
)
/*
b) citalac
	-	citalac_ID		cjelobrojna vrijednost	primarni kljuè
	-	citalac_ime		15 unicode karaktera	
	-	citalac_prezime	20 unicode karaktera	
	-	grad_citaoca_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	
*/
create table citalac
(		
	citalac_ID int,
	citalac_ime nvarchar(15),
	citalac_prezime nvarchar(20),
	grad_citaoca_ID	int,
	spol char(1),
	constraint PK_citalac_ID primary key (citalac_ID),
	constraint FK_grad_citaoca_ID foreign key (grad_citaoca_ID) references grad (grad_ID)
)
/*

c) forma_publikacije
	-	forma_pub_ID	cjelobrojna vrijednost	primarni kljuè
	-	forma_pub_naziv	15 unicode karaktera
	-	max_duz_zadrz	cjelobrojna vrijednost
*/
create table forma_publikacije
(		
	forma_pub_ID int,
	forma_pub_naziv nvarchar(15),
	max_duz_zadrz int,
	constraint PK_forma_pub_ID primary key (forma_pub_ID),
)
/*
d) grad
	-	grad_ID			cjelobrojna vrijednost	primarni kljuè
	-	naziv_grada		15 unicode karaktera
*/
create table grad
(		
	grad_ID int,
	naziv_grada nvarchar(15),
	constraint PK_grad_ID primary key (grad_ID),
)
/*
e) iznajmljivanje
	-	pub_ID			cjelobrojna vrijednost	primarni kljuè
	-	citalac_ID		cjelobrojna vrijednost	primarni kljuè
	-	dtm_podizanja	datumska vrijednost		primarni kljuè
	-	dtm_vracanja	datumska vrijednost
	-	br_dana_zadr	cjelobrojna vrijednost
*/
create table iznajmljivanje
(		
	pub_ID int,
	citalac_ID int,
	dtm_podizanja date,
	dtm_vracanja date,
	br_dana_zadr int,
	constraint PK_iznajmljivanje primary key (pub_ID, citalac_ID, dtm_podizanja),
	constraint FK_citalac_ID foreign key (citalac_ID) references citalac (citalac_ID)
)
/*
f) izdavac
	-	izdavac_ID			cjelobrojna vrijednost	primarni kljuè
	-	grad_izdavaca_ID	cjelobrojna vrijednost
	-	naziv_izdavaca		15 unicode karaktera
*/
create table izdavac
(
	izdavac_ID int,
	grad_izdavaca_ID int,
	naziv_izdavaca nvarchar(15),
	constraint PK_izdavac primary key (izdavac_ID),
	constraint FK_grad_izdavaca_ID foreign key (grad_izdavaca_ID) references grad (grad_ID)
)
/*
g) autor_pub
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	autor_ID		cjelobrojna vrijednost		primarni kljuè
*/
create table autor_pub
(
	pub_ID int,
	autor_ID int,
	constraint PK_autor_pub primary key (pub_ID, autor_ID),
	constraint FK_autor_ID foreign key (autor_ID) references autor (autor_ID)
)
/*

h) publikacija
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	naziv_pub		15 unicode karaktera	
	-	vrsta_pub_ID	cjelobrojna vrijednost	
	-	izdavac_ID		cjelobrojna vrijednost	
	-	zanr_ID			cjelobrojna vrijednost	
	-	cijena			decimalna vrijednost oblika 5 - 2	
	-	ISBN			13 unicode karaktera	
*/
create table publikacija
(
	pub_ID int,
	naziv_pub nvarchar(15),
	vrsta_pub_ID int,
	izdavac_ID int,
	zanr_ID int,
	cijena decimal(5, 2),
	ISBN nvarchar(13),
	constraint PK_pub_ID primary key (pub_ID),
	constraint FK_izdavac_ID foreign key (izdavac_ID) references izdavac (izdavac_ID),
)
/*
i) zanr
	-	zanr_ID			cjelobrojna vrijednost		primarni kljuè
	-	zanr_naziv		15 unicode karaktera
*/
create table zanr
(
	zanr_ID int,
	zanr_naziv nvarchar(15),
	constraint PK_zanr_ID primary key (zanr_ID)
)

--dodati ostale strane ključeve za zadaću

/*
3. Kreirati bazu podataka pozoriste.
*/

/*
4. Uvažavajuæi DIJAGRAM uz definiranje primarnih i vanjskih kljuèeva, te veza (relationship) izmeðu tabela, kreirati sljedeæe tabele:

a) glumac
	-	zaposlenikID	10 unicode karaktera		primarni kljuè
	-	predstava_ID	cjelobrojna vrijednost		primarni kljuè
	-	vrsta_uloge_ID	cjelobrojna vrijednost
	
b) izvodjenje
	-	izvodjenjeID		cjelobrojna vrijednost	primarni kljuè
	-	predstava_ID		cjelobrojna vrijednost
	-	datum_izvodjenja	datumska vrijednost
	-	termin_izvodjenja	vremenska vrijednost
	-	br_gledatelja		cjelobrojna vrijednost

c) predstava
	-	predstava_ID		cjelobrojna vrijednost	primarni kljuè
	-	naziv_predstave		20 unicode karaktera
	-	duz_trajanja_pred	cjelobrojna vrijednost
	-	vrsta_predstave_ID	cjelobrojna vrijednost

d) reditelj
	-	zaposlenikID	10 unicode karaktera		primarni kljuè
	-	predstava_ID	cjelobrojna vrijednost		primarni kljuè

e) rekvizit
	-	rekvizit_ID	10 unicode karaktera		primarni kljuè
	-	predstava_ID	cjelobrojna vrijednost		primarni kljuè

f) vrsta_predstave
	-	vrsta_predstave_ID	cjelobrojna vrijednost	primarni kljuè
	-	naziv_vrste_pred	15 unicode karaktera
	
g) vrsta_uloge
	-	vrsta_uloge_ID		cjelobrojna vrijednost	primarni kljuè
	-	naziv_vrste_uloge	15 unicode karaktera


h) zaposlenik
	-	zaposlenikID		10 unicode karaktera	primarni kljuè
	-	datum_zaposlenja	datumska vrijednost
	-	dtm_raskida_ugovora	datumska vrijednost
*/

--NORTHWND
/* 1
Koristeći tabele Orders i Order Details kreirati upit koji će dati sumu količina po Order ID, pri čemu je uslov:
a) da je vrijednost Freighta veća od bilo koje vrijednosti Freighta narudžbi realiziranih u 12. mjesecu 1997. godine
b) da je vrijednost Freighta veća od svih vrijednosti Freighta narudžbi realiziranih u 12. mjesecu 1997. godine
*/
use NORTHWND
--a_1
SELECT Orders.OrderID, SUM(Quantity)
FROM Orders
         LEFT OUTER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
WHERE Freight > (SELECT MIN(Freight) FROM Orders WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 12)
GROUP BY Orders.OrderID;

--a_2
SELECT	OrderID,
		(select SUM ([Order Details].Quantity) from [Order Details] 
		where Orders.OrderID = [Order Details].OrderID) as suma
FROM	Orders
WHERE	Freight > any
		(SELECT	Freight
		FROM	Orders
		WHERE	month (Orders.OrderDate) = 12 and YEAR (Orders.OrderDate) = 1997)
ORDER BY 2

--b_1
SELECT Orders.OrderID, (SELECT SUM(Quantity) FROM [Order Details] O WHERE O.OrderID = Orders.OrderID
    GROUP BY O.OrderID) AS 'Suma'
FROM Orders
WHERE Freight > (SELECT MAX(Freight) FROM Orders WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 12)
GROUP BY Orders.OrderID;

--b_2
SELECT	OrderID,
		(select SUM ([Order Details].Quantity) from [Order Details] 
		where Orders.OrderID = [Order Details].OrderID) as suma
FROM	Orders
WHERE	Freight > all
		(SELECT	Freight
		FROM	Orders
		WHERE	month (Orders.OrderDate) = 12 and YEAR (Orders.OrderDate) = 1997)
ORDER BY 2

--AdventureWorks2014

/* 2 
Koristeći tabele Production.Product i Production.WorkOrder kreirati upit sa podupitom koji će dati sumu OrderQty po nazivu proizvoda. 
pri čemu se izostavljaju zapisi u kojima je suma NULL vrijednost. Upit treba da sadrži naziv proizvoda i sumu po nazivu.
*/
use AdventureWorks2014
--rj 1
SELECT Production.Product.Name, (SELECT SUM(OrderQty) FROM Production.WorkOrder P WHERE P.ProductID = Production.Product.ProductID
    GROUP BY P.ProductID) AS 'Suma' 
FROM Production.Product
WHERE (SELECT SUM(OrderQty) FROM Production.WorkOrder P WHERE P.ProductID = Production.Product.ProductID
    GROUP BY P.ProductID) IS NOT NULL;

--rj 2
select	Production.Product.Name,
		ukupno =	(select SUM (OrderQty) from Production.WorkOrder
					where Production.Product.ProductID = Production.WorkOrder.ProductID)
from Production.Product
where	(select SUM (OrderQty) from Production.WorkOrder
		where Production.Product.ProductID = Production.WorkOrder.ProductID) is not null
order by 1

--rj. 3
select	Production.Product.Name, 
		ukupno =	(select SUM (OrderQty) from Production.WorkOrder 
					where Production.Product.ProductID = Production.WorkOrder.ProductID
					having SUM (OrderQty) is not null)
from Production.Product
where exists		(select ProductID, SUM (OrderQty) from Production.WorkOrder 
					where Production.Product.ProductID = Production.WorkOrder.ProductID
					group by ProductID
					having SUM (OrderQty) is not null)
order by 2
/* 3
Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail kreirati upit sa podupitom koji će prebrojati CarrierTrackingNumber po SalesOrderID, 
pri čemu se izostavljaju zapisi čiji AccountNumber ne spada u klasu 10-4030. Upit treba da sadrži SalesOrderID i prebrojani broj.
*/
select * from sales.SalesOrderHeader
SELECT SalesOrderID,
       (SELECT COUNT(CarrierTrackingNumber)
        FROM Sales.SalesOrderDetail S
        WHERE S.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID) AS 'BROJ'
FROM Sales.SalesOrderHeader
WHERE AccountNumber LIKE '10-4030%'
order by 1;

select	SalesOrderID,	
		(select COUNT (CarrierTrackingNumber) from Sales.SalesOrderDetail 
		where Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID) as broj
from Sales.SalesOrderHeader
where LEFT (AccountNumber,7) = '10-4030'
order by 1
/* 4
Koristeći tabele Sales.SpecialOfferProduct i Sales.SpecialOffer kreirati upit sa podupitom koji će prebrojati broj proizvoda po kategorijama koji su u 2014. godini 
bili na specijalnoj ponudi pri čemu se izostavljaju one kategorije kod kojih ne postoji ni jedan proizvod koji nije bio na specijalnoj ponudi.
*/
select * from Sales.SpecialOfferProduct
select * from sales.SpecialOffer

select sales.SpecialOffer.Category, 
	(select count(*) from sales.SpecialOfferProduct 
	where sales.SpecialOffer.SpecialOfferID=sales.SpecialOfferProduct.SpecialOfferID
	and year(Sales.SpecialOfferProduct.ModifiedDate)=2014)
from sales.SpecialOffer
where (select count(*) from sales.SpecialOfferProduct 
	where sales.SpecialOffer.SpecialOfferID=sales.SpecialOfferProduct.SpecialOfferID
	and year(Sales.SpecialOfferProduct.ModifiedDate)=2014)<>0
order by 1


--AdventureWorks2014
/* 5
Koristeći tabele SpecialOfferProduct i SpecialOffer prebrojati broj narudžbi po kategorijama popusta od 0 do 15%, 
pri čemu treba uvesti novu kolona kategorija u koju će biti unijeta vrijednost popusta, npr. 0, 1, 2... 
Rezultat sortirati prema koloni kategorija u rastućem redoslijedu. Upit treba da vrati kolone: SpecialOfferID, prebrojani broj i kategorija.
*/
select sop.SpecialOfferID, COUNT(*) as ukupno, 0 as kategorija
from Sales.SpecialOfferProduct sop join sales.SpecialOffer so on sop.SpecialOfferID=so.SpecialOfferID
where so.DiscountPct=0
group by sop.SpecialOfferID

union

select sop.SpecialOfferID, COUNT(*) as ukupno, 2 as kategorija
from Sales.SpecialOfferProduct sop join sales.SpecialOffer so on sop.SpecialOfferID=so.SpecialOfferID
where so.DiscountPct=0.02
group by sop.SpecialOfferID

union

select sop.SpecialOfferID, COUNT(*) as ukupno, 5 as kategorija
from Sales.SpecialOfferProduct sop join sales.SpecialOffer so on sop.SpecialOfferID=so.SpecialOfferID
where so.DiscountPct=0.05
group by sop.SpecialOfferID

union

select sop.SpecialOfferID, COUNT(*) as ukupno, 10 as kategorija
from Sales.SpecialOfferProduct sop join sales.SpecialOffer so on sop.SpecialOfferID=so.SpecialOfferID
where so.DiscountPct=0.1
group by sop.SpecialOfferID

union

select sop.SpecialOfferID, COUNT(*) as ukupno, 15 as kategorija
from Sales.SpecialOfferProduct sop join sales.SpecialOffer so on sop.SpecialOfferID=so.SpecialOfferID
where so.DiscountPct=0.15
group by sop.SpecialOfferID
order by 3

--rj 2
select o.SpecialOfferID, cast((o.DiscountPct * 100) as int) as kategorija , 
	(select count(p.SpecialOfferID) from Sales.SpecialOfferProduct as p 
	where p.SpecialOfferID = o.SpecialOfferID 
	group by p.SpecialOfferID) as prebrojani_broj
from Sales.SpecialOffer as o
where o.DiscountPct <= 0.15
order by o.Category

/* 6
Koristeći tabele Sales.Store i Sales.Customer kreirati upit kojim će se prebrojati koliko kupaca po teritorijama pokriva prodavac. 
Rezultat sortirati prema prodavcu i teritoriji. 
*/
SELECT TerritoryID, Sales.Store.SalesPersonID, 
	COUNT(*) FROM Sales.Store LEFT OUTER JOIN Sales.Customer C on Store.BusinessEntityID = C.StoreID
GROUP BY TerritoryID, Sales.Store.SalesPersonID
ORDER BY Sales.Store.SalesPersonID, COUNT(*);
/* 7
Koristeći kolonu AccountNumber tabele Sales.Customer prebrojati broj zapisa prema broju cifara brojčanog dijela podatka iz ove kolone. 
Rezultat sortirati u rastućem redoslijedu.
*/
select * from sales.Customer
--rj 1
SELECT LEN(CAST(RIGHT(AccountNumber, LEN(AccountNumber)-2) AS INTEGER)), COUNT(LEN(CAST(RIGHT(AccountNumber, LEN(AccountNumber)-2) AS INTEGER))) FROM Sales.Customer
GROUP BY LEN(CAST(RIGHT(AccountNumber, LEN(AccountNumber)-2) AS INTEGER))
order by 1;

--rj 2
select len (cast 
		(substring (AccountNumber, CHARINDEX ('W',AccountNumber) +1, 
		LEN (AccountNumber) - CHARINDEX ('W',AccountNumber)) as int))
		, COUNT (*)
from Sales.Customer
group by len (cast 
		(substring (AccountNumber, CHARINDEX ('W',AccountNumber) +1, 
		LEN (AccountNumber) - CHARINDEX ('W',AccountNumber)) as int))
order by 1

--JOIN
--AdventureWorks2014

--omogućuje kreiranje dijagrama baze
alter authorization on database :: [AdventureWorks2014] to sa
/* 8
Koristeći tabele Person.Address, Sales.SalesOrderDetail i Sales.SalesOrderHeader kreirati upit koji će dati
 sumu naručenih količina po gradu i godini isporuke koje su izvršene poslije 2012. godine.
*/

select	PA.City, year (SOH.ShipDate), SUM (SOD.OrderQty)
from	Person.Address as PA join Sales.SalesOrderHeader as SOH
on		PA.AddressID = SOH.ShipToAddressID
		join Sales.SalesOrderDetail as SOD
		on SOH.SalesOrderID = SOD.SalesOrderID
where	YEAR (SOH.ShipDate) > 2012
group by PA.City, year (SOH.ShipDate)

/* 9
Koristeći tabele Sales.Store, Sales.SalesPerson i SalesPersonQuotaHistory kreirati upit koji će dati sumu 
prodajnih kvota po nazivima prodavnica i ID teritorija, ali samo onih čija je suma veća od 2000000. 
Sortirati po ID teritorije i sumi.
*/
select s.Name, sales.salesperson.TerritoryID, 
		sum(sales.SalesPersonQuotaHistory.salesquota) as kvota
FROM Sales.SalesPersonQuotaHistory
         LEFT OUTER JOIN Sales.SalesPerson ON SalesPersonQuotaHistory.BusinessEntityID = SalesPerson.BusinessEntityID
        LEFT OUTER JOIN Sales.Store S on SalesPerson.BusinessEntityID = S.SalesPersonID
GROUP BY S.Name, TerritoryID
HAVING SUM(SalesPerson.SalesQuota) > 2000000;
 
/* 10
Koristeći tabele Person.Person, Person.PersonPhone, Person.PhoneNumberType i Person.Password kreirati upit kojim će se dati informacija da li PasswordHash sadrži bar jedan +. Ako sadrži u koloni status_hash dati poruku "da", inače ostaviti prazn0. Upit treba da sadrži kolone Person.Person.PersonType, Person.PersonPhone.PhoneNumber, Person.PhoneNumberType.Name, Person.Password.PasswordHash.
*/
--rj 1
SELECT PersonType, PhoneNumber, Name, PasswordHash,
       (CASE
            WHEN PasswordHash LIKE '%+%' THEN 'Da'
            ELSE ''
        END) AS 'status_hash'
FROM Person.Person
         LEFT JOIN Person.PersonPhone PP on Person.BusinessEntityID = PP.BusinessEntityID
         LEFT JOIN Person.PhoneNumberType ON PP.PhoneNumberTypeID = PhoneNumberType.PhoneNumberTypeID
         LEFT JOIN Person.Password ON Person.BusinessEntityID = Password.BusinessEntityID;

--rj 2
SELECT        Person.Person.PersonType, Person.PersonPhone.PhoneNumber, Person.PhoneNumberType.Name, Person.Password.PasswordHash, 'da' status_hash
FROM            Person.Password INNER JOIN
                         Person.Person ON Person.Password.BusinessEntityID = Person.Person.BusinessEntityID INNER JOIN
                         Person.PersonPhone ON Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID INNER JOIN
                         Person.PhoneNumberType ON Person.PersonPhone.PhoneNumberTypeID = Person.PhoneNumberType.PhoneNumberTypeID
where	CHARINDEX ('+', Person.Password.PasswordHash) > 0
union
SELECT        Person.Person.PersonType, Person.PersonPhone.PhoneNumber, Person.PhoneNumberType.Name, Person.Password.PasswordHash, ' ' status_hash
FROM            Person.Password INNER JOIN
                         Person.Person ON Person.Password.BusinessEntityID = Person.Person.BusinessEntityID INNER JOIN
                         Person.PersonPhone ON Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID INNER JOIN
                         Person.PhoneNumberType ON Person.PersonPhone.PhoneNumberTypeID = Person.PhoneNumberType.PhoneNumberTypeID
where	CHARINDEX ('+', Person.Password.PasswordHash) = 0

/* 11
Koristeći tabele HumanResources.Employee i HumanResources.EmployeeDepartmentHistory kreirati upit koji će dati pregled ukupno ostaverenih bolovanja po departmentu, pri čemu će se uzeti u obzir samo one osobe čiji nacionalni broj počinje ciframa 10, 20, 80 ili 90.
*/

SELECT DepartmentID, SUM(VacationHours)
FROM HumanResources.Employee
         LEFT JOIN HumanResources.EmployeeDepartmentHistory EDH on Employee.BusinessEntityID = EDH.BusinessEntityID
WHERE LEFT(NationalIDNumber, 2) IN (10, 20, 80, 90)
GROUP BY DepartmentID;


/* 12
Koristeći tabele Purchasing.PurchaseOrderHeader, Purchasing.Vendor, Purchasing.PurchaseOrderDetail i Purchasing.ShipMethod kreirati upit koji će sadržavati kolone VendorID, Name vendora, EmployeeID, ShipDate, ShipBase i UnitPrice, uz uslov da je UnitPrice veća od ShipBase.
*/

SELECT	Purchasing.PurchaseOrderHeader.VendorID, 
		Purchasing.Vendor.Name, Purchasing.PurchaseOrderHeader.EmployeeID,
		Purchasing.PurchaseOrderHeader.ShipDate, Purchasing.ShipMethod.ShipBase, 
		Purchasing.PurchaseOrderDetail.UnitPrice
FROM	Purchasing.PurchaseOrderDetail INNER JOIN Purchasing.PurchaseOrderHeader 
ON		Purchasing.PurchaseOrderDetail.PurchaseOrderID = Purchasing.PurchaseOrderHeader.PurchaseOrderID 
		INNER JOIN Purchasing.ShipMethod 
		ON Purchasing.PurchaseOrderHeader.ShipMethodID = Purchasing.ShipMethod.ShipMethodID 
			INNER JOIN Purchasing.Vendor 
			ON Purchasing.PurchaseOrderHeader.VendorID = Purchasing.Vendor.BusinessEntityID
where	Purchasing.PurchaseOrderDetail.UnitPrice > Purchasing.ShipMethod.ShipBase


/* 13
Koristeći tabele Person.Person, Sales.PersonCreditCard i Person.Password kreirati upit koji će da vrati polja BusinessEntityID, PersonType, CreditCardID i PasswordSalt.
*/
SELECT        Person.Person.BusinessEntityID, Person.Person.PersonType, Sales.PersonCreditCard.CreditCardID, Person.Password.PasswordHash, Person.Password.PasswordSalt
FROM            Person.Password INNER JOIN
                         Person.Person ON Person.Password.BusinessEntityID = Person.Person.BusinessEntityID INNER JOIN
                         Sales.PersonCreditCard ON Person.Person.BusinessEntityID = Sales.PersonCreditCard.BusinessEntityID

/* 14
Koristeći tabele  Production.ProductModelProductDescriptionCulture, Production.ProductModel i Production.Product kreirati upit koji će vratiti polja CultureID, Name iz tabele Production.ProductModel, Name iz tabele Production.Product i Color, te prebrojani broj po koloni Color. Uslov je da se ne prikazuju upiti u kojima nije unijeta vrijednost za CatalogDescription iz tabele Production.ProductModel.
*/

SELECT        Production.ProductModelProductDescriptionCulture.CultureID, Production.ProductModel.Name, Production.ProductModel.CatalogDescription, Production.Product.Name AS Expr1, Production.Product.Color, COUNT (*)
FROM            Production.Product INNER JOIN
                         Production.ProductModel ON Production.Product.ProductModelID = Production.ProductModel.ProductModelID INNER JOIN
                         Production.ProductModelProductDescriptionCulture ON Production.ProductModel.ProductModelID = Production.ProductModelProductDescriptionCulture.ProductModelID
						 where Production.ProductModel.CatalogDescription is not null

/* 15
Koristeći tabelu Production.Product kreirati upit koji će prebrojati broj zapisa iza tabele po bojama. Navesti i broj zapisa u kojima nije unijeta vrijednost za boju i dati poruku "nije unijeta vrijednost".
*/

SELECT	Color, COUNT (*), ''
FROM	Production.Product
where	Color = 'Red'
group by Color
union 
SELECT	Color, COUNT (*), ''
FROM	Production.Product
where	Color = 'Yellow'
group by Color
union
SELECT	Color, COUNT (*), ''
FROM	Production.Product
where	Color = 'Black'
group by Color
union
SELECT	Color, COUNT (*), 'nije'
FROM	Production.Product
where	Color is null 
group by Color


select *
from Production.Product