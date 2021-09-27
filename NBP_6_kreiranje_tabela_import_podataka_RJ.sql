/*
1. Kreirati bazu podataka radna.
*/
create database radna
use radna

/*2. Vodeæi raèuna o strukturi tabela kreirati odgovarajuæe veze (vanjske kljuèeve) 

a) Kreirati tabelu autor koja æe se sastojati od sljedeæih polja:
	au_id		varchar(11)	primarni kljuè
	au_lname	varchar(40)	
	au_fname	varchar(20)	
	phone		char(15)	
	address		varchar(40)
	city		varchar(20)
	state		char(2)	
	zip			char(5)
	contract	bit	
*/
create table autor
(
	au_id		varchar(11),
	au_lname	varchar(40),	
	au_fname	varchar(20),	
	phone		char(15),	
	address		varchar(40),
	city		varchar(20),
	state		char(2),	
	zip			char(5),
	contract	bit,
	constraint PK_autor primary key (au_id)
)

/*
b) Kreirati tabelu naslov koja æe se sastojati od sljedeæih polja:
	title_id	varchar(6), primarni kljuè
	title		varchar(80)	
	type		char(12)	
	pub_id		char(4)	
	price		money	
	advance		money	
	royalty		int	
	ytd_sales	int	
	notes		varchar(200)	
	pubdate		datetime	
		
*/
create table naslov
(
	title_id	varchar(6),
	title		varchar(80),	
	type		char(12),	
	pub_id		char(4),	
	price		money,	
	advance		money,	
	royalty		int,	
	ytd_sales	int,	
	notes		varchar(200),	
	pubdate		datetime,
	constraint PK_naslov primary key (title_id)
)

/*
c) Kreirati tabelu naslov_autor koja æe se sastojati od sljedeæih polja:
	au_id		varchar(11)	
	title_id	varchar(6)	
	au_ord		tinyint	
	royaltyper	int
*/
create table naslov_autor
(
	au_id		varchar(11),	
	title_id	varchar(6),	
	au_ord		tinyint,	
	royaltyper	int,
	constraint PK_naslov_autor primary key (au_id, title_id),
	constraint FK_naslov_autor__autor foreign key (au_id) references autor (au_id),
	constraint FK_naslov_autor__naslov foreign key (title_id) references naslov (title_id)
)

/*
3. Insert (import) podataka.
	a) u tabelu autori podatke iz tabele authors baze pubs, ali tako da se u koloni phone tabele autor prve 3 cifre smjeste u zagradu.
	b) u tabelu naslovi podatke iz tabele titles baze pubs, ali tako da se izvrši zaokruživanje vrijednosti (podaci ne smiju imati decimalne vrijednosti) u koloni price
	c) u tabelu naslov_autor podatke iz tabele titleauthor baze pubs, pri èemu æe se u koloni au_ord vrijednosti iz tabele titleauthor zamijeniti na sljedeæi naèin:
	1 -> 101
	2 -> 102
	3 -> 103
*/
insert into autor
select au_id, au_lname,	au_fname, '(' + left (phone,3) + ')' + SUBSTRING (phone,4,9), address, city, state, zip, contract
from pubs.dbo.authors

select * from autor

insert into naslov
select title_id, title, type, pub_id, ROUND (price,0), advance, royalty, ytd_sales, notes, pubdate
from pubs.dbo.titles

select * from naslov

insert into naslov_autor
select au_id, title_id,	100 + au_ord, royaltyper
from pubs.dbo.titleauthor

select * from naslov_autor

 
/*
4. Izvršiti update podataka u koloni contract tabele autor po sljedeæem pravilu:
	0 -> NE
	1 -> DA
*/
alter table autor
alter column contract char (2)

update autor
set contract = 'NE'
where contract = '0'

update autor
set contract = 'DA'
where contract = '1'

select contract from autor


/*
5. Kopirati tabelu sales iz baze pubs u tabelu prodaja u bazi radna.
*/
select *
into radna.dbo.prodaja
from pubs.dbo.sales

select * from prodaja
select * from pubs.dbo.sales

/*
6. Kopirati tabelu autor u tabelu autor1, izbrisati sve podatke, a nakon toga u tabelu autor1 importovati podatke iz tabele autor uz uslov da ID autora zapoèinje brojevima 1, 2 ili 3 i da autor ima zakljuèen ugovor (contract).
*/
select *
into autor1
from autor

delete autor1

insert into autor1
select * 
from autor
where au_id like '[123]%' and contract = 1


/* 
7. U tabelu autor1 importovati podatke iz tabele autor uz uslov da adresa poèinje cifrom 3, a na treæem mjestu se nalazi cifra 1.
*/

insert into autor1
select *
from autor
where address like '3_1%'

/*
8. Kopirati tabelu naslov u tabelu naslov1, izbrisati sve podatke, a nakon toga u tabelu naslov1 importovati podatke iz tabele naslov na naèin da se cijena (price) koriguje na sljedeæi naèin:
	- naslov èija je cijena veæa ili jednaka 15 KM cijenu smanjiti za 20% (podaci trebaju biti zaokruženi na 2 decimale)
	- naslov èija je cijena manja od 15 KM cijenu smanjiti za 15% (podaci trebaju biti zaokruženi na 2 decimale)
*/
select *
into naslov1
from naslov

delete naslov1

insert into naslov1
select title_id, title, type, pub_id, round ((price - price*0.2),2), advance, royalty, ytd_sales, notes, pubdate
from naslov
where price >= 15

insert into naslov1
select title_id, title, type, pub_id, round ((price - price*0.15),2), advance, royalty, ytd_sales, notes, pubdate
from naslov
where price < 15

/*
9. Kopirati tabelu naslov_autor u tabelu naslov_autor1, a nakon toga u tabelu naslov_autor1 dodati novu kolonu isbn tipa varchar (10).
*/
select * 
into naslov_autor1
from naslov_autor

alter table naslov_autor1
add isbn varchar (10)

/*
10. Kolonu isbn popuniti na naèin da se iz au_id preuzmu prve 3 cifre i srednja crta, te se na to dodaju posljednje 4 cifre iz title_id.
*/
update naslov_autor1
set isbn = left (au_id,4) + right (title_id,4)

/*
11. U tabelu autor1 dodati kolonu sifra koja æe se popunjavati sluèajno generisanim nizom znakova, pri èemu je broj znakova ogranièen na 15.
*/
alter table autor1
add sifra as left (newid(), 15)


/*
12. Tabelu Order Details iz baze Northwind kopirati u tabelu detalji_narudzbe, a zatim iz nje izbrisati podatke.
*/
select *
into detalji_narudzbe
from NORTHWND.dbo.[Order Details]

delete detalji_narudzbe

/*
13. U tabelu detalji_narudzbe dodati izraèunate kolone cijena_s_popustom i ukupno. cijena_s_popustom æe se raèunati pomoæu kolona UnitPrice i Discount, a ukupno pomoæu kolona Quantity i cijena_s_popustom. Obje kolone trebaju biti formirani kao numerièki tipovi sa dva decimalna mjesta.
*/
alter table detalji_narudzbe
add cijena_s_popustom as (UnitPrice - UnitPrice*Discount)

alter table detalji_narudzbe
add ukupno as Quantity * (UnitPrice - UnitPrice*Discount)

/*
14. U tabelu detalji_narudzbe izvršiti insert podataka iz tabele Order Details baze Northwind.
*/
insert into detalji_narudzbe
select *
from NORTHWND.dbo.[Order Details]

select * from detalji_narudzbe
/*
15. Kreirati tabelu uposlenik koja æe se sastojati od sljedeæih polja:
	uposlenikID	cjelobrojna vrijednost, primarni kljuè, automatsko punjenje sa inkrementom 1 i poèetnom vrijednošæu 1
	emp_id		char(9)	
	fname		varchar(20)	
	minit		char(1)	
	lname		varchar(30)	
	job_id		smallint	
	job_lvl		tinyint	
	pub_id		char(6), postaviti provjeru (ograničenje) da se ne može unijeti više od 5 znakova
	hire_date	datetime, defaultna vrijednost je aktivni datum	
*/
create table uposlenik
(
	uposlenikID	int constraint PK_uposlenik primary key identity (1,1),
	emp_id		char(9),
	fname		varchar(20),	
	minit		char(1)	,
	lname		varchar(30),
	job_id		smallint,
	job_lvl		tinyint,	
	pub_id		char(6)	constraint CK_pub_id check (len (pub_id) <=5),
	hire_date	datetime constraint DF_hire_date default getdate()
)
/*
16. U sve kolone tabele uposlenik osim hire_date insertovati podatke iz tabele employee baze pubs.
*/
insert into uposlenik
	(emp_id,
	fname,	
	minit,
	lname,
	job_id,
	job_lvl,	
	pub_id)
select
	emp_id,
	fname,	
	minit,
	lname,
	job_id,
	job_lvl,	
	pub_id
from pubs.dbo.employee



/*
17. U tabelu uposlenik dodati kolonu sifra velièine 10 unicode karaktera, a nakon toga kolonu sifra popuniti sluèajno generisanim karakterima.
*/
alter table uposlenik
add sifra varchar (10)

update uposlenik
set sifra = left (newid(),10)
