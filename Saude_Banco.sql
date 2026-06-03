--Status da instância
SELECT
    instance_name,
    status,
    database_status,
    host_name,
    startup_time
FROM v$instance;

----------------------
-- Quantidade de Sessões
SELECT
    status,
    COUNT(*) total
FROM v$session
WHERE username IS NOT NULL
GROUP BY status;

------------------------
-- Sessões Ativas 
SELECT
    sid,
    serial#,
    username,
    machine,
    program,
    event,
    wait_class,
    sql_id
FROM v$session
WHERE status = 'ACTIVE'
  AND username IS NOT NULL;
  
----------------------------------
-- Uso de TableSpaces
SELECT
    df.tablespace_name,
    ROUND((df.bytes - fs.bytes) / df.bytes * 100, 2) AS usado_pct
FROM
    (SELECT tablespace_name, SUM(bytes) bytes
     FROM dba_data_files
     GROUP BY tablespace_name) df,
    (SELECT tablespace_name, SUM(bytes) bytes
     FROM dba_free_space
     GROUP BY tablespace_name) fs
WHERE df.tablespace_name = fs.tablespace_name
ORDER BY usado_pct DESC;

-------------------------------
-- Bloqueios
SELECT
    blocking_session,
    sid,
    serial#,
    username,
    event
FROM v$session
WHERE blocking_session IS NOT NULL;

-------------------------------------
-- Resumo
SELECT 'SESSOES_ATIVAS' tipo, COUNT(*) valor
FROM v$session
WHERE status = 'ACTIVE'
  AND username IS NOT NULL

UNION ALL

SELECT 'SESSOES_TOTAL', COUNT(*)
FROM v$session
WHERE username IS NOT NULL

UNION ALL

SELECT 'LOCKS', COUNT(*)
FROM v$session
WHERE blocking_session IS NOT NULL;

---------------------------------------
SELECT
    tablespace_name,
    file_name,
    autoextensible,
    ROUND(bytes/1024/1024) AS tamanho_mb,
    ROUND(maxbytes/1024/1024) AS max_mb
FROM dba_data_files
WHERE TABLESPACE_NAME = 'DATA_RNSCOPA'
ORDER BY tablespace_name;

-------------------------------------------

SELECT S.SID "SID"
     ,S.STATUS "Status"
     ,P.SPID "O.S. SID"
     ,S.SERIAL# "Serial #"
     ,S.TYPE "Type"
     ,decode(s.username,NULL, bg.name,s.username) "DB User"
     ,S.OSUSER "Client User"
     ,s.logon_time "Logon Time"
     ,S.SERVER "Server"
     ,S.MACHINE "Machine"
     ,S.TERMINAL "Terminal"
     ,S.PROGRAM "Program"
     ,P.PROGRAM "O.S. Program"
     ,decode(s.lockwait, NULL, 'NO', 'YES') "BLOCKED?"
     ,DECODE(COMMAND, 1, 'CREATE TABLE', 2, 'INSERT', 3, 'SELECT', 4, 'CREATE CLUSTER', 5, 'ALTER CLUSTER', 6, 'UPDATE', 7, 'DELETE', 8, 'DROP', 9, 'CREATE INDEX', 10, 'DROP INDEX', 11, 'ALTER INDEX', 12, 'DROP TABLE', 15, 'ALTER TABLE', 17, 'GRANT', 18, 'REVOKE', 19, 'CREATE SYNONYM', 20, 'DROP SYNONYM', 21, 'CREATE VIEW', 22, 'DROP VIEW', 26, 'LOCK TABLE', 27, 'NO OPERATION', 28, 'RENAME', 29, 'COMMENT', 30, 'AUDIT', 31, 'NOAUDIT', 32, 'CREATE EXTERNAL DATABASE', 33, 'DROP EXTERNAL DATABASE', 34, 'CREATE DATABASE', 35, 'ALTER DATABASE', 36, 'CREATE ROLLBACK SEGMENT', 37, 'ALTER ROLLBACK SEGMENT', 38, 'DROP ROLLBACK SEGMENT', 39, 'CREATE TABLESPACE', 40, 'ALTER TABLESPACE', 41, 'DROP TABLESPACE', 42, 'ALTER SESSION', 43, 'ALTER USER', 44, 'COMMIT', 45, 'ROLLBACK', 46, 'SAVEPOINT', 'UNKNOWN') "Command"
     ,s.last_call_et "Seconds Idle Since Last Call"
FROM  V$SESSION S
    ,V$PROCESS P
    ,V$BGPROCESS BG
WHERE  S.paddr = P.addr
and   BG.paddr(+) = S.paddr
ORDER BY 2
