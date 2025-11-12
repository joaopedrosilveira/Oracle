-- Ver o quanto tem usado e livre
SELECT
    *
FROM dba_temp_free_space;

--Ver o quanto da TMP esta sendo utilizado por usuário
SELECT 
    s.sid,
    s.serial#,
    s.username,
    s.program,
    t.tablespace,
    ROUND(t.blocks * tbs.block_size / 1024 / 1024, 2) AS mb_usado
FROM v$sort_usage t
JOIN v$session s ON t.session_addr = s.saddr
JOIN dba_tablespaces tbs ON t.tablespace = tbs.tablespace_name
ORDER BY mb_usado DESC;
