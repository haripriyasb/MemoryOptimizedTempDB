--long open transaction
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

 -- kill 

 
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
TAKEWAY: OPEN TRANSACTION WILL HOLD UP THE MEMORY CLEANUP, KILL LONG OPEN TRANSACTIONS
*/

/*
In-Memory OLTP (Hekaton) grows without any limit.
Setup job to release memory every 30 minutes or an hour.
Terminate long open sleeping transactions
*/
