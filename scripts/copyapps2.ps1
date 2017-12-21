<#
Script Name: Provisioner Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Application Installation
Date:  1/18/17
Created by: Max Charles Jr.
#>

#Download apps.zip file from APQA S3 bucket
Invoke-WebRequest -Uri https://s3.amazonaws.com/packer-windows-qa-associatedpressqa-us-east-1-goldami/apps.zip -OutFile C:\apps\apps.zip

#Extract apps.zip file
$shell_app=new-object -com shell.application
$filename = "apps.zip"
$zip_file = $shell_app.namespace("C:\apps" + "\$filename")
$destination = $shell_app.namespace("C:\apps")
$destination.Copyhere($zip_file.items())

#Install AWS CLI
################################################################################################################
Write-Host "Installing AWS Command Line Interface"
#$source = "https://s3.amazonaws.com/aws-cli/AWSCLI64.msi"
#$destination = "C:\apps\AWSCLI64.msi"

#Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/i C:\apps\AWSCLI64.msi /qn /norestart /log C:\awscli_logs.txt" -Wait -PassThru | Out-Null
$LASTEXITCODE

Write-Host "AWS Command Line Interface installed." -ForegroundColor Green

Start-Sleep -Seconds 15
##################################################################################################################

<#
#Uninstall CFN 1.4-15
###################################################################################################################
Write-Host "Uninstall CFN Unicode Fix 1.4-15"

$source = "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-1.4-15.win64.msi"
$destination = "C:\apps\aws-cfn-bootstrap-1.4-15.win64.msi"

Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/x C:\apps\aws-cfn-bootstrap-1.4-15.win64.msi /qn /norestart /log C:\aws-cfn-bootstrap_4-15_x_log.txt" -Wait -PassThru
##############################################################################################################################################


#Uninstall CFN 1.4-17
###################################################################################################################
Write-Host "Uninstall CFN Unicode Fix 1.4-17"

$source = "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-1.4-17.win64.msi"
$destination = "C:\apps\aws-cfn-bootstrap-1.4-17.win64.msi"

Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/x C:\apps\aws-cfn-bootstrap-1.4-17.win64.msi /qn /norestart /log C:\aws-cfn-bootstrap_4-17_x_log.txt" -Wait -PassThru
##############################################################################################################################################


#Uninstall CFN 1.4-18
###################################################################################################################
Write-Host "Uninstall CFN Unicode Fix 1.4-18"

$source = "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-1.4-18.win64.msi"
$destination = "C:\apps\aws-cfn-bootstrap-1.4-18.win64.msi"

Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/x C:\apps\aws-cfn-bootstrap-1.4-18.win64.msi /qn /norestart /log C:\aws-cfn-bootstrap_4-18_log.txt" -Wait -PassThru
##############################################################################################################################################
#>

#Install Puppet Agent 64-bit
###############################################################################################################################################
Write-Host "Install Puppet Agent"
#$source = "https://puppet-mom.ap.org:8140/packages/current/windows-x86_64/puppet-agent-x64.msi"
#$destination = "C:\apps\puppet-agent-x64.msi"

#Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/qn /i C:\apps\puppet-agent-x64.msi PUPPET_MASTER_SERVER=badhost.ap.org /log C:\puppet_logs.txt" -Wait -PassThru | Out-Null
$LASTEXITCODE

Write-Host "Puppet Agent installed." -ForegroundColor Green

Start-Sleep -Seconds 15
################################################################################################################################################

#Install SMP CEM Agent
################################################################
Write-Host "Installing Altiris CEM Agent"
$ExecuteInstall = {C:\apps\CEMInstall.exe /s /pass:Password123!}

Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null
$LASTEXITCODE

Write-Host "Altiris Cloud Enable Management Agent installed." -ForegroundColor Green

Start-Sleep -Seconds 60
#################################################################

#Install Notepad++
#########################################################################
Write-Host "Installing Notepad++"
$ExecuteInstall = {C:\apps\npp.7.3.1.Installer.x64.exe /S}

Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null
$LASTEXITCODE

Write-Host "Notepad++ installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################

#Install SEP client (Quiet Install)
#########################################################################
Write-Host "Installing Symantec Endpoint Protection"
$ExecuteInstall = {C:\apps\setup.exe}

Invoke-Command -ScriptBlock $ExecuteInstall

Write-Host "Symantec Endpoint Protection installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################

#Install NetTime
#########################################################################
Write-Host "Installing NetTime"

Start-Process -FilePath C:\apps\InstallTimeSync.exe -ArgumentList /silent | Out-Null
$LASTEXITCODE

Write-Host "NetTime installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################


#Install AWS-SDK for Ruby
#########################################################################
Write-Host "Installing AWS-SDK for Ruby"
$ExecuteInstall = {C:\apps\gem-aws-sdk.bat}
Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null

Write-Host "AWS-SDK for Ruby installed"

Start-Sleep -Seconds 30
###############################################################################

<#
#Install ServerSpec for Ruby
#########################################################################
Write-Host "Installing ServerSpec"
$ExecuteInstall = {C:\apps\gem-serverspec.bat}
Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null

Write-Host "ServerSpec installed"

Start-Sleep -Seconds 30
###############################################################################
#>

#Install Sensu Agent
#########################################################################
Write-Host "Installing Sensu"
$source = "https://sensu.global.ssl.fastly.net/msi/2012r2/sensu-0.29.0-7-x64.msi"
$destination = "C:\apps\sensu_ap.msi"

Invoke-WebRequest -Uri $source -OutFile $destination
Start-Process msiexec.exe -ArgumentList "/i C:\apps\sensu_ap.msi /qn /norestart /log C:\sensu_log.txt" -Wait -PassThru

Move-Item C:\apps\sensu-client.xml C:\opt\sensu\bin -Force

New-Service -Name "Sensu-Client" -StartupType Manual -BinaryPathName "C:\opt\sensu\bin\sensu-client.exe" -DisplayName "Sensu Client" -Description "Enables monitoring for a computer by Sensu."
Start-Sleep -Seconds 30

<#
#########################################################################
#Install Chocolatey
#########################################################################
Write-Host "Installing Chocolatey"
Invoke-WebRequest -Uri https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression -ErrorAction SilentlyContinue
Start-Sleep -Seconds 30
#########################################################################
#>

#Install Windows Update KB3134758
#########################################################################################################
Write-Host "Install KB3134758-x64 - Windows Mgmt Framework 5"
$WU = {Start-Process dism.exe -ArgumentList "/online /add-package /PackagePath:C:\apps\win2012r2\WindowsBlue-KB3134758-x64.cab /quiet /norestart" -Wait -PassThru}
Invoke-Command -ScriptBlock $WU | Out-Null

Write-Host "KB3134758 is installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################################################

<#
Perform Windows Update
##########################################################################################################
Write-Host "Windows Update"
$Option = 2
Invoke-Command -ScriptBlock {C:\Windows\Temp\winupdates.ps1 $Option} -ErrorAction Ignore
Start-Sleep -Seconds 25
###########################################################################################################
#>
