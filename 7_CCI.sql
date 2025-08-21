


/*
COLUMNSTORE CLUSTERED INDEX ON TEMP TABLE
*/

USE DBATEST;  
GO 
CREATE OR ALTER PROCEDURE dbo.TempTableWithColumnstore  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Create temp table with a clustered columnstore index  
    CREATE TABLE #TempColumnstore  
    (  
        ID INT NOT NULL,  
    );  

    -- Create a clustered columnstore index  
    CREATE CLUSTERED COLUMNSTORE INDEX CCI_TempColumnstore  
    ON #TempColumnstore;  

    -- Insert sample data  
    INSERT INTO #TempColumnstore (ID)  
    VALUES  
        (1, 'Item A', 100);   
		-- Select data to verify  
    SELECT * FROM #TempColumnstore;  
END;










--Execute Stored procedure
EXEC dbo.TempTableWithColumnstore
GO


/* 
TAKEAWAY: CREATING SP WITH COLUMNSTORE CLUSTERED INDEX IS NOT A PROBLEM, BUT EXECUTING IT IS
*/















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
