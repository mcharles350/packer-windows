<#
Script Name: Provisioner Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Git Installation
Date:  1/18/17
Created by: Max Charles Jr.
#>

#Install Windows Update KB3134758
###########################################################################################################
Write-Host "Install KB3134758-x64 - Windows Mgmt Framework 5"
#Start-Process wusa.exe -ArgumentList "C:\apps\Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /forcerestart /log:C:\KB3134758.txt" -Wait

$Package = {C:\apps\Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /norestart /log:C:\KB3134758.txt}
Invoke-Command -ScriptBlock {wusa.exe $PACKAGE} -ErrorAction Ignore
Start-Sleep -Seconds 120

Write-Host "Windows Management Framework 5 is installed" -ForegroundColor Green
###########################################################################################################
