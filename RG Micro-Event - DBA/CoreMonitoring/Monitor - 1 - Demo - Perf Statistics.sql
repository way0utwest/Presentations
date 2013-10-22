-- Examine performance counters
SELECT 
  object_name ,
         counter_name ,
         instance_name ,
         cntr_value ,
         cntr_type
  FROM sys.dm_os_performance_counters
;
go

-- check one counter
SELECT 
		object_name ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type
 FROM sys.dm_os_performance_counters
 WHERE object_name = 'SQLServer:General Statistics'
 AND counter_name = 'User Connections'
;


-- log waits
SELECT  object_name ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type 
 FROM sys.dm_os_performance_counters
 WHERE object_name = 'SQLServer:Wait Statistics'
AND counter_name = 'Log write waits'
;
GO


-- Performance Monitor

-- Profiler

-- SQL Monitor