
-----------------------------------------------------------
-- OBX Kites sample database - CREATE Database, Tables, and Procs

-- this script will drop an existing OBXKites database 
-- and create a fresh new installation

-- related scripts:
-- OBXKites_Populate

-- T-SQL KEYWORDS go
-- DatabaseNames   

-----------------------------------------------------------
-----------------------------------------------------------
-- Drop and Create Database


USE master
GO
IF EXISTS (SELECT * FROM SysDatabases WHERE NAME='OBXKites')
  DROP DATABASE OBXKites
go

-- This creates 1 database that uses 2 filegroups
CREATE DATABASE OBXKites


-- set to Full Log

go

SET QUOTED_IDENTIFIER ON
go
USE OBXKites
go

-----------------------------------------------------------
-----------------------------------------------------------
-- Create Tables, in order from primary to secondary

CREATE TABLE dbo.OrderPriority (
  OrderPriorityID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  OrderPriorityName NVARCHAR (15) NOT NULL,
  OrderPriorityCode NVARCHAR (15) NOT NULL,
  Priority INT NOT NULL
  )

go  

CREATE TABLE dbo.ProductCategory (
  ProductCategoryID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  ProductCategoryName NVARCHAR(50) NOT NULL,
  ProductCategoryDescription NVARCHAR(100) NULL
    )
  ON [Primary]
go
CREATE UNIQUE CLUSTERED INDEX ProductCategoryName
  ON ProductCategory (ProductCategoryName)
  ON [Primary]
go
CREATE TABLE dbo.Product (
  ProductID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  RowVersion Rowversion NOT NULL,
  ProductCategoryID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.ProductCategory,
  Code CHAR(15) NOT NULL,   
  ProductName NVARCHAR(50) NOT NULL,
  ProductDescription NVARCHAR(100) NULL,
  ActiveDate DATETIME NOT NULL DEFAULT GETDATE(),
  DiscontinueDate DATETIME NULL
   )
go
CREATE TABLE dbo.CustomerType (
  CustomerTypeID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) 
	PRIMARY KEY NONCLUSTERED,
  CustomerTypeName NVARCHAR(50) NOT NULL,
  DiscountPercent NUMERIC (4,2) NOT NULL DEFAULT (0),
  [Default] BIT NOT NULL DEFAULT 0
   )
go

CREATE TABLE dbo.Contact (
  ContactID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) 
	PRIMARY KEY NONCLUSTERED,
  ContactCode CHAR(15) NOT NULL,
  SoundexCode CHAR(4) NULL,
  LastName NVARCHAR(50) NOT NULL,
  FirstName NVARCHAR(50) NOT NULL,
  CompanyName NVARCHAR(50) NULL,
  CustomerTypeID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.CustomerType,
  CustomerSince CHAR(4) NULL,

  IsCustomer BIT NOT NULL DEFAULT (1),
  IsEmployee BIT NOT NULL DEFAULT (0),
  IsSupplier BIT NOT NULL DEFAULT (0),

  HomePhone NVARCHAR(50) NULL,
  HomeAddress1 NVARCHAR(50) NULL,
  HomeAddress2 NVARCHAR(50) NULL,
  HomeCity NVARCHAR(50) NULL,
  HomeRegion NVARCHAR(50) NULL,
  HomePostalCode NVARCHAR(50) NULL,
  HomeCountry NVARCHAR(50) NULL,
  OBXPhone NVARCHAR(50) NULL,
  OBXAddress1 NVARCHAR(50) NULL,
  OBXAddress2 NVARCHAR(50) NULL,
  OBXCity NVARCHAR(50) NULL,
  OBXRegion NVARCHAR(50) NULL,
  OBXPostalCode NVARCHAR(50) NULL,
  OBXCountry NVARCHAR(50) NULL
   ) 
go
CREATE CLUSTERED INDEX IxContact 
  ON dbo.Contact (SoundexCode)

go
CREATE TABLE dbo.Location (
  LocationID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) 
	PRIMARY KEY NONCLUSTERED,
  LocationCode CHAR(5),
  LocationName NVARCHAR(50) NOT NULL,
  IsRetail BIT NOT NULL DEFAULT (0)
   ) 
go
CREATE TABLE dbo.[Order] (
  OrderID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  OrderNumber INT NOT NULL,
  ContactID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.Contact,
  OrderPriorityID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.OrderPriority,
  EmployeeID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.Contact,
  LocationID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.Location,
  OrderDate DATETIME NOT NULL DEFAULT (GETDATE()),
  Closed BIT NOT NULL DEFAULT (0) -- set to true when Closed
   ) 
  ON [Primary]
go

CREATE TABLE dbo.OrderDetail (
  OrderDetailID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  OrderID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.[Order] ON DELETE CASCADE, 
  ProductID UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES dbo.Product,
  NonStockProduct NVARCHAR(256),
  Quantity NUMERIC(7,2) NOT NULL,
  UnitPrice MONEY NOT NULL,
  ExtendedPrice AS Quantity * UnitPrice, 
  ShipRequestDate DATETIME,
  ShipDate DATETIME,
  ShipComment NVARCHAR(256)
  ) 
  ON [Primary]
go

CREATE TABLE dbo.Price (
  PriceID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  ProductID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Product,
  Price MONEY NOT NULL,
  EffectiveDate DATETIME NOT NULL
    ) 
go

CREATE TABLE dbo.Inventory (
  InventoryID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  InventoryCode CHAR(15) NOT NULL,
  LocationID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Location, 
  ProductID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Product,
  QuantityOnHand INTEGER NOT NULL Default 0
    ) 
  ON [Primary]
go
CREATE TABLE dbo.InventoryTransaction (
  InventoryTransactionID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  Value NVARCHAR(50) NOT NULL,
  InventoryID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Inventory
    ) 
  ON [Primary]
go
CREATE TABLE dbo.Supplier (
  SupplierID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  ContactID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Contact, 
  ProductID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Product
    ) 
go
CREATE TABLE dbo.PO (
  POID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  PONumber CHAR(15) NOT NULL,
  ContactID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Contact
   ) 
  ON [Primary]
go
CREATE TABLE dbo.PODetail (
  PODetailID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL DEFAULT (NEWID()) PRIMARY KEY NONCLUSTERED,
  POID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.PO, 
  ProductID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES dbo.Product
    ) 
  ON [Primary]
go


-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- SPROCS
USE OBXKites

go

-----------------------------------------------------------------
-- ProductCategory Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pProductCategory_AddNew(
  @ProductCategoryName   NVARCHAR(50),
  @ProductCategoryDescription   NVARCHAR(100) = NULL
  )
AS
  SET NOCOUNT ON
  INSERT dbo.ProductCategory (ProductCategoryName, ProductCategoryDescription)
     VALUES (@ProductCategoryName, @ProductCategoryDescription)
go

-----------------------------------------------------------------
CREATE PROCEDURE pProductCategory_Fetch
-- If @Search = null then return all ProductCategories
-- If @Search is value then try to find by Name
AS 
  SET NOCOUNT ON
  SELECT ProductCategoryID, ProductCategoryName, ProductCategoryDescription
    FROM dbo.ProductCategory
 
go


------------------------------------------------------------------
CREATE PROCEDURE pProductCategory_FetchID(
  @Search  UNIQUEIDENTIFIER
)
-- If @Search = null then return all ProductCategories
-- If @Search is value then try to find by Name
AS 
  SET NOCOUNT ON
    IF EXISTS(SELECT * FROM dbo.ProductCategory WHERE ProductCategoryID = @Search)
      SELECT ProductCategoryID, ProductCategoryName, ProductCategoryDescription
        FROM dbo.ProductCategory
          WHERE ProductCategoryID = @Search
  ELSE 
    RAISERROR('ProductID Not Found.',14,1)
go

-----------------------------------------------------------------
CREATE PROCEDURE pProductCategory_Delete(
  @ProductCategoryID UNIQUEIDENTIFIER
)
AS
  SET NOCOUNT ON
  DELETE dbo.ProductCategory
    WHERE ProductCategoryID = @ProductCategoryID
go


-----------------------------------------------------------------
-- CustomerType Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pCustomerType_AddNew(
  @Name   NVARCHAR(50),
  @DiscountPercent NUMERIC (4,2) = 0,
  @Default BIT = 0
  )
AS
  SET NOCOUNT ON
  INSERT dbo.CustomerType (CustomerTypeName, DiscountPercent,[Default])
    VALUES (@Name, @DiscountPercent, @Default)
go

--------------------------------------------------------------
CREATE  PROCEDURE pCustomerType_Fetch(
  @Search NVARCHAR(50) = NULL
  )
AS
  SET NOCOUNT ON
  IF @Search IS NULL 
    SELECT CustomerTypeID, CustomerTypeName, DiscountPercent,[Default]
      FROM dbo.CustomerType
        ORDER BY CustomerTypeName
  ELSE 
    BEGIN
      SELECT CustomerTypeID, CustomerTypeName, DiscountPercent,[Default]
        FROM dbo.CustomerType
          WHERE CustomerTypeName = @Search
  IF @@ROWCOUNT = 0 
    RAISERROR('Name ''%s'' Not Found.',14,1,@Search)
      END
go   

CREATE PROCEDURE pCustomerType_Delete(
  @CustomerTypeID UNIQUEIDENTIFIER
)
AS
  SET NOCOUNT ON
  DECLARE 
    @ProductCategoryID UNIQUEIDENTIFIER,
    @Err INT,
    @ErrCounter INT
  SET @ErrCounter = 0
  DELETE dbo.CustomerType
    WHERE CustomerTypeID = @CustomerTypeID
RETURN

go

-----------------------------------------------------------------
-- Contact Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pContact_AddNew(
  @ContactCode NVARCHAR(20),
  @LastName NVARCHAR(50), 
  @FirstName NVARCHAR(50), 
  @CompanyName NVARCHAR(50) = NULL, 
  @Name NVARCHAR(50) = NULL 
  )
AS
  SET NOCOUNT ON
  DECLARE 
    @CustomerTypeID UNIQUEIDENTIFIER,
    @Err INT

  SELECT @CustomerTypeID = CustomerTypeID 
   FROM dbo.CustomerType
     WHERE CustomerTypeName = @Name
  IF @@Error <> 0 RETURN -100

  IF @CustomerTypeID IS NULL
    SELECT @CustomerTypeID = CustomerTypeID  
      FROM dbo.CustomerType
        WHERE [Default] = 1
  IF @@Error <> 0 RETURN -100
  IF @CustomerTypeID IS NULL
    BEGIN
      RAISERROR ('Customer Type: ''%s'' not found', 15,1,@Name)
      RETURN -100
    END

  INSERT dbo.Contact (
      ContactCode,SoundexCode, LastName, 
      FirstName, CompanyName, CustomerTypeID)
    VALUES (
      @ContactCode, SOUNDEX(@LastName), @LastName, 
      @FirstName, @CompanyName, @CustomerTypeID)
  IF @@Error <> 0 RETURN -100

  RETURN 0 

go


----------------------------------------------------------
CREATE PROCEDURE pContactSetEmployee(
  @ContactCode VARCHAR(15)
   )
AS
  SET NOCOUNT ON
  UPDATE dbo.Contact
    SET IsEmployee = 1
      WHERE ContactCode = @ContactCode
  IF @@RowCount = 0
    RAISERROR('Contact %s not updated.',16,1,@ContactCode)

go
-----------------------------------------------------------
CREATE PROCEDURE pContactClearEmployee(
  @ContactCode VARCHAR(15)
   )
AS
  SET NOCOUNT ON
  UPDATE dbo.Contact
    SET IsEmployee = 0
      WHERE ContactCode = @ContactCode
  IF @@RowCount = 0
    RAISERROR('Contact %s not updated.',16,1,@ContactCode)
go



-----------------------------------------------------------------
-- Product sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pProduct_AddNew(
  @ProductCategoryName NVARCHAR(50), 
  @Code CHAR(10),   
  @Name NVARCHAR(50),
  @ProductDescription NVARCHAR(100) = NULL
  )
AS
  SET NOCOUNT ON
  DECLARE 
    @ProductCategoryID UNIQUEIDENTIFIER

  SELECT @ProductCategoryID = ProductCategoryID 
    FROM dbo.ProductCategory
      WHERE ProductCategoryName = @ProductCategoryName
  IF @@Error <> 0 RETURN -100

  IF @ProductCategoryID IS NULL
    BEGIN
      RAISERROR ('Product Category: ''%s'' not found', 15,1,@ProductCategoryName)
      RETURN -100
    END

  INSERT dbo.Product (ProductCategoryID, Code, ProductName, ProductDescription)
    VALUES (@ProductCategoryID, @Code, @Name, @ProductDescription )
  IF @@Error <> 0 RETURN -100
  RETURN 0 
go

--------------------------------------------------------

CREATE PROCEDURE pProduct_Fetch(
  @ProductCode CHAR(15) = NULL,
  @ProductCategory CHAR(15) = NULL ) 
AS
SET NoCount ON

SELECT Code, ProductName, ProductDescription, ActiveDate,
    DiscontinueDate, ProductCategoryName, [RowVersion] --,
--    Product.Created, Product.Modified  
  FROM Product
    JOIN ProductCategory
      ON Product.ProductCategoryID 
             = ProductCategory.ProductCategoryID
  WHERE ( Product.Code = @ProductCode 
                OR @ProductCode IS NULL ) 
    AND ( ProductCategory.ProductCategoryName = @ProductCategory
              OR @ProductCategory IS NULL ) 
  IF @@Error <> 0 RETURN -100

RETURN

go
-------------------------------------
CREATE PROCEDURE pProduct_Update_RowVersion (
  @Code CHAR(15), 
  @RowVersion Rowversion,
  @Name VARCHAR(50), 
  @ProductDescription VARCHAR(50), 
  @ActiveDate DateTime,
  @DiscontinueDate DateTime )
AS 
SET NoCount ON

UPDATE dbo.Product
  SET 
    ProductName = @Name,
    ProductDescription = @ProductDescription,
    ActiveDate = @ActiveDate,
    DiscontinueDate = @DiscontinueDate
  WHERE Code = @Code 
    AND [RowVersion] = @RowVersion
  
  IF @@ROWCOUNT = 0 
    BEGIN
    IF EXISTS ( SELECT * FROM Product WHERE Code = @Code)
      BEGIN
        RAISERROR ('Product failed to update because another transaction updated the row since your last read.', 16,1)
        RETURN -100
      END 
    ELSE 
      BEGIN
        RAISERROR ('Product failed to update because the row has been deleted', 16,1)
        RETURN -100
      END 
    END

RETURN
go

-----------------------------------------

CREATE PROCEDURE pProduct_Update_Minimal (
  @Code CHAR(15), 
  @Name VARCHAR(50) = NULL, 
  @ProductDescription VARCHAR(50) = NULL, 
  @ActiveDate DateTime = NULL,
  @DiscontinueDate DateTime = NULL )

AS 
SET NoCount ON

IF EXISTS (SELECT * FROM dbo.Product WHERE Code = @Code)
  BEGIN 
    BEGIN TRANSACTION
    IF @Name IS NOT NULL
      BEGIN
        UPDATE dbo.Product
          SET 
            ProductName = @Name
          WHERE Code = @Code
        IF @@Error <> 0 
          BEGIN
            ROLLBACK
            RETURN -100
          END
      END 

    IF @ProductDescription IS NOT NULL
      BEGIN
        UPDATE dbo.Product
          SET 
            ProductDescription = @ProductDescription
          WHERE Code = @Code 
        IF @@Error <> 0 
          BEGIN
            ROLLBACK
            RETURN -100
          END
      END 
 
    IF @ActiveDate IS NOT NULL
      BEGIN
        UPDATE dbo.Product
          SET 
            ActiveDate = @ActiveDate
          WHERE Code = @Code 
        IF @@Error <> 0 
          BEGIN
            ROLLBACK
            RETURN -100
          END
      END 

    IF @DiscontinueDate IS NOT NULL
      BEGIN
        UPDATE dbo.Product
          SET 
            DiscontinueDate = @DiscontinueDate
          WHERE Code = @Code
        IF @@Error <> 0 
          BEGIN
            ROLLBACK
            RETURN -100
          END
      END
    COMMIT TRANSACTION
  END
ELSE 
  BEGIN
    RAISERROR 
      ('Product failed to update because the row has 
          been deleted', 16,1)
    RETURN -100
  END
RETURN 

go
  
-----------------------------------------------------------------
CREATE PROCEDURE pProduct_Delete(
  @ProductCode INT
)
AS
  SET NOCOUNT ON
  DECLARE @ProductID UniqueIdentifier

  SELECT @ProductID = ProductID 
    FROM Product
    WHERE Code = @ProductCode
  If @@RowCount = 0 
    BEGIN
      RAISERROR  
        ('Unable to delete Product Code %i - does not exist.', 16,1, @ProductCode)
      RETURN
    END
  ELSE
    DELETE dbo.Product
      WHERE ProductID = @ProductID
RETURN
go
-----------------------------------------------------------------
-- Location Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pLocation_AddNew(
  @LocationCode CHAR(15),
  @LocationName NVARCHAR(50),
  @isRetail BIT
  )
AS
  SET NOCOUNT ON
  INSERT dbo.Location(LocationCode, LocationName, IsRetail)
    VALUES (@LocationCode, @LocationName, @IsRetail)
  IF @@Error <> 0 RETURN -100
RETURN

go


-----------------------------------------------------------------
-- Price Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pPrice_AddNew(
  @Code CHAR(10) = NULL,
  @Name NVARCHAR(50) = NULL,
  @Price MONEY,
  @EffectiveDate DATETIME = NULL)
AS
-- may specifiy either Product Code or Name
-- re-inserting price for product and date will overwrite price row

  SET NOCOUNT ON
  DECLARE @ProductID UNIQUEIDENTIFIER

  IF @Code IS NOT NULL
    BEGIN
    SELECT @ProductID = ProductID 
      FROM dbo.Product
        WHERE Code = @Code
  IF @ProductID IS NULL
   BEGIN
     RAISERROR ('Product: ''%s'' not found by code', 15,1,@Code)
     RETURN -1
     END
   END

  ELSE IF @Name IS NOT NULL
  BEGIN
  SELECT @ProductID = ProductID 
    FROM dbo.Product
      WHERE ProductName = @Name
    IF @ProductID IS NULL
      BEGIN
      RAISERROR ('Product: ''%s'' not found by name', 15,1,@Name)
      RETURN -1
        END
    END

  INSERT dbo.Price (ProductID, Price, EffectiveDate)
    VALUES (@ProductID, @Price, @EffectiveDate)

  RETURN 0 
go



-----------------------------------------------------------------
-- Order Entry  Sprocs
-----------------------------------------------------------------

CREATE PROCEDURE pGetPrice(
  @Code CHAR(10),
  @PriceDate DATETIME = NULL,
  @ContactCode CHAR(15) = NULL,
  @CurrPrice MONEY OUTPUT
  )
AS
-- Will return the current price for the product for today or any other date
-- The customer type determines the discount percentage
-- the output parameter, @CurrPrice, will contain the effective price

-- example code for calling this sproc:
-- Declare @Price money
-- EXEC GetPrice '1006', NULL, @Price OUTPUT
-- Select @Price

SET NOCOUNT ON
DECLARE 
  @DiscountPercent NUMERIC (4,2),
  @Err INT,
  @ErrCounter INT

SET @ErrCounter = 0
SET @CurrPrice = NULL

LockTimeOutRetry:

IF @PriceDate IS NULL
  SET @PriceDate = GETDATE()
 -- set the discount percent / if no customer lookup then it's zilch discount
SELECT @DiscountPercent = CustomerType.DiscountPercent 
  FROM dbo.Contact
    JOIN dbo.CustomerType
      ON contact.CustomerTypeID = CustomerType.CustomerTypeID 
   WHERE ContactCode = @ContactCode
SET @Err = @@ERROR
  IF @Err <> 0 GOTO ErrorHandler

IF @DiscountPercent IS NULL
  SET @DiscountPercent = 0

SELECT @CurrPrice = Price * (1-@DiscountPercent)
  FROM dbo.Price 
    JOIN dbo.Product 
      ON Price.ProductID = Product.ProductID
  WHERE Code = @Code
    AND EffectiveDate = 
      (SELECT MAX(EffectiveDate) 
        FROM dbo.Price 
          JOIN dbo.Product 
            ON Price.ProductID = Product.ProductID
        WHERE Code = @Code 
          AND EffectiveDate <= @PriceDate)
  IF @CurrPrice IS NULL
    BEGIN
      RAISERROR('Code: ''%s'' has no established price.',15,1, @Code)
      RETURN -100
    END

SET @Err = @@ERROR
  IF @Err <> 0 GOTO ErrorHandler
RETURN 0

ErrorHandler:
  IF (@Err = 1222 OR @Err = 1205) AND @ErrCounter = 5
    BEGIN 
      RAISERROR ('Unable to Lock Data after five attempts.', 16,1)
      RETURN -100
    END
  IF @Err = 1222 OR @Err = 1205 -- Lock Timeout / Deadlock
    BEGIN
      WAITFOR DELAY '00:00:00.25'
      SET @ErrCounter = @ErrCounter + 1
      GOTO LockTimeOutRetry
    END
  -- else unknown error
  RAISERROR (@err, 16,1) WITH LOG
  RETURN -100
go

-----------------------------------------

CREATE FUNCTION dbo.fGetPrice (   
  @Code CHAR(10),
  @PriceDate DATETIME,
  @ContactCode CHAR(15) = NULL)
RETURNS MONEY
As
-- sample calling code:
-- Select dbo.fGetPrice('1006',GetDate())
-- Select dbo.fGetPrice('1001','5/1/2001',NULL)
-- must specify date, GetDate() not allowed within function
  BEGIN
  DECLARE @CurrPrice MONEY 
   DECLARE @DiscountPercent NUMERIC (4,2)
     -- set the discount percent / if no customer lookup then it's zilch discount
  SELECT @DiscountPercent = CustomerType.DiscountPercent 
    FROM dbo.Contact
      JOIN dbo.CustomerType
        ON contact.CustomerTypeID = CustomerType.CustomerTypeID 
    WHERE ContactCode = @ContactCode
  IF @DiscountPercent IS NULL
    SET @DiscountPercent = 0
  SELECT @CurrPrice = Price * (1-@DiscountPercent)
    FROM dbo.Price 
       JOIN dbo.Product 
         ON Price.ProductID = Product.ProductID
    WHERE Code = @Code
      AND EffectiveDate = 
        (SELECT MAX(EffectiveDate) FROM dbo.Price  JOIN dbo.Product ON Price.ProductID = Product.ProductID
          WHERE Code = @Code AND EffectiveDate <= @PriceDate)
    RETURN @CurrPrice
  END
go

-----------------------------------------
-- pOrder_AddNew creates a new order and assigns an OrderNumber

CREATE PROC pOrder_AddNew (
  @ContactCode CHAR(15) = 0,  -- if default then non-tracked customer
  @EmployeeCode CHAR(15),
  @LocationCode CHAR(15),
  @OrderDate DATETIME = NULL,
  @OrderNumber INT OUTPUT
  )
AS
-- Logic:
-- If supplied, check CustomerID valid  
  SET NOCOUNT ON
  DECLARE 
    @ContactID UNIQUEIDENTIFIER,
    @OrderID UNIQUEIDENTIFIER,
    @LocationID UNIQUEIDENTIFIER,
    @EmployeeID UNIQUEIDENTIFIER,
    @Err INT,
    @ErrCounter INT

  SET @ErrCounter = 0

LockTimeOutRetry:

-- Set Customer ContactID
   IF @ContactCode = 0
    SET @ContactID = NULL
  ELSE  
    BEGIN
      SELECT @ContactID = ContactID 
        FROM dbo.Contact 
          WHERE ContactCode = @ContactCode
      SET @Err = @@ERROR
        IF @Err <> 0 GOTO ErrorHandler
      IF @ContactID IS NULL
        BEGIN  -- a customer was submitted but not found
         RAISERROR( 'CustomerCode: ''%s not found',15,1, @ContactCode)
         RETURN -100
        END
    END

-- Set LocationID
  SELECT @LocationID = LocationID 
    FROM dbo.Location 
    WHERE LocationCode = @LocationCode
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler
  IF @LocationID IS NULL
    BEGIN  -- Location not found
      RAISERROR('LocationCode: ''%s'' not found',15,1, @LocationCode)
      RETURN -100
    END
  IF EXISTS(SELECT * 
                    FROM dbo.Location 
                    WHERE LocationID = @LocationID 
                      AND IsRetail = 0)
    BEGIN  -- Location not found
      RAISERROR('LocationCode: ''%s'' not retail',15,1, @LocationCode)
      RETURN -100
    END

-- Set EmployeeID
  SELECT @EmployeeID = ContactID 
    FROM dbo.Contact 
      WHERE ContactCode = @EmployeeCode
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler
  IF @EmployeeCode IS NULL
    BEGIN  -- Location not found
      RAISERROR('EmployeeCode: ''%s'' not found',15,1, @EmployeeCode)
      RETURN -100
    END

-- OrderNumber
  SET @OrderID = NEWID()
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
  BEGIN TRANSACTION
    SELECT @OrderNumber = Max(OrderNumber) + 1 
      FROM [Order]
    SET @OrderNumber =  ISNULL(@OrderNumber, 1)
    SET @Err = @@ERROR
    IF @Err <> 0 
      BEGIN
        ROLLBACK TRANSACTION
        GOTO ErrorHandler
      END
  -- All OK Perform the Insert
  INSERT dbo.[Order] ( OrderID, ContactID, OrderNumber, EmployeeID, LocationID, OrderDate ) 
    VALUES ( @OrderID, @ContactID,@OrderNumber, @EmployeeID, @LocationID, ISNULL(@OrderDate,GETDATE()))
  SET @Err = @@ERROR
  IF @Err <> 0 
    BEGIN
      ROLLBACK TRANSACTION
      GOTO ErrorHandler
    END
  COMMIT TRANSACTION

RETURN -- @OrderNumber already set

ErrorHandler:
  IF (@Err = 1222 OR @Err = 1205) AND @ErrCounter = 5
    BEGIN 
      RAISERROR ('Unable to Lock Data after five attempts.', 16,1)
      RETURN -100
    END
  IF @Err = 1222 OR @Err = 1205 -- Lock Timeout / Deadlock
    BEGIN
      WAITFOR DELAY '00:00:00.25'
      SET @ErrCounter = @ErrCounter + 1
      GOTO LockTimeOutRetry
    END
  -- else unknown error
  RAISERROR (@err, 16,1) WITH LOG
  RETURN -100

go


-----------------------------------------
CREATE PROCEDURE pOrder_AddItem(
  @OrderNumber CHAR(15),
  @Code CHAR(15) = 0, -- if default then non-stock Product
  @NonStockProduct NVARCHAR(256) = NULL,
  @Quantity NUMERIC(7,2),
  @UnitPrice MONEY = 0, -- If Default then lookup the Price
  @ShipRequestDate DATETIME = NULL, --default to Today
  @ShipComment NVARCHAR(256) = NULL -- optional 
  )
AS 

DECLARE
  @OrderID UNIQUEIDENTIFIER,
  @ProductID UNIQUEIDENTIFIER,
  @ContactCode CHAR(15),
  @PriceDate DATETIME,
  @Err INT,
  @ErrCounter INT

  SET @ErrCounter = 0

LockTimeOutRetry:
  
-- Fetch OrderID
  SELECT @OrderID = OrderID 
    FROM dbo.[Order]
    WHERE OrderNumber = @OrderNumber
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler

-- Fetch ProductID
  SELECT @ProductID = ProductID
    FROM Product
    WHERE Code = @Code
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler

--- Fetch Contact Code / PriceDate
  SELECT @ContactCode = ContactCode, @PriceDate = OrderDate
     FROM dbo.[Order] 
       LEFT JOIN Contact
         ON [Order].ContactID = Contact.ContactID
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler

-- Fetch UnitPrice
  IF @UnitPrice IS NULL 
    EXEC pGetPrice 
      @Code, @PriceDate, @ContactCode, @UnitPrice OUTPUT
     -- Alternate GetPrice function method
     -- SET @UnitPrice = dbo.fGetPrice (@Code,@PriceDate, @ContactCode)
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler
  IF @UnitPrice IS NULL
    BEGIN
      RAISERROR(
        'Code: ''%s'' has no established price.',15,1, @Code)
      RETURN -1
    END 


-- Set ShipRequestDate
  IF @ShipRequestDate IS NULL
    SET @ShipRequestDate = @PriceDate
-- Do the insert
  INSERT OrderDetail(
    OrderID, ProductID, NonStockProduct, Quantity,
    UnitPrice, ShipRequestDate, ShipComment)
  VALUES (
    @OrderID, @ProductID, @NonStockProduct, @Quantity,
    @UnitPrice, @ShipRequestDate, @ShipComment)
  SET @Err = @@ERROR
    IF @Err <> 0 GOTO ErrorHandler

RETURN 0

ErrorHandler:
  IF (@Err = 1222 OR @Err = 1205) AND @ErrCounter = 5
    BEGIN 
      RAISERROR (
        'Unable to Lock Data after five attempts.', 16,1)
      RETURN -100
    END
  IF @Err = 1222 OR @Err = 1205 -- Lock Timeout / Deadlock
    BEGIN
      WAITFOR DELAY '00:00:00.25'
      SET @ErrCounter = @ErrCounter + 1
      GOTO LockTimeOutRetry
    END
  -- else unknown error
  RAISERROR (@err, 16,1) WITH LOG
  RETURN -100



go


-------------------------------------------------------
CREATE PROCEDURE pOrderPriority_AddNew(
   @OrderPriorityName  NVARCHAR(15),
   @OrderPriorityCode  NVARCHAR(15),
   @Priority  INT
   )
AS
   SET NOCOUNT ON
   INSERT OrderPriority (OrderPriorityName, OrderPriorityCode, Priority)
      Values (@OrderPriorityName, @OrderPriorityCode, @Priority)
go

--------------------------------------------------------
CREATE PROCEDURE pOrder_SetPriority(
   @OrderNumber INT,
   @OrderPriorityCode NVARCHAR(15)
   )
AS
   SET NOCOUNT ON
   DECLARE @OrderPriorityID UNIQUEIDENTIFIER,
      @OrderID UNIQUEIDENTIFIER
   SELECT @OrderPriorityID = OrderPriorityID 
      FROM dbo.OrderPriority
      WHERE OrderPriorityCode = @OrderPriorityCode
-- Check OrderPriorityCode
   IF @OrderPriorityCode IS NULL
      BEGIN
         RAISERROR('Invalid OrderPriorityCode',14,1)
         RETURN 1
      END 
-- Fetch OrderID
  SELECT @OrderID = OrderID 
    FROM dbo.[Order]
    WHERE OrderNumber = @OrderNumber
-- Check OrderNumber
   IF @OrderID IS NULL
      BEGIN
         RAISERROR('Invalid OrderNumber',14,1)
         RETURN 1
      END 
   UPDATE [Order]
      SET OrderPriorityID = @OrderPriorityID
      WHERE OrderID = @OrderID








go
-----------------------------------------------------------
-- Standard Utility Procs

CREATE VIEW dbo.vTableRowCount
as
SELECT TOP 100 PERCENT dbo.sysobjects.[name], dbo.sysindexes.[rows]
  FROM dbo.sysindexes 
  JOIN dbo.sysobjects 
    ON dbo.sysindexes.[id] = dbo.sysobjects.[id]
      WHERE (dbo.sysobjects.xtype = 'U') 
        AND (dbo.sysindexes.indid = 0 
    OR dbo.sysindexes.indid = 1)
  ORDER BY dbo.sysindexes.[name]
go


CREATE PROC sp_GetLocks
AS
Create Table #locks	
  (spid 	INT,
  dbid 	INT,
  objid 	INT,
  indid 	INT,
  type 	CHAR(5),
  Resource NVARCHAR(255),
  Mode	NVARCHAR(255),
  Status	NVARCHAR(255))

INSERT #Locks EXEC sp_lock

SELECT  P.loginame, P.spid, l.dbid AS 'database', S.NAME AS 'Object' ,P.cmd, 
  l.type AS 'LockSize', l.mode AS 'lockMode', l.status, P.blocked, P.waittime
  FROM #Locks L
  Join sysobjects S
    ON L.ObjID = S.ID
  Join Master.dbo.sysprocesses P
    ON L.spid = P.spid
  ORDER BY p.loginame,P.spid, P.dbid, s.NAME

RETURN


go 

USE TempDB

