-- unstructured data


-- Check filestream

-- SQL Server Configuration Manager


-- Check configuration
EXEC sp_configure
go

-- Look at Filestream in AdventureWorks
-- Product.Document table:
-- Design properties




-- Get file names and document
USE AdventureWorks2008;
GO
SELECT TOP 10 
   Document
 , FileName +'.' +  FileExtension
 FROM Production.Document
 WHERE Document IS NOT NULL;
go

-- Run PS


