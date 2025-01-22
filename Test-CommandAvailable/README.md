Determine if a particular command/parameter combination is available in a specific Powershell version

Example Usage
```
Test-CommandAvailable -Name Get-WmiObject, Get-UpTime, Select-String
# Command       CommandPSEdition Param ParamPSEdition
# -------       ---------------- ----- --------------
# Get-WmiObject          Desktop
# Get-UpTime                Core
# Select-String    Desktop, Core

Test-CommandAvailable -Name Test-Connection -ParameterName AsJob
# Command         CommandPSEdition Param ParamPSEdition
# -------         ---------------- ----- --------------
# Test-Connection    Desktop, Core AsJob        Desktop
```
