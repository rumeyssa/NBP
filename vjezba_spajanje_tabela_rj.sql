--1.	Napravite Kartezijev produkt tablica Ustanova i Polaznik.
--SELECT *
--FROM Ustanova, Polaznik

--2.	Napravite unutarnji spoj tablica Ustanova i Polaznik.
--SELECT *
--FROM Ustanova
--INNER JOIN Polaznik
--ON UstanovaId=Ustanova.Id

--3.	Napravite unutarnji spoj tablica Ustanova i Polaznik, ali u rezultatu prikažite 
--samo one ustanove koje u nazivu sadrže rijeè „fakultet“. Poredajte rezultat po nazivu ustanove, 
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
--(Rezultat treba biti ekvivalentan onome iz toèke 5.)
--SELECT *
--FROM Polaznik
--LEFT OUTER JOIN Ustanova
--ON UstanovaId=Ustanova.Id

--7.	Napravite unutarnji spoj izmeðu tablica Kategorija i Tecaj.
--SELECT *
--FROM Kategorija
--INNER JOIN Tecaj
--ON KategorijaId=Tecaj.Id

--8.	Napravite unutarnji spoj tablice Kategorija same sa sobom, na naèin da budu prikazani sljedeæi stupci: Id i Naziv nadreðene kategorije, 
--te zatim Id i Naziv podreðene kategorije.
--SELECT k.Id, k.Naziv as nadkategorija, n.Id, n.Naziv as podkategorija
--FROM Kategorija as k
--INNER JOIN Kategorija as n
--ON k.Id=n.NadKategorijaId

--9.	Napravite unutarnji spoj tablice Kategorija same sa sobom te zatim s tablicom Tecaj. U rezultatu bi trebali biti sljedeæi stupci: 
--Id i Naziv nadreðene kategorije, zatim Id i Naziv podreðene kategorije, te na kraju Id, Sifra i Naziv teèaja. 
--Poredajte rezultat po nazivu nadkategorije, zatim po nazivu podkategorije te zatim po nazivu teèaja.
--USE Tecajevi
--SELECT k.Id, k.Naziv as nadkategorija, n.Id, n.Naziv as podkategorija, Tecaj.Id, Tecaj.Sifra, Tecaj.Naziv
--FROM Kategorija as k
--	INNER JOIN Kategorija as n ON k.Id=n.NadKategorijaId
--	INNER JOIN Tecaj ON Tecaj.KategorijaId=n.Id
--	ORDER BY nadkategorija, n.Naziv, Tecaj.Naziv

--10.	Napravite unutarnji spoj izmeðu tablica Tecaj, Odrzavanje i Lokacija koji æe odgovoriti na pitanje koji se 
--teèajevi održavaju u kojoj uèionici. Od stupaca prikažite samo stupce iz tablica Tecaj i Lokacija. 
--Pomoæu kljuène rijeèi DISTINCT u rezultatu prikažite samo jedinstvene retke.

--USE Tecajevi
--SELECT DISTINCT Tecaj.Naziv as 'Naziv teèaja', Lokacija.Naziv as 'Naziv lokacije'
--FROM Tecaj
--JOIN Odrzavanje on Tecaj.Id=Odrzavanje.TecajId
--JOIN Lokacija on Odrzavanje.LokacijaId=Lokacija.Id