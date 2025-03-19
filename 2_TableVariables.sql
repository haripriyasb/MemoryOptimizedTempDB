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

    -- Insert 10 records
    DECLARE @i INT = 0;
    WHILE (@i < 10)
    BEGIN
        INSERT INTO @TableVar (Col2, Col3) VALUES ('SQL Server', 'TempDB Discussion');
        SET @i += 1;
    END
END;

/*STRESS TEST SQLSERVER USING OSTRESS - FREE MS TOOL TO TROUBLESHOOT SQL SERVER UNDER HEAVY LOAD*/

/*GENERATE THE WORKLOAD AGAINST THE SERVER.
RUN 50 SIMULTANEOUS CONNECTIONS AND RUN THE QUERY 1000 TIMES ON EACH CONNECTION
ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTableVariable" -n50 -r1000 -q

*/

/*
Table Variable Execution Time - without Feature:  secs
Table Variable Execution Time - with Feature:  secs

*/