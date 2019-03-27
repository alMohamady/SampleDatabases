Use Family 


go
CREATE 
-- alter 
FUNCTION dbo.descendents 
  (@ClassName CHAR(25))
  RETURNS @Classes TABLE (ClassID INT, ClassName VARCHAR(25), Lv INT)
AS 
BEGIN
  DECLARE @LC INT
  SET @LC = 1
  -- Handle the Anchor Person
  INSERT @Classes
    SELECT ClassID, ClassName, @LC
      FROM dbo.Class with (NoLock)
      WHERE ClassName = @ClassName

   -- Loop through sub-levels
  WHILE @@RowCount > 0 
    BEGIN
        SET @LC = @LC + 1
        -- insert the Class level
        INSERT @Classes
          SELECT ClassTree.ClassID, ClassTree.ClassName, @LC
            FROM dbo.Class ClassNode with (NoLock) 
              JOIN dbo.Class ClassTree with (NoLock) 
                ON ClassNode.ClassID = ClassTree.SuperClassID
              JOIN @Classes CC
                ON CC.ClassID = ClassNode.ClassID
            WHERE CC.Lv = @LC - 1
      END 
    RETURN
  END 
