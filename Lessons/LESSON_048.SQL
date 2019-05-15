-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 48 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
--------------------------------------------
-- Returning Parameters

-- Output Parameters
USE OBXKites;
go
CREATE PROC GetProductName (
  @ProductCode CHAR(10),
  @ProductName VARCHAR(25) OUTPUT )
AS
SELECT @ProductName = ProductName
  FROM dbo.Product
  WHERE Code = @ProductCode;
go

--
USE OBXKITES;
DECLARE @ProdName VARCHAR(25);
EXEC GetProductName '1001', @ProdName OUTPUT;
PRINT @ProdName;

-- Using the Return Command
CREATE PROC IsItOK (
  @OK VARCHAR(10) )
AS
IF @OK = 'OK'
  RETURN 0
ELSE 
  RETURN -100;
go


DECLARE @ReturnCode INT;
EXEC @ReturnCode = IsITOK 'OK';
PRINT @ReturnCode;
EXEC @ReturnCode = IsItOK 'NotOK';
PRINT @ReturnCode;