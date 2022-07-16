/*	
*******************************************************************************************************************
			Ispit iz Naprednih baza podataka 28.09.2021.godine
*******************************************************************************************************************

*/

/*
	0. Ispitni zadatak imenovati vasim brojem indeksa (File--Save As)
	
*/

/*
	1. Kreirati novu baze podataka kroz SQL kod, koja nosi ime vaseg broja indeksa
	   Napomena: default postavke servera
	(5) bodova
*/
create database ilma176meskic
use ilma176meskic






/*	2a. Unutar svoje baze podataka kreirati tabele sa sljedecom strukturom.
		Napomena: Baza podataka je simulacija rezervacije letova

Osobe
	OsobaID, automatski generator neparnih vrijednosti i primarni kljuc
	Prezime, polje za unos 50 UNICODE karaktera (obavezan unos)
	Ime, polje za unos 50 UNICODE karaktera (obavezan unos)
	Email, polje za unos 100 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
	DatumRodjenja, polje za unos datuma, DEFAULT je NULL
	DatumKreiranjaZapisa, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
	
Kreirati ALIAS tip podatka za vrstu kreditne kartice, a na osnovu 25 UNICODE karaktera sa obaveznim unosom*/

create table Osobe(
    OsobaID int identity(1,2) primary key,
	Prezime nvarchar(50) not null,
	Ime nvarchar(50) not null,
	Email nvarchar(100) unique not null,
	DatumRodjenja date default(null),
	DatumKreiranjaZapisa date default getutcdate() not null
	)

create type udt_tipKR from nvarchar(25) not null

/*OsobeKartice
	OsobaKarticaID, automatski generator parnih vrijednosti i primarni kljuc
	TipKartice, koristiti ALIAS za tip kreditne kartice
	BrojKartice, polje za unos 25 UNICODE karaktera (obavezan unos)
	MjesecIsteka, tip podatka za najmanji opseg cijelog broja
	GodinaIsteka, tip podatka za sljedeci najmanji opseg cijelog broja
	DatumKreiranjaZapisa, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa*/
	
create table OsobeKartice(
       OsobaKarticaID int identity(2,2) primary key,
	   TipKartice udt_tipKR,
	   BrojKartice nvarchar(25) not null,
	   MjesecIsteka smallint,
	   GodinaIsteka smallint,
	   DatumKreiranjaZapisa date default getutcdate() not null
	)

/*Letovi
	LetID, automatski generator vrijednosti i primarni kljuc
	BrojLeta, polje za unos 4 UNICODE karaktera (obavezan unos)
	Polaziste, polje za unos 20 UNICODE karaktera (obavezan unos)
	Destinacija, polje za unos 20 UNICODE karaktera (obavezan unos)
	DatumKreiranjaZapisa, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je trenutni datum*/
	
create table Letovi(
       LetID int identity(1,1) primary key,
	   BrojLeta nvarchar(4) not null,
	   Polaziste nvarchar(20) not null,
	   Destinacija nvarchar(20) not null,
	   DatumKreiranjaZapisa date default getutcdate() not null
)

/*Rezervacije (Napomena: Putnik moze napraviti samo jednu rezervaciju unutar leta, sto je bitno za PK)
	RezervacijaID, automatski generator vrijednosti
	DatumRezervacije, polje za unos datuma (obavezan unos) DEFAULT je trenutni datum
	DatumKreiranjaZapisa, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa zapisa
	DatumModifikovanjaZapisa, polje za unos datuma izmjene zapisa, DEFAULT je NULL

	(10) bodova
*/

create table Rezervacije(
        RezervacijaID int identity(1,1) primary key,
		DatumRezervacije date default getutcdate() not null,
		DatumKreiranjaZapisa date default getdate() not null,
		DatumModifikacije date default (null),
		OsobaID int,
		constraint fk_rezervacije_osobe foreign key (OsobaID) references Osobe(OsobaID),
		OsobaKarticaID int,
		constraint fk_rezervacije_oska foreign key (OsobaKarticaID) references OsobeKartice(OsobaKarticaID),
		LetID int,
		constraint fk_rezervacije_letovi foreign key (letID) references Letovi(letID),
		)







/*
	2b.	Modifikovati tabelu "Osobe" i dodati jednu izracunatu (trajno pohranjenju) 
		kolonu pod nazivom "GodinaRodjenja". 
		
		Napomena: Uzeti samo godinu iz polja "DatumRodjenja"
	(5) bodova

*/

alter table Osobe
add GodinaRodjenja as year(DatumRodjenja)




/*
	2c. Unosenje testnih podataka
	
	Iz baze podataka "AdventureWorks2014", a putem podupita selektovati zapise iz tabela: 
	(Person.Person, Person.EmailAddress i HumanResources.Employee) 
	(Kolone: LastName, FirstName, EmailAddress i BirthDate) i dodati u tabelu "Osobe". 
	
	Napomena: Obavezno komandom testirati da li su podaci u tabeli nakon import operacije.*/
	use  AdventureWorks2014
select top 2 * from AdventureWorks2014.Person.Person
select top 2 * from AdventureWorks2014.Person.EmailAddress
select top 2 * from AdventureWorks2014.HumanResources.Employee

insert into Osobe(Prezime, Ime, Email, DatumRodjenja)
select LastName,
       FirstName,
	   EmailAddress,
	   BirthDate
from AdventureWorks2019.Person.Person as pp join AdventureWorks2019.Person.EmailAddress as pe
     on pp.BusinessEntityID=pe.BusinessEntityID join AdventureWorks2019.HumanResources.Employee as he
	 on pe.BusinessEntityID=he.BusinessEntityID

select * from Osobe
/*	Iz baze podataka "AdventureWorks2014", a putem podupita selektovati zapise iz tabela: 
	(Sales.PersonCreditCard i Sales.CreditCard) 
	(Kolone: tip kartice, broj kartice, mjesec i godina isteka) i dodati u tabelu "OsobeKartice". 
	
	Napomena:Obavezno komandom testirati da li su podaci u tabeli nakon import operacije.*/

select top 2 * from AdventureWorks2019.Sales.PersonCreditCard
select top 2 * from AdventureWorks2019.Sales.CreditCard

select * from OsobeKartice

insert into OsobeKartice(TipKartice, BrojKartice, MjesecIsteka, GodinaIsteka)
select CardType,
       CardNumber,
	   ExpMonth,
	   ExpYear
from AdventureWorks2019.Sales.PersonCreditCard as spc join AdventureWorks2019.Sales.CreditCard as scc
     on spc.CreditCardID=scc.CreditCardID

select * from OsobeKartice
/*	Jednom SQL komandom, u tabelu Letovi dodati tri zapisa sa sljedecim parametrima:
	  - 1023, SJJ, LHR
	  - 4844, LAX, SEA
	  - 5321, JFK, SFO
	
	Napomena: Obavezno komandom testirati da li su podaci u tabeli
	(5) bodova
*/

insert into Letovi (BrojLeta, Polaziste, Destinacija)
values ('1023', 'SJJ', 'LHR'),
       ('4844', 'LAX', 'SEA'),
	   ('5321', 'JFK', 'SFO')

select * from Letovi


/*
	3. Putem procedure, modifikovati sve tabela u vasoj bazi i dodati novu kolonu 
	   u svim tabelama (istovremeno): "DatumModifikovanjaZapisa" polje za unos 
	   datuma izmjene zapisa, DEFAULT je NULL
	(5) bodova
*/
create or alter proc zadatak3 as
begin transaction 
alter table Osobe
add DatumModifikovanjaZapisa date default(null)
alter table OsobeKartice 
add DatumModifikovanjaZapisa date default(null)
alter table Letovi
add DatumModifikovanjaZapisa date default(null)
alter table Rezervacije
add DatumModifikovanjaZapisa date default(null)
commit transaction

exec  zadatak3

select * from Osobe


/*
	4. Kreirati uskladistenu proceduru koja ce vrsiti upis podataka u tabelu "Rezervacije" 
	   (sva polja), 4 zapisa proizvoljnog karaktera.
		
		Napomena:Obavezno komandom testirati da li su podaci u tabeli nakon izvrsenja procedure.
  
	(10) bodova
*/
select * from Rezervacije

create or alter proc zadatak4 
 (@OsobaKarticaID INT,
 @LetID int,
 @OsobaID int
)
as 
Begin
BEGIN TRAN
	BEGIN TRY
			INSERT INTO Rezervacije
		(OsobaKarticaID, LetID, OsobaID)
	VALUES
		(@OsobaKarticaID, @LetID, @OsobaID)

			COMMIT TRANSACTION
		END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH
END
GO

drop proc zadatak4

select * from Rezervacije

exec zadatak4 2, 1, 111
exec zadatak4 4, 2, 517
exec zadatak4 6, 3, 217
exec zadatak4 8, 3, 513
/*
	5. Kreirati uskladistenu proceduru koja ce vrsiti izmjenu u tabeli "Rezervacije", 
	   tako sto ce  modifikovati datum rezervacije. Obratite paznju na broj atributa koje je 
	   potrebno izmjeniti kako bi poslovni proces bio kompletan. 
		
	   Napomena:Obavezno komandom testirati da li su podaci u u tabeli modifikovani nakon izvrsenja procedure.
  	(10) bodova
 */
 
create or alter proc zadatak5 as
begin
BEGIN TRAN
	BEGIN TRY
			UPDATE Rezervacije
			SET DatumRezervacije = cast(month(DatumRezervacije) as nvarchar) + cast(1 as nvarchar)

			COMMIT TRANSACTION
		END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH
END
exec zadatak5

select * from Rezervacije



/*
	6. Kreirati pogled sa sljedecom definicijom: Prezime i ime osobe, broj leta i broj rezervacije,
	?
		ali samo za one osobe koje su modfikovale rezervaciju. Dodati i jednu ekstra kolonu koja 
		pokazuje koliko je prošlo minuta od incijalne rezervacije pa do njenje izmjene.
		
		Napomena: Obavezno komandom testirati funkcionalnost view objekta.
	(5) bodova
*/







/* 
						GRANICA ZA OCJENU 6 (55 bodova) 
*/

/*
	7a. Modifikovati tabele "Osobe" i dodati nove dvije kolone:
		Lozinka, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
		Telefon, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
	(5) bodova
*/
alter table Osobe
add Lozinka  nvarchar(100) default (null)

alter table Osobe
add Telefon  nvarchar(100) default (null)




/*
	7b. Kreirati uskladistenu proceduru koja ce iz baze podataka "AdventureWorks2014" i tabela:
	(Person.Person, Person.Password, Person.EmailAddress i Person.PersonPhone) mapirati 
	odgovarajuce kolone sa pripadajucim podacima te ih prebaciti u tabelu "Osobe". 
	Voditi racuna da import ukljuci samo one osobe koji nisu zaposlenici. 
	
	Napomena: Obavezno komandom testirati da li su podaci u u tabeli
	(5) bodova
*/
select * from AdventureWorks2019.Person.Person

create or alter proc zadatak7
as
insert into Osobe(Prezime, Lozinka, Telefon)
select  pp.LastName,
        pas.PasswordHash,
        ph.PhoneNumber   
from AdventureWorks2019.Person.Person as pp join 
     AdventureWorks2019.Person.Password as pas on pp.BusinessEntityID=pas.BusinessEntityID
	 join AdventureWorks2019.Person.EmailAddress as e on pas.BusinessEntityID=e.BusinessEntityID
	 join AdventureWorks2019.Person.PersonPhone as ph on e.BusinessEntityID=ph.BusinessEntityID
drop proc zadatak7

exec zadatak7
select * from Osobe
/* 
						GRANICA ZA OCJENU 7 (65 bodova) 
*/

/*
	8. Kreirati okidac nad tabelom "Osobe" za sve UPDATE operacije sa ciljem  da se nakon 
	   modifikovanja zapisa upise podatak o izmjeni u kolonu "DatumModifikovanjaZapisa".
	(10) bodova
*/
create trigger trajger1
on Osobe
after update
as
begin 
update Rezervacije
set DatumModifikovanjaZapisa = getutcdate()
end 
go


update Osobe
set Prezime='ILMA' where OsobaID=1

select * from Osobe


/* 
						GRANICA ZA OCJENU 8 (75 bodova) 
*/

/*
	9a. Svim osobama u Vasoj bazi podataka generisati novu email adresu u formatu: 
		Ime.PrezimeOsobaID@ptf.unze.ba.ba, lozinku dugacku 16 karaktera putem SQL funkcije 
		koja generise slucajne jedinstvene vrijednosti.
		
		Napomena: Obavezno testirati da li su podaci modifikovani i da li je okidac iz zadatka 8 funkcionalan. U slucaju da okidac
		nije "reagovao" zadatak "9a" nece biti priznat
	(5) bodova
*/




/*
	9b. Kreirati backup vase baze na default lokaciju servera, bez navodjenja staze (path).
	(5) bodova
*/

backup database ilma176meskic
to disk='ilma176meskic.bak'

/* 
						GRANICA ZA OCJENU 9 (85 bodova) 
*/


/*
	10a. Kreirati uskladištenu proceduru koja brise sve osoba bez rezervacije.
	
		 Napomena: Obavezno testirati funkcionalnost procedure i obrisane podatke.
	(5) bodova
*/
create or alter proc zadatak10
as 
delete 
from Osobe
where OsobaID not in (select osobaID from Rezervacije)

exec zadatak10

select * from Osobe



/*
	10b. Kreirati proceduru koja brise sve zapise iz svih tabela unutar jednog izvrsenja. 
		
		Napomena: Testirati da li su podaci obrisani.
	(5) bodova
*/

CREATE OR ALTER PROC zadatak10b
AS
	DELETE
	FROM Osobe
	DELETE
	FROM OsobeKartice
	DELETE
	FROM Letovi
	DELETE
	FROM Rezervacije

exec zadatak10b
select * from Osobe
/* 
						GRANICA ZA OCJENU 10 (95 bodova) 
*/

/*
	10c. Uraditi restore rezervene kopije baze podataka iz koraka 9b. 
	
		 Napomena: Provjeriti da li su podaci u tabelama.
	(5) bodova
*/

use master
restore database ilma176meskic
from disk ='ilma176meskic.bak'
with replace