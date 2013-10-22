/*
Hashing Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- Basic hashing
declare @t nvarchar(200)
select @t = N'What is the hash of this?'

select 
  Hashbytes('SHA', @t) as 'Hash1'
go





-- Hashing Two Strings
declare @t nvarchar(200)
      , @r nvarchar(200)
	  , @s nvarchar(200);

select @t = N'This is my string';
select @r = N'This is my other string';

select 'Hash string 1 - SHA', Hashbytes('SHA', @t)
UNION ALL
select 'Hash string 2 - SHA', Hashbytes('SHA', @r)
UNION ALL
select 'Hash string 2 - SHA1', Hashbytes('SHA1', @r) 
UNION ALL
select 'Hash string 2 - SHA2_256', Hashbytes('SHA2_256', @r) 
UNION ALL
select 'Hash string 2 - SHA2_512', Hashbytes('SHA2_512', @r) 
go



-- Add your own salt
declare @t nvarchar(200), @salt nvarchar(200);

select @t = N'This is my string';
select @salt = N'R@nd0mS!a6lTValue';

select 'string - unsalted', Hashbytes('SHA2_512', @t)
UNION ALL
select 'string - salted', Hashbytes('SHA2_512', @T + @salt);
go



-- Why add salt? Demo that shows password attack.
USE EncryptionPrimer
;
go
create table UserTest
( firstname varchar(50)
, passwordhash varbinary(max)
);
go
-- insert passwords
insert usertest select 'Steve', HASHBYTES('SHA2_512', 'AP@sswordUCan!tGuess');
insert usertest select 'Andy', HASHBYTES('SHA2_512', 'ADiffP@sswordUCan!tGuess');
go

-- validate stored proc
create procedure CheckPassword
   @user varchar(200)
 , @password varchar(200)
as
if hashbytes('SHA2_512', @password) = (select passwordhash 
                                 from UserTest
								 where firstname = @user
								)
  select 'Password Match'
else
  select 'Password Fail'
  ;
return
go



-- Validate password
declare @p varchar(200);
select @p = 'AP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go

-- try a new password
declare @p varchar(200);
select @p = 'ADiffP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go




								  
-- update the table, copy Andy's password to Steve
update s
  set s.passwordhash = a.passwordhash
 from usertest s, usertest a
 where s.firstname = 'Steve'
 and   a.firstname = 'Andy'
 ;
 go
 select 
   firstname
 , passwordhash
  from usertest
 ;
 go

-- Validate password, use Andy's password
declare @p varchar(200);
select @p = 'ADiffP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go


-- recheck Steve's password
-- Validate password
declare @p varchar(200);
select @p = 'AP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go


-- reset the table, use salt
update usertest
 set passwordhash = HASHBYTES('SHA2_512', 'AP@sswordUCan!tGuess' + firstname)
 where firstname = 'Steve'
;
update usertest
 set passwordhash = HASHBYTES('SHA2_512', 'ADiffP@sswordUCan!tGuess' + firstname)
 where firstname = 'Andy'
;
go
select 
   firstname
 , passwordhash
 from usertest
;
go


-- new procedure:
alter procedure CheckPassword
   @user varchar(200)
 , @password varchar(200)
as
if hashbytes('SHA2_512', @password + @user) = (select passwordhash 
                                 from UserTest
								 where firstname = @user
								)
  select 'Password Match'
else
  select 'Password Fail'
  ;
return
go

-- check
declare @p varchar(200);
select @p = 'AP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go

-- copy passwords again. Copy Andy's password to Steve
update n
  set n.passwordhash = o.passwordhash
 from usertest n, usertest o
 where n.firstname = 'Steve'
 and   o.firstname = 'Andy';
 go


-- recheck, Andy trying to log in as Steve, with Andy's Password
declare @p varchar(200);
select @p = 'ADiffP@sswordUCan!tGuess';
exec CheckPassword 'Steve', @p;
go




-- cleanup
 drop table UserTest;
 drop procedure CheckPassword;
 go



-- Checksum
declare 
  @i varchar(200)
, @j varchar(200);

select @i = 'LE';
select @j = 'AAAAAAAAAAAAAAAALE';

select 
  Plaintext = @i
, checksum = CHECKSUM(@i)
UNION ALL 
SELECT
  Plaintext = @j
, checksum = CHECKSUM(@j);
GO


-- binary_checksum is no better
declare 
  @i varchar(200)
, @j varchar(200)
, @k varchar(200);


select @i = 'LE'
select @j = 'Ou'
select @k = 'MU'

select 
  Plaintext = @i
, BINARY_CHECKSUM(@i)
UNION ALL 
SELECT
  Plaintext = @j
, BINARY_CHECKSUM(@j)
UNION ALL 
SELECT
  Plaintext = @k
, BINARY_CHECKSUM(@k)
GO
