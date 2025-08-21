


/*SQL VERSION*/
SELECT @@VERSION AS 'SQL VERSION'

/*NUMBER OF CPUS IN SERVER*/
SELECT CPU_COUNT FROM sys.dm_os_sys_info

/*RAM*/
SELECT 
    total_physical_memory_kb / 1024 / 1024 AS Total_Physical_Memory_GB 
FROM sys.dm_os_sys_memory;

/*VERIFY MEMORY-OPTIMIZED TEMPDB METADATA FEATURE*/
/*DISABLED BY DEFAULT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO










/* CREATE 2 STORED PROCEDURES - ONE WITH TEMP TABLE AND OTHER ONE WITH TABLE VARIABLE.

RUN STORED PROCEDURE WITHOUT FEATURE, NOTE DOWN TIME TAKEN, ENABLE FEATURE, RUN SP AND NOTE DOWN TIME TAKEN. 

IS THERE A REDUCTION IN EXECUTION TIME? IS CONTENTION REDUCED?

THIS IS NOT A COMPARISON BETWEEN TEMP TABLE AND TABLE VARIABLE.

THIS IS TO CHECK IF THE FEATURE HELPS EITHER STORED PROCEDURES.
*/









/*SP WITH TEMP TABLE */
USE DBATEST
GO
CREATE OR ALTER PROCEDURE PopulateTempTable
AS
BEGIN
/*CREATE A NEW TEMP TABLE*/
CREATE TABLE #TempTable
(
Col1 INT IDENTITY(1, 1) PRIMARY KEY, 
Col2 CHAR(4000),
Col3 CHAR(4000)
)
/*INSERT 10 RECORDS*/ 
DECLARE @i INT = 0
WHILE (@i < 10)
BEGIN
INSERT INTO #TempTable VALUES ('SQL Server','TempDB Discussion')
SET @i += 1
END
END
GO










--SP WITH TABLE VARIABLE
USE DBATEST
GO
CREATE OR ALTER PROCEDURE PopulateTableVariable
AS
BEGIN
    -- Declare a table variable
    DECLARE @TableVar TABLE
    (
        Col1 INT IDENTITY(1, 1) PRIMARY KEY,  
        Col2 CHAR(4000),
        Col3 CHAR(4000)
    );

    /*INSERT 10 RECORDS*/ 
    DECLARE @i INT = 0;
    WHILE (@i < 10)
    BEGIN
        INSERT INTO @TableVar (Col2, Col3) VALUES ('SQL Server', 'TempDB Discussion');
        SET @i += 1;
    END
END;









/*

STRESS TEST SQLSERVER USING OSTRESS - FREE MS TOOL TO TROUBLESHOOT SQL SERVER
  UNDER HEAVY LOAD
  
*/





















/* REVIEW CONTENTION SCRIPT */

















/*

GENERATE WORKLOAD AGAINST THE SERVER.
RUN 50 SIMULTANEOUS CONNECTIONS AND RUN THE QUERY 1000 TIMES ON EACH CONNECTION

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q

*/

/*
Temp Tables Execution Time - without Feature:   secs
Temp Tables Execution Time - with Feature:  secs

*/










/* NOW RUN THE STORED PROCEDURE WITH TABLE VARIABLE TO SEE THE DIFFERENCE IN EXECUTION TIME.
RUN 50 SIMULTANEOUS CONNECTIONS AND RUN THE QUERY 1000 TIMES ON EACH CONNECTION

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTableVariable" -n50 -r1000 -q

*/

/*
Table Variable Execution Time - without Feature:   secs
Table Variable Execution Time - with Feature:  secs

*/