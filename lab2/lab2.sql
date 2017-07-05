SET DATEFORMAT YMD;
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='osoba')
DROP TABLE osoba;
GO

CREATE TABLE osoba(
	id_osoba INT IDENTITY(1, 1) PRIMARY KEY,
	imie VARCHAR(20) NOT NULL CHECK(LEN(imie) > 2),
	nazwisko VARCHAR(40) NOT NULL CHECK(LEN(nazwisko) > 2),
	pesel CHAR(11) NOT NULL UNIQUE,
	data_ur DATE NOT NULL,
	pensja MONEY NOT NULL CHECK(pensja >= 0) DEFAULT 1000.00
)

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '00010112345', '1900-01-01', 10000);
GO

SELECT * FROM osoba;
GO

-- 1.

DROP TRIGGER sprawdz_pesel;
GO

CREATE TRIGGER sprawdz_pesel ON osoba
  INSERT INTO @wagi VALUES (1), (3), (7), (9), (1), (3), (7), (9), (1), (3), (1)
	SET @pesel = (SELECT pesel FROM inserted)
	IF (SELECT SUM(CONVERT(TINYINT, SUBSTRING(@pesel, pozycja, 1))*waga)%10 FROM @wagi) != 0
	BEGIN
		ROLLBACK
	END

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808695', '1900-01-01', 10000);
INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808694', '1900-01-01', 10000);
SELECT * FROM osoba;
GO

-- 2.

DROP TRIGGER sprawdz_imie;

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808690', '1900-01-01', 2000);
INSERT INTO osoba VALUES('tOm', 'Adamczyk', '94050808691', '1900-01-01', 2000);
SELECT * FROM osoba;
GO

-- 3.

DROP TRIGGER sprawdz_nazwisko;

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808690', '1900-01-01', 2000);
INSERT INTO osoba VALUES('Tomasz', 'adamczyk', '94050808691', '1900-01-01', 2000);
INSERT INTO osoba VALUES('Tomasz', 'adam-nowak', '94050808692', '1900-01-01', 2000);
SELECT * FROM osoba;
GO

-- 4.

DROP TRIGGER sprawdz_wiek;

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808690', '1990-01-01', 10000);
INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808691', '2000-01-01', 10000);
SELECT * FROM osoba;
GO

-- 5.

INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808690', '1900-01-01', 10000);
INSERT INTO osoba VALUES('Tomasz', 'Adamczyk', '94050808691', '1900-01-01', 1000);
SELECT * FROM osoba;
GO