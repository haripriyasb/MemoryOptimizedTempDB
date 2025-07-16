
/*
SCRIPT TO CHECK CONTENTION ON SQL2019 AND ABOVE
https://www.microsoft.com/en-us/sql-server/blog/2022/07/21/improve-scalability-with-system-page-latch-concurrency-enhancements-in-sql-server-2022/
*/

USE master
GO
SELECT 
er.session_id, er.wait_type, er.wait_resource, 
OBJECT_NAME(page_info.[object_id],page_info.database_id) as [object_name],
 page_info.page_type_desc,
er.blocking_session_id,er.command, 
    SUBSTRING(st.text, (er.statement_start_offset/2)+1,   
        ((CASE er.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE er.statement_end_offset  
         END - er.statement_start_offset)/2) + 1) AS statement_text,
page_info.database_id,page_info.[file_id], page_info.page_id, page_info.[object_id], 
page_info.index_id,
CASE 
WHEN page_info.page_type_desc IN('SGAM_PAGE','GAM_PAGE', 'PFS_PAGE') 
AND WAIT_TYPE IN ('PAGELATCH_SH','PAGELATCH_UP','PAGELATCH_EX')THEN 'ALLOCATION CONTENTION'
WHEN page_info.page_type_desc IN ('DATA_PAGE', 'INDEX_PAGE') 
AND WAIT_TYPE IN ('PAGELATCH_SH','PAGELATCH_UP','PAGELATCH_EX')THEN 'METADATA CONTENTION'
END AS allocation_type
FROM sys.dm_exec_requests AS er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st 
CROSS APPLY sys.fn_PageResCracker (er.page_resource) AS r --database ID, file ID, page ID SQL2019
CROSS APPLY sys.dm_db_page_info(r.[db_id], r.[file_id], r.page_id, 'DETAILED') AS page_info --replace dbcc page SQL2019
WHERE er.wait_type like 'PAGELATCH%' 
AND OBJECT_NAME(page_info.[object_id],page_info.database_id) like 'sys%'
GO
