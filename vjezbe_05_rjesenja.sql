-- Pregled tabele Tecaj
USE Tecajevi
select * from Tecaj

-- Grupisanje (Broj tecajeva po kategorijama) GROUP BY 
USE Tecajevi
select KategorijaId, Count(*) as 'Broj te�ajeva'
from Tecaj
group by KategorijaId

-- Postavljanje uslova (broj tecajeva po kategorijama gdje je cijena ve�a od 400)
USE Tecajevi
select KategorijaId, Count(*) as 'Broj te�ajeva'
from Tecaj
where Cijena>400
group by KategorijaId

-- Broj tecajeva po kategorijama gdje je cijena ve�a od 400 uz uslov da je broj te�ajeva manji od 7
USE Tecajevi
select KategorijaId, Count(*) as 'Broj te�ajeva'
from Tecaj
where Cijena>400
group by KategorijaId
having Count(*)<7

-- Vrijednost NULL i grupisanje (jedan red u rezultatu je za NULL vrijednost)
SELECT Cijena, Count(*)
From Tecaj
group by Cijena


-------------------------------------------------------------------------------------------------------------------------
--4. Iz tabele Orders u bazi Northwind prikazati ukupni tro�ak prevoza ako je ve�i od 1000 za robu koja se kupila u Francuskoj, 
--Njema�koj ili �vicarskoj. Rezultate prikazati po dr�avama.
USE NORTHWND
--SELECT * FROM ORDERS
Select ShipCountry, SUM(Freight) as 'Tro�ak prevoza'
from Orders
where ShipCountry IN ('France', 'Germany', 'Switzerland')
group by ShipCountry
having SUM(Freight)>1000

--5. Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod kojih ukupni tro�kovi prevoza nisu pre�li
-- 7500 pri �emu se rezultat treba sortirati opadaju�im redoslijedom po visini tro�kova prevoza.
USE NORTHWND
SELECT CustomerID, SUM(Freight) as 'Ukupni tro�kovi prevoza'
FROM ORDERS
group by CustomerID
having SUM(Freight)<=7500
order by 2 DESC

----------------------------------------------------------------------
--6. Prebrojati kupce kod kojih ukupni tro�kovi prevoza nisu pre�li 7500. (kori�tenje podupita)


-----------------------------------------------------------------------
--vje�ba str.62
-----------------------------------------------------------------------

--1. Izra�unajte prosje�ni kapacitet u�ionice u kojoj se te�aj odr�ava. (Tablica Lokacija) 

USE Tecajevi
select Avg(BrojMjesta)
from Lokacija

--2. Izra�unajte ukupan kapacitet svih u�ionica zajedno. 
USE Tecajevi
select Sum(BrojMjesta)
from Lokacija

--3. Ispi�ite ukupan broj polaznika u tablici Polaznik. 
select Count(*) 
from Polaznik

--4. Ispi�ite ukupan broj polaznika �enskog spola. 
USE Tecajevi
SELECT Spol, COUNT(p.Id)
FROM Polaznik AS p
WHERE p.Spol = 'F'
group by Spol

--5. Izra�unajte prosje�nu dob polaznika (dob izra�unajte na temelju stupca DatumRodjenja).  
select Avg(DateDiff(Year,DatumRodjenja,GetDate()))
from Polaznik

--6. Grupirajte polaznike po spolu. Ispi�ite ukupan broj polaznika koji pripadaju pojedinom spolu. 
--Ispi�ite i prosje�nu dob polaznika koji pripadaju pojedinom spolu. 
select Spol, Count(*) as 'Ukupan broj polaznika', Avg(DateDiff(Year,DatumRodjenja,GetDate())) as 'Prosje�na dob'
from Polaznik
group by Spol

--7. Grupirajte polaznike po dobi. Ispi�ite ukupan broj polaznika za svaku dob. Poredajte rezultat po dobi (od najmanje do najve�e). 
use Tecajevi
select DateDiff(Year,DatumRodjenja,GetDate()) as 'Dob', Count(*) as 'Broj polaznika'
from Polaznik
group by DateDiff(Year,DatumRodjenja,GetDate())
order by 1 asc
--8. Grupirajte polaznike po spolu i po dobi. Ispi�ite ukupan broj polaznika za svaku grupu. 
select Spol, DateDiff(Year,DatumRodjenja,GetDate()) as 'Dob', Count(*) as 'Ukupan broj polaznika'
from Polaznik
group by Spol, DateDiff(Year,DatumRodjenja,GetDate())

--9. Grupirajte polaznike po ustanovi (stupac UstanovaId). Za svaku ustanovu ispi�ite broj polaznika i prosje�nu dob polaznika. 
--Poredajte rezultat po broju polaznika (od najve�eg prema najmanjem broju). 
USE Tecajevi
SELECT COUNT(p.Id), p.UstanovaId, avg(DATEDIFF(Year, p.DatumRodjenja, GetDate()))
FROM Polaznik AS p
GROUP BY p.UstanovaId
ORDER BY COUNT(p.Id) DESC


--10. Grupirajte polaznike po ustanovi. U rezultatu ispi�ite broj polaznika i prosje�nu dob. Umjesto identifikatora ustanove, u 
--rezultatu ispi�ite naziv ustanove. 
select Ustanova.Naziv, Count(*) as 'Broj polaznika', avg(DATEDIFF(Year, DatumRodjenja, GetDate())) as 'Prosje�na dob'
from Polaznik left join Ustanova
on Ustanova.Id=UstanovaId
group by Naziv
order by Count(*) DESC

--11. Za svaku godinu u kojoj su odr�ani te�ajevi, ispi�ite ukupan broj odr�anih te�ajeva. 
SELECT YEAR(Pocetak), COUNT(*)
FROM Odrzavanje
GROUP BY YEAR(Pocetak)
ORDER BY YEAR(Pocetak) ASC;

--12. Za svaku godinu u kojoj su odr�ani te�ajevi, ispi�ite ukupan broj polaznika. 
SELECT Year(Pocetak) as 'Godina odr�avanja', Count(*) as 'Broj polaznika'
FROM Pohadjanje left join Odrzavanje
on OdrzavanjeId=Odrzavanje.Id
group by Year(Pocetak)
ORDER BY YEAR(Pocetak) ASC;