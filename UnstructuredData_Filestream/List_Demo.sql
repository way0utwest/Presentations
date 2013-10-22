/*
List Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

use db1
;
go
-- create my grocery list holder
create table dbo.Groceries
( ItemID int identity(1,1)
, Item varchar(500)
)
;
go
ALTER TABLE dbo.Groceries ADD CONSTRAINT
	PK_Groceries PRIMARY KEY CLUSTERED 
	(
	ItemID
	)
;
go
-- Add data
insert Groceries 
 values ('Milk')
      , ('Eggs')
      , ('Bread')
;
go
select Item
 from Groceries
;
go


-- add a second store
create table Drinks
( DrinkID int identity(1,1)
, Drink Varchar(500)
)
;
go
alter table dbo.Drinks add constraint
 pk_drinks primary key Nonclustered 
 (drinkid)
;
go
insert Drinks 
 values ('Fat Tire')
      , ('Klinker Brick Cabernet')
      , ('Patron')
;
go
select Drink
 from dbo.Drinks
;
go

create table dbo.RanchSupplies
( ItemID int identity(1,1)
, Item varchar(500)
)
;
go
ALTER TABLE dbo.RanchSupplies ADD CONSTRAINT
	PK_RanchSupplies PRIMARY KEY CLUSTERED 
	(
	ItemID
	)
;
go
-- Add data
insert RanchSupplies 
values ('Strategy')
     , ('electric fence ribbon')
     , ('feed bag')
;
go
select Item
 from RanchSupplies
;
go

-- get full list
SELECT
  'Groceries'
, Item
 from Groceries
union all
select 
  'Drinks'
,  Drink
 from Drinks
union all
select 
  'Ranch Supplies'
,  Item
 from RanchSupplies
 ;
 go
 
 
 
 
 
 


-- Semi Structured
declare @list XML
select @list = '
<Lists>
  <Groceries Store=''Safeway''>
    <Item>Milk</Item>
	<Item>Eggs</Item>
	<Item>Bread</Item>
  </Groceries>
  <Drinks Store=''Tipsys''>
	<Drink>Fat Tire</Drink>
	<Drink>Klinker Brick Cabernet</Drink>
	<Drink>Patron</Drink>
  </Drinks>
  <Ranch>
    <Item>electric fence ribbon</Item>
  </Ranch>
</Lists>'
;

-- select @list;

-- Get the groceries
select @list.query('/Lists/Groceries')
;

-- Get the drinks
select @list.query('/Lists/Drinks');
go

-- Semi Structured
declare @list XML
select @list = '
<Lists>
  <Groceries Store=''Safeway''>
    <Item>Milk</Item>
	<Item>Eggs</Item>
	<Item>Bread</Item>
  </Groceries>
  <Drinks Store=''Tipsys''>
	<Drink>Fat Tire</Drink>
	<Drink>Klinker Brick Cabernet</Drink>
	<Drink>Patron</Drink>
  </Drinks>
  <Ranch>
    <Item store="Big R">electric fence ribbon</Item>
    <Item store="Parker Feed">Strategy</Item>
    <Item OnlyBuy=''If on sale''>Feed Bag</Item>
  </Ranch>
</Lists>'
;

-- select @list;
-- Get the ranch
select @list.query('/Lists/Ranch');
go



-- cleanup
 DROP TABLE dbo.Groceries
 ;
 DROP TABLE dbo.Drinks;
 DROP TABLE dbo.RanchSupplies;
 GO
 