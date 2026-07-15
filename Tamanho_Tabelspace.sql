SELECT
    df.tablespace_name,
    ROUND(df.total_gb,2) AS allocated_gb,
    ROUND(NVL(fs.free_gb,0),2) AS free_gb,
    ROUND(df.total_gb - NVL(fs.free_gb,0),2) AS used_gb,
    ROUND((df.total_gb - NVL(fs.free_gb,0))*100/df.total_gb,2) AS pct_used
FROM (
    SELECT tablespace_name,
           SUM(bytes)/1024/1024/1024 total_gb
    FROM dba_data_files
    GROUP BY tablespace_name
) df
LEFT JOIN (
    SELECT tablespace_name,
           SUM(bytes)/1024/1024/1024 free_gb
    FROM dba_free_space
    GROUP BY tablespace_name
) fs
ON df.tablespace_name = fs.tablespace_name
WHERE df.tablespace_name = 'TBS_RNSCOPA_DATA';
