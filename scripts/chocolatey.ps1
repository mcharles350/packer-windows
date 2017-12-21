<#
Script Name: Provisioner Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Chocolatey Installation
Date:  1/18/17
Created by: Max Charles Jr.
#>

﻿#Install Chocolatey
#########################################################################
Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Unrestricted; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Invoke-WebRequest -Uri https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression -ErrorAction SilentlyContinue
Start-Sleep -Seconds 30
#########################################################################
