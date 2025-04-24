#SMO
#Powershell can access the .NET SMO Libraries
#Libraries are loaded with SQLPS

$smoserver = New-Object Microsoft.SqlServer.Management.Smo.Server 'RSMB-JX7WQ9ONFS'

#We can now interact with the server as it is an object
$smoserver | Get-Member
$smoserver.Version
$smoserver.VersionString

#We can also drilldown into the parts of the server
$smoserver.Databases

#Now we have a table object with its own properties
$sysjobs = $smoserver.Databases["msdb"].Tables["sysjobs"]
$sysjobs | Get-Member
$sysjobs.Indexes
$sysjobs.Script()

#we can now make collections
if(Test-Path C:\DBA\logins.sql) {Remove-Item C:\DBA\logins.sql}
$smoserver.Logins | ForEach-Object {$_.Script() | Out-File C:\DBA\logins.sql -Append}

notepad C:\DBA\logins.sql

#we can also create objects
#this is a little trikckier

$db = New-Object Microsoft.SqlServer.Management.Smo.Database ($smoserver, 'SMOTest')
$db | Get-Member

dir SQLSERVER:\SQL\localhost\DEFAULT\DATABASES

#Just creating the new object doesn't mean it's created (look in SMO)
#now let's create it
$db.Create()

dir SQLSERVER:\SQL\localhost\DEFAULT\DATABASES

#but we don't want the file in the default location.
$db.Drop()

#First we have to declare our files
$dbname = 'SMOTest'
$db = New-Object Microsoft.SqlServer.Management.Smo.Database ($smoserver,$dbname)
$fg = New-Object Microsoft.SqlServer.Management.Smo.FileGroup ($db,'PRIMARY')
$mdf = New-Object Microsoft.SqlServer.Management.Smo.DataFile ($fg,"${dbname}_data01")
$ldf = New-Object Microsoft.SqlServer.Management.Smo.LogFile ($db, "${dbname}_log")
$mdf.FileName = "C:\DBFiles\Data\${dbname}_data01.mdf"
$mdf.Size = (100 * 1024)
$mdf.Growth = (10 * 1024)
$mdf.GrowthType = 'KB'
$db.FileGroups.Add($fg)
$fg.Files.Add($mdf)

$ldf.FileName = "C:\DBFiles\Log\${dbname}_log.ldf"
$ldf.Size = (10 * 1024)
$ldf.Growth = (10 * 1024)
$ldf.GrowthType = 'KB'
$db.LogFiles.Add($ldf)

#and we can look at the script to create it
$db.Script()

#or we can just create it
$db.Create()
dir SQLSERVER:\SQL\localhost\DEFAULT\DATABASES

#Cleanup!
$db.Drop()







