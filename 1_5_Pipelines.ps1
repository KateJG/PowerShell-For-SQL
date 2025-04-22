#Start exploring your objects by piping to Get-Member
[string]$string = "Earl Grey, hot"
$string | Get-Member

#You can also measurecollections using Mesaure-Object
Get-Help about* | Measure-Object

#We can use the pipeline to quikcly write out text file
New-Item -ItemType Directory -Path 'C:\Users\Kate\Test'
'The quick brown fox jumps over the lazy dog.' | Out-File -FilePath 'C:\Users\Kate\Test\Dummy.txt'
notepad 'C:\Users\Kate\Test\Dummy.txt'

#We can also use it for removing things
New-Item -ItemType file -Path 'C:\Users\Kate\Test\Junk1.txt'
New-Item -ItemType file -Path 'C:\Users\Kate\Test\Junk2.txt'
New-Item -ItemType file -Path 'C:\Users\Kate\Test\Junk3.txt'
New-Item -ItemType file -Path 'C:\Users\Kate\Test\Junk4.txt'

cls
dir C:\Users\kate\Test

#removes all file from Test, but not the folder
dir C:\Users\kate\Test | Remove-Item

cls
dir C:\Users\kate\Test

#lets start expanding other commands
#Getting free space information

#Get-WmiObject gives us access to different parts of the Windows OS
#Getting freespace for disk volumes uses win32_Volume
Get-WmiObject win32_volume |
    Where-Object {$_.drivetype -eq 3} |
    Sort-Object name |
    Format-Table name, label,@{l="Size(GB)";e={($_.capacity/1gb).ToString("F2")}},@{l="Free Space(GB)";e={($_.freespace)}}

#chatgpt script
# GetFreeDiskSpace.ps1
# Get disk space info for all logical drives
$drives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

# Display results in a table
$drives | Select-Object `
    @{Name="Drive"; Expression={$_.DeviceID}},
    @{Name="VolumeName"; Expression={$_.VolumeName}},
    @{Name="Size (GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}},
    @{Name="Free Space (GB)"; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}},
    @{Name="Free (%)"; Expression={[math]::Round(($_.FreeSpace / $_.Size) * 100, 2)}}


#clean out 'old' transaction log backups
Get-ChildItem '\\PICARD\C$\Backups' -Recurse |
    Where-Object {$_.Extension -eq ".trn" -and $_.LastWriteTime -lt (Get-Date).AddHours(-3)} |
    Remove-Item -WhatIf