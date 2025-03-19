/*
RESOURCE POOL 
*/

USE [master]
GO

CREATE RESOURCE POOL [TempDBRPool] WITH(min_cpu_percent=10, 
		max_cpu_percent=80, 
		min_memory_percent=10, 
		max_memory_percent=80, 
		cap_cpu_percent=100, 
		AFFINITY SCHEDULER = AUTO
, 
		min_iops_per_volume=0, 
		max_iops_per_volume=0)
GO



--Bind to TempDB
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA = ON (RESOURCE_POOL = 'TempDBRPool');

--Needs Restart of SQL Service to take effect, yes another one even if feature is enabled

--Resource Pool sometimes results in OUT OF MEMORY errors

