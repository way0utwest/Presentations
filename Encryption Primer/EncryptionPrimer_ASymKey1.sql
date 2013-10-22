/*
Asymmetric Key Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
-- asymmetric keys
USE EncryptionPrimer

-- create an asymmetric key
DROP ASYMMETRIC KEY hrprotection
create asymmetric key HRProtection
 with algorithm = RSA_1024
GO



go


-- encrypt data
declare 
  @p varchar(200)
, @e varbinary(max);

select @p = 'My salary is $1,000,000/yr';
select @e = ENCRYPTBYASYMKEY(AsymKey_ID(N'HRProtection'), @p);

select 
   plaintext = @p
 , encrypted = @e;

go

-- decrypt the data
declare @e varbinary(max);

-- paste from previous results
select @e = 0xBAE7CA2751407AC6862FE621E22D64EA2A212F2E083DF8045FA9FE8564E1F62B18BECF4D56DFF3E839DADC334C83D856AE0E190409CBC7BDB3428978373DBF047B6D495091F08303F9A1195F6C3B6C715B2EBF02243A199E861F78C18D8398DE0ACD1E31D32D8B2226C1F778B8C33182831165047AA1DF22CFE12ED825E05149;

select decryptedvalue = cast( DECRYPTBYASYMKEY(asymkey_id(N'HRProtection'), @e) as varchar(max));

go


-- more common, protect symmetric key with another key

-- Create certificate
-- run in command prompt
/*
makecert -sv "c:\EncryptionPrimer\MyHRCert.pvk" -pe -a sha1 -b "01/01/2012" -e "12/31/2012" -len 2048 -r -n CN="HR Protection Certificate" c:\EncryptionPrimer\MyHRCert.cer


*/

-- load certificate
-- check permissions
create certificate MyHRCert
 from file = N'c:\EncryptionPrimer\MyHRCert.cer'
 with private key
  ( file = N'c:\EncryptionPrimer\MyHRCert.pvk'
  
   );
go


-- create self signed certificate
create certificate MySalaryCert
   ENCRYPTION BY PASSWORD = N'UCan!tBreakThis1'
   WITH SUBJECT = 'Sammamish Shipping Records', 
   EXPIRY_DATE = '20121231';
go


-- backup, since we could lose this with a db issue.
backup certificate MySalaryCert
 to file = N'C:\EncryptionPrimer\MySalaryCert.cer'
  WITH PRIVATE KEY ( DECRYPTION BY PASSWORD = N'UCan!tBreakThis1'
                   , FILE = 'C:\EncryptionPrimer\MySalaryCert.pvk' , 
    ENCRYPTION BY PASSWORD = N'UCan*tBr3akThisEither' );
go


-- Drop certificate
Drop Certificate MySalaryCert;
go



-- Reload to test restore
create certificate MySalaryCert
 from file = N'c:\EncryptionPrimer\MySalaryCert.cer'
 with private key
  ( file = N'c:\EncryptionPrimer\MySalaryCert.pvk'
  , decryption by password = N'UCan*tBr3akThisEither'
   );



-- create symmetric key
create symmetric key SalarySymKey
 with algorithm = AES_256
 encryption by certificate MySalaryCert;
go


-- Now go and encrypt data
create table salary
( empid int NOT NULL
, empname varchar(200)
, plainsalary numeric (10, 4)
, encryptedsalary varbinary(max)
)
;
ALTER TABLE dbo.salary 
  ADD CONSTRAINT Salark_PK PRIMARY KEY NONCLUSTERED
   (empid)
;
go
insert salary
 values ( 1, 'Steve', 5000, null)
      , ( 2, 'Delaney', 2000, null)
      , ( 3, 'Kendall', 1000, null);
go

select empname
     , plainsalary
	 , encryptedsalary
 from salary;
go  


-- encrypt data
open symmetric key SalarySymKey
 decryption by certificate MySalaryCert;


update salary
  set encryptedsalary = ENCRYPTBYKEY( key_guid('SalarySymKey'), cast( plainsalary as nvarchar(200)))
go
select empname
     , plainsalary
	 , encryptedsalary
 from salary;
go  


-- View open keys
SELECT *
 FROM sys.openkeys;


-- decrypt
select empname
     , plainsalary
	 , DECRYPTBYKEY(encryptedsalary)
 from salary;
go



-- cast
select empname
     , plainsalary
	 , cast( DECRYPTBYKEY(encryptedsalary) as nvarchar(200))
 from salary;
go









-- clean up
drop symmetric key SalarySymKey;
drop certificate MySalaryCert;
drop certificate MyHRCert;
drop table Salary;
go
