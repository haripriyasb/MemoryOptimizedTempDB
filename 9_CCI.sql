/*
COLUMNSTORE CLUSTERED INDEX ON TEMP TABLE
*/

USE DBATEST
GO
CREATE PROCEDURE dbo.TempTableWithColumnstore  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Create a temporary table with a clustered columnstore index  
    CREATE TABLE #TempColumnstore  
    (  
        ID INT NOT NULL,  
        Name NVARCHAR(100),  
        Value DECIMAL(10,2)  
    );  

    -- Create a clustered columnstore index  
    CREATE CLUSTERED COLUMNSTORE INDEX CCI_TempColumnstore  
    ON #TempColumnstore;  

    -- Insert sample data  
    INSERT INTO #TempColumnstore (ID, Name, Value)  
    VALUES  
        (1, 'Item A', 100.50),  
        (2, 'Item B', 200.75),  
        (3, 'Item C', 300.25);  

    -- Select data to verify  
    SELECT * FROM #TempColumnstore;  
END;

--Execute Stored procedure
EXEC dbo.TempTableWithColumnstore
GO

/* 
TAKEAWAY: CREATING SP WITH COLUMNSTORE CLUSTERED INDEX IS NOT A PROBLEM BUT EXECUTING IT IS*/

USE DBATEST;  
GO  

-- Estimate savings for COLUMNSTORE compression  
EXEC sp_estimate_data_compression_savings   
    'dbo',                -- Schema name  
    'Orders',          -- Table name  
    1,                    -- Index ID (1 for clustered index or heap)  
    NULL,                 -- NULL means all partitions  
    'COLUMNSTORE';        -- Compression type  
GO  

-- Estimate savings for COLUMNSTORE_ARCHIVE compression  
EXEC sp_estimate_data_compression_savings   
    'dbo',    
	'Orders',  
    1,  
    NULL,  
    'COLUMNSTORE_ARCHIVE';  
GO  
