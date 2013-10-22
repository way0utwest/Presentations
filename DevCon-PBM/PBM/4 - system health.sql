-- advanced system health
-- query 22 from Glenn Berry's SQL Server 2012 diagnostic queries, Oct 2012
-- http://sqlserverperformance.wordpress.com/2012/10/01/sql-server-2012-diagnostic-information-queries-october-2012/

-- look for average disk response time.
SELECT DB_NAME(fs.database_id) AS [Database Name], mf.physical_name, io_stall_read_ms, num_of_reads,
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],io_stall_write_ms, 
num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io],
CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
INNER JOIN sys.master_files AS mf WITH (NOLOCK)
ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
ORDER BY avg_io_stall_ms DESC OPTION (RECOMPILE);









-- rewrite, limit to one database
SELECT 
   DatabaseName = DB_NAME( fs.database_id)
 , Stalls = CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
FROM sys.dm_io_virtual_file_stats(DB_ID(),null) AS fs
ORDER BY stalls DESC OPTION (RECOMPILE);






-- we care about avg > 100
-- add case
SELECT
  CASE WHEN Stalls > 100
    THEN 'I/O Stall issue in ' + DatabaseName
	  + ' - Stalls averaging ' 
	  + CAST( stalls AS VARCHAR(20))
	  + 'ms'
    ELSE ''
  END
FROM
 (SELECT TOP 1 
     DatabaseName = DB_NAME( fs.database_id)
   , Stalls = CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
  FROM sys.dm_io_virtual_file_stats(DB_ID(),null) AS fs
  ORDER BY stalls DESC 
) a
 ;



 -- wrap
ExecuteSql( 'String', '
declare @maxstalls int

 SELECT
  CASE WHEN Stalls > @maxstalls
    THEN ''I/O Stall issue in '' + DatabaseName
	  + '' - Stalls averaging'' 
	  + CAST( stalls AS VARCHAR(20))
	  + ''ms''
    ELSE ''''
  END
FROM
 (SELECT TOP 1 
     DatabaseName = DB_NAME( fs.database_id)
   , Stalls = CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
  FROM sys.dm_io_virtual_file_stats(DB_ID(),null) AS fs
  ORDER BY stalls DESC 
) a
 ;
')

