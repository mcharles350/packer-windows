<#
Script Name: Provisioner Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Application Installation
Date:  1/18/17
Created by: Max Charles Jr.
#>

########################################################################################################################################################
#Install Git
# Set Location to download the Git Installer for Windows x64
Write-Host "Downloading Git"
$url = "https://github.com/git-for-windows/git/releases/download/v2.16.1.windows.1/Git-2.16.1-64-bit.exe"

# Set the download destination & file name
$path = "c:\apps\git-64-bit.exe"

# Ignore SSL Certificate errors
# [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download the Git installer to the destination specified
$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $url, $path )

# Wait 30 seconds for download to complete
start-sleep -Seconds 30

# Install Git
Write-Host "Installing Git"
Start-Sleep -Seconds 15
start-process -FilePath "c:\apps\git-64-bit.exe" -PassThru "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOG=C:\git_log.txt" -Wait
Write-Host "Git is installed"
#########################################################################################################################################################
#Download apps.zip file from APQA S3 bucket
Write-Host "Downloading files from S3"
Invoke-WebRequest -Uri "https://s3.amazonaws.com/packer-windows-qa-associatedpressqa-us-east-1-goldami/apps.zip" -OutFile C:\apps\apps.zip

#Extract apps.zip file
$shell_app=new-object -com shell.application
$filename = "apps.zip"
$zip_file = $shell_app.namespace("C:\apps" + "\$filename")
$destination = $shell_app.namespace("C:\apps")
$destination.Copyhere($zip_file.items())

Write-Host "S3 Download Complete"
################################################################################################################
#Install AWS CLI

Write-Host "Installing AWS Command Line Interface"
#$source = "https://s3.amazonaws.com/aws-cli/AWSCLI64.msi"
#$destination = "C:\apps\AWSCLI64.msi"

#Invoke-WebRequest -Uri $source -OutFile $destination

$a = Start-Process msiexec.exe -ArgumentList "/i C:\apps\AWSCLI64.msi /qn /norestart /log C:\awscli_logs.txt" -Wait -PassThru

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "AWS Command Line Interface installed." -ForegroundColor Green

Start-Sleep -Seconds 15
##################################################################################################################

<#
#Install CFN Fix
###################################################################################################################
Write-Host "Installing CFN Unicode Fix"

$source = "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-win64-latest.msi"
$destination = "C:\apps\aws-cfn-bootstrap-win64-latest.msi"

Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/i C:\apps\aws-cfn-bootstrap-win64-latest.msi /qn /norestart /log C:\aws-cfn-bootstrap_log.txt" -Wait -PassThru
##############################################################################################################################################
#>

########################################################################################################################################################
#Install AWS Agent for Amazon Inspector
#Set Location to download the AWS Agent for Amazon Inspector for Windows x64

$url = "https://d1wk0tztpsntt1.cloudfront.net/windows/installer/latest/AWSAgentInstall.exe"

# Set the download destination & file name
$path = "c:\apps\AWSAgentInstall.exe"

# Download the application and install to the destination specified
$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $url, $path )

# Wait 30 seconds for download to complete
start-sleep 10

# Install AWS Agent for Amazon Inspector
Write-Host "AWS Agent for Amazon Inspector"
start-process -FilePath "c:\apps\AWSAgentInstall.exe" -PassThru "/install /quiet /norestart /log C:\aws_inspector.txt" -Wait

Start-Sleep -Seconds 15
#Stop-Service -Name "AWS Agent Update Service" -Force
#Stop-Service -Name "AWS Agent Updater Service" -Force
#########################################################################################################################################################

#Install Puppet Agent 64-bit
###############################################################################################################################################
Write-Host "Install Puppet Agent"
Invoke-WebRequest -Uri https://downloads.puppetlabs.com/windows/puppet-agent-1.10.12-x64.msi -OutFile C:\apps\puppet-agent-1.10.12-x64.msi -ErrorAction SilentlyContinue

Write-Host "Puppet Agent download complete" 
Start-Sleep -Seconds 15

Write-Host "Install Puppet Agent" 
Start-Sleep -Seconds 15
Start-Process msiexec.exe -ArgumentList '/qn /i C:\apps\puppet-agent-1.10.12-x64.msi PUPPET_MASTER_SERVER=badhost.ap.org /log C:\puppet_logs.txt' -Wait -PassThru -ErrorAction SilentlyContinue
Write-Host "Puppet Agent Install Complete" 

<#
$source = "https://puppet-mom.ap.org:8140/packages/current/windows-x86_64-1.10.1/puppet-agent-x64.msi"
$destination = "C:\apps\puppet-agent-x64.msi"

$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $source, $destination )

Start-Process msiexec.exe -ArgumentList "/qn /i C:\apps\puppet-agent-x64.msi PUPPET_MASTER_SERVER=badhost.ap.org /log C:\puppet_logs.txt" -Wait -PassThru | Out-Null

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "Puppet Agent installed." -ForegroundColor Green
#>

Start-Sleep -Seconds 15
################################################################################################################################################

#Install SMP CEM Agent
################################################################
Write-Host "Installing Altiris CEM Agent"
$ExecuteInstall = {C:\apps\CEMInstall.exe /s /pass:Password123!}

$a = Invoke-Command -ScriptBlock $ExecuteInstall -ErrorAction SilentlyContinue
$a

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "Altiris Cloud Enable Management Agent installed." -ForegroundColor Green

Start-Sleep -Seconds 10
#################################################################

#Install Notepad++
#########################################################################
Write-Host "Downloading Notepad++"
$url = "https://notepad-plus-plus.org/repository/7.x/7.5.4/npp.7.5.4.Installer.x64.exe"

# Set the download destination & file name
$path = "c:\apps\npp.7.5.4.Installer.x64.exe"

# Ignore SSL Certificate errors
# [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# Download the Git installer to the destination specified
$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $url, $path )

Write-Host "Installing Notepad++"
$ExecuteInstall = {C:\apps\npp.7.5.4.Installer.x64.exe /S}

$a = Invoke-Command -ScriptBlock $ExecuteInstall -ErrorAction SilentlyContinue

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "Notepad++ installed." -ForegroundColor Green

Start-Sleep -Seconds 25
#########################################################################

#Install SEP client (Quiet Install)
#########################################################################
Write-Host "Installing Symantec Endpoint Protection"
$ExecuteInstall = {C:\apps\setup.exe}

$a = Invoke-Command -ScriptBlock $ExecuteInstall -ErrorAction SilentlyContinue
$a

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "Symantec Endpoint Protection installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################

#Install NetTime
#########################################################################
Write-Host "Installing NetTime"

$a = Start-Process -FilePath C:\apps\InstallTimeSync.exe -ArgumentList /silent
$a

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "NetTime installed." -ForegroundColor Green

Start-Sleep -Seconds 25
#########################################################################

<#
#Install AWS-SDK for Ruby
#########################################################################
Write-Host "Installing Gem Packages"
$ExecuteInstall = {C:\apps\gem-aws-sdk.bat}
$a = Invoke-Command -ScriptBlock $ExecuteInstall | Out-Null
$a

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "Gem Packages installed"

Start-Sleep -Seconds 30
#>

#Install Sensu Agent
#########################################################################
Write-Host "Installing Sensu"
$source = "https://sensu.global.ssl.fastly.net/msi/2012r2/sensu-0.29.0-7-x64.msi"
$destination = "C:\apps\sensu_ap.msi"

$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $source, $destination )

#Invoke-WebRequest -Uri $source -OutFile $destination

$a = Start-Process msiexec.exe -ArgumentList "/i C:\apps\sensu_ap.msi /qn /norestart /log C:\sensu_log.txt" -Wait -PassThru
$a

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

#Install Windows Update KB3191564
#########################################################################################################
Write-Host "Install KB3191564-x64 - Windows Mgmt Framework 5.1"
$WU = {Start-Process dism.exe -ArgumentList "/online /add-package /PackagePath:C:\apps\win2012r2\WindowsBlue-KB3191564-x64.cab /quiet /norestart" -Wait -PassThru}
$a = Invoke-Command -ScriptBlock $WU -ErrorAction SilentlyContinue
$a

#Write-Host "ExitCode is " $a.ExitCode
Write-Host "KB3191564 is installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################################################


<#
Perform Windows Update
##########################################################################################################
Write-Host "Windows Update"
$Option = 2
Invoke-Command -ScriptBlock {C:\apps\winupdates.ps1 $Option} -ErrorAction Ignore
Start-Sleep -Seconds 25
###########################################################################################################
#>
