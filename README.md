# Deep Dive into Memory-Optimized TempDB

Demo scripts and slides from my session **Deep Dive into Memory-Optimized TempDB**, presented at EightKB on August 21, 2025.

The memory-optimized TempDB metadata feature moves TempDB system tables into memory to remove metadata contention. It can be a big win, but it changes how memory is used and comes with limitations. This session covers when to turn it on, how to monitor it, and how to keep its memory usage under control.

## What the demo shows

- Measuring a temp table workload and a table variable workload before and after enabling the feature
- Detecting page latch contention on SQL Server 2019 and later
- How much memory the TempDB system tables use, and how to free it with `sys.sp_xtp_force_gc`
- How a single open transaction can block memory cleanup
- Capping memory usage with a Resource Governor resource pool
- Features that do not work with it, including columnstore indexes on temp tables and transactions that combine In-Memory OLTP user tables with TempDB system views

## Requirements

- SQL Server 2019 or later, Enterprise or Developer edition (the feature is not available in Standard edition or Azure SQL Database)
- A test database named `DBATEST`
- [ostress](https://learn.microsoft.com/en-us/troubleshoot/sql/tools/replay-markup-language-utility) (part of the free RML Utilities) to generate concurrent workload
- Permission to restart the SQL Server service

## Run the demo

| Step | Script | What it does |
|---|---|---|
| 1 | `1_TempTables.sql` | Checks the server and creates temp table and table variable test procedures |
| 2 | `2_CheckContention.sql` | Shows current page latch contention |
| 3 | `3_EnableFeature.sql` | Enables memory-optimized TempDB metadata (restart required) and lists the converted system tables |
| 4 | `4_Cleanup.sql` | Shows memory used by TempDB system tables and runs garbage collection |
| 5 | `5_1HoldCleanup.sql`, `5_2HoldCleanup.sql` | Two-window demo showing how an open transaction blocks memory cleanup |
| 6 | `6_ResourcePool.sql` | Binds TempDB memory to a Resource Governor pool to cap memory usage |
| 7 | `7_CCI.sql` | Shows that columnstore indexes on temp tables are not supported |
| 8 | `8_InMemoryUserTableError.sql` | Shows the error from mixing In-Memory OLTP user tables with TempDB system views |

`MonitoringXTPMemory` is an example monitoring job that logs and handles long-running sessions holding TempDB memory. Test it carefully before using it anywhere.

## Files

- `*.sql`: demo scripts, run in numbered order
- `MonitoringXTPMemory`: sample monitoring script
- `Memory-Optimized TempDB.pptx`: session slides

## Learn more

- [Memory-optimized TempDB metadata (Microsoft Learn)](https://learn.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database#memory-optimized-tempdb-metadata)
- Blog: [gohigh.substack.com](https://gohigh.substack.com)

> These scripts change server configuration, require a service restart, and can end sessions. Run them only on a test instance.
