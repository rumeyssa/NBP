
/*
	8. U tabelu HumanResources.Employee dodati novu kolonu BirthYear, gdje će biti pohranjena samo godina kada je Employee rođen
*/

-- 1 Koristeći DATEPART
ALTER TABLE HumanResources.Employee ADD BirthYear AS DATEPART(yyyy, BirthDate)
GO

-- 2 Koristeći YEAR
ALTER TABLE HumanResources.Employee ADD BirthYear AS YEAR(BirthDate)
GO

/*
	9. Napisati query koji prikazuje ukupan broj narudžbi za svaki proizvod. Koristiti tabelu Sales.SalesOrderDetail
*/

SELECT SUM(OrderQty) AS TotalOrdered, ProductID
FROM Sales.SalesOrderDetail
GROUP BY ProductID
GO

/*
	10. Napisati query koji prikazuje broj narudžbi po godinama za svakog kupca koristeći Sales.SalesOrderHeader tabelu
*/

SELECT CustomerID, COUNT(*) AS CountOfSales,
 YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, YEAR(OrderDate)

/*
VJEŽBA SVEGA
*/

/*
a) a) Kreirati bazu podataka da proizvoljnim nazivom
*/
create database indeks
use indeks

--omogućuje kreiranje dijagrama baze
alter authorization on database :: [AdventureWorks2014] to sa


/*
Prilikom kreiranja tabela voditi računa o međusobnom odnosu između tabela.
b) Kreirati tabelu radnik koja će imati sljedeću strukturu:
	radnikID, cjelobrojna varijabla, primarni ključ
	drzavaID, 15 unicode karaktera
	loginID, 30 unicode karaktera
	sati_god_odmora, cjelobrojna varijabla
	sati_bolovanja, cjelobrojna varijabla
*/
create table radnik
(
	radnikID int constraint PK_radnik primary key,
	drzavaID nvarchar (15),
	loginID nvarchar (30),
	sati_god_odmora int,
	sati_bolovanja int
)


/*
c) Kreirati tabelu kupovina koja će imati sljedeću strukturu:
	kupovinaID, cjelobrojna varijabla, primarni ključ
	status, cjelobrojna varijabla
	radnikID, cjelobrojna varijabla
	br_racuna, 15 unicode karaktera
	naziv_dobavljaca, 50 unicode karaktera
	kred_rejting, cjelobrojna varijabla
*/
create table kupovina
(
	kupovinaID int,
	status int,
	radnikID int, 
	br_racuna nvarchar (15),
	naziv_dobavljaca nvarchar (50),
	kred_rejting int,
	constraint PK_kupovina primary key (kupovinaID),
	constraint FK_kup_rad_radnikID foreign key (radnikID) references radnik (radnikID)
)

/*
d) Kreirati tabelu prodaja koja će imati sljedeću strukturu:
	prodavacID, cjelobrojna varijabla, primarni ključ
	prod_kvota, novčana varijabla
	bonus, novčana varijabla
	proslogod_prodaja, novčana varijabla
	naziv_terit, 50 unicode karaktera
*/
create table prodaja 
(
	prodavacID int constraint PK_prodaja primary key,
	prod_kvota money,
	bonus money,
	proslogod_prodaja money,
	naziv_terit nvarchar (50),
	constraint FK_prod_radn_prodavacID foreign key (prodavacID) references radnik (radnikID)
)



--2. Import podataka
/*
a) Iz tabela humanresources.employee baze AdventureWorks2014 u tabelu radnik importovati podatke po sljedećem pravilu:
	BusinessEntityID -> radnikID
	NationalIDNumber -> drzavaID
	LoginID -> loginID
	VacationHours -> sati_god_odmora
	SickLeaveHours -> sati_bolovanja
*/
insert into radnik
select	BusinessEntityID, NationalIDNumber, LoginID, VacationHours, SickLeaveHours
from	AdventureWorks2014.HumanResources.Employee


/*
b) Iz tabela purchasing.purchaseorderheader i purchasing.vendor baze AdventureWorks2014 u tabelu kupovina importovati podatke po sljedećem pravilu:
	PurchaseOrderID -> kupovinaID
	Status -> status
	EmployeeID -> radnikID
	AccountNumber -> br_racuna
	Name -> naziv_dobavljaca
	CreditRating -> kred_rejting
*/
insert into kupovina
select	poh.PurchaseOrderID, poh.Status, poh.EmployeeID,
		v.AccountNumber, v.Name, v.CreditRating
from	AdventureWorks2014.Purchasing.PurchaseOrderHeader poh 
		join AdventureWorks2014.Purchasing.Vendor v
on		v.BusinessEntityID = poh.VendorID


/*
c) Iz tabela sales.salesperson i sales.salesterritory baze AdventureWorks2014 u tabelu prodaja importovati podatke po sljedećem pravilu:
	BusinessEntityID -> prodavacID
	SalesQuota -> prod_kvota
	Bonus -> bonus
	SalesLastYear -> proslogod_prodaja
	Name -> naziv_terit
*/

--napomena:
--SalesLastYear se uzima iz tabele SalesTerritory

insert into prodaja
select	sp.BusinessEntityID, sp.SalesQuota, sp.Bonus, st.SalesLastYear, st.Name
from	AdventureWorks2014.Sales.SalesPerson sp 
		join AdventureWorks2014.Sales.SalesTerritory st
on		st.TerritoryID = sp.TerritoryID


--3.
/*
Iz tabela radnik i kupovina kreirati pogled view_drzavaID koji će imati sljedeću strukturu: 
	- naziv dobavljača,
	- drzavaID
Uslov je da u pogledu budu samo oni zapisi čiji ID države počinje ciframa u rasponu od 40 do 49, te da se kombinacije dobavljača i drzaveID ne ponavljaju.
*/
go
create view view_drzavaID
as
select	distinct k.naziv_dobavljaca, r.drzavaID
from	radnik r join kupovina k
on		r.radnikID = k.radnikID
where	LEFT (r.drzavaID, 2) between 40 and 49
go


--4.
/*
Koristeći tabele radnik i prodaja kreirati pogled view_klase_prihoda koji će sadržavati ID radnika, ID države, količnik prošlogodišnje prodaje i prodajne kvote, te oznaku klase koje će biti formirane prema pravilu: 
	- <10			- klasa 1 
	- >=10 i <20	- klasa 2 
	- >=20 i <30	- klasa 3
*/
go
create view view_klase_prihoda
as
select	r.radnikID, r.drzavaID, p.proslogod_prodaja / p.prod_kvota as kolicnik, 'klasa 1' as klasa
from	radnik r join prodaja p
on		r.radnikID = p.prodavacID
where	p.proslogod_prodaja / p.prod_kvota < 10
union
select	r.radnikID, r.drzavaID, p.proslogod_prodaja / p.prod_kvota as kolicnik, 'klasa 2' as klasa
from	radnik r join prodaja p
on		r.radnikID = p.prodavacID
where	p.proslogod_prodaja / p.prod_kvota >= 10 and p.proslogod_prodaja / p.prod_kvota < 20
union
select	r.radnikID, r.drzavaID, p.proslogod_prodaja / p.prod_kvota as kolicnik, 'klasa 3' as klasa
from	radnik r join prodaja p
on		r.radnikID = p.prodavacID
where	p.proslogod_prodaja / p.prod_kvota >= 20 and p.proslogod_prodaja / p.prod_kvota < 30
go



--5.
/*
Koristeći pogled view_klase_prihoda kreirati proceduru proc_klase_prihoda koja će prebrojati broj klasa. Procedura treba da sadrži naziv klase i ukupan broj pojavljivanja u pogledu view_klase_prihoda. Sortirati prema broju pojavljivanja u opadajućem redoslijedu.
*/
go
create procedure proc_klase_prihoda
as
begin
select	klasa, COUNT (*) as prebrojano
from	view_klase_prihoda
group by klasa
order by 2 desc
end

exec proc_klase_prihoda



--6.
/*
Koristeći tabele radnik i kupovina kreirati pogled view_kred_rejting koji će sadržavati kolone drzavaID, kreditni rejting i prebrojani broj pojavljivanja kreditnog rejtinga po ID države.
*/
go
create view view_kred_rejting
as
select	r.drzavaID, k.kred_rejting, COUNT (*) as prebrojano
from	radnik r join kupovina k
on		r.radnikID = k.radnikID
group by r.drzavaID, k.kred_rejting
go



--7.
/*
Koristeći pogled view_kred_rejting kreirati proceduru proc_kred_rejting koja će davati informaciju o najvećem prebrojanom broju pojavljivanja kreditnog rejtinga. Procedura treba da sadrži oznaku kreditnog rejtinga i najveći broj pojavljivanja za taj kreditni rejting. Proceduru pokrenuti za sve kreditne rejtinge (1, 2, 3, 4, 5). 
*/
go
create procedure proc_kred_rejting
(
	@kred_rejting int = null
)
as
begin
select	kred_rejting, MAX (prebrojano) as najveci
from	view_kred_rejting
where	kred_rejting = @kred_rejting
group by kred_rejting
end
go

exec proc_kred_rejting @kred_rejting = 5


--8.
/*
Kreirati tabelu radnik_nova i u nju prebaciti sve zapise iz tabele radnik. Nakon toga, svim radnicima u tabeli radnik_nova čije se ime u koloni loginID sastoji od 3 i manje slova, loginID promijeniti u slučajno generisani niz znakova.
*/
select *
into	radnik_nova
from	radnik

select loginID
from radnik_nova

select  LEN (loginID) - 1 - CHARINDEX ('\', loginID)
from	radnik_nova

update radnik_nova
set	loginID = left (NEWID (),30)
where LEN (loginID) - 1 - CHARINDEX ('\', loginID) <= 3

--9.
/*
a) Kreirati pogled view_sume koji će sadržavati sumu sati godišnjeg odmora i sumu sati bolovanja za radnike iz tabele radnik_nova kojima je loginID promijenjen u slučajno generisani niz znakova 
b) Izračunati odnos (količnik) sume bolovanja i sume godišnjeg odmora. Ako je odnos veći od 0.5 dati poruku 'Suma bolovanja je prevelika. Odnos iznosi: ______'. U suprotnom dati poruku 'Odnos je prihvaljiv i iznosi: _____'
*/
go
create view view_sume
as
select	SUM (sati_god_odmora) as god_od, SUM (sati_bolovanja) as bol
from	radnik_nova
where	LEN (loginID) = 30
--where	left (loginID, 3) <> 'adv'
--where	loginID not like 'adventure%'
go

select cast (1263 as real)/cast (1387 as real)

select	'Suma bolovanja je prevelika. Odnos iznosi: ' + cast (convert (real,bol)/god_od as nvarchar)
from	view_sume
where	convert (real,bol)/god_od > 0.5
union
select	'Odnos je prihvaljiv i iznosi: ' + cast (convert (real,bol)/god_od as nvarchar)
from	view_sume
where	convert (real,bol)/god_od <= 0.5


--10.
/*
a) Kreirati backup baze na default lokaciju.
b) Obrisati bazu.
c) Napraviti restore baze.
*/

backup database indeks
to disk = 'indeks.bak'

use master

alter database indeks
set offline

drop database indeks

restore database indeks 
from disk = 'indeks.bak'
with replace

/*
Kreirati bazu podataka BrojIndeksa sa sljedećim parametrima:
a) primarni i sekundarni data fajl:
- veličina: 		5 MB
- maksimalna veličina: 	neograničena
- postotak rasta:	10%
b) log fajl
- veličina: 		2 MB
- maksimalna veličina: 	neograničena
- postotak rasta:	5%
Svi fajlovi trebaju biti smješteni u folder c:\BP2\data\ koji je potrebno prethodno kreirati.
*/


CREATE DATABASE BrojIndeksa ON PRIMARY
--primarni data fajl
(
	NAME = 'BrojIndeksa',
	FILENAME = 'c:\BP2\data\BrojIndeksa.mdf',
	SIZE = 5 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
),

--sekundartni data fajl
(
	NAME = 'BrojIndeksa_sek',
	FILENAME = 'c:\BP2\data\BrojIndeksa_sek.ndf',
	SIZE = 5 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)

--log fajl
LOG ON
(
	NAME = 'BrojIndeksa_log',
	FILENAME = 'c:\BP2\log\BrojIndeksa_log.ldf',
	SIZE = 2 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 5%
)
GO