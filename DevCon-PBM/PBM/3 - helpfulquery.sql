-- 2012 diagnostic query
-- Adapated from Glenn Berry's SQL Server 2012 Oct 2012 Diagnostic queries
-- (http://dl.dropbox.com/u/13748067/SQL%20Server%202012%20%20Diagnostic%20Information%20Queries%20%28October%202012%29.sql)



-- check affinity
SELECT name, value, value_in_use, [description] 
 FROM sys.configurations WITH (NOLOCK)
 WHERE name like 'affinity%'
 ORDER BY name OPTION (RECOMPILE);
go









-- we do not want affinity set
-- rewrite query 
SELECT SUM(CAST(value AS NUMERIC))
 FROM sys.configurations WITH (NOLOCK)
 WHERE name like 'affinity%'
go










-- add a more informative message
SELECT
   CASE WHEN sum(CAST(VALUE AS numeric)) > 0
          THEN 'Affinity mask is set'
		ELSE ''
   END
 FROM sys.configurations WITH (NOLOCK)
 WHERE name like 'affinity%'
;
go
   



-- wrap in an ExecuteSQL() call
executesql('String', '
SELECT
   CASE WHEN sum(CAST(VALUE AS numeric)) > 0
          THEN ''Affinity mask is set''
		ELSE ''''
   END
 FROM sys.configurations WITH (NOLOCK)
 WHERE name like ''affinity%''
')



-- paste into new policy









-- change affinity mask
sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
sp_configure 'affinity mask', 1;
RECONFIGURE;
GO


-- evaluate policy





-- fix
sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
sp_configure 'affinity mask', 0;
RECONFIGURE;
GO
