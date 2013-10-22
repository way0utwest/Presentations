CREATE DATABASE EncryptionPrimer2
;
go
USE EncryptionPrimer2
;
go

-- create master key
create master KEY
 encryption by password = 'MySup3rSafe5Passc0d#'
;
GO


CREATE TABLE TEST
( ID INT)

GO


INSERT INTO TEST
 SELECT 1


 SELECT * FROM TEST
