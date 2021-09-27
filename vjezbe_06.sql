-- Operacije nad skupovima, tj. nad rezultatima upita:
-- UNIJA (bez ponavljanja), UNIJA (sa ponavljanjima), PRESJEK, RAZLIKA

/* 
1. Unija (bez ponavljanja)
Broj kolona u oba upita mora biti jednak. Obratiti pažnju na tipove podataka
*/
SELECT Ime, Prezime
FROM Predavac
UNION
SELECT Ime, Prezime
FROM Polaznik
ORDER BY Prezime

--2. Unija (sa ponavljanjima)
SELECT Ime, Prezime
FROM Predavac
UNION ALL
SELECT Ime, Prezime
FROM Polaznik
ORDER BY Ime

--3. Presjek
SELECT Ime, Prezime
FROM Predavac
INTERSECT
SELECT Ime, Prezime
FROM Polaznik
ORDER BY Ime

--4. Razlika
SELECT Ime, Prezime
FROM Predavac
EXCEPT
SELECT Ime, Prezime
FROM Polaznik
ORDER BY Ime


SELECT Ime, Prezime
FROM Polaznik
EXCEPT
SELECT Ime, Prezime
FROM Predavac

-------------------------------------------
--PODUPITI
-------------------------------------------
--1. U SELECT-U, tj. u listi za odabir
SELECT Ime, Prezime, (SELECT COUNT(*) FROM Odrzavanje WHERE Predavac.Id=PredavacId) AS Ukupno
FROM Predavac

--2. U uslovu WHERE
--Ispisati sve tečajeve čija je cijena veća od prosječne
SELECT *
FROM Tecaj
WHERE Cijena > (SELECT AVG(Cijena) FROM Tecaj)

--Svi predavači koji su održali bar jedan tečaj u 2015. (Koristiti operator IN)
SELECT *
FROM Predavac
WHERE Id IN (SELECT PredavacId FROM Odrzavanje WHERE YEAR(Pocetak) = 2015)

--Nisu održali ni jedan u 2015.
SELECT *
FROM Predavac
WHERE Id NOT IN (SELECT PredavacId FROM Odrzavanje WHERE YEAR(Pocetak) = 2015)

--Prikazati one odjele u kojima je zaposlen bar jedan predavač (EXISTS)
SELECT *
FROM Odjel
WHERE EXISTS (SELECT * FROM Predavac where Odjel.Id=OdjelId)

--3. Kao tabelu, tj. u klauzuli FROM ili JOIN

--NULL vrijednosti
SELECT * FROM Lokacija

SELECT *
FROM Tecaj
WHERE MinimalnoPolaznika < ALL (SELECT BrojMjesta FROM Lokacija WHERE BrojMjesta IS NOT NULL)

---------------------
--ZADACI str.80
---------------------
--1. Uz svaku lokaciju ispišite broj održavanja tečajeva na toj lokaciji.
select * from Lokacija
SELECT Id, Naziv, (SELECT Count(*) FROM Odrzavanje WHERE Lokacija.Id=LokacijaId) AS 'Broj održavanja'
FROM Lokacija
WHERE NadredjenaLokacijaId IS NOT NULL

--2. Ispišite sve lokacije na kojima su održavani tečajevi
SELECT *
FROM Lokacija
WHERE Id IN (SELECT LokacijaId FROM Odrzavanje)

--3. Uz svaki tečaj ispišite broj puta koliko je tečaj održan.
SELECT Id, Naziv, (SELECT Count(*) FROM Odrzavanje WHERE Tecaj.Id=TecajId) as 'Broj održavanja'
FROM Tecaj

--4. Uz svaki tečaj ispišite ukupan broj polaznika koji su pohađali taj tečaj.
SELECT Naziv, (SELECT Count(*) FROM Odrzavanje join Pohadjanje on Odrzavanje.Id=OdrzavanjeId where Tecaj.Id=TecajId) as 'Broj polaznika'
FROM Tecaj

/* 5.	Ispišite naziv teèaja i datum održavanja za sva održavanja na kojima je bilo prisutno više od minimalnog broja polaznika. */
SELECT Naziv, Pocetak
FROM Tecaj join Odrzavanje on Tecaj.Id=Odrzavanje.TecajId
join Pohadjanje on Pohadjanje.OdrzavanjeId=Pohadjanje.Id
WHERE Tecaj.MinimalnoPolaznika < (SELECT Count(*) FROM Dolazak where Prisutan=1 and Dolazak.PohadjanjeId=Pohadjanje.Id)

/* 6.	Ispišite polaznike koji su pohaðali više od 2 teèaja. */
SELECT Ime, Prezime, 
		(SELECT Count(Distinct TecajId)
		FROM Odrzavanje inner join Pohadjanje on Odrzavanje.Id=Pohadjanje.OdrzavanjeId 
		where Pohadjanje.PolaznikId=Polaznik.Id) AS BrojPohadjanja
FROM Polaznik
where (SELECT Count(Distinct TecajId)
		FROM Odrzavanje inner join Pohadjanje on Odrzavanje.Id=Pohadjanje.OdrzavanjeId 
		where Pohadjanje.PolaznikId=Polaznik.Id) > 2

/* 7.	Ispišite polaznike koji nemaju niti jedan izostanak. 
(Prisutnost se bilježi pomoæu stupca Prisutan u tablici Dolazak). */
SELECT Ime, Prezime
FROM Polaznik
WHERE NOT EXISTS (SELECT * FROM Pohadjanje inner join Dolazak on Pohadjanje.Id=PohadjanjeId 
					where PolaznikId=Polaznik.Id and Prisutan=0)

/* 8.	Ispišite teèajeve èija je prosjeèna ocjena veæa od 4,10. */
Select Naziv, (SELECT AVG(CAST(OcjenaTecaja as decimal)) 
				FROM Pohadjanje inner join Odrzavanje 
				on OdrzavanjeId=Odrzavanje.Id
				where Odrzavanje.TecajId=Tecaj.Id) AS ProsjecnaOcjena
FROM Tecaj
WHERE (SELECT AVG(CAST(OcjenaTecaja as decimal)) 
				FROM Pohadjanje inner join Odrzavanje 
				on OdrzavanjeId=Odrzavanje.Id
				where Odrzavanje.TecajId=Tecaj.Id) > 4.1

/* 9.	Uz svaki teèaj ispišite broj godina u kojima se teèaj održava. */
SELECT Naziv, (SELECT Count(Distinct Year(Pocetak)) from Odrzavanje 
				where TecajId=Tecaj.Id) as BrojGodina
FROM Tecaj

/* 10.	Napravite uniju izmeðu tablice Ustanova i onih redaka iz tablice Lokacija za koje je stupac NadredjenaLokacijaId jednak NULL.
Napravite i uniju s ponavljanjem i usporedite dobiveni broj redaka. */
SELECT Naziv
FROM Ustanova
UNION
SELECT Naziv
FROM Lokacija
WHERE NadredjenaLokacijaId is null

SELECT Naziv
FROM Ustanova
UNION ALL
SELECT Naziv
FROM Lokacija
WHERE NadredjenaLokacijaId is null

--northwind
/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti razlika između:
a) minimalne i maksimalne vrijednosti UnitPrice.
b) maksimalne i srednje vrijednosti UnitPrice
*/
--a
select max(UnitPrice)-min(UnitPrice)
from [Order Details]
--b
select max(UnitPrice)-avg(UnitPrice)
from [Order Details]
/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti srednje vrijednosti UnitPrice po narudžbama.
*/
SELECT OrderID, AVG(UnitPrice) AS 'Prosjecna vrijednost'
FROM [Order Details]
GROUP BY OrderID;
/*
Koristeći tabelu Order Details kreirati upit kojim će se prebrojati broj narudžbi kojima je UnitPrice:
a) za 20 KM veća od minimalne vrijednosti UniPrice
b) za 10 KM manja od maksimalne vrijednosti UniPrice
*/
SELECT Count(*)
FROM [Order Details]
WHERE UnitPrice = (SELECT MIN(UnitPrice)+20 FROM [Order Details])

--b
SELECT Count(*)
FROM [Order Details]
WHERE UnitPrice = (SELECT MAX(UnitPrice)-10 FROM [Order Details])
/*
Koristeći tabelu Order Details kreirati upit kojim će se dati pregled zapisa kojima se UnitPrice 
nalazi u rasponu od +10 KM u odnosu na minimum, kao donje granice i -10 u odnosu na maksimum kao gornje granice. 
Upit traba da sadrži OrderID.
*/
SELECT OrderID, UnitPrice
FROM [Order Details]
WHERE UnitPrice BETWEEN (SELECT MIN(UnitPrice)+10 FROM [Order Details]) AND 
					(SELECT MAX(UnitPrice)-10 FROM [Order Details])
ORDER BY 2 DESC
/*
Koristeći tabelu Orders kreirati upit kojim će se prebrojati broj naručitelja 
kojima se Freight nalazi u rasponu od 10 KM u odnosu na srednju vrijednost Freighta. 
Upit traba da sadrži CustomerID i ukupan broj po CustomerID.
*/
SELECT CustomerID, Count(*)
FROM Orders
WHERE Freight between (select avg(Freight) -10 from Orders) and 
						(select avg(Freight) +10 from Orders)
GROUP BY CustomerID

select * from Orders
/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled 
ukupnih količina ostvarenih po OrderID.
*/
SELECT OrderID, (SELECT SUM(Quantity) from [Order Details] 
				where [Order Details].OrderID=Orders.OrderID) as UkupnaKolicina
FROM Orders

/*
Koristeći tabele Orders i Employees kreirati upit kojim će se dati pregled ukupno 
realiziranih narudžbi po uposleniku.
Upit treba da sadrži prezime i ime uposlenika, te ukupan broj narudžbi.
*/
SELECT LastName, FirstName, 
	(SELECT COUNT(*) FROM Orders WHERE Employees.EmployeeID = Orders.EmployeeID) 
FROM Employees

/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled narudžbi 
kupca u kojima je naručena količina veća od 10.
Upit treba da sadrži CustomerID, OrderID i Količinu.
*/
SELECT CustomerID, OrderID, (SELECT SUM(Quantity) FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID) FROM Orders
WHERE (SELECT SUM(Quantity) FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID) > 10


/*
Koristeći tabelu Products kreirati upit kojim će se dati pregled proizvoda kojima je stanje na stoku 
veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži ProductName i UnitsInStock.
*/

SELECT ProductName, UnitsInStock
FROM Products
WHERE UnitsInStock > (SELECT AVG(UnitsInStock) FROM Products);

/*
Koristeći tabelu Products kreirati upit kojim će se prebrojati broj proizvoda po dobavljaču kojima je stanje na stoku 
veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži SupplierID i ukupan broj proizvoda.
*/
SELECT SupplierID,
       (SELECT COUNT(*)
        FROM Products
        WHERE Suppliers.SupplierID = Products.SupplierID
          AND UnitsInStock > (SELECT AVG(UnitsInStock) FROM Products)) AS 'Product count'
FROM Suppliers;
/*
Iz tabele Order Details baze Northwind dati prikaz ID narudžbe, ID proizvoda, jedinične cijene i srednje vrijednosti, te razliku cijene proizvoda u odnosu na srednju vrijednost cijene za sve proizvode u tabeli. 
Rezultat sortirati prema vrijednosti razlike u rastućem redoslijedu.*/


/*
Iz tabele Products baze Northwind za sve proizvoda kojih ima na stanju dati prikaz ID proizvoda, naziv proizvoda, stanje zaliha i srednju vrijednost, te razliku stanja zaliha proizvoda u odnosu na srednju vrijednost stanja za sve proizvode u tabeli. 
Rezultat sortirati prema vrijednosti razlike u opadajućem redoslijedu.*/


/*
Upotrebom tabela Orders i Order Details baze Northwind prikazati ID narudžbe i kupca koji je kupio više od 10 komada proizvoda čiji je ID 15.*/

/*
Upotrebom tabela sales i stores baze pubs prikazati ID i naziv prodavnice u kojoj je naručeno više od 1 komada publikacije čiji je ord_num 6871.
*/
