-- Declare variables
DECLARE @column_name NVARCHAR(128) = 'is_telehealth';
DECLARE @table_name NVARCHAR(128);
DECLARE @column_exists INT;

-- Create a cursor to loop through each table in the database
DECLARE table_cursor CURSOR FOR
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

-- Open the cursor
OPEN table_cursor;

-- Loop through each table
FETCH NEXT FROM table_cursor INTO @table_name;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Check if the specific column exists in the current table
    SELECT @column_exists = COUNT(*)
    FROM information_schema.columns
    WHERE table_name = @table_name AND column_name = @column_name;

    -- If the column exists, print the table name
    IF @column_exists > 0
    BEGIN
        PRINT @table_name;
    END

    -- Fetch the next table
    FETCH NEXT FROM table_cursor INTO @table_name;
END

-- Close and deallocate the cursor
CLOSE table_cursor;
DEALLOCATE table_cursor;


-------------------------------------------------------------------------------------------------------------------------


-- Initialize the counter
DECLARE @counter INT = 0

-- Iterate through the list of tables
DECLARE @table_name sysname
DECLARE table_cursor CURSOR FOR
    SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'
OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @table_name
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Check if the specific column is in the table
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table_name AND COLUMN_NAME = 'is_telehealth')
    BEGIN
        SET @counter = @counter + 1
    END
    
    FETCH NEXT FROM table_cursor INTO @table_name
END
CLOSE table_cursor
DEALLOCATE table_cursor

-- Print the result
PRINT 'Number of tables that contain the specific column: ' + CAST(@counter AS VARCHAR(10))
