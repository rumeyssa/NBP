/*1. Iz tabele Order Details u bazi Northwind prikazati narud�be sa najmanjom i najve�om naru�enom koli�inom, ukupan broj narud�bi, ukupan broj naru�enih proizvoda, te srednju vrijednost naru�enih proizvoda.

USE NORTHWND
SELECT		MIN(Quantity) AS 'Minimalna narud�ba', 
		MAX(Quantity) AS 'Maksimalna narud�ba',
		COUNT(Quantity) AS 'Broj narud�bi',
		SUM(Quantity) AS 'Ukupan broj naru�enih proizvoda',
		AVG(Quantity) AS 'Sr. vrijednost broja naru�enih proizvoda'
FROM 	[Order Details]

--Rj: 		1		130		2155		51317			23

2. Iz tabele Order Details u bazi Northwind prikazati narud�be sa najmanjom i najve�om ukupnom nov�anom vrijedno��u.

USE NORTHWND
SELECT		MIN(Quantity * (UnitPrice-UnitPrice * Discount)) 
		AS 'Minimalna nov�ana vrijednost', 
		MAX(Quantity * (UnitPrice-UnitPrice * Discount))
		AS 'Maksimalna nov�ana vrijednost'
FROM 	[Order Details]

--Rj: 	4.8		15810

3. Iz tabele Order Details u bazi Northwind prikazati broj narud�bi sa odobrenim popustom.

USE NORTHWND
SELECT		COUNT(Quantity) AS 'Broj narud�bi sa odobrenim popustom' 
FROM 		[Order Details]
WHERE 		Discount > 0

--Rj: 838

4. Iz tabele Orders u bazi Northwind prikazati tro�ak prevoza ako je ve�i od 20000 za robu koja se kupila u Francuskoj, Njema�koj ili �vicarskoj. Rezultate prikazati po dr�avama.

USE NORTHWND
SELECT 		ShipCountry, SUM(Freight) AS TrosakPrevoza 
FROM 		Orders
WHERE 		ShipCountry IN ('France', 'Germany', 'Switzerland')
GROUP BY ShipCountry
HAVING 		SUM (Freight) > 1000

France			4237.84
Germany		11283.28
Switzerland		1368.53

5. Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod kojih ukupni tro�kovi prevoza nisu pre�li 7500 pri �emu se rezultat treba sortirati opadaju�im redoslijedom po visini tro�kova prevoza.

USE NORTHWND
SELECT 		CustomerID, SUM(Freight) AS PoKupcu 
FROM 		Orders
GROUP BY 	CustomerID
HAVING 		SUM (Freight) <= 7500
ORDER BY 2 DESC

--Rj: 89
*/