-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 51 - T-SQL Handling Errors
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
----------------------------------------------------------
-- Handling Errors

-- Try...Catch
BEGIN TRY;
  SET NOCOUNT ON; 
  SELECT 'Try One';
  RAISERROR('Simulated Error', 16, 1); 
  Select 'Try Two';
END TRY 
BEGIN CATCH;
  SELECT 'Catch Block';
END CATCH ;
SELECT 'Try Three';


BEGIN TRY;
  SET NOCOUNT ON; 
  SELECT 'Try One';
  RAISERROR('Simulated Error', 16, 1) ;
  Select 'Try Two';
END TRY 

BEGIN CATCH 
  SELECT 
    ERROR_MESSAGE() AS [Message],
    ERROR_PROCEDURE() AS [Procedure],
    ERROR_LINE() AS Line,
    ERROR_NUMBER() AS Number,
    ERROR_SEVERITY() AS Severity,
    ERROR_STATE() AS State;
END CATCH;
SELECT 'Try Three';

-- Without a Catch Block the Functions Return a Null
  SELECT 
    ERROR_MESSAGE() AS [Message],
    ERROR_PROCEDURE() AS [Procedure],
    ERROR_LINE() AS Line,
    ERROR_NUMBER() AS Number,
    ERROR_SEVERITY() AS Severity,
    ERROR_STATE() AS State;
 
-- Legacy @@Error Global Variable
USE Family;
UPDATE Person 
  SET PersonID = 1 
  Where PersonID = 2;
Print @@Error;
Print @@Error;

-- Saving @@Error to a Local Variable
USE Family;
DECLARE @err INT;

UPDATE Person 
  SET PersonID = 1 
  Where PersonID = 2;
SET @err = @@Error;

IF @err <> 0 
  Begin;
    -- error handling code
    Print @err;
  End;

-- Legacy @@RowCount Global Variable
USE FAMILY;
UPDATE Person
  SET LastName = 'Johnson'
  WHERE PersonID = 100;

IF @@RowCount = 0 
  Begin;
    -- error handling code
    Print 'no rows affected';
  End;

-- Raiserror


-- The Complete Raiserror Form 
RAISERROR('Unable to update Customer', 14, 1);

-- Error Severity
RAISERROR('Print', 10,1);
RAISERROR('Info', 14,1);
RAISERROR('Warning', 15,1);
RAISERROR('Critical', 16,1);

--  Adding Variable Parameters to Message
RAISERROR ('Unable to update %s.', 14, 1, 'Customer');

