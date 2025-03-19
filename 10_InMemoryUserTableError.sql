
/*
Memory Optimized OLTP User Table NOT COMPATIBLE with Memory Optimized TempDB 
*/
USE DBATEST;
GO

-- Create a memory-optimized table
IF OBJECT_ID('dbo.MemoryOptimizedTable', 'U') IS NOT NULL  
    DROP TABLE dbo.MemoryOptimizedTable;
GO
CREATE TABLE dbo.MemoryOptimizedTable
(
    ID INT NOT NULL PRIMARY KEY NONCLUSTERED
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

-- Create an In-memory OLTP transaction that accesses a system view in tempdb

BEGIN TRAN;

--In-memory TempDB
SELECT name
FROM tempdb.sys.tables;

-- An attempt to create an In-memory OLTP transaction in the user database fails
INSERT INTO DBATest.dbo.MemoryOptimizedTable
VALUES (1);

COMMIT TRAN;


--Verify no data inserted
SELECT * FROM DBATest.dbo.MemoryOptimizedTable

/*
TAKEAWAY: 
In-memory user tables and in-memory tempdb cannot exist in same transaction*/




