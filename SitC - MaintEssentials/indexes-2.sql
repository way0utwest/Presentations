-- @SQLfool
-- Unused indexes
--

Declare @dbid int
    , @dbName varchar(100);
 
Select @dbid = DB_ID()
    , @dbName = DB_Name();
 
With partitionCTE (object_id, index_id, row_count, partition_count) 
As
(
    Select [object_id]
        , index_id
        , Sum([rows]) As 'row_count'
        , Count(partition_id) As 'partition_count'
    From sys.partitions
    Group By [object_id]
        , index_id
) 
 
Select Object_Name(i.[object_id]) as objectName
        , i.name
        , Case 
            When i.is_unique = 1 
                Then 'UNIQUE ' 
            Else '' 
          End + i.type_desc As 'indexType'
        , ddius.user_seeks
        , ddius.user_scans
        , ddius.user_lookups
        , ddius.user_updates
        , cte.row_count
        , Case When partition_count > 1 Then 'yes' 
            Else 'no' End As 'partitioned?'
        , Case 
            When i.type = 2 And i.is_unique_constraint = 0
                Then 'Drop Index ' + i.name 
                    + ' On ' + @dbName 
                    + '.dbo.' + Object_Name(ddius.[object_id]) + ';'
            When i.type = 2 And i.is_unique_constraint = 1
                Then 'Alter Table ' + @dbName 
                    + '.dbo.' + Object_Name(ddius.[object_ID]) 
                    + ' Drop Constraint ' + i.name + ';'
            Else '' 
          End As 'SQL_DropStatement'
From sys.indexes As i
Inner Join sys.dm_db_index_usage_stats ddius
    On i.object_id = ddius.object_id
        And i.index_id = ddius.index_id
Inner Join partitionCTE As cte
    On i.object_id = cte.object_id
        And i.index_id = cte.index_id
Where ddius.database_id = @dbid
Order By 
    (ddius.user_seeks + ddius.user_scans + ddius.user_lookups) Asc
    , user_updates Desc;
    
 --
 -- @SQLFool
 -- Missing Indexes
 --
 

 Select t.name As 'affected_table'
    , 'Create NonClustered Index IX_' + t.name + '_missing_' 
        + Cast(ddmid.index_handle As nvarchar(10))
        + ' On ' + ddmid.statement COLLATE DATABASE_DEFAULT
        + ' (' + IsNull(ddmid.equality_columns,'') 
        + Case When ddmid.equality_columns Is Not Null 
            And ddmid.inequality_columns Is Not Null Then ',' 
                Else '' End 
        + IsNull(ddmid.inequality_columns, '')
        + ')' 
        + IsNull(' Include (' + ddmid.included_columns + ');', ';'
        ) As sql_statement
    , ddmigs.user_seeks
    , ddmigs.user_scans
    , Cast((ddmigs.user_seeks + ddmigs.user_scans) 
        * ddmigs.avg_user_impact As bigint) As 'est_impact'
    , ddmigs.last_user_seek
From sys.dm_db_missing_index_groups As ddmig 
Inner Join sys.dm_db_missing_index_group_stats As ddmigs 
    On ddmigs.group_handle = ddmig.index_group_handle
Inner Join sys.dm_db_missing_index_details As ddmid 
    On ddmig.index_handle = ddmid.index_handle
Inner Join sys.tables As t
    On ddmid.object_id = t.object_id
Where ddmid.database_id = DB_ID()
    And Cast((ddmigs.user_seeks + ddmigs.user_scans) 
        * ddmigs.avg_user_impact As bigint) > 100
    Order By Cast((ddmigs.user_seeks + ddmigs.user_scans) 
    * ddmigs.avg_user_impact As bigint) Desc;

    