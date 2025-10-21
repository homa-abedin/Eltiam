DECLARE @schemaName NVARCHAR(128) = 'kharazmi';                      
DECLARE @tableName NVARCHAR(128) = 'dimproduct';         
DECLARE @collation NVARCHAR(100) = 'SQL_Latin1_General_CP1_CI_AS';  
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 
    'ALTER TABLE [' + s.name + '].[' + t.name + '] ALTER COLUMN [' + c.name + '] ' +
    UPPER(tp.name) + 
    CASE 
        WHEN tp.name IN ('varchar', 'char', 'nvarchar', 'nchar') 
        THEN '(' + 
            CASE 
                WHEN c.max_length = -1 THEN 'MAX' 
                ELSE CAST(c.max_length AS VARCHAR(10)) 
            END + ')' 
        ELSE '' 
    END +
    ' COLLATE ' + @collation + 
    CASE WHEN c.is_nullable = 1 THEN ' NULL' ELSE ' NOT NULL' END + ';
' + CHAR(13) + CHAR(10)
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.types tp ON c.user_type_id = tp.user_type_id
WHERE tp.name IN ('varchar', 'char', 'text', 'nvarchar', 'nchar', 'ntext')
  AND t.name = @tableName
  AND s.name = @schemaName;

--SELECT @sql AS ScriptToRun;

 EXEC sp_executesql @sql;
