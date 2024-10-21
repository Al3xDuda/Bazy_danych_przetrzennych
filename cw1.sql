-- 1

CREATE DATABASE firma;

-- 2

CREATE SCHEMA ksiegowosc;

-- 3

CREATE TABLE IF NOT EXISTS pracownicy(
	id_pracownika int PRIMARY KEY
	,imie TEXT
	,nazwisko TEXT
	,adres TEXT
	,telefon TEXT
);

CREATE TABLE  IF NOT EXISTS godziny(
	id_godziny int PRIMARY KEY
	,data TEXT 
	,liczba_godzin INT
	,id_pracownika INT REFERENCES pracownicy(id_pracownika) ON DELETE CASCADE
); 

CREATE TABLE  IF NOT EXISTS pensja(
	id_pensji INT PRIMARY KEY
	,stanowisko TEXT
	,kwota INT
);

CREATE TABLE  IF NOT EXISTS premia(
	id_premii INT PRIMARY KEY
	,rodzaj TEXT
	,kwota INT
);

CREATE TABLE  IF NOT EXISTS wynagrodzenie(
	id_wynagrodzenia INT PRIMARY KEY
	,data TEXT 
	,id_pracownika INT REFERENCES pracownicy(id_pracownika) ON DELETE CASCADE
	,id_godziny INT REFERENCES godziny(id_godziny)
	,id_pensji INT  REFERENCES pensja(id_pensji)
	,id_premii INT  REFERENCES premia(id_premii)
);


-- 4

INSERT INTO pracownicy (id_pracownika, imie, nazwisko, adres, telefon) VALUES
(1, 'Jan', 'Kowalski', 'ul. Kwiatowa 10, Warszawa', '500123456')
,(2, 'Anna', 'Nowak', 'ul. Sloneczna 5, Krakow', '501234567')
,(3, 'Piotr', 'Wisniewski', 'ul. Ogrodowa 20, Wroclaw', '502345678')
,(4, 'Maria', 'Zielinska', 'ul. Lesna 8, Poznan', '503456789')
,(5, 'Tomasz', 'Wojcik', 'ul. Polna 12, Gdansk', '504567890')
,(6, 'Katarzyna', 'Kwiatkowska', 'ul. Lipowa 6, Lodz', '505678901')
,(7, 'Michal', 'Kaminski', 'ul. Brzozowa 3, Lublin', '506789012')
,(8, 'Ewa', 'Lewandowska', 'ul. Debowa 15, Katowice', '507890123')
,(9, 'Pawel', 'Dabrowski', 'ul. Sosnowa 9, Szczecin', '508901234')
,(10, 'Magdalena', 'Sikora', 'ul. Wrzosowa 2, Bialystok', '509012345');


INSERT INTO godziny (id_godziny, data, liczba_godzin, id_pracownika) VALUES
(1, '2024-10', 140, 1)
,(2, '2024-10', 170, 2)
,(3, '2024-10', 160, 3)
,(4, '2024-10', 120, 4)
,(5, '2024-10', 200, 5)
,(6, '2024-10', 170, 6)
,(7, '2024-10', 150, 7)
,(8, '2024-10', 170, 8)
,(9, '2024-10', 170, 9)
,(10, '2024-10', 100, 10);


INSERT INTO pensja (id_pensji, stanowisko, kwota) VALUES
(1, 'Specjalista IT', 5000)
,(2, 'Analityk danych', 5500)
,(3, 'Kierownik projektu', 7000)
,(4, 'Administrator systemu', 4800)
,(5, 'Programista', 6000)
,(6, 'Tester oprogramowania', 4500)
,(7, 'Architekt IT', 8000)
,(8, 'Inzynier systemowy', 1000)
,(9, 'Mlodszy programista', 2000)
,(10, 'Grafik komputerowy', 1000);


INSERT INTO premia (id_premii, rodzaj, kwota) VALUES
(1, 'Premia za wyniki', 1000)
,(2, 'Premia swiateczna', 800)
,(3, 'Premia roczna', 1200)
,(4, 'Premia projektowa', 1500)
,(5, 'Premia uznaniowa', 700)
,(6, 'Premia kwartalna', 1100)
,(7, 'Premia za nadgodziny', 500)
,(8, 'Premia zespolowa', 900)
,(9, 'Premia motywacyjna', 1300)
,(10, 'Premia za oszczednosci', 600);


INSERT INTO wynagrodzenie (id_wynagrodzenia , data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
(1, '2024-10', 1, 1, 1, 1)
,(2, '2024-10', 2, 2, 2, 2)
,(3, '2024-10', 3, 3, 3, 3)
,(4, '2024-10', 4, 4, 4, 4)
,(5, '2024-10', 5, 5, 5, 5)
,(6, '2024-10', 6, 6, 6, NULL)
,(7, '2024-10', 7, 7, 7, 7)
,(8, '2024-10', 8, 8, 8, 8)
,(9, '2024-10', 9, 9, 9, NULL)
,(10, '2024-10', 10, 10, 10, 10);

-- 5 

-- a)

SELECT id_pracownika
		,nazwisko
	FROM pracownicy p;

-- b)
	
SELECT w.id_pracownika,kwota
FROM wynagrodzenie w 
JOIN pensja p 
ON p.id_pensji=w.id_pensji 
WHERE p.kwota >1000;

-- c)

SELECT w.id_pracownika
FROM wynagrodzenie w 
JOIN pensja p 
ON p.id_pensji=w.id_pensji 
WHERE id_premii IS NULL AND p.kwota>2000;
	
-- d)

SELECT * FROM pracownicy p WHERE imie^@'J';

-- e)

 SELECT * FROM pracownicy p WHERE LOWER(nazwisko) LIKE '%n%a'
 
 -- f)
 
 SELECT imie
 		,nazwisko	
 		,CASE WHEN (g.liczba_godzin - 160) > 0 
 			THEN g.liczba_godzin - 160 
 			ELSE 0 
 		END ilosc_nadgozin 
 	FROM pracownicy p 
 	JOIN godziny g 
 	ON p.id_pracownika=g.id_pracownika;
 
-- g)
 
 SELECT imie,nazwisko 
 FROM pracownicy p 
 JOIN wynagrodzenie w ON p.id_pracownika=w.id_pracownika 
 JOIN pensja pe ON w.id_pensji=pe.id_pensji 
 WHERE kwota BETWEEN 1500 AND 3000;
 
-- h)

SELECT imie,nazwisko
FROM pracownicy p 
JOIN godziny g ON p.id_pracownika=g.id_pracownika 
JOIN wynagrodzenie w ON w.id_pracownika = p.id_pracownika 
WHERE id_premii IS NULL AND (g.liczba_godzin - 160) > 0; 

-- i)

SELECT p.id_pracownika,imie,nazwisko,kwota 
FROM pracownicy p 
JOIN wynagrodzenie w ON p.id_pracownika =w.id_pracownika 
JOIN pensja pe ON w.id_pensji = pe.id_pensji 
ORDER BY kwota 

-- j)


SELECT p.id_pracownika,imie,nazwisko,pe.kwota,COALESCE(pr.kwota,0) 
FROM pracownicy p 
JOIN wynagrodzenie w ON p.id_pracownika =w.id_pracownika 
JOIN pensja pe ON w.id_pensji = pe.id_pensji 
LEFT JOIN premia pr ON w.id_premii = pr.id_premii 
ORDER BY pe.kwota,pr.kwota DESC

-- k)

SELECT COUNT(1),Stanowisko 
FROM wynagrodzenie w 
JOIN pensja p ON w.id_pensji=p.id_pensji 
GROUP BY stanowisko 

-- l)

SELECT AVG(kwota),MIN(kwota),MAX(kwota),stanowisko FROM wynagrodzenie w JOIN pensja p ON w.id_pensji =p.id_pensji 
WHERE p.stanowisko = 'Kierownik projektu'
GROUP BY stanowisko 

-- m)

SELECT SUM(p.kwota + COALESCE(p2.kwota,0)) FROM wynagrodzenie w JOIN pensja p ON w.id_pensji = p.id_pensji 
LEFT JOIN premia p2 ON p2.id_premii = w.id_premii ;

-- f)
SELECT SUM(p.kwota + COALESCE(p2.kwota,0)),stanowisko FROM wynagrodzenie w JOIN pensja p ON w.id_pensji = p.id_pensji 
LEFT JOIN premia p2 ON p2.id_premii = w.id_premii 
GROUP BY stanowisko;

-- g)

SELECT COUNT(p2.kwota),stanowisko FROM wynagrodzenie w JOIN pensja p ON w.id_pensji = p.id_pensji 
LEFT JOIN premia p2 ON p2.id_premii = w.id_premii 
GROUP BY stanowisko;

-- h)

DELETE FROM pracownicy p 
WHERE id_pracownika IN (
	SELECT id_pracownika 
	FROM wynagrodzenie w 
	JOIN pensja p ON w.id_pensji=p.id_pensji
	WHERE kwota < 1200
);

