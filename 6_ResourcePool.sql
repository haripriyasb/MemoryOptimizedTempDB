

/*
RESOURCE POOL 
*/

/* Enable Resource Governor */

ALTER RESOURCE GOVERNOR RECONFIGURE;


















USE [master]
GO

ALTER RESOURCE POOL [TempDBRPool] 
        WITH
       (min_cpu_percent=10, 
		max_cpu_percent=100, 
		min_memory_percent=1, 
		max_memory_percent=2, --600MB, for demo purpose, actual servers - set it to 70 or 80%
		cap_cpu_percent=100, 
		AFFINITY SCHEDULER = AUTO
, 
		min_iops_per_volume=0, 
		max_iops_per_volume=0)
GO


ALTER RESOURCE GOVERNOR RECONFIGURE;











--Bind Resource Pool to TempDB

ALTER SERVER CONFIGURATION 
SET MEMORY_OPTIMIZED TEMPDB_METADATA = ON (RESOURCE_POOL = 'TempDBRPool');

--Needs Restart of SQL Service to take effect, yes even if feature is enabled












--Verify binding to TempDB
SELECT d.database_id, d.name, d.resource_pool_id , p.name, p.max_memory_percent
FROM sys.databases d  
join sys.resource_governor_resource_pools p
on d.resource_pool_id = p.pool_id
where database_id = 2












/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2' --TempDB












/* DEMO FOR OUT OF MEMORY ERRORS
max memory is 2% of 32GB, once XTP memory reaches around 600MB, it displays out of memory errors 
*/

BEGIN TRAN
    CREATE TABLE #hold(id int)

--ROLLBACK










/*
ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q
*/










--TAKEAWAY
--Resource Pool results in OUT OF MEMORY errors if max memory is reached 
--Sometimes causes server restarts in SQL 2019

/*
REMOVE RESOURCE POOL BINDING:
Remove the resource pool binding while keeping Memory-optimized TempDB metadata enabled
*/
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA = ON;




