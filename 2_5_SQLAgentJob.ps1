#SQL Agent Job Example

#backup your databases
#get a collection of databases
$dbs = Invoke-Sqlcmd -ServerInstance localhost -Database tempdb -Query "Select name FROM sys.databases WHERE databse_id > 4"

#Get a formatted string for the datetime
$datestring = (Get-Date- Format 'yyyyMMddHHmm')

#loop through the databases
foreach($db in $dbs.name) {
    $dir = "C:\BackupDemo\$db"
    #does the backup directory exist? If not, create ir
    if( -not(Test-Path $dir)){New-Item -ItemType Directory -Path $dir}
    
    #Get a nice name and backup your database to it
    $filename = "$db-$datestring.bak"
    $backup = Join-Path -Path $dir -ChildPath $filename
    Backup-SqlDatabase -ServerInstance localhost -Database $db -BackupFile -CompressionOption On -CopyOnly
    #Delete old backups
    Get-ChildItems $dir\*.bak| Where {$_LastWriteTime -lt (Get-Date).AddMinutes(-1)}|Remove-Item
    
    }

    #now, copy and paste this into an agent job and schedule it.

