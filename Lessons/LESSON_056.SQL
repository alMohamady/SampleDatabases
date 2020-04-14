-----------------------------------------------------------
-- SQL Server 2020
-- 
-- Developing Solutions
-- Lesson 56- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
--------------------------------------------------------
-- Enforcing Complex RI

-- Complex Business Rules Validation
-- Custom RI

-- ensure the guide's qual date is good and the revoke date is null
-- for the given guideID and TourID

USE CHA2
go
CREATE TRIGGER LeadQualied ON Event_mm_Guide
AFTER INSERT, UPDATE
AS 
SET NoCount ON
IF EXISTS(
  SELECT *  
    FROM Inserted
      JOIN dbo.Event 
        ON Inserted.EventID = Event.EventID
      LEFT JOIN dbo.Tour_mm_Guide
        ON Tour_mm_Guide.TourID = Event.TourID
        AND Inserted.GuideID = Tour_mm_Guide.GuideID
    WHERE
       Inserted.IsLead = 1  
       AND 
          (QualDate > Event.DateBegin 
        OR   
           RevokeDate IS NOT NULL
        OR 
           QualDate IS NULL )
        )
  BEGIN 
    RAISERROR('Lead Guide is not Qualified.',16,1)
    ROLLBACK TRANSACTION
  END
go


-- test 

INSERT Event_mm_Guide (EventID, GuideID, IsLead)
  VALUES (10, 1, 1)

INSERT Event_mm_Guide (EventID, GuideID, IsLead)
  VALUES (10, 2, 1)