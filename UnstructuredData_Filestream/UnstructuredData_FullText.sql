/*
Filetable Full Text Search Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
-- use the database from the Filetable demo
USE UnstructuredData
go

select * 
 from sys.fulltext_document_types;
go


-- if you install the Adobe PDF iFilter, then reload

-- load filters
EXEC sp_fulltext_service @action='load_os_resources', @value=1;
exec sp_fulltext_service 'verify_signature', 0;
EXEC sp_fulltext_service 'restart_all_fdhosts';
go


-- create catalog
CREATE FULLTEXT CATALOG AuthorDrafts_Catalog AS DEFAULT;
go


-- Index
-- Needs PK index name from table. You may need to go get this from the table
-- Use wizard
CREATE FULLTEXT INDEX ON dbo.AuthorDrafts
    (name,
    file_stream TYPE COLUMN file_type)
    KEY INDEX PK__AuthorDr__5A5B77D5337E95C5
    ON AuthorDrafts_Catalog
    WITH
        CHANGE_TRACKING AUTO,
        STOPLIST = SYSTEM;



-- run full population





-- search table
SELECT name
FROM dbo.AuthorDrafts
WHERE
FREETEXT (file_stream, 'Delaney');


-- search table
SELECT name
FROM dbo.AuthorDrafts
WHERE
FREETEXT (file_stream, 'PDA');


-- search table
SELECT name
FROM dbo.AuthorDrafts
WHERE
FREETEXT (file_stream, 'hypervisor');

SELECT name
FROM dbo.AuthorDrafts
WHERE
FREETEXT (file_stream, 'GCWR');

-- search table
SELECT name
FROM dbo.AuthorDrafts
WHERE
FREETEXT (file_stream, 'Amena''s');


-- clean up
DROP TABLE dbo.AuthorDrafts
;
go
-- share is gone.

CHECKPOINT
;
go

