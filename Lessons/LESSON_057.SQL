-----------------------------------------------------------
-- SQL Server 2020
-- 
-- Developing Solutions
-- Lesson 57- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-------------------------------------------------------
-- Auditing Data Changes

USE OBXKites

CREATE TABLE dbo.Audit (
  AuditID UNIQUEIDENTIFIER RowGUIDCol  NOT NULL 
    CONSTRAINT DF_Audit_AuditID DEFAULT (NEWID())
    CONSTRAINT PK_Audit PRIMARY KEY NONCLUSTERED (AuditID),
  AuditDate DATETIME NOT NULL,
  SysUser VARCHAR(50) NOT NULL,
  Application VARCHAR(50) NOT NULL,
  TableName VARCHAR(50)NOT NULL,
  Operation CHAR(1) NOT NULL, 	
  PrimaryKey VARCHAR(50) NOT NULL,
  RowDescription VARCHAR(50) NULL,
  SecondaryRow VARCHAR(50) NULL,
  [Column] VARCHAR(50) NOT NULL,
  OldValue VARCHAR(50) NULL,
  NewValue VARCHAR(50) NULL
	)

--------------------------------------------------------------
-- Fixed Audit Trail Trigger

Use OBXKites

Go

CREATE TRIGGER Product_Audit
ON dbo.Product
AFTER Insert, Update
NOT FOR REPLICATION
AS

DECLARE @Operation CHAR(1)

IF EXISTS(SELECT * FROM Deleted)
 SET @Operation = 'U'
ELSE 
 SET @Operation = 'I'

IF UPDATE(ProductCategoryID) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'ProductCategoryID',
          OPC.ProductCategoryName, NPC.ProductCategoryName
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
            AND Inserted.ProductCategoryID
                <> Deleted.ProductCategoryID 
          -- fetch ProductCategory Names
          LEFT OUTER JOIN dbo.ProductCategory OPC
            ON Deleted.ProductCategoryID = OPC.ProductCategoryID
          JOIN dbo.ProductCategory NPC
            ON Inserted.ProductCategoryID = NPC.ProductCategoryID
   
IF UPDATE(Code) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'Code',
          Deleted.Code, Inserted.Code
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
              AND Inserted.Code <> Deleted.Code

IF UPDATE(ProductName) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'Name',
          Deleted.ProductName, Inserted.ProductName
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
              AND Inserted.ProductName <> Deleted.ProductName

IF UPDATE(ProductDescription) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'ProductDescription',
          Deleted.ProductDescription, Inserted.ProductDescription
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
              AND Inserted.ProductDescription <> Deleted.ProductDescription

IF UPDATE(ActiveDate) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'ActiveDate',
          Deleted.ActiveDate, Inserted.ActiveDate
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
              AND Inserted.ActiveDate != Deleted.ActiveDate

IF UPDATE(DiscontinueDate) 
    INSERT dbo.Audit 
      (AuditDate, SysUser, Application, TableName, Operation, 
       PrimaryKey, RowDescription, SecondaryRow, [Column], 
       OldValue, NewValue) 
      SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
          Inserted.ProductID, Inserted.Code, NULL, 'DiscontinueDate',
          Deleted.DiscontinueDate, Inserted.DiscontinueDate
        FROM Inserted
          LEFT OUTER JOIN Deleted
            ON Inserted.ProductID = Deleted.ProductID
              AND Inserted.DiscontinueDate != Deleted.DiscontinueDate

go     

-- Test the Fixed Audit Trail

EXEC pProduct_AddNew 'Kite', 200, 'The MonstaKite', 'Man what a big Kite!'

SELECT TableName, RowDescription, [Column], NewValue 
  FROM Audit

SELECT * 
  FROM Audit

UPDATE dbo.Product 
  SET ProductDescription = 'Biggie Sized'
  WHERE Code = 200

SELECT AuditDate, OldValue, NewValue   
  FROM dbo.Audit
  WHERE TableName = 'Product'
    AND RowDescription = '200'
    AND [Column] = 'ProductDescription'

--Rolling back an Audit Trail change

CREATE PROCEDURE pAudit_RollBack (
  @AuditID UNIQUEIDENTIFIER)
AS
SET NoCount ON

DECLARE
  @SQLString NVARCHAR(4000),
  @TableName NVARCHAR(50),
  @PrimaryKey NVARCHAR(50),
  @Column NVARCHAR(50),
  @NewValue NVARCHAR(50)

SELECT 
  @TableName = TableName,
  @PrimaryKey = PrimaryKey,
  @Column = [Column],
  @NewValue = OldValue
  FROM dbo.Audit
  WHERE AuditID = @AuditID

SET @SQLString = 
  'UPDATE ' + @TableName
    + ' SET ' + @Column + ' = ''' + @NewValue +''''
    + ' WHERE ' + @TableName + 'ID = ''' + @PrimaryKey + ''''

EXEC sp_executeSQL @SQLString
go

--Test RollBack

DECLARE @AuditRollBack UNIQUEIDENTIFIER

SELECT @AuditRollBack = AuditID 
  FROM dbo.Audit
  WHERE TableName = 'Product'
    AND RowDescription = '200'
    AND OldValue = 'Man what a big Kite!'

EXEC pAudit_RollBack @AuditRollBack

SELECT ProductDescription 
  FROM dbo.Product
  WHERE Code = 200