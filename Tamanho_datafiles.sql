-- Tamnho do banco de todos os datafiles (total) e tamanho da temp(total)
SELECT 
    ROUND(SUM(bytes)/1024/1024/1024,2) AS tamanho_gb
FROM dba_data_files
UNION ALL
SELECT 
    ROUND(SUM(bytes)/1024/1024/1024,2)
FROM dba_temp_files;

-- Tamanho do banco por datafile
SELECT 
    tablespace_name,
    ROUND(SUM(bytes)/1024/1024/1024,2) AS tamanho_gb
FROM dba_data_files
GROUP BY tablespace_name
ORDER BY tamanho_gb DESC;
