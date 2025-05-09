﻿#Using the cmdlets
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

Invoke-Sqlcmd -ServerInstance 'your instance name' -Database tempdb -Query $sql

#compare to sqlcmd
$sqlcmdout = sqlcmd -S 'your instance name' -d tempdb -Q $sql
$invokesqlout = Invoke-Sqlcmd -ServerInstance "hostname" -Database tempdb -Query $sql




 
