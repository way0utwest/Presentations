/*
TDE Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- create a database
CREATE DATABASE TDE_Primer
;
GO
-- create and populate a table
USE TDE_Primer
go
CREATE TABLE MyTable
( myid INT
, myname VARCHAR(20)
, mychar VARCHAR(200)  
)
;
go
DECLARE @i INT = 65;
WHILE @i < 92
 begin
  INSERT mytable SELECT @i, 'Steve Jones', REPLICATE(CHAR(@i), 200);
  SELECT @i = @i + 1;
 END
;
GO
SELECT * FROM Mytable;
go





-- detach database
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'TDE_Primer'
;

GO



-- examine with a hex editor




-- reattach database
USE [master]
GO
CREATE DATABASE [TDE_Primer] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TDE_Primer.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TDE_Primer_log.ldf' )
 FOR ATTACH
GO

USE TDE_Primer
go
SELECT * FROM mytable
;
go


-- begin encryption setup
-- from http://msdn.microsoft.com/en-us/library/bb934049.aspx
USE master;
GO
-- create master key for master
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AlwaysU$eaStr0ngP@ssword4This'
;
go

-- create certificate to secure TDE
CREATE CERTIFICATE TDEPRimer_CertSecurity WITH SUBJECT = 'TDE_Primer DEK Certificate';
go


USE TDE_Primer;
GO
-- Create DEK
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE TDEPRimer_CertSecurity;
GO


-- backup TDE cert
USE master
;
go
BACKUP CERTIFICATE TDEPRimer_CertSecurity
 TO FILE = 'tdeprimer_cert'
  WITH PRIVATE KEY (
               FILE = 'tdeprimer_cert.pvk',
               ENCRYPTION BY PASSWORD = 'AStr0ngB@ckUpP@ssw0rd4TDEcERT%')
;
go

-- check encryption status
SELECT
    db.name,
    db.is_encrypted,
    dm.encryption_state,
    dm.percent_complete,
    dm.key_algorithm,
    dm.key_length
FROM
    sys.databases db
    LEFT OUTER JOIN sys.dm_database_encryption_keys dm
        ON db.database_id = dm.database_id;
GO

-- enable encryption
USE TDE_Primer
;
GO
ALTER DATABASE TDE_Primer
  SET ENCRYPTION ON;
GO
-- check encryption status
SELECT
    db.name,
    db.is_encrypted,
    dm.encryption_state,
    dm.percent_complete,
    dm.key_algorithm,
    dm.key_length
FROM
    sys.databases db
    LEFT OUTER JOIN sys.dm_database_encryption_keys dm
        ON db.database_id = dm.database_id;
GO
-- TDE_PRimer and tempdb encrypted


-- detach database again.
-- detach database
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'TDE_Primer'
;

GO






-- hex editor







-- reattach it and perform a backup
USE [master]
GO
CREATE DATABASE [TDE_Primer] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TDE_Primer.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TDE_Primer_log.ldf' )
 FOR ATTACH
GO
BACKUP DATABASE TDE_Primer
  TO DISK = 'TDE_PRimer_Full.bak'
;
go



-- copy files to new instance.


-- restore in GUI







-- Error
-- copy certificate


-- second script





-- remove encryption
ALTER DATABASE TDE_Primer
 SET ENCRYPTION OFF
;
go
SELECT
    db.name,
    db.is_encrypted,
    dm.encryption_state,
    dm.percent_complete,
    dm.key_algorithm,
    dm.key_length
FROM
    sys.databases db
    LEFT OUTER JOIN sys.dm_database_encryption_keys dm
        ON db.database_id = dm.database_id;
GO



-- cleanup
USE master
;
DROP DATABASE TDE_Primer
;
go
DROP CERTIFICATE TDEPRimer_CertSecurity
;
GO
DROP MASTER KEY
;
GO

