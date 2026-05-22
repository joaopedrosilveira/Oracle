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
