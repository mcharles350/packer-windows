<#
Script Name: Preparation Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Sysprep AMI
Date:  6/9/17
Created by: Max Charles Jr.
#>

###################################################################################################################################################################
#Delete Apps folder
Remove-Item -Path C:\apps\* -ErrorAction SilentlyContinue -Force -Recurse
Remove-Item -Path C:\apps -ErrorAction SilentlyContinue -Force

###################################################################################################################################################################
#Delete Puppet Cache Files
Remove-Item -Path C:\ProgramData\PuppetLabs\puppet\cache\* -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path C:\ProgramData\PuppetLabs\puppet -Force -Recurse -ErrorAction SilentlyContinue
####################################################################################################################################################################
#Set Puppet Agent Service to Manual
Write-Host "Setting Puppet Agent to Manual Startup"
Set-Service -Name puppet -ErrorAction SilentlyContinue -StartupType Manual 

Write-Host "Puppet Agent Service Stopped" 
Start-Sleep -Seconds 20
###################################################################################################################################################################
#Reset CEM Client Settings from registry
Write-Host "Cleaning up CEM Client" 
Start-Sleep -Seconds 10

Stop-Service -Name AeXNSClient -ErrorAction SilentlyContinue -Force
Start-Sleep -Seconds 30

Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress" /v MachineGuid /f} -ErrorAction SilentlyContinue
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress\NS Client" /v MachineGuid /f} -ErrorAction SilentlyContinue
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\Altiris Agent" /v MachineGuid /f} -ErrorAction SilentlyContinue

Write-Host "CEM Client Cleanup Completed"
Start-Sleep -Seconds 20
#########################################################################################################################################################################
#Cleanup SEP client GUID informtion
Write-Host "SEP Client Cleanup" 

Invoke-Command -ScriptBlock {& "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\smc.exe" -stop} -ErrorAction SilentlyContinue
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SepMasterService" -Name "start" -Value 4
Remove-Item -Path "C:\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Common Files\Symantec Shared\HWID\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\All Users\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\*\Local Settings\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\*\AppData\Local\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Common Files\Symantec Shared\HWID\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\All Users\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\*\Local Settings\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\*\AppData\Local\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\ForceHardwareKey" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\HardwareID" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\HostGUID" -Force -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "SEP Client Cleanup Completed" 
#########################################################################################################################################################################
