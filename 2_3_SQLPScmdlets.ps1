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

$sqlcmdout
$invokesqlout

$sqlcmdout[0].GetType()
$invokesqlout[0].GetType()

#get member
$invokesqlout | gm

$invokesqlout.name

#Doing backups
Backup-SqlDatabase -ServerInstance RSMB-JX7WQ9ONFS -Database AdventureWorks2014 -BackupFile 'C:\DBA\AdventureWorks2014.bak' -Initialize -CopyOnly -Script
Backup-SqlDatabase -ServerInstance RSMB-JX7WQ9ONFS -Database AdventureWorks2014 -BackupFile 'C:\DBA\AdventureWorks2014.bak' -Initialize -CopyOnly

dir '\\RSMB-JX7WQ9ONFS\C$\DBA\*.bak'

#Lets combine the Backup-SQLDatabase with the provider
#gonna clean up the directory first
dir 'C:\Backups' -Recurse | rm -Recurse -Force

#nothing up my sleeve
dir 'C:\Backups' -Recurse

#now let's use it to run all our systemdb backups - THE SCRIPT IS NOT FINISHED !!!
cd C:\
$servers= @('RSMB-JX7WQ9ONFS', 'server2hostname')

foreach($server in $servers) {
    $dbs = dir SQLSERVER:\SQL\$server\DEFAULT\DATABASES -Force | Where-Object {$_.IsSystemObject -eq $true -and $_.$invokesqlout.name
    $pathname= "\\RSMB-JX7WQ9ONF\Backups\"+$server.Replace('\','_')
    if(!(test-path $pathname)){New-Item $pathname -ItemType directory }
    $dbs | ForEach-Object {Backup-SqlDatabase -ServerInstance $server -Database $_.name -BackupFile "$pathname\$_." }
}}

dir 'C:\Backups'
#THE SCRIPT IS NOT FINISHED !!! NEEDS FIXING


#PowerShell Backup Script Template for All SQL Databases


<# 
.SYNOPSIS
    Backs up all SQL Server databases on a given instance (excluding tempdb).
.NOTES
    Requires the SqlServer module (install with: Install-Module SqlServer).
    Make sure this script is run with permissions to access SQL Server and write to the backup path.
#>

#--- Configuration Parameters ---#
$serverInstance = "localhost"                   # Change to your server/instance name, e.g., "SQLSERVER01\INSTANCE1"
$backupRootPath = "C:\SQLBackups"               # Folder where backups will be stored
$includeTimestampInFile = $true                 # Set to $false if you don't want timestamps

# Create the backup directory if it doesn't exist
if (-not (Test-Path $backupRootPath)) {
    New-Item -Path $backupRootPath -ItemType Directory -Force | Out-Null
}

# Get list of all databases (excluding tempdb)
$databases = Invoke-Sqlcmd -ServerInstance $serverInstance -Query "
    SELECT name 
    FROM sys.databases 
    WHERE name NOT IN ('tempdb')
"

# Loop through each database and back it up
foreach ($db in $databases) {
    $dbName = $db.name
    $timestamp = if ($includeTimestampInFile) { "_" + (Get-Date -Format 'yyyyMMdd_HHmmss') } else { "" }
    $backupFile = Join-Path -Path $backupRootPath -ChildPath "$dbName$timestamp.bak"

    try {
        Write-Host "Backing up database: $dbName to $backupFile"
        Backup-SqlDatabase -ServerInstance $serverInstance -Database $dbName -BackupFile $backupFile -ErrorAction Stop
        Write-Host "Backup completed for $dbName" -ForegroundColor Green
    }
    catch {
        Write-Host "Backup failed for $dbName: $_" -ForegroundColor Red
    }
}




#From OpenAI

# Define variables
$serverInstance = "localhost"                 # Change to your server name or instance
$backupDirectory = "C:\SQLBackups"            # All .bak files will go here
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Create the backup folder if it doesn't exist
if (-not (Test-Path $backupDirectory)) {
    New-Item -Path $backupDirectory -ItemType Directory | Out-Null
}

# Backup all databases (excluding tempdb) to the same location
(Get-SqlDatabase -ServerInstance $serverInstance | Where-Object { $_.Name -ne "tempdb" }) |
    ForEach-Object {
        $backupFile = Join-Path $backupDirectory "$($_.Name)_$timestamp.bak"
        Backup-SqlDatabase -ServerInstance $serverInstance -Database $_.Name -BackupFile $backupFile
        Write-Host "Backed up: $($_.Name) -> $backupFile"
    }





 