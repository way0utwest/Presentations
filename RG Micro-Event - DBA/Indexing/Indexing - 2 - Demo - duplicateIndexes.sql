-- Duplicate Indexes
USE AdventureWorks2008
go
-- Execute SQL Skills Find dupes - http://www.sqlskills.com/blogs/kimberly/removing-duplicate-indexes/
EXEC sp_SQLskills_SQL2008_finddupes 'Production.Document'
go


/*
-- copy drop statement here
DROP INDEX [Production].[Document].[AK_Document_rowguid]
*/

EXEC sp_SQLskills_SQL2008_helpindex 'Production.Document'
GO







-- disable index

  