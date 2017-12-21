<#
Script Name: Provisioner Script for Windows AMI
OS: Windows Server 2016
Purpose: Application Installation
Date:  9/18/17
Created by: Max Charles Jr.
#>

#########################################################################################################################################################
#Download apps.zip file from APQA S3 bucket
Write-Host "Downloading files from S3 bucket"
Invoke-WebRequest -Uri https://s3.amazonaws.com/packer-windows-qa-associatedpressqa-us-east-1-goldami/apps.zip -OutFile C:\apps\apps.zip -WarningAction SilentlyContinue | Out-Null 

#Extract apps.zip file
$shell_app=new-object -com shell.application -WarningAction SilentlyContinue
$filename = "apps.zip"
$zip_file = $shell_app.namespace("C:\apps" + "\$filename")
$destination = $shell_app.namespace("C:\apps")
$destination.Copyhere($zip_file.items())

Write-Host "Files from S3 bucket downloaded and extracted to 'apps' folder"
#########################################################################################################################################################
<#Install SMP CEM Agent

Write-Host "Installing Altiris CEM Agent"
Start-Sleep -Seconds 15
$ExecuteInstall = {C:\temp\CEMInstall.exe /s /pass:Password123!}
Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null

#########################################################################
#Install SEP client (Quiet Install)

Write-Host "Installing Symantec Endpoint Protection"
Start-Sleep -Seconds 15
$ExecuteInstall = {C:\temp\setup.exe}
Invoke-Command -ScriptBlock $ExecuteInstall
#>

#########################################################################
#Install Puppet Agent 64-bit

Write-Host "Downloading Puppet Agent Installer"
#$url = "https://downloads.puppetlabs.com/windows/puppet-agent-1.10.1-x64.msi"
#$path = "C:\apps\puppet\puppet-agent-1.10.1-x64.msi"

Invoke-WebRequest -Uri https://downloads.puppetlabs.com/windows/puppet-agent-1.10.1-x64.msi -OutFile C:\apps\puppet\puppet-agent-1.10.1-x64.msi -WarningAction SilentlyContinue

#$webclient = New-Object System.Net.WebClient
#$webclient.DownloadFile( $url, $path )

Write-Host "Puppet Agent download complete" 
Start-Sleep -Seconds 15

Write-Host "Install Puppet Agent" 
Start-Sleep -Seconds 15
Start-Process msiexec.exe -ArgumentList '/qn /i C:\apps\puppet\puppet-agent-1.10.1-x64.msi PUPPET_MASTER_SERVER=badhost.ap.org /log C:\puppet_logs.txt' -Wait -PassThru -WarningAction SilentlyContinue | Out-Null

Write-Host "Puppet Agent Install Complete" 