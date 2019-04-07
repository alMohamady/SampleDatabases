-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 36 - Selecting Data through Views
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Protecting from Schema Changes

-- With Schema Binding

Use [NEW_DB]
go
IF EXISTS(SELECT * FROM SysObjects WHERE Name = 'vTest')
  DROP View dbo.vTest
go
IF EXISTS(SELECT * FROM SysObjects WHERE Name = 'Test')
  DROP TABLE dbo.Test

go
CREATE TABLE dbo.Test (
   [Name] NVARCHAR(50)
   )
go

CREATE VIEW dbo.vTest
WITH SCHEMABINDING
AS
SELECT [Name] FROM dbo.Test

go
ALTER TABLE dbo.Test
   ALTER COLUMN [Name] NVARCHAR(100)
