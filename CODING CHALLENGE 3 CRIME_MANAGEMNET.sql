CREATE DATABASE CRIME_MANAGEMENT

CREATE TABLE Crime ( 
    CrimeID INT PRIMARY KEY, 
    IncidentType VARCHAR(255), 
    IncidentDate DATE, 
    Location VARCHAR(255), 
    Description TEXT, 
    Status VARCHAR(20) 
);  
CREATE TABLE Victim ( 
    VictimID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    ContactInfo VARCHAR(255), 
    Injuries VARCHAR(255), 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 
CREATE TABLE Suspect ( 
    SuspectID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    Description TEXT, 
    CriminalHistory TEXT, 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 
 -- Insert sample data 
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) VALUES 
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'), 
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'), 
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'); 
 
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)VALUES 
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'), 
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'), 
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None'); 
 
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)VALUES 
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'), 
(2, 2, 'Unknown', 'Investigation ongoing', NULL), 
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

--Q1
SELECT * FROM Crime 
WHERE STATUS ='Open'
--Q2
SELECT COUNT(CRIMEID) AS TOTAL_INCIDENTS FROM CRIME
--Q3
SELECT IncidentType FROM CRIME
GROUP BY IncidentType
--Q4
SELECT * FROM CRIME
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10'
--Q5
--DOB FOR SUSPECTS AND VICTIMS NOT PRESENT
ALTER TABLE VICTIM ADD DOB DATE
ALTER TABLE SUSPECT ADD DOB DATE
UPDATE Victim 
SET DOB ='1999-09-09' WHERE VictimID=1
UPDATE Victim 
SET DOB ='1999-07-09' WHERE VictimID=2
UPDATE Victim 
SET DOB ='1999-05-09' WHERE VictimID=3
UPDATE Suspect 
SET DOB ='1998-09-09' WHERE SuspectID=1
UPDATE Suspect 
SET DOB ='1998-04-09' WHERE SuspectID=2
UPDATE Suspect 
SET DOB ='2000-09-09' WHERE SuspectID=3

SELECT P.Name,DATEDIFF(YEAR,P.DOB,GETDATE()) AS AGE
FROM (
SELECT V.Name, V.DOB FROM Victim V
UNION 
SELECT S.Name, S.DOB FROM Suspect S) AS P
ORDER BY AGE DESC
--Q6
SELECT AVG(A.AGE) AS AVG_AGE FROM 
(SELECT P.Name,DATEDIFF(YEAR,P.DOB,GETDATE()) AS AGE
FROM (
SELECT V.Name, V.DOB FROM Victim V
UNION 
SELECT S.Name, S.DOB FROM Suspect S) AS P) AS A
--Q7
SELECT IncidentType,COUNT(IncidentType) AS COUNT FROM Crime
WHERE Status='Open'
GROUP BY IncidentType
--Q8
SELECT N.NAME FROM
(SELECT NAME FROM Victim UNION SELECT NAME FROM Suspect) AS N
WHERE N.NAME LIKE '%Doe%'
--Q9
SELECT N.Name FROM CRIME AS C
INNER JOIN (SELECT NAME,CRIMEID FROM Victim UNION SELECT NAME,CRIMEID FROM Suspect) AS N ON N.CrimeID=C.CrimeID
WHERE Status='Open' or Status= 'Closed'
GROUP BY Name
--Q10
SELECT IncidentType FROM CRIME AS C 
INNER JOIN (SELECT NAME,CrimeID ,DATEDIFF(YEAR,DOB,GETDATE()) AS AGE FROM Victim 
UNION SELECT NAME,CrimeID ,DATEDIFF(YEAR,DOB,GETDATE()) AS AGE FROM Suspect) AS A ON A.CrimeID=C.CrimeID
WHERE AGE = 30 OR AGE = 35
--Q11
SELECT NAME FROM Crime AS C
INNER JOIN(SELECT NAME,CrimeID FROM Victim UNION SELECT NAME,CRIMEID FROM Suspect) AS A ON A.CrimeID=C.CrimeID
WHERE IncidentType='Robbery'
--Q12
SELECT IncidentType FROM Crime
WHERE Status='Open'
GROUP BY IncidentType
HAVING COUNT(Status)>1
--Q13
SELECT Name FROM Victim 
WHERE Name IN (SELECT Name FROM Suspect)
--Q14
SELECT IncidentType,IncidentDate,VictimID,V.Name,V.Injuries,V.ContactInfo,S.SuspectID,S.Name,S.Description,S.CriminalHistory FROM Crime AS C
INNER JOIN Suspect AS S ON C.CrimeID=S.CrimeID
INNER JOIN Victim AS V ON V.CrimeID=C.CrimeID
--Q15
SELECT * FROM Crime AS C
INNER JOIN Suspect AS S ON C.CrimeID=S.CrimeID
INNER JOIN Victim AS V ON V.CrimeID=C.CrimeID
WHERE S.DOB<V.DOB
--Q16
SELECT SuspectID,Name,COUNT(CrimeID) AS INVOLVED_CRIMES FROM Suspect 
GROUP BY SuspectID,Name
HAVING COUNT(CrimeID)>1
--Q17
SELECT * FROM Crime AS C
LEFT JOIN Suspect AS S ON C.CrimeID=S.CrimeID
WHERE SuspectID IS NULL
--Q18
SELECT TOP 1 CrimeID,IncidentType,IncidentDate,Status FROM Crime
WHERE IncidentType='Homicide'
UNION 
SELECT CrimeID,IncidentType,IncidentDate,Status FROM Crime
WHERE IncidentType='Robbery'
--Q19
SELECT *, CASE WHEN S.SUSPECTID IS NULL THEN 'NO SUSPECT' ELSE 'AVAILABLE' end AS SUSPECT_STATUS
FROM Crime AS C 
LEFT JOIN Suspect AS S ON C.CrimeID=S.CrimeID
--Q20
SELECT * FROM Suspect AS S
INNER JOIN Crime AS C ON C.CrimeID=S.CrimeID
WHERE IncidentType IN ('Robbery','Assault')