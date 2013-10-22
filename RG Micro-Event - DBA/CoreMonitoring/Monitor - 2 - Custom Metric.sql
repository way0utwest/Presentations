/*
Title:
Low physical/external memory 

Description
This metric uses the sys.dm_os_ring_buffers to identify low physical/external memory on the SQL Server system. It uses the RING_BUFFER_RESOURCE_MONITOR to identify when the latest alert has a Notification value of RESOURCE_MEMPHYSICAL_LOW. 

Database: Master

Interval: 5 min

Calculated: Off

Alert: (high) >0
URL: http://sqlmonitormetrics.red-gate.com/low-physical-external-memory/
*/

WITH    RingBuffer
          AS (SELECT    CAST(record AS XML) AS xRecord,
                        DATEADD(ss, (-1 * ((dosi.cpu_ticks / CONVERT (float,(dosi.cpu_ticks / dosi.ms_ticks))) - dorb.timestamp)/1000), GETDATE()) AS DateOccurred
              FROM      sys.dm_os_ring_buffers AS dorb
                        CROSS JOIN sys.dm_os_sys_info AS dosi
              WHERE     ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR'
             )
    SELECT TOP 1
            CASE (xr.value('(ResourceMonitor/Notification)[1]', 'varchar(75)'))
              WHEN 'RESOURCE_MEMPHYSICAL_LOW' THEN 1
              ELSE 0
            END AS LowMemAlert
    FROM    RingBuffer AS rb
            CROSS APPLY rb.xRecord.nodes('Record') record (xr)
    WHERE   xr.value('(ResourceMonitor/Notification)[1]', 'varchar(75)') = 'RESOURCE_MEMPHYSICAL_LOW'
            AND rb.DateOccurred > DATEADD(mm, -5, GETDATE())
    ORDER BY rb.DateOccurred DESC;