--PODUPITI
/*
1. Iz tabele Order Details baze Northwind dati prikaz ID narudžbe, ID proizvoda, jedinične cijene i srednje vrijednosti, 
te razliku cijene proizvoda u odnosu na srednju vrijednost cijene za sve proizvode u tabeli. 
Rezultat sortirati prema vrijednosti razlike u rastućem redoslijedu.*/
use NORTHWND
select OrderID, ProductID, UnitPrice,
		(select avg(UnitPrice) from [Order Details]) as 'Srednja vrijednost',
		(UnitPrice - (select avg(UnitPrice) from [Order Details])) as Razlika
from [Order Details]
order by 5

--"prosjecna cijena jednog tipa proizvoda"
select o.OrderID, o.ProductID, o.UnitPrice,
	(select avg(UnitPrice) from [Order Details] where ProductID=o.ProductID) as Avg, o.UnitPrice - (select avg(UnitPrice) from [Order Details] where ProductID=o.ProductID) as Difference
from [Order Details] as o
order by (select avg(UnitPrice) from [Order Details] where ProductID=o.ProductID)

/*
2. Iz tabele Products baze Northwind za sve proizvoda kojih ima na stanju dati prikaz ID proizvoda, naziv proizvoda, stanje zaliha i srednju vrijednost, 
te razliku stanja zaliha proizvoda u odnosu na srednju vrijednost stanja za sve proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike u opadajućem redoslijedu.*/
use NORTHWND
select	ProductID, ProductName, UnitsInStock,
		(select avg(UnitsInStock) from Products) as srednja,
		 UnitsInStock - (select avg(UnitsInStock) from Products) as razlika
from	Products
order by 5 desc

/*
3. Upotrebom tabela Orders i Order Details baze Northwind prikazati ID narudžbe i kupca koji je kupio više od 10 komada proizvoda čiji je ID 15.*/
select OrderID, CustomerID
from Orders
where (select Quantity from [Order Details]
		where [Order Details].OrderID = Orders.OrderID and
		[Order Details].ProductID = 15) > 10
	
/*
4. Upotrebom tabela sales i stores baze pubs prikazati ID i naziv prodavnice u kojoj je naručeno 
više od 1 komada publikacije čiji je ord_num 6871.
*/
use pubs
select stor_id, stor_name 
from stores
where (select qty from sales where sales.stor_id=stores.stor_id and sales.ord_num='6871')>1

--JOIN
/*
1. Iz tabela discounts i stores baze pubs prikazati naziv popusta, ID i naziv prodavnice
*/
SELECT d.discounttype, s.stor_id, s.stor_name
FROM discounts d JOIN stores s
ON d.stor_id = s.stor_id

/*
2. Iz tabela employee i jobs baze pubs prikazati ID i ime uposlenika, ID posla i naziv posla koji obavlja*/
SELECT emp_id, fname, lname, J.job_id, J.job_desc 
FROM employee E JOIN jobs J 
ON E.job_id = J.job_id;

/*
3. Iz tabela Employees, EmployeeTerritories, Territories i Region baze Northwind prikazati prezime i ime uposlenika 
kao polje ime i prezime, teritorije i regiju koju pokrivaju i stariji su od 30 godina.*/
USE NORTHWND
SELECT LastName + ' ' + FirstName AS 'Ime i prezime', TerritoryDescription, RegionDescription
FROM Employees E
         LEFT JOIN EmployeeTerritories ET on E.EmployeeID = ET.EmployeeID
         LEFT JOIN Territories T on ET.TerritoryID = T.TerritoryID
         JOIN Region R2 on T.RegionID = R2.RegionID
WHERE DATEDIFF(year, E.BirthDate, GETDATE()) > 30;

/*
4. Iz tabela Employees, Order Details i Orders baze Northwind prikazati ime i prezime uposlenika kao polje ime i prezime, 
jediničnu cijenu, količinu i izračunatu vrijednost pojedinačne narudžbe kao polje izracunato za sve narudžbe u 1997. godini, 
pri čemu će se rezultati sortirati prema novokreiranom polju izracunato.*/
SELECT (e.FirstName + ' ' + e.LastName) as 'ime i prezime', od.UnitPrice, od.Quantity, ((od.UnitPrice * od.Quantity)*(1-od.Discount)) as izracunato
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEPART(YEAR, o.OrderDate) = 1997
ORDER BY izracunato

/*
5. Iz tabela Employee, Order Details i Orders baze Northwind prikazati ime uposlenika i ukupnu vrijednost svih narudžbi 
koje je taj uposlenik napravio u 1996. godini ako je ukupna vrijednost veća od 50000, 
pri čemu će se rezultati sortirati uzlaznim redoslijedom prema polju ime. Vrijednost sume zaokružiti na dvije decimale.*/

SELECT FirstName + ' ' + LastName AS 'Ime uposlenika', ROUND(SUM((1-Discount)*UnitPrice * Quantity), 2)
FROM Employees E
         LEFT JOIN Orders O on E.EmployeeID = O.EmployeeID
         LEFT JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(OrderDate) = 1996
GROUP BY E.EmployeeID, FirstName, LastName
HAVING ROUND(SUM((1-Discount)*UnitPrice * Quantity), 2) > 50000
ORDER BY 1

--Bez discounta
select	Employees.FirstName,
		ROUND (SUM ([Order Details].UnitPrice * [Order Details].Quantity),2) 
		as ukupno
from	Employees join Orders
on		Employees.EmployeeID = Orders.EmployeeID
		inner join [Order Details]
		on Orders.OrderID = [Order Details].OrderID
where	YEAR (Orders.OrderDate) = 1996
group by Employees.FirstName
having	SUM ([Order Details].UnitPrice * [Order Details].Quantity) > 50000 
order by 1

/*
6.Iz tabela Categories, Products i Suppliers baze Northwind prikazati naziv isporučitelja (dobavljača), 
mjesto i državu isporučitelja (dobavljača) i naziv(e) proizvoda iz kategorije napitaka (pića) 
kojih na stanju ima više od 30 jedinica. Rezultat upita sortirati po državi.
*/
SELECT CompanyName, City, Country, ProductName
FROM Suppliers
         LEFT JOIN Products P on Suppliers.SupplierID = P.SupplierID
         JOIN Categories C on P.CategoryID = C.CategoryID
WHERE CategoryName = 'Beverages' AND UnitsInStock > 30
ORDER BY Country;


/*
UNION-UNION ALL_INTERSECT_EXCEPT
7. U tabeli Customers baze Northwind ID kupca je primarni ključ. 
U tabeli Orders baze Northwind ID kupca je vanjski ključ.
Dati izvještaj:
a) koliko je ukupno kupaca evidentirano u obje tabele (lista bez ponavljanja iz obje tabele)
b) da li su svi kupci obavili narudžbu(intersect)
c) koji kupci nisu napravili narudžbu(except)
*/
--a
select CustomerID
from Customers
union
select CustomerID
from Orders

--B
SELECT CASE
    WHEN (SELECT COUNT(*) FROM (SELECT CustomerID FROM Customers
                                INTERSECT
                                SELECT CustomerID FROM Orders) I) = (SELECT COUNT(*) FROM Customers) THEN 'DA'
    ELSE 'NE'
END;

select CustomerID
from Customers
INTERSECT
select CustomerID
from Orders

--c
SELECT CustomerID FROM Customers
EXCEPT
SELECT CustomerID FROM Orders;

/*
8. 
a) Provjeriti u koliko zapisa (slogova) tabele Orders nije unijeta vrijednost u polje regija isporuke.
b) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca pri čemu u polje regija kupovine 
nije unijeta vrijednost, uz uslov da je kupac obavio narudžbu (kupac iz tabele Customers postoji u tabeli Orders). 
Rezultat sortirati u rastućem redoslijedu.
c) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca pri čemu u polje regija kupovine 
nije unijeta vrijednost i kupac nije obavio ni jednu narudžbu (kupac iz tabele Customers ne postoji u tabeli Orders). 
Rezultat sortirati u rastućem redoslijedu.*/

--A
select count(*)
from Orders
where ShipRegion is null

--B
select CustomerID
from Customers
intersect
select CustomerID
from Orders
where ShipRegion is null
order by 1

--C
select CustomerID
from Customers
except
select CustomerID
from Orders
where ShipRegion is null
order by 1

/*
9. Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 5 zaposlenika muškog, odnosno, ženskog pola uz navođenje 
sljedećih podataka: 
radno mjesto na kojem se nalazi, datum rođenja, korisnicko ime i godine starosti. Korisničko ime je dio podatka u LoginID. 
Rezultate sortirati prema polu uzlaznim, a zatim prema godinama starosti silaznim redoslijedom.*/
/* funkcija CHARINDEX(substring, string, start)
The CHARINDEX() function searches for a substring in a string, and returns the position.
If the substring is not found, this function returns 0.
Note: This function performs a case-insensitive search.
*/
select * from HumanResources.Employee
select	top 5 JobTitle, BirthDate, Gender,
		left (RIGHT (LoginID, LEN (LoginID) - CHARINDEX ('\', LoginID)),
		LEN (LoginID) - CHARINDEX ('\', LoginID)-1),
		YEAR (GETDATE()) - YEAR (BirthDate) as god_star
from AdventureWorks2014.HumanResources.Employee
where Gender = 'M'
union
select	top 5 JobTitle, BirthDate, Gender,
		left (RIGHT (LoginID, LEN (LoginID) - CHARINDEX ('\', LoginID)),
		LEN (LoginID) - CHARINDEX ('\', LoginID)-1),		
		datediff (year, BirthDate, getdate())
from AdventureWorks2014.HumanResources.Employee
where Gender = 'F'
order by 3, 5 desc
/*
10. Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 2 zaposlenika  bez 
obzira da li su u braku ili ne i obavljaju poslove inžinjera uz navođenje sljedećih podataka: 
radno mjesto na kojem se nalazi, datum zaposlenja i bračni status. Ako osoba nije u braku plaća 
dodatni porez, inače ne plaća. Rezultate sortirati prema bračnom statusu uzlaznim redoslijedom.
*/
select top 2 JobTitle, HireDate, MaritalStatus, 'plaća porez' as status_poreza
from HumanResources.Employee
where JobTitle like '%engineer%' and MaritalStatus = 'S'
union 
select top 2 JobTitle, HireDate, MaritalStatus, 'ne plaća porez' as status_poreza
from HumanResources.Employee
where JobTitle like '%engineer%' and MaritalStatus = 'M'
order by MaritalStatus

/*
11. Iz tabela HumanResources.Employee i Person.Person prikazati po 5 osoba prema tome da li žele primati email ponude od AdventureWorksa uz navođenje sljedećih polja: ime i prezime osobe kao jedinstveno polje, organizacijski nivo na kojem se nalazi i da li prima email promocije. Pored ovih uvesti i polje koje će, u ovisnosti od sadržaja polja EmailPromotion, davati poruke: Ne prima, Prima selektirane i Prima. Uslov je da uposlenici rade na 1. ili 4. organizacijskom nivou. Rezultat sortirati prema organizacijskom nivou i dodatno uvedenom polju.
*/
select	top 5 Person.Person.FirstName + ' ' + Person.Person.LastName,
		HumanResources.Employee.OrganizationLevel, 
		Person.Person.EmailPromotion,
		'ne prima' mail_status
from	HumanResources.Employee join Person.Person
on		HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where	HumanResources.Employee.OrganizationLevel in (1,4) and
		Person.Person.EmailPromotion = 0 
union
select	top 5 Person.Person.FirstName + ' ' + Person.Person.LastName,
		HumanResources.Employee.OrganizationLevel, 
		Person.Person.EmailPromotion,
		'prima selektirane' mail_status
from	HumanResources.Employee join Person.Person
on		HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where	HumanResources.Employee.OrganizationLevel in (1,4) and
		Person.Person.EmailPromotion = 1
union
select	top 5 Person.Person.FirstName + ' ' + Person.Person.LastName,
		HumanResources.Employee.OrganizationLevel, 
		Person.Person.EmailPromotion,
		'prima sve' mail_status
from	HumanResources.Employee join Person.Person
on		HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where	HumanResources.Employee.OrganizationLevel in (1,4) and
		Person.Person.EmailPromotion = 2
order by 3, 4

/*
12. Iz tabela Sales.SalesOrderDetail i Production.Product prikazati 10 najskupljih stavki prodaje uz navođenje polja: naziv proizvoda, količina, cijena i iznos. Cijenu i iznos zaokružiti na dvije decimale. Iz naziva proizvoda odstraniti posljednji dio koji sadržava cifre i zarez. U rezultatu u polju količina na broj dodati 'kom.', a u polju cijena i iznos na broj dodati 'KM'.*/
select	top 10 left (P.Name, CHARINDEX (',', P.Name)-1) naziv, 
		cast (SOD.OrderQty as varchar) + ' kom.' broj,
		convert (varchar, ROUND (SOD.UnitPrice,2)) + ' KM' cijena, 
		cast (round ((SOD.OrderQty * SOD.UnitPrice),2) as varchar) + ' KM' ukupno
from	AdventureWorks2014.Sales.SalesOrderDetail as SOD join	
		AdventureWorks2014.Production.Product as P
on		SOD.ProductID = P.ProductID
where	CHARINDEX (',', P.Name)-1 > 0
order by SOD.OrderQty * SOD.UnitPrice desc

select CHARINDEX (',', Name)-1
from AdventureWorks2014.Production.Product