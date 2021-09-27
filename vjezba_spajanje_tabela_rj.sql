--1.	Napravite Kartezijev produkt tablica Ustanova i Polaznik.
--SELECT *
--FROM Ustanova, Polaznik

--2.	Napravite unutarnji spoj tablica Ustanova i Polaznik.
--SELECT *
--FROM Ustanova
--INNER JOIN Polaznik
--ON UstanovaId=Ustanova.Id

--3.	Napravite unutarnji spoj tablica Ustanova i Polaznik, ali u rezultatu prika�ite 
--samo one ustanove koje u nazivu sadr�e rije� �fakultet�. Poredajte rezultat po nazivu ustanove, 
--a zatim po imenu i prezimenu polaznika.
--SELECT *
--FROM Ustanova
--INNER JOIN Polaznik
--ON UstanovaId=Ustanova.Id
--WHERE Ustanova.Naziv LIKE '%fakultet%'
--ORDER BY Naziv, Ime, Prezime

--4.	Napravite lijevi spoj tablica Ustanova i Polaznik, tako da budu prikazane i ustanove kojima ne pripada nijedan polaznik.
--SELECT *
--FROM Ustanova
--LEFT OUTER JOIN Polaznik
--ON UstanovaId=Ustanova.Id

--5.	Napravite desni spoj tablica Ustanova i Polaznik, tako da budu prikazani i polaznici koji ne pripadaju nijednoj ustanovi. 
--SELECT *
--FROM Ustanova
--RIGHT OUTER JOIN Polaznik
--ON UstanovaId=Ustanova.Id

--6.	Napravite lijevi spoj tablica Ustanova i Polaznik, tako da budu prikazani i polaznici koji ne pripadaju nijednoj ustanovi. 
--(Rezultat treba biti ekvivalentan onome iz to�ke 5.)
--SELECT *
--FROM Polaznik
--LEFT OUTER JOIN Ustanova
--ON UstanovaId=Ustanova.Id

--7.	Napravite unutarnji spoj izme�u tablica Kategorija i Tecaj.
--SELECT *
--FROM Kategorija
--INNER JOIN Tecaj
--ON KategorijaId=Tecaj.Id

--8.	Napravite unutarnji spoj tablice Kategorija same sa sobom, na na�in da budu prikazani sljede�i stupci: Id i Naziv nadre�ene kategorije, 
--te zatim Id i Naziv podre�ene kategorije.
--SELECT k.Id, k.Naziv as nadkategorija, n.Id, n.Naziv as podkategorija
--FROM Kategorija as k
--INNER JOIN Kategorija as n
--ON k.Id=n.NadKategorijaId

--9.	Napravite unutarnji spoj tablice Kategorija same sa sobom te zatim s tablicom Tecaj. U rezultatu bi trebali biti sljede�i stupci: 
--Id i Naziv nadre�ene kategorije, zatim Id i Naziv podre�ene kategorije, te na kraju Id, Sifra i Naziv te�aja. 
--Poredajte rezultat po nazivu nadkategorije, zatim po nazivu podkategorije te zatim po nazivu te�aja.
--USE Tecajevi
--SELECT k.Id, k.Naziv as nadkategorija, n.Id, n.Naziv as podkategorija, Tecaj.Id, Tecaj.Sifra, Tecaj.Naziv
--FROM Kategorija as k
--	INNER JOIN Kategorija as n ON k.Id=n.NadKategorijaId
--	INNER JOIN Tecaj ON Tecaj.KategorijaId=n.Id
--	ORDER BY nadkategorija, n.Naziv, Tecaj.Naziv

--10.	Napravite unutarnji spoj izme�u tablica Tecaj, Odrzavanje i Lokacija koji �e odgovoriti na pitanje koji se 
--te�ajevi odr�avaju u kojoj u�ionici. Od stupaca prika�ite samo stupce iz tablica Tecaj i Lokacija. 
--Pomo�u klju�ne rije�i DISTINCT u rezultatu prika�ite samo jedinstvene retke.

--USE Tecajevi
--SELECT DISTINCT Tecaj.Naziv as 'Naziv te�aja', Lokacija.Naziv as 'Naziv lokacije'
--FROM Tecaj
--JOIN Odrzavanje on Tecaj.Id=Odrzavanje.TecajId
--JOIN Lokacija on Odrzavanje.LokacijaId=Lokacija.Id