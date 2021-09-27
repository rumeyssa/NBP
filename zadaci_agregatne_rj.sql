/*1. Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najveæom naruèenom kolièinom, ukupan broj narudžbi, ukupan broj naruèenih proizvoda, te srednju vrijednost naruèenih proizvoda.

USE NORTHWND
SELECT		MIN(Quantity) AS 'Minimalna narudžba', 
		MAX(Quantity) AS 'Maksimalna narudžba',
		COUNT(Quantity) AS 'Broj narudžbi',
		SUM(Quantity) AS 'Ukupan broj naruèenih proizvoda',
		AVG(Quantity) AS 'Sr. vrijednost broja naruèenih proizvoda'
FROM 	[Order Details]

--Rj: 		1		130		2155		51317			23

2. Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najveæom ukupnom novèanom vrijednošæu.

USE NORTHWND
SELECT		MIN(Quantity * (UnitPrice-UnitPrice * Discount)) 
		AS 'Minimalna novèana vrijednost', 
		MAX(Quantity * (UnitPrice-UnitPrice * Discount))
		AS 'Maksimalna novèana vrijednost'
FROM 	[Order Details]

--Rj: 	4.8		15810

3. Iz tabele Order Details u bazi Northwind prikazati broj narudžbi sa odobrenim popustom.

USE NORTHWND
SELECT		COUNT(Quantity) AS 'Broj narudžbi sa odobrenim popustom' 
FROM 		[Order Details]
WHERE 		Discount > 0

--Rj: 838

4. Iz tabele Orders u bazi Northwind prikazati trošak prevoza ako je veæi od 20000 za robu koja se kupila u Francuskoj, Njemaèkoj ili Švicarskoj. Rezultate prikazati po državama.

USE NORTHWND
SELECT 		ShipCountry, SUM(Freight) AS TrosakPrevoza 
FROM 		Orders
WHERE 		ShipCountry IN ('France', 'Germany', 'Switzerland')
GROUP BY ShipCountry
HAVING 		SUM (Freight) > 1000

France			4237.84
Germany		11283.28
Switzerland		1368.53

5. Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod kojih ukupni troškovi prevoza nisu prešli 7500 pri èemu se rezultat treba sortirati opadajuæim redoslijedom po visini troškova prevoza.

USE NORTHWND
SELECT 		CustomerID, SUM(Freight) AS PoKupcu 
FROM 		Orders
GROUP BY 	CustomerID
HAVING 		SUM (Freight) <= 7500
ORDER BY 2 DESC

--Rj: 89
*/