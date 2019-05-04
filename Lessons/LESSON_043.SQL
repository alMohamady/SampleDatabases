-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 43 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
---------------------------------------------------------
-- Controlling Procedural Flow

-- If 
IF 1 = 0
  PRINT 'Line One';
PRINT 'Line Two';

-- If w/ begin/end block
IF 1 = 0
  BEGIN
    PRINT 'Line One';
    PRINT 'Line Two';
  END 

-- IF Exists()
USE OBXKITES;
IF EXISTS(SELECT * FROM [ORDER] WHERE Closed = 0)
  BEGIN;
    PRINT 'Process Orders';
  END;

-- While
DECLARE @Temp int;
SET @Temp = 0;

WHILE @Temp <3
  BEGIN;
    PRINT 'tested condition' + Str(@Temp);
    SET @Temp = @Temp + 1;
  END;

-- goto
GOTO ErrorHandler;
PRINT 'more code';
ErrorHandler:; 
PRINT 'Logging the error'; 
