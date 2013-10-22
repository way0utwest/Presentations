-- Missing Indexes
USE AdventureWorks2008;
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON
go


-- Missing index query
SELECT CustomerID, SalesOrderNumber, SubTotal
FROM Sales.SalesOrderHeader
WHERE ShipMethodID > 2
AND SubTotal > 500.00
AND Freight < 15.00
AND TerritoryID = 5;
GO
-- 686
-- 16ms


-- Note execution plan






-- check the dmv
SELECT 
  index_handle ,
  database_id ,
  object_id ,
  equality_columns ,
  inequality_columns ,
  included_columns ,
  statement
 FROM sys.dm_db_missing_index_details
go


-- Better query using other DMVs
-- Check missing indexes, limit to Adventureworks
-- from http://www.sqlservercentral.com/articles/Indexing/74510/
select d.name AS DatabaseName, mid.*
 from sys.dm_db_missing_index_details mid
  join sys.databases d ON mid.database_id=d.database_id
  WHERE d.database_id = 7


-- Get the create statement
-- From http://sqlserverpedia.com/wiki/Find_Missing_Indexes
-- modified to include schema.
SELECT  
  schemaname = sys.schemas.NAME
, sys.objects.NAME
, (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Impact
,  'CREATE NONCLUSTERED INDEX ix_IndexName ON ' + sys.schemas.NAME + '.' + sys.objects.name COLLATE DATABASE_DEFAULT + ' ( ' + IsNull(mid.equality_columns, '') + CASE WHEN mid.inequality_columns IS NULL 
                THEN ''  
    ELSE CASE WHEN mid.equality_columns IS NULL 
                    THEN ''  
        ELSE ',' END + mid.inequality_columns END + ' ) ' + CASE WHEN mid.included_columns IS NULL 
                THEN ''  
    ELSE 'INCLUDE (' + mid.included_columns + ')' END + ';' AS CreateIndexStatement
, mid.equality_columns
, mid.inequality_columns
, mid.included_columns 
    FROM sys.dm_db_missing_index_group_stats AS migs 
            INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
            INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() 
            INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
			INNER JOIN sys.schemas ON sys.objects.SCHEMA_ID = sys.schemas.schema_id
    WHERE     (migs.group_handle IN 
        ( 
        SELECT     TOP (500) group_handle 
            FROM          sys.dm_db_missing_index_group_stats WITH (nolock) 
            ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC))  
        AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable')=1 
    ORDER BY 2 DESC , 3 DESC 
go

-- paste in create index statement
CREATE NONCLUSTERED INDEX ix_IndexName 
ON Sales.SalesOrderHeader ( [TerritoryID],[ShipMethodID], [SubTotal], [Freight] ) 
INCLUDE ([SalesOrderNumber], [CustomerID]);



-- re-run query
SELECT CustomerID, SalesOrderNumber, SubTotal
FROM Sales.SalesOrderHeader
WHERE ShipMethodID > 2
AND SubTotal > 500.00
AND Freight < 15.00
AND TerritoryID = 5;
GO
-- 7
-- 0 



-- stats
-- from http://www.sqlservercentral.com/articles/Indexing/74510/
SELECT d.name AS 'database name', t.name AS 'table name', i.name AS 'index name', ius.*
 FROM sys.dm_db_index_usage_stats ius
 JOIN sys.databases d ON d.database_id = ius.database_id AND ius.database_id=db_id()
 JOIN sys.tables t ON t.object_id = ius.object_id
 JOIN sys.indexes i ON i.object_id = ius.object_id AND i.index_id = ius.index_id
 ORDER BY user_updates DESC





-- cleanup
DROP INDEX ix_IndexName ON Sales.SalesOrderHeader
GO



