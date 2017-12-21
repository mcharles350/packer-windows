<#
Script Name: Cleanup Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Sysprep AMI
Date:  1/18/17
Created by: Max Charles Jr.
#>

#Set Puppet Agent Service to Manual
Write-Host "Set Puppet Agent to Manual Startup"
Set-Service -Name puppet -StartupType Manual

#Reset CEM Client Settings from registry
Write-Host "CEM Client Cleanup"

Stop-Service -Name AeXNSClient -Force
Start-Sleep -Seconds 60
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress" /v MachineGuid /f}
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress\NS Client" /v MachineGuid /f}
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\Altiris Agent" /v MachineGuid /f}

#Cleanup SEP client GUID information
Write-Host "SEP Client Cleanup"

Invoke-Command -ScriptBlock {& "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\smc.exe" -stop}
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
