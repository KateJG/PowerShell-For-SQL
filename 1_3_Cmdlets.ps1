#Cmdlets - the core functionality
#Get-Date, Verb-noun
Get-Date

#What if we wanted to see all the verbs?
Get-Verb

#Get-Command, the Dictionary lookup
Get-Command
Get-Command -Name *New*

#Get-Help, describing a specific cmdlet
Get-Help Get-Command
Get-Help Get-Command -Full
Get-Help Get-Command -ShowWindow
Get-Help Get-Command -Online

#Help is for more than just cmdlets
Get-Help about*

#Practical use
Get-Command 'New*Firewall*'

Get-Help New-NetFirewallRule -ShowWindow

#Aliases are handy, they can be used for short hand.
#Get-ChildItem gest all the contents of a directory
Get-ChildItem C:\

#Cmdlets can have aliases to make them easier to use
#dir is an alias for Get-ChildItem
dir C:\

#We can see all the aliases for a cmdlet
Get-Alias -Definition Get-ChildItem

#Use a different alias
ls C:\
 

