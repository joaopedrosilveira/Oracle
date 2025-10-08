SELECT username, COUNT(*) sessions
FROM v$session
WHERE username IS NOT NULL
GROUP BY username
ORDER BY 2 DESC;
