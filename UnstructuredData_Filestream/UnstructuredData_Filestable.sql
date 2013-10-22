/*
FileTable Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- create a new database
create database UnstructuredData
go


-- add a filestream FG
ALTER DATABASE [UnstructuredData] ADD FILEGROUP [FS] CONTAINS FILESTREAM 
GO





-- Add a file to the Filestream FG
ALTER DATABASE [UnstructuredData] 
  ADD FILE ( NAME = N'UnstructuredFS', FILENAME = N'c:\fs\UnstructuredFS' ) TO FILEGROUP [FS]
go








-- Enable the database for access, specify the folder for storage. This is 
alter database UnstructuredData
  SET FILESTREAM 
      ( NON_TRANSACTED_ACCESS = FULL, 
	    DIRECTORY_NAME = N'FS' );
go

-- change to the database
Use UnstructuredData
go

-- Create a filetable
CREATE TABLE AuthorDrafts AS FileTable
GO



-- check the table.
select *
 from AuthorDrafts;
go




-- check the filetable DMV
SELECT * FROM sys.filetables;
GO

-- check the share, paste result into Explorer
select  FileTableRootPath('dbo.AuthorDrafts');
go





-- copy files, use sample corpus of documents. (Word, Excel, PDF, etc)




-- check the table.
select *
 from AuthorDrafts
 ;
go
-- documents appear


-- delete some image files from explorer
-- recheck the table
select *
 from AuthorDrafts
 where right(name, 3) = 'jpg'
 ;
 go


 -- delete files from T-SQL
 delete authordrafts
  where right(name, 3) = 'pdf'
 ;
 go
-- check the table
select *
 from AuthorDrafts
;
go
-- go look in explorer
-- issue checkpoint
checkpoint;


-- check the table.
select 
  NAME, *	
 from AuthorDrafts;






 -- clean up
 use master;
 go
 drop database UnstructuredData;


