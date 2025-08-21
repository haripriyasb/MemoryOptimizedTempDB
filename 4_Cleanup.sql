
/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'


















/* 
Memory Cleanup

sys.sp_xtp_force_gc - Frees up memory that is no longer in use

xtp - xtreme transaction processing
gc - garbage collection

SQL 2019 - Run twice
SQL 2022 CU1 - Run Once

*/
EXEC sys.sp_xtp_force_gc 'tempdb'   --garbage cleanup on memory-optimized TempDB metadata
GO
EXEC sys.sp_xtp_force_gc 'tempdb'
GO
EXEC sys.sp_xtp_force_gc            --garbage cleanup on system-level memory structures 
GO
EXEC sys.sp_xtp_force_gc











/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'

/*END*/