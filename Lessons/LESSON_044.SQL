-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 44 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-----------------------------------------------------
-- Examining SQL Server with Code

-- sp_help
USE OBXKites;
sp_help price;

-- Global Variables 
Select @@Connections;	
Select @@CPU_Busy;	
Select @@Cursor_Rows;	
Select @@DateFirst;	
Select @@DBTS;	
Select @@Error;	
Select @@Fetch_Status;	
Select @@Identity;	
Select @@Idle;	
Select @@IO_Busy;	
Select @@LangID;	
Select @@Language;	
Select @@Lock_TimeOut;	
Select @@Max_Connections;	
Select @@Max_Precision;	
Select @@Nestlevel;	
Select @@Options;	
Select @@Pack_Received;	
Select @@Pack_Sent;	
Select @@Packet_Errors;	
Select @@ProcID;	
Select @@RemServer;	
Select @@RowCount;	
Select @@ServerName;	
Select @@ServiceName;	
Select @@SPID;	
Select @@TextSize;	
Select @@TimeTicks;	
Select @@Total_Errors;	
Select @@Total_Read;	
Select @@Total_Write;	
Select @@TranCount;	
Select @@Version;	

---------------------------------------------------
-- Using Temp Tables

CREATE TABLE #ProductTemp (
  ProductID INT PRIMARY KEY
  );

INSERT INTO #ProductTemp  VALUES ( 1);

SELECT * 
  FROM #ProductTemp

SELECT Name 
  FROM TempDB.dbo.SysObjects
  WHERE Name Like '#Pro%'

-- Global Temp Table
IF NOT EXISTS(
  SELECT * FROM Tempdb.dbo.Sysobjects 
    WHERE Name = '##TempWork')
CREATE TABLE ##TempWork(
  PK INT,
  Col1 INT
);

-- Table Variable
DECLARE @WorkTable TABLE (
  PK INT PRIMARY KEY,
  Col1 INT NOT NULL);

INSERT INTO @WorkTable (PK, Col1)
  VALUES ( 1, 101);

SELECT PK, Col1 
  FROM @WorkTable;