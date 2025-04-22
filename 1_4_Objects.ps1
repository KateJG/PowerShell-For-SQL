#Powershell variables start with a $
$string = "This is a varianle"
$string

#We can use Get-Member to find out all the information on our objects
$string | Get-Member

#Powershell is stringly typed and uses .Net objects.
#Not just limited to string and inetegers

$date=Get-Date
$date
$date | gm #gm is the alias of Get-Member

#Because they are .Net types/classes, we can use the methods and properties.
$date.Day
$date.DayOfWeek
$date.ToUniversalTime()

#Powershell tries to figure out the variable type when it can (implicit types)
#We can also explicitly declare our type
[string]$datestring = Get-Date #could also use [System.String]
$datestring
$datestring | gm
 
#Everything is an object. This means more than just basic types:
$file = New-Item -ItemType File -Path 'C:\Users\kate\OneDrive - rsmb.co.uk\Desktop\My_work_notes\SQL\junkfile.txt'
$file | gm

$file.Name
$file.FullName
$File.Extension
$file.LastWriteTime

Remove-Item $file
