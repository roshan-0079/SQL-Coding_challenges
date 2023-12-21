CREATE DATABASE VISUAL_ART_GALLERY

-- Create the Artists table 
CREATE TABLE Artists ( 
    ArtistID INT PRIMARY KEY, 
    Name VARCHAR(255) NOT NULL, 
    Biography TEXT, 
    Nationality VARCHAR(100)); 
-- Create the Categories table 
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    Name VARCHAR(100) NOT NULL); 
-- Create the Artworks table 
CREATE TABLE Artworks ( 
    ArtworkID INT PRIMARY KEY, 
    Title VARCHAR(255) NOT NULL, 
    ArtistID INT, 
    CategoryID INT, 
    Year INT, 
    Description TEXT, 
    ImageURL VARCHAR(255), 
    FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)); 
-- Create the Exhibitions table 
CREATE TABLE Exhibitions ( 
    ExhibitionID INT PRIMARY KEY, 
    Title VARCHAR(255) NOT NULL, 
    StartDate DATE, 
    EndDate DATE,
    Description TEXT); 
-- Create a table to associate artworks with exhibitions 
CREATE TABLE ExhibitionArtworks ( 
    ExhibitionID INT, 
    ArtworkID INT, 
    PRIMARY KEY (ExhibitionID, ArtworkID), 
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID), 
    FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)); 

-- Insert sample data into the Artists table 
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES 
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'), 
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'), 
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'); 
-- Insert sample data into the Categories table 
INSERT INTO Categories (CategoryID, Name) VALUES 
(1, 'Painting'), 
(2, 'Sculpture'), 
(3, 'Photography'); 
-- Insert sample data into the Artworks table 
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'), 
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'), 
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso s powerful anti-war mural.', 'guernica.jpg'); 
-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES 
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'), 
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
-- Insert artworks into exhibitions 
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES 
(1, 1), 
(1, 2), 
(1, 3), 
(2, 2); 

--Q1
SELECT A.ArtistID,A.Name,COUNT(AW.ArtworkID) AS TOTAL_ARTWORKS FROM Artists AS A
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY A.ArtistID,A.Name
ORDER BY TOTAL_ARTWORKS DESC
--Q2
SELECT * FROM Artists AS A 
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
WHERE Nationality IN ('Spanish','Dutch')
ORDER BY YEAR
--Q3
SELECT Name,COUNT(AW.ArtistID) AS TOTAL_ARTWORKS FROM Artists AS A 
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
WHERE CategoryID=1
GROUP BY NAME
--Q4
SELECT AW.Title FROM Artists AS A 
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
INNER JOIN Categories AS C ON C.CategoryID=AW.CategoryID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
WHERE ExhibitionID=1
--Q5
SELECT A.ArtistID,A.Name,COUNT(AW.ArtworkID) AS TOTAL_ARTWORKS FROM Artists AS A
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY A.ArtistID,A.Name
HAVING COUNT(AW.ArtworkID) >1
--Q6
SELECT Title FROM Artworks AS AW 
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY Title
HAVING COUNT(ExhibitionID)=2
--Q7
SELECT CategoryID,COUNT(ArtworkID) AS TOTAL_ARTWORKS FROM Artworks 
GROUP BY CategoryID
--Q8
SELECT A.ArtistID,A.Name,COUNT(AW.ArtworkID) AS TOTAL_ARTWORKS FROM Artists AS A
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY A.ArtistID,A.Name
HAVING COUNT(AW.ArtworkID)>3
--Q9
SELECT Title,Name,Nationality FROM Artists AS A
INNER JOIN Artworks AS AW ON A.ArtistID=AW.ArtistID
WHERE Nationality='Spanish'
--Q10
SELECT E.ExhibitionID,E.Title FROM Artworks AS AW
INNER JOIN ExhibitionArtworks AS EA ON AW.ArtworkID=EA.ArtworkID
INNER JOIN Exhibitions AS E ON E.ExhibitionID=EA.ExhibitionID
WHERE ArtistID IN (3,2) 
GROUP BY E.ExhibitionID,E.Title
HAVING COUNT(DISTINCT ArtistID)=2
--Q11
SELECT * FROM Artworks AS A
LEFT JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=A.ArtworkID
WHERE EA.ExhibitionID IS NULL
--Q12
SELECT A.ArtistID FROM Artists AS A
INNER JOIN Artworks AS AW ON AW.ArtistID=A.ArtistID
RIGHT JOIN Categories AS C ON C.CategoryID=AW.CategoryID
GROUP BY A.ArtistID
HAVING COUNT(DISTINCT C.CategoryID)=(SELECT COUNT(CategoryID) FROM Categories)
--Q13
SELECT C.CategoryID,C.Name,COUNT(ArtworkID) AS TOTAL_ARTWORKS FROM Categories AS C
LEFT JOIN Artworks AS AW ON AW.CategoryID=C.CategoryID
GROUP BY C.CategoryID,C.Name
--Q14
SELECT A.ArtistID,A.Name FROM Artists AS A
INNER JOIN Artworks AS AW ON AW.ArtistID=A.ArtistID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY A.ArtistID,A.Name
HAVING COUNT(EA.ArtworkID)>2
--Q15
SELECT C.CategoryID,AVG(AW.Year) AS AVERAGE_YEAR FROM Categories AS C
INNER JOIN Artworks AS AW ON AW.CategoryID=C.CategoryID
GROUP BY C.CategoryID
HAVING COUNT(AW.ArtworkID)>1
--Q16
SELECT AW.ArtworkID,AW.Title FROM Exhibitions AS E 
INNER JOIN ExhibitionArtworks AS EA ON EA.ExhibitionID=E.ExhibitionID
INNER JOIN Artworks AS AW ON AW.ArtworkID=EA.ArtworkID
WHERE E.Title='Modern Art Masterpieces'
--Q17
SELECT C.CategoryID,C.Name FROM Artworks AS AW 
INNER JOIN Categories AS C ON C.CategoryID=AW.CategoryID
GROUP BY C.CategoryID,C.Name
HAVING AVG(AW.Year)>(SELECT AVG(YEAR) FROM Artworks)
--Q18
SELECT AW.ArtworkID, AW.Title FROM Artworks AS AW
LEFT JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
WHERE EA.ArtworkID IS NULL
GROUP BY AW.ArtworkID, AW.Title
--Q19
SELECT A.ArtistID,A.Name FROM Artists AS A 
INNER JOIN Artworks AS AW ON AW.ArtistID=A.ArtistID
INNER JOIN Categories AS C ON C.CategoryID=AW.CategoryID
WHERE C.CategoryID=(SELECT C.CategoryID FROM Categories AS C
INNER JOIN Artworks AS AW ON AW.CategoryID=C.CategoryID 
WHERE Title='Mona Lisa')
--Q20
SELECT A.Name,COUNT(EA.ArtworkID) AS TOTAL_ARTWORKS FROM Artists AS A 
INNER JOIN Artworks AS AW ON AW.ArtistID=A.ArtistID
INNER JOIN ExhibitionArtworks AS EA ON EA.ArtworkID=AW.ArtworkID
GROUP BY A.ArtistID,A.Name