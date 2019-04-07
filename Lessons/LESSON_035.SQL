-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 35 - Selecting Data through Views
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-- Creating the View
USE [OBXKites]
GO

IF EXISTS(SELECT * FROM SysObjects WHERE Name = 'ViewFirst')
  DROP VIEW dbo.ViewFirst


CREATE VIEW [dbo].[ViewFirst]
AS
SELECT         O.OrderID AS musterO, O.OrderNumber, O.ContactID, O.OrderPriorityID, 
               O.EmployeeID, O.LocationID, O.OrderDate, O.Closed, 
               OD.OrderDetailID, OD.NonStockProduct, OD.UnitPrice, P.ProductID, 
                         P.ProductCategoryID, P.Code, P.ProductName, P.ProductDescription
FROM            dbo.Product AS P INNER JOIN
                         dbo.OrderDetail AS OD ON P.ProductID = OD.ProductID INNER JOIN
                         dbo.[Order] AS O ON OD.OrderID = O.OrderID
ORDER BY musterO
GO


-- Where
   Select * From  ViewFirst where 
        OrderNumber = '4'


-- Order By
    Select * From  ViewFirst 
	    Order By  [musterO], [OrderNumber]