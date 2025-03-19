
/*
Explicit open transaction
*/
BEGIN TRAN
    CREATE TABLE #hold(id int)

/*
Run SP that creates temp table accesses memory optimized tempdb

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q
*/

/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2' --TempDB


/* 
Memory Cleanup
SQL 2019 - Run twice
SQL 2022 CU1 - Run Once
*/
EXEC sys.sp_xtp_force_gc 'tempdb'
GO
EXEC sys.sp_xtp_force_gc 'tempdb'
GO
EXEC sys.sp_xtp_force_gc
GO
EXEC sys.sp_xtp_force_gc


/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2' --TempDB

/*
TAKEAWAY: DUE TO OPEN TRANSACTION, MEMORY CLEANUP WILL BE HELD UP
*/
