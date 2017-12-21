<#
Script Name: SysPrep Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Sysprep AMI
Date:  6/9/17
Created by: Max Charles Jr.
#>

Write-Host "Starting Sysprep"

Start-Sleep -Seconds 15

$awssys = "$env:programFiles\Amazon\Ec2ConfigService\ec2config.exe"
$arguments = "-sysprep"
start-process $awssys $arguments -Wait -PassThru
