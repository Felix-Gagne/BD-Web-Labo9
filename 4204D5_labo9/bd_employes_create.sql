-- •○•○•○•○•○•○•○•○•
-- Base de données
-- •○•○•○•○•○•○•○•○•

CREATE DATABASE Lab09_Employes;
GO

USE Lab09_Employes;
GO

CREATE SCHEMA Employes;
GO

-- •○•○•○•○•○•○•○•○•
--      Tables
-- •○•○•○•○•○•○•○•○•

CREATE TABLE Employes.Employe(
	EmployeID int IDENTITY(1,1),
	Prenom nvarchar(50) NOT NULL,
	Nom nvarchar(50) NOT NULL,
	NoTel char(10) NOT NULL,
	Courriel nvarchar(255) NULL,
	DateEmbauche date NOT NULL,
	CONSTRAINT PK_Employe_EmployeID PRIMARY KEY (EmployeID)
);

CREATE TABLE Employes.Artiste(
	ArtisteID int IDENTITY(1,1),
	Specialite nvarchar(20) NOT NULL,
	EmployeID int NOT NULL,
	CONSTRAINT PK_Artiste_ArtisteID PRIMARY KEY (ArtisteID)
);

-- •○•○•○•○•○•○•○•○•
--    Contraintes
-- •○•○•○•○•○•○•○•○•

ALTER TABLE Employes.Artiste ADD CONSTRAINT FK_Artiste_EmployeID
FOREIGN KEY (EmployeID) REFERENCES Employes.Employe(EmployeID);
GO
-- Pas de cascade : ça empêche de supprimer un employé ! (Il faut supprimer l'artiste à la place)

ALTER TABLE Employes.Artiste ADD CONSTRAINT CK_Artiste_Specialite
CHECK (Specialite IN ('son', 'design', 'modélisation 3D', 'illustration', 'effets VFX'));
GO

ALTER TABLE Employes.Employe ADD CONSTRAINT CK_Employe_NoTel
CHECK (NoTel NOT LIKE '%[^0-9]%');
GO

ALTER TABLE Employes.Employe ADD CONSTRAINT CK_Employe_Courriel
CHECK (Courriel LIKE '_%@__%.__%');
GO

-- •○•○•○•○•○•○•○•○•
--       Vues
-- •○•○•○•○•○•○•○•○•

-- Vue de toutes les infos d'un artiste. (Données artiste + données employé)
CREATE VIEW Employes.VW_ListeArtistes
AS
	SELECT E.EmployeID, A.ArtisteID, E.Prenom, E.Nom, A.Specialite, E.NoTel, E.Courriel, E.DateEmbauche
	FROM Employes.Artiste A
	INNER JOIN Employes.Employe E
	ON A.EmployeID = E.EmployeID
GO

-- •○•○•○•○•○•○•○•○•
--    Procédures
-- •○•○•○•○•○•○•○•○•

-- Quand on crée un artiste, on doit aussi créer un employé qui lui est associé. (Héritage)
CREATE PROCEDURE Employes.USP_AjouterArtiste
	@Prenom nvarchar(50),
	@Nom nvarchar(50),
	@NoTel char(10),
	@Courriel nvarchar(255),
	@Specialite nvarchar(20)
AS
BEGIN
	INSERT INTO Employes.Employe (Prenom, Nom, NoTel, Courriel, DateEmbauche)
	VALUES (@Prenom, @Nom, @NoTel, @Courriel, GETDATE());
	
	DECLARE @EmployeID int;
	SELECT @EmployeID = SCOPE_IDENTITY();
	
	INSERT INTO Employes.Artiste(Specialite, EmployeID)
	VALUES (@Specialite, @EmployeID);
END
GO

-- •○•○•○•○•○•○•○•○•
--   Déclencheurs
-- •○•○•○•○•○•○•○•○•

-- Quand on supprime un artiste, on supprime l'employé associé. 
-- (La FK est dans l'autre direction, alors on a besoin du trigger)
CREATE TRIGGER Employes.TR_dSupprArtiste
ON Employes.Artiste AFTER DELETE
AS
BEGIN
	DELETE FROM Employes.Employe
	WHERE EmployeID IN (SELECT EmployeID FROM deleted);
END
GO

-- •○•○•○•○•○•○•○•○•
--    Insertions
-- •○•○•○•○•○•○•○•○•

INSERT INTO Employes.Employe (Prenom, Nom, NoTel, Courriel, DateEmbauche)
VALUES
('Ayaan', 'Karim', '5141112222', 'ak@bogobstudios.ca', '2022-01-12'),
('Mathieu', 'Paquin', '5141113333', 'mp@bogobstudios.ca', '2022-01-12'),
('Farah', 'Abed', '5142221111', 'fa@bogobstudios.ca', '2022-02-14'),
('Stéphanie', 'Carron', '5143331111', 'sc@bogobstudios.ca', '2022-02-16'),
('Juan', 'Garcia', '5141114444', 'jg@bogobstudios.ca', '2022-03-04'),
('Brenda', 'Pralda', '4384441111', 'bp@bogobstudios.ca', '2022-03-08'),
('Gabriela', 'Perez', '4502223333', 'gp@bogobstudios.ca', '2022-03-13'),
('Félix', 'Lavoie', '5143332222', 'fl@bogobstudios.ca', '2022-03-18'),
('Junior', 'Madiou', '5142224444', 'jm@bogobstudios.ca', '2022-04-09'),
('Emma', 'Dolbot', '4384442222', 'ed@bogobstudios.ca', '2022-04-09'),
('Violine', 'Pierre', '5143335555', 'vp@bogobstudios.ca', '2022-04-18'),
('Samuel', 'Pelletier', '4505553333', 'sp@bogobstudios.ca', '2022-05-25'),
('Lee', 'Zhang', '5143334444', 'lz@bogobstudios.ca', '2022-06-21'),
('Mélissa', 'Provost', '5144443333', 'mpr@bogobstudios.ca', '2022-06-22'),
('Qian', 'Liu', '4384445555', 'ql@bogobstudios.ca', '2022-06-28'),
('Tommy', 'Champagne', '4505554444', 'tc@bogobstudios.ca', '2022-07-08'),
('Mohib', 'Sharma', '4504447777', 'ms@bogobstudios.ca', '2022-07-15'),
('Katie', 'Gabriel', '4387774444', 'kg@bogobstudios.ca', '2022-08-16'),
('Uma', 'Nandi', '5144449999', 'un@bogobstudios.ca', '2022-08-21'),
('Hugo', 'Côté', '5149994444', 'hc@bogobstudios.ca', '2022-09-11'),
('Rocco', 'Bianchi', '4385558888', 'rb@bogobstudios.ca', '2022-09-19'),
('Samantha', 'Racine', '4508885555', 'sr@bogobstudios.ca', '2022-10-01'),
('Ginevra', 'Romano', '5145559999', 'gr@bogobstudios.ca', '2022-10-18'),
('Paul', 'Simard', '5149995555', 'ps@bogobstudios.ca', '2022-11-30'),
('William', 'Smith', '4386667777', 'ws@bogobstudios.ca', '2022-12-02'),
('Karine', 'Leto', '5147776666', 'kl@bogobstudios.ca', '2022-12-03'),
('Freya', 'Taylor', '4506669999', 'ft@bogobstudios.ca', '2023-01-17'),
('Simon', 'Paule', '5149996666', 'spa@bogobstudios.ca', '2023-01-31'),
('Simone', 'Vachon', '4507778888', 'sv@bogobstudios.ca', '2023-02-27'),
('Marc', 'Robidoux', '5148887777', 'mr@bogobstudios.ca', '2023-03-16');
GO

INSERT INTO Employes.Artiste (Specialite, EmployeID)
VALUES
('son', 1),
('design', 16),
('modélisation 3D', 2),
('effets VFX', 17),
('illustration', 3),
('son', 18),
('design', 4),
('modélisation 3D', 19),
('illustration', 5),
('effets VFX', 20),
('modélisation 3D', 6),
('modélisation 3D', 21),
('modélisation 3D', 7),
('effets VFX', 22),
('effets VFX', 8),
('son', 23),
('effets VFX', 9),
('modélisation 3D', 24),
('effets VFX', 10),
('design', 25),
('modélisation 3D', 11),
('illustration', 26),
('modélisation 3D', 12),
('effets VFX', 27),
('modélisation 3D', 13),
('modélisation 3D', 28),
('illustration', 14),
('design', 29),
('illustration', 15),
('modélisation 3D', 30);
GO



