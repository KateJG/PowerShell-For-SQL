#List all of your current providers
Get-PSDrive

#Change to the SQL Server Provider
cd SQLSERVER:\
dir

#Can browse our SQL Servers as if they were directories
cd SQL\'hostname or instancename'
dir

CD DEFAULT
dir


#List our databases
dir databases | Format-Table -AutoSize

#use -Force switch to list also system databases
dir databases -Force | Format-Table -AutoSize

#Everything is an object. What objects are we looking at? TypeName: Microsoft.SqlServer.Management.Smo.Database
dir databases | Get-Member

dir databases -Force | Select-Object name, createdate,@{name='DataSizeMB'; Expression={$_.dataspaceusage/1024}},


#We can drill further down
dir databases\AdventureWorks2014\Tables

#Practical use
$instances = @('hostname or instancename')

#Check your databases for last backup
$instances | ForEach-Object {Get-ChildItem "SQLSERVER:\SQL\$_\DEFAULT\Databases" -Force} |
    Sort-Object Size -Descending |
    Select-Object @{n='Server';e={$_.parent.Name}},Name,LastBackupDate,Size

