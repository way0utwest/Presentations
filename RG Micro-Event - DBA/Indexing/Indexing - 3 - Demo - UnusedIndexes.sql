USE AdventureWorks2008
go

-- Index Usage
-- from http://www.mssqltips.com/sqlservertip/1545/deeper-insight-into-unused-indexes-for-sql-server/
SELECT DB_NAME(DATABASE_ID) AS DATABASENAME,
       OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,
       INDEX_NAME = (SELECT NAME
                     FROM   SYS.INDEXES A
                     WHERE  A.OBJECT_ID = B.OBJECT_ID
                            AND A.INDEX_ID = B.INDEX_ID),
       USER_SEEKS,
       USER_SCANS,
       USER_LOOKUPS,
       USER_UPDATES
FROM   SYS.DM_DB_INDEX_USAGE_STATS B
       INNER JOIN SYS.OBJECTS C
         ON B.OBJECT_ID = C.OBJECT_ID
WHERE  DATABASE_ID = DB_ID(DB_NAME())
       AND C.TYPE <> 'S' 
go


-- slightly better version
SELECT   PVT.TABLENAME, PVT.INDEXNAME, [1] AS COL1, [2] AS COL2, [3] AS COL3,
         [4] AS COL4, [5] AS COL5, [6] AS COL6, [7] AS COL7, B.USER_SEEKS,
         B.USER_SCANS, B.USER_LOOKUPS
FROM     (SELECT A.NAME AS TABLENAME,
                 A.OBJECT_ID,
                 B.NAME AS INDEXNAME,
                 B.INDEX_ID,
                 D.NAME AS COLUMNNAME,
                 C.KEY_ORDINAL
          FROM   SYS.OBJECTS A
                 INNER JOIN SYS.INDEXES B
                   ON A.OBJECT_ID = B.OBJECT_ID
                 INNER JOIN SYS.INDEX_COLUMNS C
                   ON B.OBJECT_ID = C.OBJECT_ID
                      AND B.INDEX_ID = C.INDEX_ID
                 INNER JOIN SYS.COLUMNS D
                   ON C.OBJECT_ID = D.OBJECT_ID
                      AND C.COLUMN_ID = D.COLUMN_ID
          WHERE  A.TYPE <> 'S') P
         PIVOT
         (MIN(COLUMNNAME)
          FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT
         INNER JOIN SYS.DM_DB_INDEX_USAGE_STATS B
           ON PVT.OBJECT_ID = B.OBJECT_ID
              AND PVT.INDEX_ID = B.INDEX_ID
              AND B.DATABASE_ID = DB_ID()
ORDER BY TABLENAME, INDEXNAME; 





-- simulate load on AdventureWorks.







-- Unused Indexes
-- from http://www.mssqltips.com/sqlservertip/1545/deeper-insight-into-unused-indexes-for-sql-server/
SELECT   DB_NAME() AS DATABASENAME,
         OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,
         B.NAME AS INDEXNAME,
         B.INDEX_ID
FROM     SYS.OBJECTS A
         INNER JOIN SYS.INDEXES B
           ON A.OBJECT_ID = B.OBJECT_ID
WHERE    NOT EXISTS (SELECT *
                     FROM   SYS.DM_DB_INDEX_USAGE_STATS C
                     WHERE  B.OBJECT_ID = C.OBJECT_ID
                            AND B.INDEX_ID = C.INDEX_ID)
         AND A.TYPE <> 'S'
ORDER BY Databasename, Tablename, indexname
;




-- Note Store table, 4 unused indexes



-- Store - AK_Sales_SalesPersonID
SELECT 
  SalesPersonID
 FROM Sales.Store
 WHERE SalesPersonID = 279



 -- Recheck Unused Indexes
SELECT   DB_NAME() AS DATABASENAME,
         OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,
         B.NAME AS INDEXNAME,
         B.INDEX_ID
FROM     SYS.OBJECTS A
         INNER JOIN SYS.INDEXES B
           ON A.OBJECT_ID = B.OBJECT_ID
WHERE    NOT EXISTS (SELECT *
                     FROM   SYS.DM_DB_INDEX_USAGE_STATS C
                     WHERE  B.OBJECT_ID = C.OBJECT_ID
                            AND B.INDEX_ID = C.INDEX_ID)
         AND A.TYPE <> 'S'
ORDER BY databaseName, TableName, IndexName


-- Examine Used Stats
SELECT DB_NAME(DATABASE_ID) AS DATABASENAME,
       OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,
       INDEX_NAME = (SELECT NAME
                     FROM   SYS.INDEXES A
                     WHERE  A.OBJECT_ID = B.OBJECT_ID
                            AND A.INDEX_ID = B.INDEX_ID),
       USER_SEEKS,
       USER_SCANS,
       USER_LOOKUPS,
       USER_UPDATES
FROM   SYS.DM_DB_INDEX_USAGE_STATS B
       INNER JOIN SYS.OBJECTS C
         ON B.OBJECT_ID = C.OBJECT_ID
WHERE  DATABASE_ID = DB_ID(DB_NAME())
       AND C.TYPE <> 'S' 
go

