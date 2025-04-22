#Using the cmdlets
Get-Command -Module SQLPS
Get-Command -Module SQLPS | Measure-Object

#Let's look at Invoke-SqlCmd
$sql=@'
SET NOCOUNT ON
SELECT sp.name, count(1) db_count
FROM sys.server_principals sp
JOIN sys.databases d on (sp.sid = d.owner_sid)
GROUP BY sp.name
'@

Invoke-Sqlcmd -ServerInstance RSMB-JX7WQ9ONFS -Database tempdb -Query $sql

#compare to sqlcmd
$sqlcmdout = sqlcmd -S RSMB-JX7WQ9ONFS -d tempdb -Q $sql
$invokesqlout = Invoke-Sqlcmd -ServerInstance RSMB-JX7WQ9ONFS -Database tempdb -Query $sql




 