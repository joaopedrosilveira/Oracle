SELECT
  s.sid,
  s.serial#,
  s.username,
  s.status,
  s.osuser,
  s.machine,
  s.program,
  TO_CHAR(s.logon_time,'YYYY-MM-DD HH24:MI:SS') AS logon_time,
  s.sql_id,
  s.event,
  s.wait_class
FROM v$session s
WHERE STATUS <> 'INACTIVE'
ORDER BY s.username NULLS LAST, s.status;
