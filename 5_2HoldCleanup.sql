
/*

Run processes that access memory optimized tempdb. 
Now try to cleanup memory. 
Cleanup will not happen since there is an earlier open tran in the other window still accessing memory optimized tempdb.

*/

/* Check how much memory is consumed now */

SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'

/*











Run SP that creates temp table, this accesses memory optimized tempdb

ostress.exe -S"HARIPRIYA\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q
*/











/* Check how much memory is occupied now after SP is run */
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'












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












/* Memory won't be released due to open tran */
SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'











/*
TAKEAWAY: DUE TO OPEN TRANSACTION, MEMORY CLEANUP WILL BE HELD UP
*/

/* Check for long open transaction */
SELECT 
 DATEDIFF(MINUTE, transaction_begin_time, GETDATE()) as tran_elapsed_time_mins,
 st.session_id,
 txt.text, 
 DB_NAME(sess.database_id) as database_name ,
 sess.program_name,
 *
FROM
 sys.dm_tran_active_transactions at
 INNER JOIN sys.dm_tran_session_transactions st ON st.transaction_id = at.transaction_id
 LEFT OUTER JOIN sys.dm_exec_sessions sess ON st.session_id = sess.session_id
 LEFT OUTER JOIN sys.dm_exec_connections conn ON conn.session_id = sess.session_id
   OUTER APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle)  AS txt
ORDER BY
 1 DESC;










 -- KILL <spid>
 KILL
 GO










 /* Check for long open transaction - shouldn't have any */
 SELECT 
 DATEDIFF(MINUTE, transaction_begin_time, GETDATE()) as tran_elapsed_time_mins,
 st.session_id,
 txt.text, 
 DB_NAME(sess.database_id) as database_name ,
 sess.program_name,
 *
FROM
 sys.dm_tran_active_transactions at
 INNER JOIN sys.dm_tran_session_transactions st ON st.transaction_id = at.transaction_id
 LEFT OUTER JOIN sys.dm_exec_sessions sess ON st.session_id = sess.session_id
 LEFT OUTER JOIN sys.dm_exec_connections conn ON conn.session_id = sess.session_id
   OUTER APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle)  AS txt
ORDER BY
 1 DESC;











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











/* Memory would have been released now, let's verify */


SELECT type
	,name
	,pages_kb / 1024 AS pages_MB
FROM sys.dm_os_memory_clerks
WHERE name = 'DB_ID_2'










/*
TAKEWAY: OPEN TRANSACTION WILL HOLD UP THE MEMORY CLEANUP, CHECK FOR ANY OPEN SLEEPING TRANSACTION AND KILL SPID
*/

/*
In-Memory TempDB grows without any limit.
Setup jobs:
1. Release memory every 30 minutes or an hour.
2. Terminate long open sleeping transactions - find repeat offenders
*/
