-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 49 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
----------------------------------------------------------
-- Iterating through rows 


USE Family
DECLARE @Name VARCHAR(100)

-- Fast Forward Cursor / Function
-- 1
DECLARE cDetail CURSOR FAST_FORWARD READ_ONLY
  FOR SELECT FirstName + ' ' + LastName
      FROM Person 
        ORDER BY DateofBirth
-- 2  
OPEN cDetail
-- 3
FETCH cDetail INTO @Name  -- prime the cursor
PRINT @Name

  WHILE @@Fetch_Status = 0 
    BEGIN
      PRINT @Name
      
      -- 3       
      FETCH cDetail INTO @Name  -- fetch next
    END

-- 4  
CLOSE cDetail

-- 5
DEALLOCATE cDetail