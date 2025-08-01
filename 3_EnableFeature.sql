
/*VERIFY MEMORY-OPTIMIZED TEMPDB METADATA FEATURE*/
/*NOT ON BY DEFAULT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO


/*ENABLE MEMORY-OPTIMIZED TEMPDB METADATA */
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=ON;
GO

/*WARNING: SERVER RESTART*/

/*THIS CHANGE REQUIRES A SERVER RESTART TO TAKE EFFECT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO

/*CHECK WHICH SYSTEM TABLES HAVE BEEN CONVERTED TO MEMORY-OPTIMIZED*/
USE TEMPDB
GO
SELECT t.[object_id], t.name
  FROM tempdb.sys.all_objects AS t 
  INNER JOIN tempdb.sys.memory_optimized_tables_internal_attributes AS i
  ON t.[object_id] = i.[object_id];


/*MEMORY OCCUPIED BY TEMPDB SYSTEM TABLES*/
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'



/*FROM SCRIPT 1_TEMPTABLES.sql COPIED AGAIN BELOW - 

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTableVariable" -n50 -r1000 -q

*/

/*
TAKEAWAY:
METADATA CONTENTION IS RESOLVED AFTER ENABLING MEMORY-OPTIMIZED TEMPDB FEATURE
*/