-- New Condition
-- name: Proc Name
-- Facet: Stored procedure
-- @name not like 'sp_%'

-- New Policy
-- Use condition
-- use every database


USE db1
;
go


CREATE PROCEDURE sp_MyProc
AS 
 SELECT *
  FROM mytable

RETURN
go












-- Find Policies with DDDL
SELECT a.NAME
FROM msdb.dbo.syspolicy_policies a
 INNER JOIN msdb.dbo.syspolicy_conditions b
   ON a.condition_id = b.condition_id
  INNER JOIN msdb.dbo.syspolicy_management_facets c
   ON b.facet = c.name
WHERE c.execution_mode & 1 = 1