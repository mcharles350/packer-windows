#######################################################
#
# Powershell script to Download & Install GitLab
# Created by BLiebowitz on 1/6/2017
#
#######################################################

# Set Location to download the Git Installer for Windows x64
$url = "https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.3/Git-2.11.0.3-64-bit.exe"

# Set the download destination & file name
$path = "c:\apps\git-64-bit.exe"

# Ignore SSL Certificate errors
# [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# Download the Puppet install to the destination specified
$webclient = new-object System.Net.WebClient
$webclient.DownloadFile( $url, $path )

# Wait 30 seconds for download to complete
start-sleep 30

# Install Gitlab
Write-Host "Installing Git"
Start-Sleep -Seconds 15
start-process -FilePath "c:\apps\git-64-bit.exe" -PassThru "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOG=C:\git_log.txt" -Wait | Out-Null
