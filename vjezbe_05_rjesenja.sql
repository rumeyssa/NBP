-- Pregled tabele Tecaj
USE Tecajevi
select * from Tecaj

-- Grupisanje (Broj tecajeva po kategorijama) GROUP BY 
USE Tecajevi
select KategorijaId, Count(*) as 'Broj teèajeva'
from Tecaj
group by KategorijaId

-- Postavljanje uslova (broj tecajeva po kategorijama gdje je cijena veæa od 400)
USE Tecajevi
select KategorijaId, Count(*) as 'Broj teèajeva'
from Tecaj
where Cijena>400
group by KategorijaId

-- Broj tecajeva po kategorijama gdje je cijena veæa od 400 uz uslov da je broj teèajeva manji od 7
USE Tecajevi
select KategorijaId, Count(*) as 'Broj teèajeva'
from Tecaj
where Cijena>400
group by KategorijaId
having Count(*)<7

-- Vrijednost NULL i grupisanje (jedan red u rezultatu je za NULL vrijednost)
SELECT Cijena, Count(*)
From Tecaj
group by Cijena


-------------------------------------------------------------------------------------------------------------------------
--4. Iz tabele Orders u bazi Northwind prikazati ukupni trošak prevoza ako je veæi od 1000 za robu koja se kupila u Francuskoj, 
--Njemaèkoj ili Švicarskoj. Rezultate prikazati po državama.
USE NORTHWND
--SELECT * FROM ORDERS
Select ShipCountry, SUM(Freight) as 'Trošak prevoza'
from Orders
where ShipCountry IN ('France', 'Germany', 'Switzerland')
group by ShipCountry
having SUM(Freight)>1000

--5. Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod kojih ukupni troškovi prevoza nisu prešli
-- 7500 pri èemu se rezultat treba sortirati opadajuæim redoslijedom po visini troškova prevoza.
USE NORTHWND
SELECT CustomerID, SUM(Freight) as 'Ukupni troškovi prevoza'
FROM ORDERS
group by CustomerID
having SUM(Freight)<=7500
order by 2 DESC

----------------------------------------------------------------------
--6. Prebrojati kupce kod kojih ukupni troškovi prevoza nisu prešli 7500. (korištenje podupita)


-----------------------------------------------------------------------
--vježba str.62
-----------------------------------------------------------------------

--1. Izraèunajte prosjeèni kapacitet uèionice u kojoj se teèaj održava. (Tablica Lokacija) 

USE Tecajevi
select Avg(BrojMjesta)
from Lokacija

--2. Izraèunajte ukupan kapacitet svih uèionica zajedno. 
USE Tecajevi
select Sum(BrojMjesta)
from Lokacija

--3. Ispišite ukupan broj polaznika u tablici Polaznik. 
select Count(*) 
from Polaznik

--4. Ispišite ukupan broj polaznika ženskog spola. 
USE Tecajevi
SELECT Spol, COUNT(p.Id)
FROM Polaznik AS p
WHERE p.Spol = 'F'
group by Spol

--5. Izraèunajte prosjeènu dob polaznika (dob izraèunajte na temelju stupca DatumRodjenja).  
select Avg(DateDiff(Year,DatumRodjenja,GetDate()))
from Polaznik

--6. Grupirajte polaznike po spolu. Ispišite ukupan broj polaznika koji pripadaju pojedinom spolu. 
--Ispišite i prosjeènu dob polaznika koji pripadaju pojedinom spolu. 
select Spol, Count(*) as 'Ukupan broj polaznika', Avg(DateDiff(Year,DatumRodjenja,GetDate())) as 'Prosjeèna dob'
from Polaznik
group by Spol

--7. Grupirajte polaznike po dobi. Ispišite ukupan broj polaznika za svaku dob. Poredajte rezultat po dobi (od najmanje do najveæe). 
use Tecajevi
select DateDiff(Year,DatumRodjenja,GetDate()) as 'Dob', Count(*) as 'Broj polaznika'
from Polaznik
group by DateDiff(Year,DatumRodjenja,GetDate())
order by 1 asc
--8. Grupirajte polaznike po spolu i po dobi. Ispišite ukupan broj polaznika za svaku grupu. 
select Spol, DateDiff(Year,DatumRodjenja,GetDate()) as 'Dob', Count(*) as 'Ukupan broj polaznika'
from Polaznik
group by Spol, DateDiff(Year,DatumRodjenja,GetDate())

--9. Grupirajte polaznike po ustanovi (stupac UstanovaId). Za svaku ustanovu ispišite broj polaznika i prosjeènu dob polaznika. 
--Poredajte rezultat po broju polaznika (od najveæeg prema najmanjem broju). 
USE Tecajevi
SELECT COUNT(p.Id), p.UstanovaId, avg(DATEDIFF(Year, p.DatumRodjenja, GetDate()))
FROM Polaznik AS p
GROUP BY p.UstanovaId
ORDER BY COUNT(p.Id) DESC


--10. Grupirajte polaznike po ustanovi. U rezultatu ispišite broj polaznika i prosjeènu dob. Umjesto identifikatora ustanove, u 
--rezultatu ispišite naziv ustanove. 
select Ustanova.Naziv, Count(*) as 'Broj polaznika', avg(DATEDIFF(Year, DatumRodjenja, GetDate())) as 'Prosjeèna dob'
from Polaznik left join Ustanova
on Ustanova.Id=UstanovaId
group by Naziv
order by Count(*) DESC

--11. Za svaku godinu u kojoj su održani teèajevi, ispišite ukupan broj održanih teèajeva. 
SELECT YEAR(Pocetak), COUNT(*)
FROM Odrzavanje
GROUP BY YEAR(Pocetak)
ORDER BY YEAR(Pocetak) ASC;

--12. Za svaku godinu u kojoj su održani teèajevi, ispišite ukupan broj polaznika. 
SELECT Year(Pocetak) as 'Godina održavanja', Count(*) as 'Broj polaznika'
FROM Pohadjanje left join Odrzavanje
on OdrzavanjeId=Odrzavanje.Id
group by Year(Pocetak)
ORDER BY YEAR(Pocetak) ASC;