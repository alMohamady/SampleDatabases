-----------------------------------------------------------
-- 14 Fun Family Queries
-----------------------------------------------------------

USE Family

-----------------------------------------------------------
-- Raw Data 
SELECT * FROM Person ORDER BY PersonID
SELECT * FROM Marriage ORDER BY DateOfWedding


----------------------------------------------------------
-- 1) Who died, when, who old were they?
SELECT FirstName, LastName, CONVERT(VARCHAR(12),DateOfDeath,101) AS Death,
    DATEDIFF(yy,DateOfBirth, DateOfDeath) AS Age
  FROM Person 
  WHERE DateOfDeath IS NOT NULL
  ORDER BY DateOfDeath

----------------------------------------------------------
-- 2) Who was alive on 1/1/2001 and how old were they?
SELECT FirstName, LastName, DATEDIFF(yy,DateOfBirth, '1/1/2001') AS Age
  FROM Person 
  WHERE DateOfBirth <= '1/1/2001'
    AND (DateOfDeath IS NULL
    OR DateOfDeath >= '1/1/2001' )
  ORDER BY Age DESC

-----------------------------------------------------------
-- 3) List all James Halloways
SELECT FirstName, LastName, SrJr, 
    CONVERT(VARCHAR(12),DateOfBirth,101) AS Birth, 
    CONVERT(VARCHAR(12),DateOfDeath,101) AS Death
  FROM Person
  WHERE FirstName = 'James' 
    AND LastName = 'Halloway'
    AND SrJr IS NOT NULL
  ORDER BY DateOfBirth


-----------------------------------------------------------
-- 4) List all Weddings and age of bride and groom
SELECT  CONVERT( VARCHAR(12), DateOfWedding,101) AS WeddingDate, 
    H.FirstName + ' ' +  H.LastName +  ISNULL(' ' + H.SrJr,'') AS Groom, 
    DATEDIFF(yy,H.DateOfBirth, Marriage.DateOfWedding) AS GroomAge,
    W.FirstName + ' ' +  W.MaidenName AS Bride,
    DATEDIFF(yy,W.DateOfBirth, Marriage.DateOfWedding) AS BrideAge
  FROM Marriage
    JOIN Person H
      ON Marriage.HusbandID = H.personID
    JOIN Person W
      ON Marriage.WifeID = W.personID
  ORDER BY DateOfWedding

-----------------------------------------------------------
-- 5) Who got divorced? and How long were they married?
SELECT Person.FirstName + ' ' + Person.LastName AS XHubby,
    Wife.FirstName + ' ' + Wife.LastName AS XWife, DateOfDivorce,
    DATEDIFF(yy, DateOfWedding, DateOfDivorce) AS YrsMarried
  FROM Person
    JOIN Marriage
      ON Person.PersonID = Marriage.HusbandID
    JOIN Person Wife
      ON Marriage.WifeID = WIfe.PersonID
  WHERE DateOfDivorce IS NOT NULL


-----------------------------------------------------------
-- 6) List all births including their mother and father (if known) check
SELECT Person.PersonID, CONVERT(NVARCHAR(15), Person.DateofBirth,1) AS Date, 
   Person.FirstName,
    Person.Gender, ISNULL(F.FirstName + ' ' + F.LastName, ' * unknown *') as Father, 
    M.FirstName + ' ' + M.LastName as Mother
  FROM Person
    Left Outer JOIN Person F
      ON Person.FatherID = F.PersonID
    INNER JOIN Person M
      ON Person.MotherID = M.PersonID
  ORDER BY Person.DateOfBirth

-----------------------------------------------------------
-- 7) How many children has each mother born? 
SELECT PersonID, FirstName, LastName, Children
  FROM Person
    JOIN (SELECT MotherID, COUNT(*) AS Children 
               FROM Person 
               WHERE MotherID IS NOT NULL 
               GROUP BY MotherID) ChildCount
      ON Person.PersonID = ChildCount.MotherID
  ORDER BY Children DESC


-----------------------------------------------------------
-- 8) Who remarried?
SELECT Person.FirstName + ' ' + Person.LastName
  FROM Person
  WHERE 
      PersonID IN 
        (SELECT HusbandID FROM Marriage GROUP BY HusbandID Having Count(*) > 1)
    OR  
      PersonID IN 
        (SELECT WifeID FROM Marriage GROUP BY WifeID Having Count(*) > 1)

-- Carl's solution
SELECT  MarriageCnt, Person.* 
FROM  Person
join (select HusbandID as PersonId , count(*) as MarriageCnt
	from 	Marriage
	group by HusbandID
	having count(*) > 1
	union all 
	select WifeID as PersonId , count(*) as MarriageCnt
	from 	Marriage
	group by WifeID
	having count(*) > 1
	) as Marriages
	on Person.PersonId	= Marriages.PersonId



-----------------------------------------------------------
-- 9) How old were the mothers when their children were born? 
SELECT Person.FirstName + ' ' + Person.LastName AS Mother, 
    DATEDIFF(yy, Person.DateOfBirth, Child.DateOfBirth) AS Age,
    Child.FirstName
  FROM Person
    JOIN Person Child 
      ON Person.PersonID = Child.MotherID 
  ORDER By Age DESC


-----------------------------------------------------------
-- 10) Who had a child less than 9 months after the wedding, regardless of who is the father?
SELECT Person.FirstName + ' ' +  Person.LastName AS Mother, 
   Convert(Char(12), Marriage.DateOfWedding, 107) as Wedding,
   Child.FirstName + ' ' + Child.LastName as Child, 
   Convert(Char(12), Child.DateOfBirth, 107) as Birth
  FROM Person
    JOIN Marriage
      ON Person.PersonID = Marriage.WifeID
    JOIN Person Child
      ON Person.PersonID = Child.MotherID
   WHERE  Child.DateOfBirth 
      BETWEEN Marriage.DateOfWedding AND DATEADD(mm, 9, Marriage.DateOfWedding)


-----------------------------------------------------------
-- 11) Who are Twins?
SELECT Person.FirstName + ' ' + Person.LastName, 
    Twin.FirstName + ' ' + Twin.LastName as Twin,
    Person.DateOfBirth
  FROM Person
    JOIN Person Twin
      ON Person.PersonID != Twin.PersonID
        AND Person.MotherID = Twin.MotherID
        AND Person.DateOfBirth = Twin.DateOfBirth
  WHERE Person.DateOfBirth IS NOT NULL

SELECT Person.FirstName + ' ' + Person.LastName, 
    Twin.FirstName + ' ' + Twin.LastName as Twin,
    Person.DateOfBirth
  FROM Person
    JOIN Person Twin
      ON  Person.MotherID = Twin.MotherID
  WHERE Person.DateOfBirth IS NOT NULL
     AND Person.PersonID != Twin.PersonID
     AND Person.DateOfBirth = Twin.DateOfBirth
       

-----------------------------------------------------------
-- 12) Who was born out of wedlock? 

SELECT Person.PersonID, Person.FirstName, Person.LastName, 
    Person.DateOfBirth
  FROM Person
  WHERE 
    PersonID IN (
      SELECT PersonID  -- parents at one time married but not at time of birth
        FROM Person
          JOIN Marriage
            ON Person.MotherID = Marriage.WifeID
            AND Person.FatherID = Marriage.HusbandID
            AND Person.DateOfBirth < Marriage.DateOfWedding
            AND (Person.DateOfBirth > Marriage.DateOfDivorce
              OR Marriage.DateOfDivorce IS NULL) )
     OR PersonID IN (
       SELECT PersonID -- Mother unmarried
         FROM Person
           LEFT JOIN Marriage
             ON Person.MotherID = Marriage.WifeID
         WHERE Marriage.MarriageID IS NULL
            AND Person.MotherID IS NOT NULL)
      OR PersonID IN (
        SELECT PersonID -- Mother not married to Father (known)
          FROM Person
            LEFT JOIN Marriage
              ON Person.MotherID = Marriage.WifeID
               AND Person.FatherID != Marriage.HusbandID
              AND Person.DateOfBirth > Marriage.DateOfWedding
              AND (Person.DateOfBirth < Marriage.DateOfDivorce
                OR Marriage.DateOfDivorce IS NULL)
           WHERE MotherID IS NOT NULL
             AND FatherID IS NOT NULL
             AND Marriage.MarriageID IS NOT NULL )

-- Carl's solution
SELECT Person.*
  FROM Person
  WHERE Person.MotherId IS NOT NULL
    AND NOT EXISTS
      (SELECT 1 
        FROM Marriage
        WHERE Marriage.WifeId = Person.MotherId
          AND Person.DateOfBirth 
            BETWEEN Marriage.DateOfWedding 
              AND COALESCE(Marriage.DateOfDivorce,Person.DateOfBirth) 
       )


-----------------------------------------------------------
-- 13) How many life events (children, marriages, divorces, deaths) has each woman had? 

SELECT FirstName + ' ' + LastName AS Woman, 
    IsNull(Marriages,0) AS Marriages, IsNull(Divorces,0) AS Divorces, IsNull(Children,0) AS Children, 
    IsNull(HusbandDeaths,0) AS HusbandDeaths, IsNull(ChildDeaths,0) AS ChildDeaths,   
    IsNull(Marriages,0) + IsNull(Divorces,0) + IsNull(Children,0) + 
    IsNull(HusbandDeaths,0) +IsNull(ChildDeaths,0) AS LifeEvents
  FROM Person
    LEFT OUTER JOIN 
      (SELECT WifeID, Count(*) AS Marriages
        FROM Marriage 
        GROUP BY WifeID) M
      ON Person.PersonID = M.WifeID

    LEFT OUTER JOIN 
      (SELECT MotherID, COUNT(*) AS Children 
        FROM Person 
        WHERE MotherID IS NOT NULL 
        GROUP BY MotherID) C
      ON Person.PersonID = C.MotherID

     LEFT OUTER JOIN 
      (SELECT WifeID, Count(*) AS Divorces
        FROM Marriage 
        WHERE DateOfDivorce IS NOT NULL
        GROUP BY WifeID) D
      ON Person.PersonID = D.WifeID

     LEFT OUTER JOIN 
      ( SELECT Person.MotherID, Count(*) AS ChildDeaths
        FROM Person 
          JOIN Person M
            ON Person.MotherID = M.PersonID
            AND Person.DateOfDeath < M.DateOfDeath 
        GROUP BY Person.MotherID ) CD
      ON Person.MotherID = CD.MotherID

     LEFT OUTER JOIN 
      ( SELECT Person.PersonID, Count(*) AS HusbandDeaths
        FROM Person
          JOIN Marriage 
            ON Person.PersonID = Marriage.WifeID
          JOIN Person H
            ON Marriage.HusbandID = H.PersonID
            AND H.DateOfDeath < Person.DateOfDeath 
        GROUP BY Person.PersonID ) HD
      ON Person.MotherID = HD.PersonID

    WHERE Person.Gender = 'F'
    ORDER BY LifeEvents DESC


-----------------------------------------------------------
--14)  Who are the two patriachs at the top of the family tree?
SELECT Person.FirstName + ' ' + Person.Lastname 
  FROM Person
  WHERE Person.Gender = 'M'
    AND Person.MotherID IS NULL
    AND Person.FatherID IS NULL
    AND PersonID NOT IN -- married a person with a MotherID or FatherID
      (SELECT Person.PersonID
         FROM Person
           JOIN Marriage
             ON Person.PersonID = Marriage.HusbandID
           JOIN Person Wife
             ON Marriage.WifeID = Wife.PersonID
         WHERE Wife.MotherID IS NOT NULL
           OR Wife.FatherID IS NOT NULL)

-----------------------------------------------------------
-- 15) Who married into the Family? Who did they marry? How old were they when they married?

-- new wife joining to husbands in the family
SELECT Person.FirstName, Person.MaidenName, 
      H.FirstName + ' ' +  H.LastName +  ISNULL(' ' + H.SrJr,'') AS Spouse,
      CONVERT(VARCHAR(12),HM.DateOfWedding,101) AS Wedding,    
      DATEDIFF(yy, Person.DateOfBirth, HM.DateOfWedding) AS Age
  FROM Person
    LEFT JOIN Marriage HM
      ON Person.PersonID = HM.WifeID
    LEFT JOIN Person H
      ON HM.HusbandID = H.PersonID
  -- married in has no recorded parents
  WHERE Person.FatherID IS NULL
    AND Person.MotherID IS NULL
    AND HM.MarriageID IS NOT NULL
    -- not founder of family
    AND Person.PersonID > 4
UNION
-- new husband joining to wives in the family
SELECT Person.FirstName, Person.LastName, 
      W.FirstName + ' ' +  W.LastName  ,
      CONVERT(VARCHAR(12),WM.DateOfWedding,101) ,    
      DATEDIFF(yy, Person.DateOfBirth, WM.DateOfWedding) 
  FROM Person
    -- new wife joining to husbands in the family
    LEFT JOIN Marriage WM
      ON Person.PersonID = WM.HusbandID
    LEFT JOIN Person W
      ON WM.WifeID = W.PersonID
  -- married in has no recorded parents
  WHERE Person.FatherID IS NULL
    AND Person.MotherID IS NULL
    AND WM.MarriageID IS NOT NULL
    -- not founder of family
    AND Person.PersonID > 4
ORDER BY Person.FirstName, Person.MaidenName
